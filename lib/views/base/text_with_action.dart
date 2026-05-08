import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:sarkasm/utils/app_colors.dart';
import 'package:sarkasm/utils/app_texts.dart';

class TextWithAction extends StatelessWidget {
  const TextWithAction({
    super.key,
    required this.text,
    required this.actionText,
    required this.onAction,
    this.textColor,
    this.actionColor,
  });

  final String text;
  final String actionText;
  final VoidCallback onAction;
  final Color? textColor;
  final Color? actionColor;

  @override
  Widget build(BuildContext context) {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        text: text,
        style: AppTexts.txsr.copyWith(
          color: textColor ?? AppColors.zinc.shade400,
        ),
        children: [
          TextSpan(
            text: " $actionText",
            style: AppTexts.txss.copyWith(color: actionColor ?? AppColors.teal),
            recognizer: TapGestureRecognizer()..onTap = onAction,
          ),
        ],
      ),
    );
  }
}
