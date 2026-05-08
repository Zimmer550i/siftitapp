import 'package:flutter/material.dart';
import 'package:sarkasm/utils/app_colors.dart';
import 'package:sarkasm/utils/app_texts.dart';

class Onboarding3 extends StatelessWidget {
  const Onboarding3({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Image.asset(
          "assets/images/onboarding_3.png",
          width: double.infinity,
          fit: BoxFit.cover,
        ),
        Spacer(),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            spacing: 16,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: Color(0xffC2FFE7),
                  borderRadius: BorderRadius.circular(99),
                ),
                child: Text(
                  "STEP 3 of 3",
                  style: AppTexts.txsr.copyWith(color: Color(0xff0A8C5A)),
                ),
              ),
              Text("Find better options, instantly.", style: AppTexts.dsmm),
              Text(
                "ScanPure suggests cleaner alternatives on every results screen. Eat well — without spending hours reading labels.",
                style: AppTexts.tmdr.copyWith(color: AppColors.zinc.shade400),
              ),
            ],
          ),
        ),
        Spacer(flex: 2),
      ],
    );
  }
}
