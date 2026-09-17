import 'package:flutter/material.dart';

import 'app_colors.dart';

abstract final class AppSpacing {
  static const double xxs = 4;
  static const double xs = 6;
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 20;
  static const double xxl = 24;
  static const double screenHorizontal = 22;
  static const double section = 18;
  static const EdgeInsets screenPadding = EdgeInsets.symmetric(
    horizontal: screenHorizontal,
  );
}

abstract final class AppRadius {
  static const double xs = 8;
  static const double sm = 10;
  static const double md = 14;
  static const double lg = 16;
  static const double xl = 18;
  static const double xxl = 20;
  static const double pill = 999;

  static BorderRadius circular(double radius) => BorderRadius.circular(radius);
}

abstract final class AppSizes {
  static const double buttonHeight = 50;
  static const double ctaButtonHeight = 54;
  static const double inputHeight = 52;
  static const double searchHeight = 46;
  static const double iconBoxSmall = 32;
  static const double iconBoxMedium = 38;
  static const double iconBoxLarge = 44;
  static const double avatarSmall = 42;
  static const double avatarLarge = 62;
  static const double minTapTarget = 48;
}

abstract final class AppShadows {
  static List<BoxShadow> card = [
    BoxShadow(
      color: AppColors.ink.withValues(alpha: 0.05),
      blurRadius: 8,
      offset: const Offset(0, 2),
    ),
  ];

  static List<BoxShadow> cardSoft = [
    BoxShadow(
      color: AppColors.ink.withValues(alpha: 0.04),
      blurRadius: 6,
      offset: const Offset(0, 2),
    ),
  ];

  static List<BoxShadow> primaryGlow = [
    BoxShadow(
      color: AppColors.primary.withValues(alpha: 0.32),
      blurRadius: 18,
      offset: const Offset(0, 8),
    ),
  ];

  static List<BoxShadow> brandGlow = [
    BoxShadow(
      color: AppColors.primaryDark.withValues(alpha: 0.22),
      blurRadius: 18,
      offset: const Offset(0, 8),
    ),
  ];

  static List<BoxShadow> thumb = [
    BoxShadow(
      color: AppColors.ink.withValues(alpha: 0.18),
      blurRadius: 6,
      offset: const Offset(0, 2),
    ),
  ];
}

abstract final class AppDurations {
  static const Duration fast = Duration(milliseconds: 150);
  static const Duration normal = Duration(milliseconds: 250);
  static const Duration slow = Duration(milliseconds: 400);
}
