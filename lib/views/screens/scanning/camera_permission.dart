import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sarkasm/controllers/scan_controller.dart';
import 'package:sarkasm/utils/app_colors.dart';
import 'package:sarkasm/utils/app_texts.dart';
import 'package:sarkasm/views/base/custom_button.dart';
import 'package:sarkasm/views/screens/scanning/scan.dart';

class CameraPermission extends StatelessWidget {
  const CameraPermission({super.key});

  void checkAccess() async {
    bool hasAccess = await Get.find<ScanController>().hasAccess();

    if (hasAccess) {
      Get.off(() => Scan());
    }
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      checkAccess();
    });
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Image.asset(
              "assets/images/camera.png",
              width: double.infinity,
              fit: BoxFit.cover,
            ),
            Spacer(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                spacing: 16,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "We’ll need to access your camera before continuing.",
                    style: AppTexts.dsmm,
                  ),
                  Text(
                    "SIFTITAPP uses your camera only for scanning barcodes and ingredient labels. No photos are stored or shared.",
                    style: AppTexts.tmdr.copyWith(
                      color: AppColors.zinc.shade400,
                    ),
                  ),
                ],
              ),
            ),
            Spacer(flex: 2),
            Padding(
              padding: const EdgeInsets.all(24),
              child: CustomButton(
                onTap: () async {
                  await Get.find<ScanController>().requestCameraPermission();
                  checkAccess();
                },
                text: "Enable Camera Access",
              ),
            ),
          ],
        ),
      ),
    );
  }
}
