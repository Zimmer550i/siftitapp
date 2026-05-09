import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sarkasm/controllers/auth_controller.dart';
import 'package:sarkasm/utils/app_colors.dart';
import 'package:sarkasm/utils/app_texts.dart';
import 'package:sarkasm/utils/custom_svg.dart';
import 'package:sarkasm/views/base/custom_button.dart';
import 'package:sarkasm/views/base/custom_text_field.dart';
import 'package:sarkasm/views/base/text_with_action.dart';
import 'package:sarkasm/views/screens/auth/forget_password.dart';
import 'package:sarkasm/views/screens/auth/signup.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();

  @override
  void dispose() {
    emailCtrl.dispose();
    passCtrl.dispose();
    super.dispose();
  }

  void onSubmit() async {
    await Get.find<AuthController>().loginWithEmail(
      email: emailCtrl.text,
      password: passCtrl.text,
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
              const SizedBox(height: 80),
              Image.asset("assets/images/logo.png"),
              const SizedBox(height: 64),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Welcome!",
                  style: AppTexts.dxsb.copyWith(color: AppColors.zinc.shade900),
                ),
              ),
              const SizedBox(height: 24),
              Column(
                spacing: 16,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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
                  GestureDetector(
                    onTap: () {
                      Get.to(() => ForgetPassword(email: emailCtrl.text));
                    },
                    child: Text(
                      "Forgot password?",
                      style: AppTexts.tsms.copyWith(color: AppColors.teal),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              GetBuilder<AuthController>(
                builder: (authController) {
                  return CustomButton(
                    onTap: onSubmit,
                    text: "Login",
                    isLoading: authController.isLoading,
                  );
                },
              ),
              const SizedBox(height: 16),
              TextWithAction(
                text: "Not a member?",
                actionText: "Register now",
                onAction: () {
                  Get.to(() => Signup());
                },
              ),
              const SizedBox(height: 24),
              Container(
                height: 0.3,
                width: double.infinity,
                color: AppColors.zinc.shade200,
              ),
              const SizedBox(height: 24),
              Text(
                "Or continue with",
                style: AppTexts.txsr.copyWith(color: AppColors.zinc.shade400),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                spacing: 20,
                children: [
                  GestureDetector(
                    onTap: () => Get.find<AuthController>().signInWithGoogle(),
                    child: Container(
                      height: 52,
                      width: 52,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0xffFF616D),
                      ),
                      child: Center(
                        child: CustomSvg(asset: "assets/icons/google.svg"),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Get.find<AuthController>().signInWithApple(),
                    child: Container(
                      height: 52,
                      width: 52,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.black,
                      ),
                      child: Center(
                        child: CustomSvg(asset: "assets/icons/apple.svg"),
                      ),
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
