import 'package:camera/camera.dart' as camera;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sarkasm/controllers/scan_controller.dart';
import 'package:sarkasm/utils/app_colors.dart';
import 'package:sarkasm/utils/app_texts.dart';
import 'package:sarkasm/utils/custom_list_handler.dart';
import 'package:sarkasm/utils/custom_svg.dart';
import 'package:sarkasm/views/base/custom_button.dart';
import 'package:sarkasm/views/base/profile_picture.dart';
import 'package:sarkasm/views/screens/profile/profile.dart';
import 'package:sarkasm/views/screens/scanning/scan_result.dart';

class Scan extends StatefulWidget {
  const Scan({super.key});

  @override
  State<Scan> createState() => _ScanState();
}

class _ScanState extends State<Scan> {
  final camCtrl = Get.find<ScanController>();

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
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                child: Row(
                  children: [
                    CustomSvg(asset: "assets/icons/logo.svg"),
                    Spacer(),
                    GestureDetector(
                      onTap: () {
                        Get.to(() => Profile());
                      },
                      child: AbsorbPointer(
                        child: ProfilePicture(
                          image: "https://thispersondoesnotexist.com",
                          size: 40,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              GetBuilder<ScanController>(
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
                        child: CustomSvg(asset: "assets/icons/scan.svg"),
                      ),
                    ],
                  );
                },
              ),
              Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    CustomButton(
                      onTap: () {
                        Get.to(() => ScanResult());
                      },
                      text: "Tap to scan",
                      leading: "assets/icons/scan.svg",
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Padding(
                padding: const EdgeInsets.only(left: 24),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Recent",
                    style: AppTexts.tmdr.copyWith(color: AppColors.zinc),
                  ),
                ),
              ),
              CustomListHandler(
                shrinkWrap: true,
                seperator: Padding(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: Container(
                    height: 0.5,
                    width: double.infinity,
                    color: AppColors.zinc.shade300,
                  ),
                ),
                children: [
                  for (int i = 0; i < 3; i++)
                    GestureDetector(
                      onTap: () {
                        Get.to(() => ScanResult());
                      },
                      child: Row(
                        spacing: 8,
                        children: [
                          Container(
                            height: 12,
                            width: 12,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: spectrumColor(i / 2),
                            ),
                          ),
                          Expanded(
                            child: Text(
                              "Pringles Original",
                              style: AppTexts.tmdm.copyWith(
                                color: AppColors.zinc.shade700,
                              ),
                            ),
                          ),
                          Text(
                            "2m ago",
                            style: AppTexts.txsm.copyWith(
                              color: AppColors.zinc.shade300,
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
