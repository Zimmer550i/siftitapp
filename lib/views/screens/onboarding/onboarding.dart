import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sarkasm/utils/app_colors.dart';
import 'package:sarkasm/utils/app_texts.dart';
import 'package:sarkasm/views/base/custom_button.dart';
import 'package:sarkasm/views/screens/auth/login.dart';
import 'package:sarkasm/views/screens/onboarding/onboarding_1.dart';
import 'package:sarkasm/views/screens/onboarding/onboarding_2.dart';
import 'package:sarkasm/views/screens/onboarding/onboarding_3.dart';

class Onboarding extends StatefulWidget {
  const Onboarding({super.key});

  @override
  State<Onboarding> createState() => _OnboardingState();
}

class _OnboardingState extends State<Onboarding> {
  PageController controller = PageController();
  int index = 0;
  List<Widget> pages = [Onboarding1(), Onboarding2(), Onboarding3()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: SafeArea(
              child: PageView(
                controller: controller,
                children: pages,
                onPageChanged: (value) {
                  setState(() {
                    index = value;
                  });
                },
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: 4,
            children: [
              AnimatedContainer(
                duration: Duration(milliseconds: 300),
                height: 8,
                width: index == 0 ? 24 : 8,
                decoration: BoxDecoration(
                  color: index == 0 ? AppColors.teal : AppColors.zinc.shade200,
                  borderRadius: BorderRadius.circular(99),
                ),
              ),
              AnimatedContainer(
                duration: Duration(milliseconds: 300),
                height: 8,
                width: index == 1 ? 24 : 8,
                decoration: BoxDecoration(
                  color: index == 1 ? AppColors.teal : AppColors.zinc.shade200,
                  borderRadius: BorderRadius.circular(99),
                ),
              ),
              AnimatedContainer(
                duration: Duration(milliseconds: 300),
                height: 8,
                width: index == 2 ? 24 : 8,
                decoration: BoxDecoration(
                  color: index == 2 ? AppColors.teal : AppColors.zinc.shade200,
                  borderRadius: BorderRadius.circular(99),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: CustomButton(
              onTap: () {
                if (index == 2) {
                  Get.offAll(() => Login());
                } else {
                  controller.animateToPage(
                    index + 1,
                    duration: Duration(milliseconds: 300),
                    curve: Curves.ease,
                  );
                }
              },
              text: "Next",
            ),
          ),
          const SizedBox(height: 24),
          GestureDetector(
            onTap: () {
              Get.offAll(() => Login());
            },
            child: Text(
              "Skip intro",
              style: AppTexts.tsms.copyWith(color: AppColors.zinc.shade400),
            ),
          ),
          SafeArea(top: false, child: SizedBox(height: 20)),
        ],
      ),
    );
  }
}
