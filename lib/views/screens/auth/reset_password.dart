import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sarkasm/utils/app_colors.dart';
import 'package:sarkasm/utils/app_icons.dart';
import 'package:sarkasm/utils/app_texts.dart';
import 'package:sarkasm/utils/custom_svg.dart';
import 'package:sarkasm/views/base/custom_button.dart';
import 'package:sarkasm/views/base/custom_text_field.dart';
import 'package:sarkasm/views/screens/auth/login.dart';

class ResetPassword extends StatefulWidget {
  const ResetPassword({super.key});

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  final passCtrl = TextEditingController();
  final confirmPassCtrl = TextEditingController();

  @override
  void dispose() {
    passCtrl.dispose();
    confirmPassCtrl.dispose();
    super.dispose();
  }

  void onSubmit() async {
    Get.offAll(() => Login());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                alignment: Alignment.centerLeft,
                child: Text(
                  "Reset Password",
                  style: AppTexts.dxsb.copyWith(color: AppColors.zinc.shade900),
                ),
              ),
              const SizedBox(height: 8),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Create an account to get started",
                  style: AppTexts.tmdr.copyWith(color: AppColors.zinc),
                ),
              ),
              const SizedBox(height: 24),
              Column(
                spacing: 16,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomTextField(
                    controller: passCtrl,
                    title: "Password",
                    hintText: "Enter your password",
                    isPassword: true,
                  ),
                  CustomTextField(
                    controller: confirmPassCtrl,
                    title: "Confirm Password",
                    hintText: "Re-Enter your password",
                    isPassword: true,
                  ),
                ],
              ),
              SizedBox(height: 50),
              CustomButton(onTap: onSubmit, text: "Confirm"),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
