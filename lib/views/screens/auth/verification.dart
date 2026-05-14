import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sarkasm/controllers/auth_controller.dart';
import 'package:sarkasm/utils/app_colors.dart';
import 'package:sarkasm/utils/app_icons.dart';
import 'package:sarkasm/utils/app_texts.dart';
import 'package:sarkasm/utils/custom_svg.dart';
import 'package:sarkasm/views/base/custom_button.dart';
import 'package:sarkasm/views/base/text_with_action.dart';

class Verification extends StatefulWidget {
  final String email;
  final bool isResettingPassword;
  const Verification({
    super.key,
    required this.email,
    this.isResettingPassword = false,
  });

  @override
  State<Verification> createState() => _VerificationState();
}

class _VerificationState extends State<Verification> {
  Timer? _resendTimer;
  int _resendSeconds = 10;

  bool get _canResend => _resendSeconds == 0;

  @override
  void initState() {
    super.initState();
    _startResendTimer();
  }

  void onSubmit() async {
    await Get.find<AuthController>().checkEmailVerification();
  }

  @override
  void dispose() {
    _resendTimer?.cancel();
    super.dispose();
  }

  void _startResendTimer() {
    _resendTimer?.cancel();
    if (mounted) {
      setState(() {
        _resendSeconds = 10;
      });
    } else {
      _resendSeconds = 10;
    }

    _resendTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_resendSeconds <= 1) {
        timer.cancel();
        if (mounted) {
          setState(() {
            _resendSeconds = 0;
          });
        }
        return;
      }

      if (mounted) {
        setState(() {
          _resendSeconds--;
        });
      }
    });
  }

  void _onResend() {
    if (!_canResend) return;
    Get.find<AuthController>().sendEmailVerification();
    _startResendTimer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: CustomAppBar(title: "Forgot Password"),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24),
        child: SafeArea(
          child: Column(
            children: [
              Row(
                children: [
                  InkWell(
                    onTap: () => Get.back(),
                    borderRadius: BorderRadius.circular(8),
                    child: SizedBox(
                      height: 24,
                      width: 24,
                      child: Center(
                        child: CustomSvg(
                          asset: AppIcons.back,
                          color: AppColors.zinc.shade900,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                ],
              ),
              Image.asset("assets/images/logo.png"),
              const SizedBox(height: 40),
              Align(
                alignment: Alignment.center,
                child: Text(
                  "Verify your email",
                  style: AppTexts.tlgs.copyWith(color: AppColors.zinc.shade900),
                ),
              ),
              const SizedBox(height: 8),
              Align(
                alignment: Alignment.center,
                child: Text(
                  "A verification link was sent to\n${widget.email}",
                  textAlign: TextAlign.center,
                  style: AppTexts.tsmr.copyWith(color: AppColors.zinc),
                ),
              ),
              const SizedBox(height: 48),
              Text(
                "Open the link from your inbox, then return here to continue.",
                textAlign: TextAlign.center,
                style: AppTexts.tsmr.copyWith(color: AppColors.zinc),
              ),
              const SizedBox(height: 24),
              TextWithAction(
                text: "Haven’t received the email yet?",
                actionText: _canResend ? "Resend" : "Resend in $_resendSeconds",
                actionColor: _canResend
                    ? AppColors.teal
                    : AppColors.zinc.shade400,
                onAction: _onResend,
              ),
              const SizedBox(height: 16),
              Spacer(),
              GetBuilder<AuthController>(
                builder: (authController) {
                  return CustomButton(
                    onTap: onSubmit,
                    text: "I've Verified",
                    isLoading: authController.isLoading.value,
                  );
                },
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
