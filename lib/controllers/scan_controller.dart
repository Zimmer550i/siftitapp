import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

class ScanController extends GetxController {
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
}
