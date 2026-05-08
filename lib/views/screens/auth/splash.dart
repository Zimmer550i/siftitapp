import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sarkasm/utils/app_colors.dart';
import 'package:sarkasm/views/screens/onboarding/onboarding.dart';

class Splash extends StatelessWidget {
  const Splash({super.key});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(Duration(milliseconds: 100), () {
        Get.off(() => Onboarding());
      });
    });
    return Scaffold(
      backgroundColor: AppColors.teal,
      body: Center(child: Image.asset("assets/images/logo.png")),
    );
  }
}
