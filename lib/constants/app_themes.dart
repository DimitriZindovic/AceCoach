import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';
import 'app_spacing.dart';

abstract final class AppThemes {
  static ThemeData get light => _build(_lightScheme, Brightness.light);

  static ThemeData get dark => _build(_darkScheme, Brightness.dark);

  static const ColorScheme _lightScheme = ColorScheme(
    brightness: Brightness.light,
    primary: AppColors.primary,
    onPrimary: AppColors.surface,
    primaryContainer: AppColors.primaryContainer,
    onPrimaryContainer: AppColors.primaryDark,
    secondary: AppColors.lime,
    onSecondary: AppColors.primaryDeep,
    secondaryContainer: AppColors.lime,
    onSecondaryContainer: AppColors.primaryDeep,
    tertiary: AppColors.primaryDark,
    onTertiary: AppColors.surface,
    error: AppColors.error,
    onError: AppColors.surface,
    errorContainer: AppColors.errorContainer,
    onErrorContainer: AppColors.error,
    surface: AppColors.surface,
    onSurface: AppColors.ink,
    onSurfaceVariant: AppColors.textSecondary,
    surfaceContainerLowest: AppColors.surface,
    surfaceContainerLow: AppColors.background,
    surfaceContainer: AppColors.surfaceMuted,
    surfaceContainerHigh: AppColors.surfaceMutedAlt,
    surfaceContainerHighest: AppColors.canvas,
    outline: AppColors.outline,
    outlineVariant: AppColors.hairline,
    inverseSurface: AppColors.ink,
    onInverseSurface: AppColors.surface,
    inversePrimary: AppColors.lime,
    shadow: AppColors.ink,
    scrim: AppColors.ink,
  );

  static const ColorScheme _darkScheme = ColorScheme(
    brightness: Brightness.dark,
    primary: AppColors.primary,
    onPrimary: AppColors.surface,
    primaryContainer: AppColors.primaryDeep,
    onPrimaryContainer: AppColors.primaryContainer,
    secondary: AppColors.lime,
    onSecondary: AppColors.primaryDeep,
    secondaryContainer: AppColors.lime,
    onSecondaryContainer: AppColors.primaryDeep,
    tertiary: AppColors.lime,
    onTertiary: AppColors.ink,
    error: AppColors.errorContainer,
    onError: AppColors.error,
    errorContainer: AppColors.error,
    onErrorContainer: AppColors.errorContainer,
    surface: AppColors.darkSurface,
    onSurface: AppColors.background,
    onSurfaceVariant: AppColors.textDisabled,
    surfaceContainerLowest: AppColors.darkBackground,
    surfaceContainerLow: AppColors.darkBackground,
    surfaceContainer: AppColors.darkSurfaceMuted,
    surfaceContainerHigh: AppColors.darkSurfaceMuted,
    surfaceContainerHighest: AppColors.darkOutline,
    outline: AppColors.darkOutline,
    outlineVariant: AppColors.darkHairline,
    inverseSurface: AppColors.background,
    onInverseSurface: AppColors.ink,
    inversePrimary: AppColors.primaryDark,
    shadow: AppColors.ink,
    scrim: AppColors.ink,
  );

