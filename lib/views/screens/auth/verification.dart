import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pinput/pinput.dart';
import 'package:sarkasm/utils/app_colors.dart';
import 'package:sarkasm/utils/app_icons.dart';
import 'package:sarkasm/utils/app_texts.dart';
import 'package:sarkasm/utils/custom_svg.dart';
import 'package:sarkasm/views/base/custom_button.dart';
import 'package:sarkasm/views/base/text_with_action.dart';
import 'package:sarkasm/views/screens/auth/reset_password.dart';

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
  final otpCtrl = TextEditingController();
  final _focusNode = FocusNode();
  Timer? _resendTimer;
  int _resendSeconds = 10;

  bool get _canResend => _resendSeconds == 0;

  @override
  void initState() {
    super.initState();
    _startResendTimer();
  }

  void onSubmit() async {
    if (widget.isResettingPassword) {
      Get.to(() => ResetPassword());
    } else {
      Get.back();
      Get.back();
      Get.back();
    }
  }

  @override
  void dispose() {
    _resendTimer?.cancel();
    otpCtrl.dispose();
    _focusNode.dispose();
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
                  "Enter confirmation code",
                  style: AppTexts.tlgs.copyWith(color: AppColors.zinc.shade900),
                ),
              ),
              const SizedBox(height: 8),
              Align(
                alignment: Alignment.center,
                child: Text(
                  "A 4-digit code was sent to\n${widget.email}",
                  textAlign: TextAlign.center,
                  style: AppTexts.tsmr.copyWith(color: AppColors.zinc),
                ),
              ),
              const SizedBox(height: 48),
              Pinput(
                controller: otpCtrl,
                focusNode: _focusNode,
                onTapOutside: (event) {
                  _focusNode.unfocus();
                },
                separatorBuilder: (index) {
                  return const SizedBox(width: 8);
                },
                defaultPinTheme: PinTheme(
                  height: 48,
                  width: 48,
                  textStyle: AppTexts.tmdr.copyWith(
                    color: AppColors.zinc.shade900,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: AppColors.zinc.shade200),
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                focusedPinTheme: PinTheme(
                  height: 48,
                  width: 48,
                  textStyle: AppTexts.tmdr.copyWith(
                    color: AppColors.zinc.shade900,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: AppColors.teal),
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                followingPinTheme: PinTheme(
                  height: 48,
                  width: 48,
                  textStyle: AppTexts.tmdr.copyWith(
                    color: AppColors.zinc.shade900,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.zinc.shade200),
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              TextWithAction(
                text: "Haven’t received code yet?",
                actionText: _canResend ? "Resend" : "Resend in $_resendSeconds",
                actionColor: _canResend
                    ? AppColors.teal
                    : AppColors.zinc.shade400,
                onAction: _onResend,
              ),
              const SizedBox(height: 16),
              Spacer(),
              CustomButton(onTap: onSubmit, text: "Verify"),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
