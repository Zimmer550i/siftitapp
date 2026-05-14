import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sarkasm/controllers/auth_controller.dart';
import 'package:sarkasm/models/scan_model.dart';
import 'package:sarkasm/utils/custom_snackbar.dart';

class ScanController extends GetxController {
  final _firestore = FirebaseFirestore.instance;
  RxBool isLoading = RxBool(false);
  RxList<ScanModel> scanHistory = RxList.empty();

  static const int _scanHistoryLimit = 10;
  DocumentSnapshot<Map<String, dynamic>>? _lastScanHistoryDoc;
  bool hasMoreScanHistory = true;

  Future<bool> hasAccess() async {
    return Permission.camera.isGranted;
  }

  Future<void> requestCameraPermission() async {
    final status = await Permission.camera.request();

    if (status.isGranted || status.isLimited) {
      return;
    }

    if (status.isPermanentlyDenied || status.isRestricted) {
      await openAppSettings();
      return;
    }

    Get.snackbar(
      "Camera access needed",
      "Please allow camera access to scan barcodes and ingredient labels.",
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  Future<String> getScanResult(List<String> ids) async {
    isLoading(true);

    try {
      final auth = Get.find<AuthController>();
      final userId = auth.currentUser?.uid;
      if (ids.isEmpty) {
        return "No scan data provided";
      }

      DocumentSnapshot<Map<String, dynamic>>? scanDoc;

      for (final id in ids) {
        final trimmedId = id.trim();

        if (trimmedId.isEmpty) {
          continue;
        }

        final currentDoc = await _firestore
            .collection("data")
            .doc(trimmedId)
            .get();

        if (currentDoc.exists && currentDoc.data() != null) {
          scanDoc = currentDoc;
          break;
        }
      }

      if (scanDoc == null || scanDoc.data() == null) {
        return "Scan information not found";
      }

      final newData = ScanModel.fromJson(scanDoc.data()!);

      final currentUser = auth.userModel.value;
      if (currentUser == null) {
        return "User data not found";
      }

      currentUser.recentScans ??= [];
      currentUser.recentScans!.insert(0, newData);

      if (currentUser.recentScans!.length > 3) {
        currentUser.recentScans!.removeLast();
      }

      auth.userModel.refresh();

      await _firestore.collection("users").doc(userId).update({
        "recentScans": currentUser.recentScans!
            .map((scan) => scan.toJson())
            .toList(),
      });

      // Save scan history if logged in
      if (userId != null && userId.isNotEmpty) {
        await _firestore
            .collection("scanHistory")
            .doc(userId)
            .collection("items")
            .add({
          ...newData.toJson(),
          "createdAt": FieldValue.serverTimestamp(),
        });
      }

      return "success";
    } catch (e) {
      return e.toString();
    } finally {
      isLoading(false);
    }
  }

  Future<void> getScanHistory({bool isLoadmore = false}) async {
    if (isLoading.value) return;

    if (isLoadmore && !hasMoreScanHistory) return;

    isLoading(true);
    try {
      final auth = Get.find<AuthController>();
      final userId = auth.currentUser?.uid;

      if (userId == null || userId.isEmpty) {
        scanHistory.clear();
        _lastScanHistoryDoc = null;
        hasMoreScanHistory = false;
        return;
      }

      if (!isLoadmore) {
        scanHistory.clear();
        _lastScanHistoryDoc = null;
        hasMoreScanHistory = true;
      }

      Query<Map<String, dynamic>> query = _firestore
          .collection("scanHistory")
          .doc(userId)
          .collection("items")
          .orderBy("createdAt", descending: true)
          .limit(_scanHistoryLimit);

      if (isLoadmore && _lastScanHistoryDoc != null) {
        query = query.startAfterDocument(_lastScanHistoryDoc!);
      }

      final snapshot = await query.get();

      if (snapshot.docs.isEmpty) {
        hasMoreScanHistory = false;
        return;
      }

      _lastScanHistoryDoc = snapshot.docs.last;
      hasMoreScanHistory = snapshot.docs.length == _scanHistoryLimit;

      final scans = snapshot.docs
          .map((doc) => ScanModel.fromJson(doc.data()))
          .toList();

      if (isLoadmore) {
        scanHistory.addAll(scans);
      } else {
        scanHistory.assignAll(scans);
      }
    } catch (e) {
      customSnackBar(e.toString());
    } finally {
      isLoading(false);
    }
  }
}
