import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sarkasm/controllers/scan_controller.dart';
import 'package:sarkasm/utils/app_colors.dart';
import 'package:sarkasm/utils/app_texts.dart';
import 'package:sarkasm/utils/custom_list_handler.dart';
import 'package:sarkasm/utils/formatter.dart';
import 'package:sarkasm/views/base/custom_app_bar.dart';
import 'package:sarkasm/views/screens/scanning/scan_result.dart';

class History extends StatelessWidget {
  const History({super.key});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => Get.find<ScanController>().getScanHistory(),
    );

    return Scaffold(
      appBar: CustomAppBar(title: "History"),
      body: Obx(
        () => CustomListHandler(
          onRefresh: () => Get.find<ScanController>().getScanHistory(),
          onLoadMore: () =>
              Get.find<ScanController>().getScanHistory(isLoadmore: true),
          topPadding: true,
          isLoading: Get.find<ScanController>().isLoading.value,
          isLoadingMore:
              Get.find<ScanController>().isLoading.value &&
              Get.find<ScanController>().scanHistory.isNotEmpty,
          seperator: Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Container(
              height: 0.5,
              width: double.infinity,
              color: AppColors.zinc.shade300,
            ),
          ),
          children: [
            for (var i in Get.find<ScanController>().scanHistory)
              GestureDetector(
                onTap: () {
                  Get.to(() => ScanResult(scanResult: i));
                },
                child: Row(
                  spacing: 8,
                  children: [
                    Container(
                      height: 12,
                      width: 12,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: spectrumColor(i.safety),
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
                    Text(
                      "${Formatter.durationFormatter(DateTime.now().difference(i.createdAt))} ago",
                      style: AppTexts.txsm.copyWith(
                        color: AppColors.zinc.shade300,
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
}
