import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sarkasm/controllers/auth_controller.dart';
import 'package:sarkasm/utils/app_colors.dart';
import 'package:sarkasm/utils/app_texts.dart';
import 'package:sarkasm/views/base/custom_button.dart';
import 'package:sarkasm/views/base/custom_text_field.dart';
import 'package:sarkasm/views/base/text_with_action.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final nameCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();
  final confirmPassCtrl = TextEditingController();

  @override
  void dispose() {
    nameCtrl.dispose();
    emailCtrl.dispose();
    passCtrl.dispose();
    confirmPassCtrl.dispose();
    super.dispose();
  }

  void onSubmit() async {
    await Get.find<AuthController>().signUpWithEmail(
      name: nameCtrl.text,
      email: emailCtrl.text,
      password: passCtrl.text,
      confirmPassword: confirmPassCtrl.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 24),
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 32),
              Image.asset("assets/images/logo.png"),
              const SizedBox(height: 40),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Signup",
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
                    controller: nameCtrl,
                    title: "Name",
                    hintText: "Enter your name",
                  ),
                  CustomTextField(
                    controller: emailCtrl,
                    title: "Email",
                    hintText: "Enter your email",
                  ),
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
              const SizedBox(height: 24),
              GetBuilder<AuthController>(
                builder: (authController) {
                  return CustomButton(
                    onTap: onSubmit,
                    text: "Register",
                    isLoading: authController.isLoading.value,
                  );
                },
              ),
              const SizedBox(height: 16),
              TextWithAction(
                text: "Already have an account?",
                actionText: "Login",
                onAction: () {
                  Get.back();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
