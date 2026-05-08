import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sarkasm/utils/app_colors.dart';
import 'package:sarkasm/utils/app_icons.dart';
import 'package:sarkasm/utils/app_texts.dart';
import 'package:sarkasm/utils/custom_svg.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool hasLeading;
  const CustomAppBar({super.key, required this.title, this.hasLeading = true});

  @override
  Size get preferredSize => Size(double.infinity, kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.white,
      automaticallyImplyLeading: false,
      titleSpacing: 0,
      title: SizedBox(
        height: 44,
        child: Row(
          children: [
            SizedBox(width: 16),
            InkWell(
              onTap: () => hasLeading ? Get.back() : null,
              borderRadius: BorderRadius.circular(8),
              child: SizedBox(
                height: 24,
                width: 24,
                child: hasLeading
                    ? Center(
                        child: CustomSvg(
                          asset: AppIcons.back,
                          color: AppColors.zinc.shade900,
                        ),
                      )
                    : const SizedBox(),
              ),
            ),
            Spacer(),
            Text(
              title,
              style: AppTexts.tmdm.copyWith(color: AppColors.zinc.shade900),
            ),
            Spacer(),
            const SizedBox(width: 40),
          ],
        ),
      ),
    );
  }
}
