import 'package:flutter/material.dart';

/// Colour tokens extracted from the AceCoach design
/// (`design/AceCoach.dc.html`). Every hex value below appears in the mockup;
/// the dark variants are derived from the ink token, see [AppColors.darkSurface].
abstract final class AppColors {
  // Brand greens.
  static const Color primary = Color(0xFF4CAF50);
  static const Color primaryDark = Color(0xFF2E7D32);
  static const Color primaryDeep = Color(0xFF1B5E20);
  static const Color primaryContainer = Color(0xFFE8F5E9);

  // Lime accent used for badges, selected chips and the splash gradient.
  static const Color lime = Color(0xFFDCE775);
  static const Color limeDark = Color(0xFFA8D24A);

  // Neutrals.
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

  // Semantic: weather alert and technical tip.
  static const Color warningSurface = Color(0xFFFFF8E1);
  static const Color warningBorder = Color(0xFFF5E6A8);
  static const Color warningText = Color(0xFF6B5B12);
  static const Color tipSurface = Color(0xFFFFFDF2);
  static const Color tipIcon = Color(0xFFB59A0A);

  // Semantic: destructive.
  static const Color error = Color(0xFFC62828);
  static const Color errorContainer = Color(0xFFFFCDD2);

  // Google brand colours for the sign-in button glyph.
  static const Color googleBlue = Color(0xFF4285F4);
  static const Color googleGreen = Color(0xFF34A853);
  static const Color googleYellow = Color(0xFFFBBC05);
  static const Color googleRed = Color(0xFFEA4335);

  // Dark theme surfaces: the ink token lifted step by step. The design does
  // not ship a dark mode, so these are the only derived values in the palette.
  static const Color darkBackground = ink;
  static const Color darkSurface = Color(0xFF171C19);
  static const Color darkSurfaceMuted = Color(0xFF1F2521);
  static const Color darkHairline = Color(0xFF242A26);
  static const Color darkOutline = Color(0xFF2E352F);

  // Gradients used by the splash, the weather card and the profile header.
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
