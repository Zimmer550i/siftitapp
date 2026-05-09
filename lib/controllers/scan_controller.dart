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
    _setLoading();

    final canUseCamera = await _ensureCameraPermission();
    if (!canUseCamera) {
      _setError("Camera access is required");
      return;
    }

    await initializeCamera();
  }

  Future<void> initializeCamera() async {
    try {
      final cameras = await camera.availableCameras();

      if (cameras.isEmpty) {
        _setError("No camera found");
        return;
      }

      await cameraController?.dispose();
      cameraController = camera.CameraController(
        _preferredCamera(cameras),
        camera.ResolutionPreset.medium,
        enableAudio: false,
      );

      await cameraController!.initialize();
    } catch (error) {
      cameraError = "Unable to open camera";
    }

    _setIdle();
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

  Future<bool> _ensureCameraPermission() async {
    if (await hasAccess()) {
      return true;
    }

    final granted = await Get.to<bool>(() => CameraPermission());
    return granted == true;
  }

  camera.CameraDescription _preferredCamera(
    List<camera.CameraDescription> cameras,
  ) {
    return cameras.firstWhere(
      (description) =>
          description.lensDirection == camera.CameraLensDirection.back,
      orElse: () => cameras.first,
    );
  }

  void _setLoading() {
    isLoading = true;
    cameraError = null;
    update();
  }

  void _setIdle() {
    isLoading = false;
    update();
  }

  void _setError(String message) {
    cameraError = message;
    isLoading = false;
    update();
  }

  @override
  void onClose() {
    cameraController?.dispose();
    super.onClose();
  }
}
