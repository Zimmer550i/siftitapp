import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sarkasm/utils/app_colors.dart';
import 'package:sarkasm/utils/app_texts.dart';
import 'package:sarkasm/utils/custom_list_handler.dart';
import 'package:sarkasm/views/base/custom_app_bar.dart';
import 'package:sarkasm/views/base/subscription_widget.dart';
import 'package:sarkasm/views/screens/profile/congratulations.dart';

class Subscription extends StatelessWidget {
  final bool showWarning;
  const Subscription({super.key, this.showWarning = false});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "Subscriptions"),
      body: CustomListHandler(
        topPadding: true,
        spacing: 16,
        children: [
          if (showWarning)
            Text(
              "You've reached your free limit. Unlock unlimited scans and deeper insights",
              style: AppTexts.dxss.copyWith(color: AppColors.zinc.shade900),
              textAlign: TextAlign.center,
            ),
          SubscriptionWidget(
            title: "Annual Plan",
            price: 4.99,
            duration: "month",
            pros: [
              "Unlimited barcode & OCR scans",
              "Full E-number database (3,000+)",
              "Scientific research per additive",
              "Safer product alternatives",
              "Custom allergen & diet filters",
              "Family profiles (up to 5)",
            ],
          ),
          SubscriptionWidget(
            title: "Monthly Plan",
            price: 8.99,
            isPurchased: true,
            duration: "month",
            pros: [
              "Unlimited scans",
              "Full additive database",
              "Alternatives & research",
            ],
            onTap: () {
              Get.to(() => Congratulations());
            },
          ),
        ],
      ),
    );
  }
}