  static ThemeData _build(ColorScheme scheme, Brightness brightness) {
    final isDark = brightness == Brightness.dark;
    final textTheme = _textTheme(scheme.onSurface, scheme.onSurfaceVariant);
    final scaffoldBackground = isDark
        ? AppColors.darkBackground
        : AppColors.background;

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: scheme,
      scaffoldBackgroundColor: scaffoldBackground,
      textTheme: textTheme,
      splashFactory: InkSparkle.splashFactory,
      visualDensity: VisualDensity.standard,
      appBarTheme: AppBarTheme(
        backgroundColor: scheme.surface,
        foregroundColor: scheme.onSurface,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleTextStyle: textTheme.titleMedium,
        shape: Border(bottom: BorderSide(color: scheme.outlineVariant)),
      ),
      cardTheme: CardThemeData(
        color: scheme.surface,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: AppRadius.circular(AppRadius.xl),
          side: BorderSide(color: scheme.outlineVariant),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: scheme.primary,
          foregroundColor: scheme.onPrimary,
          minimumSize: const Size.fromHeight(AppSizes.buttonHeight),
          shape: RoundedRectangleBorder(
            borderRadius: AppRadius.circular(AppRadius.lg),
          ),
          textStyle: textTheme.labelLarge,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: isDark ? AppColors.lime : AppColors.primaryDark,
          minimumSize: const Size.fromHeight(AppSizes.buttonHeight),
          side: const BorderSide(color: AppColors.primary, width: 1.5),
          shape: RoundedRectangleBorder(
            borderRadius: AppRadius.circular(AppRadius.lg),
          ),
          textStyle: textTheme.labelLarge,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: isDark ? AppColors.lime : AppColors.primaryDark,
          minimumSize: const Size(AppSizes.minTapTarget, AppSizes.minTapTarget),
          textStyle: textTheme.labelMedium,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: scheme.surface,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.lg,
        ),
        hintStyle: textTheme.bodyMedium?.copyWith(
          color: AppColors.textTertiary,
        ),
        prefixIconColor: AppColors.textTertiary,
        suffixIconColor: AppColors.textTertiary,
        border: OutlineInputBorder(
          borderRadius: AppRadius.circular(AppRadius.md),
          borderSide: BorderSide(color: scheme.outline),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: AppRadius.circular(AppRadius.md),
          borderSide: BorderSide(color: scheme.outline),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: AppRadius.circular(AppRadius.md),
          borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: AppRadius.circular(AppRadius.md),
          borderSide: BorderSide(color: scheme.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: AppRadius.circular(AppRadius.md),
          borderSide: BorderSide(color: scheme.error, width: 1.5),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: scheme.surface,
        selectedColor: scheme.primary,
        side: BorderSide(color: scheme.outline),
        shape: const StadiumBorder(),
        labelStyle: textTheme.labelMedium?.copyWith(
          color: scheme.onSurfaceVariant,
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        showCheckmark: false,
      ),
      sliderTheme: SliderThemeData(
        trackHeight: 6,
        activeTrackColor: scheme.primary,
        inactiveTrackColor: scheme.outline,
        thumbColor: scheme.surface,
        overlayColor: AppColors.primary.withValues(alpha: 0.12),
        trackShape: const RoundedRectSliderTrackShape(),
        thumbShape: const _OutlinedThumbShape(),
        showValueIndicator: ShowValueIndicator.never,
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: scheme.surface,
        indicatorColor: Colors.transparent,
        elevation: 0,
        height: 64,
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          final selected = states.contains(WidgetState.selected);
          return textTheme.labelSmall?.copyWith(
            fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
            color: selected
                ? (isDark ? AppColors.lime : AppColors.primaryDark)
                : AppColors.textTertiary,
          );
        }),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          final selected = states.contains(WidgetState.selected);
          return IconThemeData(
            size: 22,
            color: selected
                ? (isDark ? AppColors.lime : AppColors.primaryDark)
                : AppColors.textTertiary,
          );
        }),
      ),
      dividerTheme: DividerThemeData(
        color: scheme.outlineVariant,
        thickness: 1,
        space: 1,
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppColors.ink,
        contentTextStyle: textTheme.bodySmall?.copyWith(
          color: AppColors.surface,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: AppRadius.circular(AppRadius.md),
        ),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: scheme.surface,
        shape: RoundedRectangleBorder(
          borderRadius: AppRadius.circular(AppRadius.xxl),
        ),
        titleTextStyle: textTheme.titleMedium,
        contentTextStyle: textTheme.bodySmall,
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: scheme.surface,
        showDragHandle: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(AppRadius.xxl),
          ),
        ),
      ),
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: AppColors.primary,
      ),
    );
  }

  static TextTheme _textTheme(Color onSurface, Color onSurfaceVariant) {
    final base = GoogleFonts.poppinsTextTheme();
    TextStyle style(
      double size,
      FontWeight weight, {
      double? letterSpacing,
      double? height,
      Color? color,
    }) {
      return GoogleFonts.poppins(
        fontSize: size,
        fontWeight: weight,
        letterSpacing: letterSpacing,
        height: height,
        color: color ?? onSurface,
      );
    }

    return base.copyWith(
      displaySmall: style(40, FontWeight.w700, letterSpacing: -1.2),
      headlineMedium: style(
        26,
        FontWeight.w700,
        letterSpacing: -0.5,
        height: 1.2,
      ),
      headlineSmall: style(
        22,
        FontWeight.w700,
        letterSpacing: -0.4,
        height: 1.25,
      ),
      titleLarge: style(20, FontWeight.w700, letterSpacing: -0.4),
      titleMedium: style(17, FontWeight.w600),
      titleSmall: style(15, FontWeight.w600),
      bodyLarge: style(16, FontWeight.w400, height: 1.45),
      bodyMedium: style(14, FontWeight.w400, height: 1.45),
      bodySmall: style(
        13,
        FontWeight.w400,
        height: 1.4,
        color: onSurfaceVariant,
      ),
      labelLarge: style(15, FontWeight.w600),
      labelMedium: style(12, FontWeight.w600),
      labelSmall: style(11, FontWeight.w600, letterSpacing: 0.2),
    );
  }
}

class _OutlinedThumbShape extends SliderComponentShape {
  const _OutlinedThumbShape();

  static const double _radius = 11;

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) =>
      const Size.fromRadius(_radius);

  @override
  void paint(
    PaintingContext context,
    Offset center, {
    required Animation<double> activationAnimation,
    required Animation<double> enableAnimation,
    required bool isDiscrete,
    required TextPainter labelPainter,
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required TextDirection textDirection,
    required double value,
    required double textScaleFactor,
    required Size sizeWithOverflow,
  }) {
    final canvas = context.canvas;
    canvas.drawShadow(
      Path()..addOval(Rect.fromCircle(center: center, radius: _radius)),
      AppColors.ink.withValues(alpha: 0.18),
      2,
      true,
    );
    canvas.drawCircle(
      center,
      _radius,
      Paint()..color = sliderTheme.thumbColor ?? AppColors.surface,
    );
    canvas.drawCircle(
      center,
      _radius - 1.5,
      Paint()
        ..color = sliderTheme.activeTrackColor ?? AppColors.primary
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3,
    );
  }
}

extension AppTextStyles on TextTheme {
  TextStyle get sectionLabel => labelLarge!.copyWith(fontSize: 13);

  TextStyle get fieldLabel =>
      labelSmall!.copyWith(color: AppColors.textSecondary, letterSpacing: 0.44);

  TextStyle get caption => bodySmall!.copyWith(fontSize: 12);

  TextStyle get badge => labelSmall!.copyWith(fontSize: 10, letterSpacing: 0);

  TextStyle get eyebrow => labelSmall!.copyWith(letterSpacing: 1.1);
}
