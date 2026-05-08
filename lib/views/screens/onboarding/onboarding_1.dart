import 'package:flutter/material.dart';
import 'package:sarkasm/utils/app_colors.dart';
import 'package:sarkasm/utils/app_texts.dart';

class Onboarding1 extends StatelessWidget {
  const Onboarding1({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Image.asset(
          "assets/images/onboarding_1.png",
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
                  "STEP 1 of 3",
                  style: AppTexts.txsr.copyWith(color: Color(0xff0A8C5A)),
                ),
              ),
              Text("Scan any product, anywhere.", style: AppTexts.dsmm),
              Text(
                "Point your camera at a barcode or ingredient list. ScanPure reads it in under 2 seconds — no typing, no searching.",
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
