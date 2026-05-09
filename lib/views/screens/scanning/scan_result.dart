import 'package:flutter/material.dart';
import 'package:sarkasm/utils/app_colors.dart';
import 'package:sarkasm/utils/app_texts.dart';
import 'package:sarkasm/utils/custom_list_handler.dart';
import 'package:sarkasm/views/base/custom_app_bar.dart';

class ScanResult extends StatelessWidget {
  const ScanResult({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "Pringles Originals"),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 24),
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 24),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 50),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        Text(
                          "72",
                          style: AppTexts.dxsm.copyWith(
                            color: AppColors.zinc.shade900,
                          ),
                        ),
                        SizedBox(
                          height: 90,
                          width: 90,
                          child: CircularProgressIndicator(
                            value: 0.72,
                            color: spectrumColor(.72),
                            strokeWidth: 12,
                            strokeCap: StrokeCap.round,
                            backgroundColor: AppColors.zinc.shade200,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 24),
                    Expanded(
                      child: Column(
                        spacing: 4,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "C+",
                            style: AppTexts.dxsm.copyWith(
                              color: spectrumColor(0.72),
                            ),
                          ),
                          Text(
                            "Moderate concerns detected in ingredients",
                            style: AppTexts.tsmr.copyWith(
                              color: AppColors.zinc,
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Color(0xffFFE8D8),
                              borderRadius: BorderRadius.circular(99),
                            ),
                            child: Text(
                              "3 additives flagged",
                              style: AppTexts.tsmr.copyWith(
                                color: AppColors.bad,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 34),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Ingredient Analysis",
                  style: AppTexts.tmdr.copyWith(color: AppColors.zinc),
                ),
              ),
              CustomListHandler(
                shrinkWrap: true,
                topPadding: true,
                endIndicator: "",
                horizontalPadding: 0,
                physics: NeverScrollableScrollPhysics(),
                seperator: Padding(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: Container(
                    height: 0.5,
                    width: double.infinity,
                    color: AppColors.zinc.shade300,
                  ),
                ),
                children: [
                  for (int i = 0; i < 4; i++)
                    Row(
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
                            "Some Ingredient",
                            style: AppTexts.tmdm.copyWith(
                              color: AppColors.zinc.shade700,
                            ),
                          ),
                        ),
                        getRisk(0.22 * (i + 1)),
                      ],
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget getRisk(double value) {
    if (value < 0.3) {
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        decoration: BoxDecoration(
          color: Color(0xffC2FFE7),
          borderRadius: BorderRadius.circular(99),
        ),
        child: Text(
          "LOW",
          style: AppTexts.tsmr.copyWith(color: AppColors.good),
        ),
      );
    } else if (value < 0.6) {
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        decoration: BoxDecoration(
          color: Color(0xffFFE8D8),
          borderRadius: BorderRadius.circular(99),
        ),
        child: Text("MED", style: AppTexts.tsmr.copyWith(color: AppColors.mid)),
      );
    }
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: Color(0xffFFC8C8),
        borderRadius: BorderRadius.circular(99),
      ),
      child: Text("HIGH", style: AppTexts.tsmr.copyWith(color: AppColors.bad)),
    );
  }
}
