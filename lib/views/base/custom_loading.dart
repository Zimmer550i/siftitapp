import 'package:flutter/material.dart';
import 'package:sarkasm/utils/app_colors.dart';

class CustomLoading extends StatelessWidget {
  final Color? color;
  const CustomLoading({super.key, this.color});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(color: color ?? AppColors.teal[50]),
    );
  }
}
