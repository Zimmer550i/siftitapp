import 'package:flutter/material.dart';

class AppColors {
  // Base
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);
  static const Color bad = Color(0xFFD94040);
  static const Color mid = Color(0xFFE07B30);
  static const Color good = Color(0xFF0A8C5A);

  // Teal
  static const MaterialColor teal = MaterialColor(0xFF016B57, {
    25: Color(0xFFF0FDFA),
    50: Color(0xFFE6F0EE),
    100: Color(0xFFB0D1CB),
    200: Color(0xFF8ABBB2),
    300: Color(0xFF559C8E),
    400: Color(0xFF348979),
    500: Color(0xFF016B57),
    600: Color(0xFF01614F),
    700: Color(0xFF014C3E),
    800: Color(0xFF013B30),
    900: Color(0xFF002D25),
  });

  // Red
  static const MaterialColor red = MaterialColor(0xFFDC2626, {
    25: Color(0xFFFEF2F2),
    50: Color(0xFFFEE2E2),
    100: Color(0xFFFECACA),
    200: Color(0xFFFCA5A5),
    300: Color(0xFFF87171),
    400: Color(0xFFEF4444),
    500: Color(0xFFDC2626),
    600: Color(0xFFB91C1C),
    700: Color(0xFF991B1B),
    800: Color(0xFF7F1D1D),
    900: Color(0xFF450A0A),
  });

  // Zinc
  static const MaterialColor zinc = MaterialColor(0xFF52525b, {
    25: Color(0xFFfafafa),
    50: Color(0xFFf4f4f5),
    100: Color(0xFFe4e4e7),
    200: Color(0xFFd4d4d8),
    300: Color(0xFFa1a1aa),
    400: Color(0xFF71717a),
    500: Color(0xFF52525b),
    600: Color(0xFF3f3f46),
    700: Color(0xFF27272a),
    800: Color(0xFF18181b),
    900: Color(0xFF09090b),
  });
}

Color spectrumColor(
  double value, {
  Color red = AppColors.bad,
  Color yellow = AppColors.mid,
  Color green = AppColors.good,
}) {
  final clamped = value.clamp(0.0, 1.0).toDouble();

  if (clamped <= 0.5) {
    return Color.lerp(red, yellow, clamped * 2)!;
  }

  return Color.lerp(yellow, green, (clamped - 0.5) * 2)!;
}
