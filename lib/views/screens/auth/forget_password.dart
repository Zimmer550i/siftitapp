import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sarkasm/controllers/auth_controller.dart';
import 'package:sarkasm/utils/app_colors.dart';
import 'package:sarkasm/utils/app_icons.dart';
import 'package:sarkasm/utils/app_texts.dart';
import 'package:sarkasm/utils/custom_svg.dart';
import 'package:sarkasm/views/base/custom_button.dart';
import 'package:sarkasm/views/base/custom_text_field.dart';

class ForgetPassword extends StatefulWidget {
  final String email;
  const ForgetPassword({super.key, required this.email});

  @override
  State<ForgetPassword> createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  final emailCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    emailCtrl.text = widget.email;
  }

  @override
  void dispose() {
    emailCtrl.dispose();
    super.dispose();
  }

  void onSubmit() async {
    await Get.find<AuthController>().sendPasswordResetEmail(emailCtrl.text);
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
                alignment: Alignment.centerLeft,
                child: Text(
                  "Forgot Password?",
                  style: AppTexts.dxsb.copyWith(color: AppColors.zinc.shade900),
                ),
              ),
              const SizedBox(height: 8),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Please enter your email to reset your password",
                  style: AppTexts.tmdr.copyWith(color: AppColors.zinc),
                ),
              ),
              const SizedBox(height: 24),
              CustomTextField(
                controller: emailCtrl,
                title: "Email",
                hintText: "Enter your email",
              ),
              Spacer(),
              GetBuilder<AuthController>(
                builder: (authController) {
                  return CustomButton(
                    onTap: onSubmit,
                    text: "Send reset link",
                    isLoading: authController.isLoading,
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
