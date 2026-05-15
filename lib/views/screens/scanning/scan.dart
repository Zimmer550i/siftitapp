import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'package:get/get.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:sarkasm/controllers/auth_controller.dart';
import 'package:sarkasm/controllers/scan_controller.dart';
import 'package:sarkasm/utils/app_colors.dart';
import 'package:sarkasm/utils/app_texts.dart';
import 'package:sarkasm/utils/custom_list_handler.dart';
import 'package:sarkasm/utils/custom_snackbar.dart';
import 'package:sarkasm/utils/custom_svg.dart';
import 'package:sarkasm/utils/formatter.dart';
import 'package:sarkasm/views/base/custom_button.dart';
import 'package:sarkasm/views/base/profile_picture.dart';
import 'package:sarkasm/views/screens/profile/profile.dart';
import 'package:sarkasm/views/screens/scanning/camera_permission.dart';
import 'package:sarkasm/views/screens/scanning/scan_result.dart';

class Scan extends StatefulWidget {
  const Scan({super.key});

  @override
  State<Scan> createState() => _ScanState();
}

class _ScanState extends State<Scan> {
  final scanCtrl = Get.find<ScanController>();
  late MobileScannerController mobileScannerController;
  bool hasAccess = false;
  BarcodeCapture? latestCapture;
  Timer? _latestCaptureResetTimer;

  @override
  void initState() {
    super.initState();
    if (Get.find<AuthController>().getUser == null) {
      Get.find<AuthController>().getUserInfo().then(
        (val) => Get.find<AuthController>().userModel.value = val,
      );
    }
    checkAccess();
    mobileScannerController = MobileScannerController();
  }

  @override
  void dispose() {
    _latestCaptureResetTimer?.cancel();
    mobileScannerController.dispose();
    super.dispose();
  }

  void checkAccess() async {
    final access = await scanCtrl.hasAccess();

    if (!mounted) return;

    setState(() {
      hasAccess = access;
    });

    if (!access) {
      Get.to(() => CameraPermission());
    }
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
                          image: Get.find<AuthController>().getUser?.imageUrl,
                          size: 40,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Stack(
                children: [
                  SizedBox(
                    height: 300,
                    child: MobileScanner(
                      controller: mobileScannerController,
                      fit: BoxFit.cover,
                      tapToFocus: true,
                      scanWindow: Rect.fromLTWH(
                        24,
                        24,
                        MediaQuery.of(context).size.width - 48,
                        MediaQuery.of(context).size.width - 48,
                      ),
                      onDetect: onDetect,
                    ),
                  ),
                  Positioned(
                    top: 24,
                    bottom: 24,
                    left: 24,
                    right: 24,
                    child: CustomSvg(asset: "assets/icons/scan.svg"),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              if (latestCapture != null)
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 0,
                    horizontal: 24,
                  ),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Detected: ",
                          style: AppTexts.tsms.copyWith(color: AppColors.zinc),
                        ),
                        Column(
                          children: [
                            for (var i in latestCapture!.barcodes)
                              Text(
                                i.displayValue.toString(),
                                style: AppTexts.tsmr.copyWith(
                                  color: AppColors.zinc,
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                child: Column(
                  children: [
                    Obx(
                      () => CustomButton(
                        onTap: onScan,
                        isLoading: scanCtrl.isLoading.value,
                        isDisabled: latestCapture?.barcodes.isEmpty ?? false,
                        text: "Tap to scan",
                        leading: "assets/icons/scan.svg",
                      ),
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
              Obx(
                () => CustomListHandler(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  seperator: Padding(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    child: Container(
                      height: 0.5,
                      width: double.infinity,
                      color: AppColors.zinc.shade300,
                    ),
                  ),
                  children: [
                    if (Get.find<AuthController>()
                            .userModel
                            .value
                            ?.recentScans !=
                        null)
                      for (var i
                          in Get.find<AuthController>()
                              .userModel
                              .value!
                              .recentScans!)
                        GestureDetector(
                          onTap: () {
                            Get.to(() => ScanResult(scanResult: i));
                          },
                          child: Row(
                            spacing: 8,
                            children: [
                              Container(
                                height: 12,
                                width: 12,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: spectrumColor(i.safety),
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  i.name,
                                  style: AppTexts.tmdm.copyWith(
                                    color: AppColors.zinc.shade700,
                                  ),
                                ),
                              ),
                              Text(
                                "${Formatter.durationFormatter(DateTime.now().difference(i.createdAt))} ago",
                                style: AppTexts.txsm.copyWith(
                                  color: AppColors.zinc.shade300,
                                ),
                              ),
                            ],
                          ),
                        ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> onScan() async {
    final capture = latestCapture;

    if (capture == null || capture.barcodes.isEmpty) {
      customSnackBar("No barcode found");
      return;
    }

    final data = capture.barcodes
        .map((barcode) => barcode.rawValue ?? barcode.displayValue)
        .whereType<String>()
        .toList();

    if (data.isEmpty) {
      customSnackBar("No barcode found");
      return;
    }

    debugPrint(data.toString());

    final result = await scanCtrl.getScanResult(data);

    if (result == "success") {
      Get.to(
        () => ScanResult(
          scanResult: Get.find<AuthController>().getUser!.recentScans!.first,
        ),
      );
    } else {
      customSnackBar(result);
    }
  }

  void onDetect(BarcodeCapture capture) {
    debugPrint(
      "Detected: ${capture.barcodes.map((val) => val.displayValue).join(", ")}",
    );

    if (capture.barcodes.isNotEmpty) {
      _latestCaptureResetTimer?.cancel();
      setState(() => latestCapture = capture);
      HapticFeedback.vibrate();

      _latestCaptureResetTimer = Timer(const Duration(seconds: 1), () {
        if (!mounted) return;
        HapticFeedback.vibrate();
        setState(() => latestCapture = null);
      });
    } else {
      _latestCaptureResetTimer?.cancel();
      setState(() => latestCapture = null);
    }
  }
}
