import 'package:flutter/material.dart';

abstract final class AppColors {
  static const Color primary = Color(0xFF4CAF50);
  static const Color primaryDark = Color(0xFF2E7D32);
  static const Color primaryDeep = Color(0xFF1B5E20);
  static const Color primaryContainer = Color(0xFFE8F5E9);

  static const Color lime = Color(0xFFDCE775);
  static const Color limeDark = Color(0xFFA8D24A);

  static const Color ink = Color(0xFF101512);
  static const Color textSecondary = Color(0xFF5C6660);
  static const Color textTertiary = Color(0xFF8A948E);
  static const Color textDisabled = Color(0xFFA9B2AC);
  static const Color chevron = Color(0xFFC3CAC5);

  static const Color background = Color(0xFFFAFAFA);
  static const Color canvas = Color(0xFFEDEFEC);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceMuted = Color(0xFFF2F4F2);
  static const Color surfaceMutedAlt = Color(0xFFF4F6F4);
  static const Color hairline = Color(0xFFEFF1EF);
  static const Color outline = Color(0xFFE0E4E0);

  static const Color warningSurface = Color(0xFFFFF8E1);
  static const Color warningBorder = Color(0xFFF5E6A8);
  static const Color warningText = Color(0xFF6B5B12);
  static const Color tipSurface = Color(0xFFFFFDF2);
  static const Color tipIcon = Color(0xFFB59A0A);

  static const Color error = Color(0xFFC62828);
  static const Color errorContainer = Color(0xFFFFCDD2);

  static const LinearGradient splashGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primaryDark, primary, limeDark, lime],
    stops: [0, 0.46, 0.78, 1],
  );
  static const LinearGradient brandGradient = LinearGradient(
    colors: [primaryDark, primary],
  );
}
