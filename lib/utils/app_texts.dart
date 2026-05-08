import 'package:flutter/material.dart';
import 'package:sarkasm/utils/app_colors.dart';

/// AppTexts
/// ---------------------------------------------------------------------------
/// Naming Convention:
/// d = Display text (large headings, hero titles)
/// t = Text (body text, labels, paragraphs)
///
/// Size scale (largest → smallest):
/// 2xl, xl, lg, md, sm, xs
///
/// Weight suffix:
/// r = Regular (FontWeight.w400)
/// m = Medium  (FontWeight.w500)
/// s = SemiBold(FontWeight.w600)
/// b = Bold    (FontWeight.w700)
///
/// Example:
/// dxlb -> Display, Extra Large, Bold
/// tsmr -> Text, Small, Regular
///
/// Usage:
/// Text("Hello", style: AppTexts.tmdr);
///
/// Customization:
/// Use copyWith() to override only what you need without breaking the system.
/// Example:
/// AppTexts.tmdr.copyWith(color: Colors.red, fontSize: 15);
/// ---------------------------------------------------------------------------
class AppTexts {
  // =========================
  // Display
  // =========================

  // 2XL – 72
  static TextStyle d2xlr = _base(72, 88, FontWeight.w400);
  static TextStyle d2xlm = _base(72, 88, FontWeight.w500);
  static TextStyle d2xls = _base(72, 88, FontWeight.w600);
  static TextStyle d2xlb = _base(72, 88, FontWeight.w700);

  // XL – 60
  static TextStyle dxlr = _base(60, 72, FontWeight.w400);
  static TextStyle dxlm = _base(60, 72, FontWeight.w500);
  static TextStyle dxls = _base(60, 72, FontWeight.w600);
  static TextStyle dxlb = _base(60, 72, FontWeight.w700);

  // LG – 48
  static TextStyle dlgr = _base(48, 60, FontWeight.w400);
  static TextStyle dlgm = _base(48, 60, FontWeight.w500);
  static TextStyle dlgs = _base(48, 60, FontWeight.w600);
  static TextStyle dlgb = _base(48, 60, FontWeight.w700);

  // MD – 36
  static TextStyle dmdr = _base(36, 44, FontWeight.w400);
  static TextStyle dmdm = _base(36, 44, FontWeight.w500);
  static TextStyle dmds = _base(36, 44, FontWeight.w600);
  static TextStyle dmdb = _base(36, 44, FontWeight.w700);

  // SM – 30
  static TextStyle dsmr = _base(30, 36, FontWeight.w400);
  static TextStyle dsmm = _base(30, 36, FontWeight.w500);
  static TextStyle dsms = _base(30, 36, FontWeight.w600);
  static TextStyle dsmb = _base(30, 36, FontWeight.w700);

  // XS – 24
  static TextStyle dxsr = _base(24, 32, FontWeight.w400);
  static TextStyle dxsm = _base(24, 32, FontWeight.w500);
  static TextStyle dxss = _base(24, 32, FontWeight.w600);
  static TextStyle dxsb = _base(24, 32, FontWeight.w700);

  // =========================
  // Text
  // =========================

  // XL – 20
  static TextStyle txlr = _base(20, 30, FontWeight.w400);
  static TextStyle txlm = _base(20, 30, FontWeight.w500);
  static TextStyle txls = _base(20, 30, FontWeight.w600);
  static TextStyle txlb = _base(20, 30, FontWeight.w700);

  // LG – 18
  static TextStyle tlgr = _base(18, 28, FontWeight.w400);
  static TextStyle tlgm = _base(18, 28, FontWeight.w500);
  static TextStyle tlgs = _base(18, 28, FontWeight.w600);
  static TextStyle tlgb = _base(18, 28, FontWeight.w700);

  // MD – 16
  static TextStyle tmdr = _base(16, 24, FontWeight.w400);
  static TextStyle tmdm = _base(16, 24, FontWeight.w500);
  static TextStyle tmds = _base(16, 24, FontWeight.w600);
  static TextStyle tmdb = _base(16, 24, FontWeight.w700);

  // SM – 14
  static TextStyle tsmr = _base(14, 20, FontWeight.w400);
  static TextStyle tsmm = _base(14, 20, FontWeight.w500);
  static TextStyle tsms = _base(14, 20, FontWeight.w600);
  static TextStyle tsmb = _base(14, 20, FontWeight.w700);

  // XS – 12
  static TextStyle txsr = _base(12, 18, FontWeight.w400);
  static TextStyle txsm = _base(12, 18, FontWeight.w500);
  static TextStyle txss = _base(12, 18, FontWeight.w600);
  static TextStyle txsb = _base(12, 18, FontWeight.w700);

  /// Base text style generator
  ///
  /// [fontSize] → Text size
  /// [lineHeight] → Desired line height in px (converted internally)
  /// [weight] → FontWeight (w400–w700)
  ///
  /// Centralizing this ensures:
  /// - Consistent font family
  /// - Consistent default color
  /// - Easy future changes (font, color, scaling)
  static TextStyle _base(
    double fontSize,
    double lineHeight,
    FontWeight weight,
  ) {
    return TextStyle(
      fontFamily: "Plus Jakarta Sans",
      fontSize: fontSize,
      height: lineHeight / fontSize,
      fontWeight: weight,
      color: AppColors.zinc.shade700,
    );
  }
}
