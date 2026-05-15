import 'package:flutter/material.dart';
import 'package:sarkasm/models/scan_model.dart';
import 'package:sarkasm/utils/app_colors.dart';
import 'package:sarkasm/utils/app_texts.dart';
import 'package:sarkasm/utils/custom_list_handler.dart';
import 'package:sarkasm/views/base/custom_app_bar.dart';

class ScanResult extends StatelessWidget {
  final ScanModel scanResult;
  const ScanResult({super.key, required this.scanResult});

  int get rating => (scanResult.safety * 100).toInt();

  int get highAdditivesCount => scanResult.ingrediants
      .where((ingredient) => ingredient.impact == Impact.high)
      .length;

  String getRatingLabel(int rating) {
    if (rating >= 90) return "Good";
    if (rating >= 80) return "Decent";
    if (rating >= 70) return "Bad";
    if (rating >= 50) return "Very Bad";
    return "Warning";
  }

  String getConcernLevel(int flaggedCount) {
    if (flaggedCount == 0) return "No";
    if (flaggedCount <= 2) return "Little";
    if (flaggedCount <= 4) return "Moderate";
    return "Massive";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: scanResult.name),
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
                          rating.toString(),
                          style: AppTexts.dxsm.copyWith(
                            color: AppColors.zinc.shade900,
                          ),
                        ),
                        SizedBox(
                          height: 90,
                          width: 90,
                          child: CircularProgressIndicator(
                            value: scanResult.safety,
                            color: spectrumColor(scanResult.safety),
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
                            getRatingLabel(rating),
                            style: AppTexts.dxsm.copyWith(
                              color: spectrumColor(scanResult.safety),
                            ),
                          ),
                          Text(
                            "${getConcernLevel(highAdditivesCount)} concerns detected in ingredients",
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
                              "$highAdditivesCount additives flagged",
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
                  for (var i in scanResult.ingrediants)
                    Row(
                      spacing: 8,
                      children: [
                        Container(
                          height: 12,
                          width: 12,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: spectrumColor(0.3),
                          ),
                        ),
                        Expanded(
                          child: Text(
                            i.name,
                            style: AppTexts.tmdm.copyWith(
                              color: AppColors.zinc.shade700,
                            ),
                          ),
                        ),
                        getRisk(
                          i.impact == Impact.high
                              ? 1
                              : i.impact == Impact.med
                              ? .5
                              : 0,
                        ),
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
