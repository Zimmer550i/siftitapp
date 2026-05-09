import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sarkasm/utils/app_colors.dart';
import 'package:sarkasm/utils/app_texts.dart';
import 'package:sarkasm/utils/custom_svg.dart';
import 'package:sarkasm/views/base/custom_app_bar.dart';
import 'package:sarkasm/views/screens/profile/history.dart';
import 'package:sarkasm/views/screens/profile/profile_information.dart';
import 'package:sarkasm/views/screens/profile/subscription.dart';

class Profile extends StatelessWidget {
  const Profile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "Profile"),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          children: [
            const SizedBox(height: 20),
            Column(
              spacing: 8,
              children: [
                options("user", "Profile Information", () {
                  Get.to(() => ProfileInformation());
                }),
                options("history", "History", () {
                  Get.to(() => History());
                }),
                options("crown", "Subscriptions", () {
                  Get.to(() => Subscription());
                }),
                options("terms", "Terms of Services", () {}),
                options("privacy", "Privacy Policy", () {}),
                options("about", "About Us", () {}),
              ],
            ),
            const SizedBox(height: 18),
            GestureDetector(
              onTap: () {},
              child: Row(
                spacing: 8,
                children: [
                  CustomSvg(
                    asset: "assets/icons/logout.svg",
                    color: AppColors.red,
                  ),
                  Expanded(
                    child: Text(
                      "Logout",
                      style: AppTexts.tlgm.copyWith(color: AppColors.red),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget options(String iconName, String title, void Function() onClick) {
    return GestureDetector(
      onTap: onClick,
      child: SizedBox(
        height: 48,
        child: Row(
          spacing: 8,
          children: [
            CustomSvg(asset: "assets/icons/$iconName.svg"),
            Expanded(
              child: Text(
                title,
                style: AppTexts.tlgm.copyWith(color: AppColors.zinc.shade600),
              ),
            ),
            CustomSvg(asset: "assets/icons/arrow_right.svg"),
          ],
        ),
      ),
    );
  }
}
