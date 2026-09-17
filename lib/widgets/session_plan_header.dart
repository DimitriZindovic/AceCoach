import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../constants/app_spacing.dart';
import '../constants/app_themes.dart';
import '../models/weather.dart';
import 'weather_chip.dart';

/// Dark header of the result and detail screens: back button, eyebrow,
/// title, meta line and the weather / advice strip.
class SessionPlanHeader extends StatelessWidget {
  const SessionPlanHeader({
    super.key,
    required this.title,
    required this.meta,
    this.eyebrow = 'AI generated',
    this.weather,
    this.weatherAdvice,
    this.weatherUsed = true,
    this.onBack,
    this.actions = const [],
  });

  final String title;
  final String meta;
  final String eyebrow;
  final Weather? weather;
  final String? weatherAdvice;

  /// False when the plan was generated without weather context.
  final bool weatherUsed;
  final VoidCallback? onBack;
  final List<Widget> actions;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final stripText =
        weatherAdvice ??
        (weather != null
            ? '${weather!.temperatureLabel}, ${weather!.conditionLabel.toLowerCase()}'
            : 'Generated without today\'s weather');
    final stripIcon = weather != null
        ? weatherIcon(weather!)
        : Icons.cloud_off_outlined;

    return Container(
      color: AppColors.ink,
      padding: EdgeInsets.fromLTRB(
        AppSpacing.sm,
        MediaQuery.paddingOf(context).top + AppSpacing.xs,
        AppSpacing.sm,
        AppSpacing.lg,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              IconButton(
                onPressed: onBack ?? () => Navigator.of(context).maybePop(),
                tooltip: 'Back',
                color: AppColors.surface,
                icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
              ),
              Expanded(
                child: Text(
                  eyebrow.toUpperCase(),
                  style: text.eyebrow.copyWith(color: AppColors.lime),
                ),
              ),
              ...actions,
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.screenHorizontal - AppSpacing.sm,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: AppSpacing.xs),
                Text(
                  title,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: text.headlineSmall?.copyWith(color: AppColors.surface),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  meta,
                  style: text.caption.copyWith(color: AppColors.textDisabled),
                ),
                const SizedBox(height: AppSpacing.md),
                Semantics(
                  label: weatherUsed ? 'Weather advice: $stripText' : stripText,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.md,
                      vertical: AppSpacing.sm,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.surface.withValues(alpha: 0.08),
                      borderRadius: AppRadius.circular(AppRadius.md),
                    ),
                    child: Row(
                      children: [
                        Icon(stripIcon, size: 20, color: AppColors.lime),
                        const SizedBox(width: AppSpacing.sm + 2),
                        Expanded(
                          child: Text(
                            stripText,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: text.caption.copyWith(
                              color: AppColors.surface,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
