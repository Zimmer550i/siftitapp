import 'package:camera/camera.dart' as camera;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sarkasm/controllers/custom_camera_controller.dart';
import 'package:sarkasm/utils/custom_svg.dart';
import 'package:sarkasm/views/base/custom_button.dart';
import 'package:sarkasm/views/base/profile_picture.dart';

class Scan extends StatefulWidget {
  const Scan({super.key});

  @override
  State<Scan> createState() => _ScanState();
}

class _ScanState extends State<Scan> {
  final camCtrl = Get.find<CustomCameraController>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      camCtrl.prepareCamera();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Row(
                children: [
                  CustomSvg(asset: "assets/icons/logo.svg"),
                  Spacer(),
                  ProfilePicture(
                    image: "https://thispersondoesnotexist.com",
                    size: 40,
                  ),
                ],
              ),
            ),
            GetBuilder<CustomCameraController>(
              builder: (controller) {
                if (controller.cameraError != null) {
                  return Center(child: Text(controller.cameraError!));
                }

                if (controller.isLoading ||
                    controller.cameraController == null ||
                    !controller.cameraController!.value.isInitialized) {
                  return const Center(child: CircularProgressIndicator());
                }

                return Stack(
                  children: [
                    camera.CameraPreview(controller.cameraController!),
                    Positioned(
                      top: 24,
                      bottom: 24,
                      left: 24,
                      right: 24,
                      child: CustomSvg(asset: "assets/icons/scan.svg")),
                  ],
                );
              },
            ),
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  CustomButton(
                    text: "Tap to scan",
                    leading: "assets/icons/scan.svg",
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
