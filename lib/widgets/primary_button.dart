import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../constants/app_spacing.dart';

/// Visual variants of the app button, all 50 dp tall with a 16 dp radius.
enum AppButtonVariant {
  /// Green fill with the soft green glow (main call to action).
  primary,

  /// White fill, 1.5 dp green border, dark green label.
  outline,

  /// White fill, neutral border, ink label ("Regenerate", Google sign-in).
  neutral,

  /// White fill, light red border, red label ("Log out").
  destructive,
}

/// Full-width button following the design's button anatomy.
class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    super.key,
    required this.label,
    this.onPressed,
    this.icon,
    this.leading,
    this.isLoading = false,
    this.variant = AppButtonVariant.primary,
    this.height = AppSizes.buttonHeight,
    this.dense = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;

  /// Custom leading widget (e.g. the Google glyph). Wins over [icon].
  final Widget? leading;
  final bool isLoading;
  final AppButtonVariant variant;
  final double height;

  /// 14 dp label and 17 dp icon, for two buttons side by side.
  final bool dense;

  bool get _enabled => onPressed != null && !isLoading;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final foreground = switch (variant) {
      AppButtonVariant.primary => scheme.onPrimary,
      AppButtonVariant.outline =>
        isDark ? AppColors.lime : AppColors.primaryDark,
      AppButtonVariant.neutral => scheme.onSurface,
      AppButtonVariant.destructive => AppColors.error,
    };
    final border = switch (variant) {
      AppButtonVariant.primary => null,
      AppButtonVariant.outline => const BorderSide(
        color: AppColors.primary,
        width: 1.5,
      ),
      AppButtonVariant.neutral => BorderSide(color: scheme.outline, width: 1.5),
      AppButtonVariant.destructive => const BorderSide(
        color: AppColors.errorContainer,
        width: 1.5,
      ),
    };

    final child = AnimatedSwitcher(
      duration: AppDurations.fast,
      child: isLoading
          ? SizedBox(
              key: const ValueKey('loading'),
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2.2,
                color: foreground,
              ),
            )
          : Row(
              key: const ValueKey('label'),
              mainAxisSize: MainAxisSize.min,
              children: [
                if (leading != null) ...[
                  leading!,
                  const SizedBox(width: AppSpacing.sm + 2),
                ] else if (icon != null) ...[
                  Icon(icon, size: dense ? 17 : 18),
                  const SizedBox(width: AppSpacing.sm),
                ],
                Flexible(child: Text(label, overflow: TextOverflow.ellipsis)),
              ],
            ),
    );

    final shape = RoundedRectangleBorder(
      borderRadius: AppRadius.circular(AppRadius.lg),
    );
    final textStyle = dense
        ? Theme.of(context).textTheme.labelLarge?.copyWith(fontSize: 14)
        : null;
    final padding = dense
        ? const EdgeInsets.symmetric(horizontal: AppSpacing.md)
        : null;
    final Widget button;
    if (variant == AppButtonVariant.primary) {
      button = FilledButton(
        onPressed: _enabled ? onPressed : null,
        style: FilledButton.styleFrom(
          minimumSize: Size.fromHeight(height),
          shape: shape,
          textStyle: textStyle,
          padding: padding,
        ),
        child: child,
      );
    } else {
      button = OutlinedButton(
        onPressed: _enabled ? onPressed : null,
        style: OutlinedButton.styleFrom(
          foregroundColor: foreground,
          backgroundColor: scheme.surface,
          minimumSize: Size.fromHeight(height),
          side: border,
          shape: shape,
          textStyle: textStyle,
          padding: padding,
        ),
        child: child,
      );
    }

    return Semantics(
      button: true,
      enabled: _enabled,
      label: label,
      child: AnimatedContainer(
        duration: AppDurations.normal,
        decoration: BoxDecoration(
          borderRadius: AppRadius.circular(AppRadius.lg),
          boxShadow: variant == AppButtonVariant.primary && _enabled
              ? AppShadows.primaryGlow
              : const [],
        ),
        child: button,
      ),
    );
  }
}
