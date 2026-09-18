import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../constants/app_spacing.dart';

enum BannerTone { warning, info }

class WeatherAlertBanner extends StatelessWidget {
  const WeatherAlertBanner({
    super.key,
    required this.icon,
    required this.message,
    this.tone = BannerTone.warning,
    this.actionLabel,
    this.onAction,
  });

  final IconData icon;
  final String message;
  final BannerTone tone;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    final (background, border, foreground) = switch (tone) {
      BannerTone.warning => (
        AppColors.warningSurface,
        AppColors.warningBorder,
        AppColors.warningText,
      ),
      BannerTone.info => (
        AppColors.primaryContainer,
        AppColors.primaryContainer,
        AppColors.primaryDark,
      ),
    };

    return Semantics(
      container: true,
      liveRegion: true,
      child: Container(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.md + 2,
          AppSpacing.md,
          AppSpacing.md,
          AppSpacing.md,
        ),
        decoration: BoxDecoration(
          color: background,
          borderRadius: AppRadius.circular(AppRadius.lg),
          border: Border.all(color: border),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 18, color: foreground),
            const SizedBox(width: AppSpacing.sm + 2),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    message,
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: foreground,
                      fontWeight: FontWeight.w500,
                      height: 1.45,
                    ),
                  ),
                  if (actionLabel != null && onAction != null)
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: onAction,
                        style: TextButton.styleFrom(
                          foregroundColor: foreground,
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.sm,
                          ),
                          visualDensity: VisualDensity.compact,
                        ),
                        child: Text(actionLabel!),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
