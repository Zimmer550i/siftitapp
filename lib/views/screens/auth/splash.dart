import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sarkasm/controllers/auth_controller.dart';
import 'package:sarkasm/utils/app_colors.dart';

class Splash extends StatelessWidget {
  const Splash({super.key});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.find<AuthController>().checkAuthStatus();
    });
    return Scaffold(
      backgroundColor: AppColors.teal,
      body: Center(child: Image.asset("assets/images/logo.png")),
    );
  }
}
