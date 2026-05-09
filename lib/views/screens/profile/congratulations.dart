import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sarkasm/utils/app_colors.dart';
import 'package:sarkasm/utils/app_texts.dart';
import 'package:sarkasm/utils/custom_svg.dart';
import 'package:sarkasm/views/base/custom_button.dart';

class Congratulations extends StatelessWidget {
  const Congratulations({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CustomSvg(asset: "assets/icons/congrats.svg"),
            const SizedBox(height: 32),
            Text(
              "Congratulations!",
              style: AppTexts.dsms.copyWith(color: AppColors.zinc.shade700),
            ),
            const SizedBox(height: 32),
            Text(
              "You have successfully purchased the Package. Now you can enjoy it over offline from my music tab, anytime anywhere.",
              style: AppTexts.tmdr.copyWith(color: AppColors.zinc),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            CustomButton(
              onTap: () {
                Get.back();
                Get.back();
              },
              text: "Back To Home",
              width: null,
            ),
          ],
        ),
      ),
    );
  }
}
