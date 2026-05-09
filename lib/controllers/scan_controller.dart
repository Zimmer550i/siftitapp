import 'package:camera/camera.dart' as camera;
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sarkasm/views/screens/scanning/camera_permission.dart';

class ScanController extends GetxController {
  camera.CameraController? cameraController;
  bool isLoading = false;
  String? cameraError;

  Future<bool> hasAccess() async {
    return Permission.camera.isGranted;
  }

  Future<void> prepareCamera() async {
    isLoading = true;
    cameraError = null;
    update();

    final hasPermission = await hasAccess();

    if (!hasPermission) {
      final granted = await Get.to<bool>(() => CameraPermission());
      if (granted != true) {
        cameraError = "Camera access is required";
        isLoading = false;
        update();
        return;
      }
    }

    await initializeCamera();
  }

  Future<void> initializeCamera() async {
    try {
      final cameras = await camera.availableCameras();

      if (cameras.isEmpty) {
        cameraError = "No camera found";
        isLoading = false;
        update();
        return;
      }

      final cameraDescription = cameras.firstWhere(
        (description) =>
            description.lensDirection == camera.CameraLensDirection.back,
        orElse: () => cameras.first,
      );

      await cameraController?.dispose();
      cameraController = camera.CameraController(
        cameraDescription,
        camera.ResolutionPreset.medium,
        enableAudio: false,
      );

      await cameraController!.initialize();
    } catch (error) {
      cameraError = "Unable to open camera";
    }

    isLoading = false;
    update();
  }

  Future<void> getAccess() async {
    final status = await Permission.camera.request();

    if (status.isGranted || status.isLimited) {
      Get.back(result: true);
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

  @override
  void onClose() {
    cameraController?.dispose();
    super.onClose();
  }
}
