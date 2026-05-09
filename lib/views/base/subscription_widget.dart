import 'package:sarkasm/utils/app_colors.dart';
import 'package:sarkasm/utils/app_icons.dart';
import 'package:sarkasm/utils/app_texts.dart';
import 'package:sarkasm/views/base/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SubscriptionWidget extends StatelessWidget {
  final String title;
  final double price;
  final String duration;
  final List<String> pros;
  final List<String> cons;
  final bool isPurchased;
  final bool isPremium;
  final Function()? onTap;
  const SubscriptionWidget({
    super.key,
    required this.title,
    this.pros = const [],
    this.cons = const [],
    this.isPurchased = false,
    this.isPremium = false,
    this.onTap,
    required this.price,
    required this.duration,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 32),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isPurchased ? AppColors.teal : AppColors.zinc.shade300,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTexts.tlgs.copyWith(
              color: isPurchased ? AppColors.teal : AppColors.zinc.shade900,
            ),
          ),
          Row(
            spacing: 8,
            children: [
              Text(
                "\$${price.toString()}",
                style: AppTexts.dxsb.copyWith(
                  color: isPurchased ? AppColors.zinc.shade900 : AppColors.teal,
                ),
              ),
              Text(
                "/$duration",
                style: AppTexts.tmdm.copyWith(color: AppColors.zinc),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 10,
            children: [
              ...pros.map((e) {
                return Row(
                  spacing: 8,
                  children: [
                    SvgPicture.asset("assets/icons/tick.svg"),
                    Text(
                      e,
                      style: AppTexts.tmdr.copyWith(
                        color: AppColors.zinc.shade900,
                      ),
                    ),
                  ],
                );
              }),
              ...cons.map((e) {
                return Row(
                  spacing: 8,
                  children: [
                    SvgPicture.asset(AppIcons.closeCircle),
                    Text(
                      e,
                      style: AppTexts.tmdm.copyWith(color: AppColors.teal[100]),
                    ),
                  ],
                );
              }),
            ],
          ),
          const SizedBox(height: 32),
          CustomButton(
            text: isPurchased ? "Current Plan" : "Choose Plan",
            leading: isPurchased ? "assets/icons/tick.svg" : null,
            isSecondary: isPurchased,
            onTap: onTap,
          ),
        ],
      ),
    );
  }
}
