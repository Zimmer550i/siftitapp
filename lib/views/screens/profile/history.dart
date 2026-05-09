import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sarkasm/utils/app_colors.dart';
import 'package:sarkasm/utils/app_texts.dart';
import 'package:sarkasm/utils/custom_list_handler.dart';
import 'package:sarkasm/views/base/custom_app_bar.dart';
import 'package:sarkasm/views/screens/scanning/scan_result.dart';

class History extends StatelessWidget {
  const History({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "History"),
      body: CustomListHandler(
        topPadding: true,
        seperator: Padding(
          padding: EdgeInsets.symmetric(vertical: 16),
          child: Container(
            height: 0.5,
            width: double.infinity,
            color: AppColors.zinc.shade300,
          ),
        ),
        children: [
          for (int i = 0; i < 3; i++)
            GestureDetector(
              onTap: () {
                Get.to(() => ScanResult());
              },
              child: Row(
                spacing: 8,
                children: [
                  Container(
                    height: 12,
                    width: 12,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: spectrumColor(i / 2),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      "Pringles Original",
                      style: AppTexts.tmdm.copyWith(
                        color: AppColors.zinc.shade700,
                      ),
                    ),
                  ),
                  Text(
                    "2m ago",
                    style: AppTexts.txsm.copyWith(
                      color: AppColors.zinc.shade300,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
