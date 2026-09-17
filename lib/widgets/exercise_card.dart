import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../constants/app_spacing.dart';
import '../constants/app_themes.dart';
import '../models/exercise.dart';

/// One drill of the plan: number, title, duration badge, description and the
/// optional technical tip box.
class ExerciseCard extends StatelessWidget {
  const ExerciseCard({super.key, required this.index, required this.exercise});

  /// 1-based position shown in the green square.
  final int index;
  final Exercise exercise;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final text = theme.textTheme;

    return Semantics(
      container: true,
      label:
          'Exercise $index, ${exercise.title}, '
          '${exercise.estimatedDurationMinutes} minutes',
      child: Container(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.md + 2,
          AppSpacing.md,
          AppSpacing.md + 2,
          AppSpacing.md,
        ),
        decoration: BoxDecoration(
          color: scheme.surface,
          borderRadius: AppRadius.circular(AppRadius.xl),
          border: Border.all(color: scheme.outlineVariant),
          boxShadow: AppShadows.card,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _IndexBadge(index: index),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          exercise.title,
                          style: text.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                            height: 1.3,
                          ),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      _DurationBadge(
                        minutes: exercise.estimatedDurationMinutes,
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(exercise.description, style: text.caption),
                  if (exercise.hasTip) ...[
                    const SizedBox(height: AppSpacing.sm),
                    _TipBox(tip: exercise.technicalTip),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _IndexBadge extends StatelessWidget {
  const _IndexBadge({required this.index});

  final int index;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 28,
      height: 28,
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: AppRadius.circular(AppRadius.sm),
      ),
      alignment: Alignment.center,
      child: Text(
        '$index',
        style: Theme.of(context).textTheme.bodySmall
            ?.copyWith(color: AppColors.surface, fontWeight: FontWeight.w700),
      ),
    );
  }
}

class _DurationBadge extends StatelessWidget {
  const _DurationBadge({required this.minutes});

  final int minutes;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: 3,
      ),
      decoration: BoxDecoration(
        color: isDark ? AppColors.primaryDeep : AppColors.primaryContainer,
        borderRadius: AppRadius.circular(AppRadius.xs),
      ),
      child: Text(
        '$minutes min',
        style: Theme.of(context).textTheme.labelSmall
            ?.copyWith(color: isDark ? AppColors.lime : AppColors.primaryDark),
      ),
    );
  }
}

class _TipBox extends StatelessWidget {
  const _TipBox({required this.tip});

  final String tip;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm + 2,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurfaceMuted : AppColors.tipSurface,
        borderRadius: AppRadius.circular(AppRadius.sm),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 1),
            child: Icon(
              Icons.lightbulb_outline_rounded,
              size: 14,
              color: AppColors.tipIcon,
            ),
          ),
          const SizedBox(width: AppSpacing.xs + 1),
          Expanded(
            child: Text(
              tip,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                fontWeight: FontWeight.w400,
                letterSpacing: 0,
                height: 1.45,
                color: isDark ? AppColors.textDisabled : AppColors.warningText,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
