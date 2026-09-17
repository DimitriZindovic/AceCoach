import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../constants/app_colors.dart';
import '../constants/app_spacing.dart';
import '../constants/app_themes.dart';
import '../models/training_session.dart';
import 'goal_selector.dart';

/// "Today", "Yesterday" or "13 Sep".
String relativeDayLabel(DateTime date, {DateTime? now}) {
  final today = DateUtils.dateOnly(now ?? DateTime.now());
  final day = DateUtils.dateOnly(date);
  final difference = today.difference(day).inDays;
  if (difference == 0) return 'Today';
  if (difference == 1) return 'Yesterday';
  return DateFormat('d MMM').format(date);
}

/// History row: goal icon, title, meta line and a status badge.
class SessionCard extends StatelessWidget {
  const SessionCard({super.key, required this.session, this.onTap});

  final TrainingSession session;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;
    final meta =
        '${relativeDayLabel(session.createdAt)} · '
        '${session.params.durationMinutes} min · ${session.params.level.label}';

    return Semantics(
      button: onTap != null,
      label: '${session.title}, $meta',
      child: Material(
        color: scheme.surface,
        borderRadius: AppRadius.circular(AppRadius.xl),
        child: InkWell(
          onTap: onTap,
          borderRadius: AppRadius.circular(AppRadius.xl),
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md + 2,
              vertical: AppSpacing.md + 1,
            ),
            decoration: BoxDecoration(
              borderRadius: AppRadius.circular(AppRadius.xl),
              border: Border.all(color: scheme.outlineVariant),
              boxShadow: AppShadows.cardSoft,
            ),
            child: Row(
              children: [
                _GoalIconBox(session: session, size: AppSizes.iconBoxMedium),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        session.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: text.bodySmall?.copyWith(
                          color: scheme.onSurface,
                          fontWeight: FontWeight.w600,
                          height: 1.3,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xxs),
                      Text(
                        meta,
                        style: text.labelSmall?.copyWith(
                          fontWeight: FontWeight.w400,
                          letterSpacing: 0,
                          color: scheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    _StatusBadge(completed: session.isCompleted),
                    const SizedBox(height: AppSpacing.xs),
                    const Icon(
                      Icons.chevron_right_rounded,
                      size: 18,
                      color: AppColors.chevron,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Compact card used in the "Recent sessions" carousel on the home screen.
class RecentSessionCard extends StatelessWidget {
  const RecentSessionCard({super.key, required this.session, this.onTap});

  final TrainingSession session;
  final VoidCallback? onTap;

  static const double width = 172;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Semantics(
      button: onTap != null,
      label: '${session.title}, ${session.params.durationMinutes} minutes',
      child: SizedBox(
        width: width,
        child: Material(
          color: scheme.surface,
          borderRadius: AppRadius.circular(AppRadius.xl),
          child: InkWell(
            onTap: onTap,
            borderRadius: AppRadius.circular(AppRadius.xl),
            child: Container(
              padding: const EdgeInsets.all(AppSpacing.md + 2),
              decoration: BoxDecoration(
                borderRadius: AppRadius.circular(AppRadius.xl),
                border: Border.all(color: scheme.outlineVariant),
                boxShadow: AppShadows.card,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _GoalIconBox(
                        session: session,
                        size: AppSizes.iconBoxSmall,
                      ),
                      Text(
                        relativeDayLabel(session.createdAt),
                        style: text.badge.copyWith(
                          color: scheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.sm + 2),
                  Text(
                    session.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: text.bodySmall?.copyWith(
                      color: scheme.onSurface,
                      fontWeight: FontWeight.w600,
                      height: 1.35,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm + 2),
                  Wrap(
                    spacing: AppSpacing.xs,
                    runSpacing: AppSpacing.xs,
                    children: [
                      _Tag(
                        label: '${session.params.durationMinutes} min',
                        background: AppColors.lime,
                        foreground: AppColors.primaryDeep,
                      ),
                      _Tag(
                        label: session.params.level.label,
                        background: isDark
                            ? AppColors.darkSurfaceMuted
                            : AppColors.surfaceMuted,
                        foreground: scheme.onSurfaceVariant,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _GoalIconBox extends StatelessWidget {
  const _GoalIconBox({required this.session, required this.size});

  final TrainingSession session;
  final double size;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: isDark ? AppColors.primaryDeep : AppColors.primaryContainer,
        borderRadius: AppRadius.circular(
          size >= AppSizes.iconBoxMedium ? AppRadius.md - 2 : AppRadius.sm,
        ),
      ),
      child: Icon(
        goalIcon(session.params.goal),
        size: size * 0.5,
        color: isDark ? AppColors.lime : AppColors.primaryDark,
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.completed});

  final bool completed;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final (background, foreground) = completed
        ? (
            isDark ? AppColors.primaryDeep : AppColors.primaryContainer,
            isDark ? AppColors.lime : AppColors.primaryDark,
          )
        : (scheme.surfaceContainer, scheme.onSurfaceVariant);
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color: background,
        borderRadius: AppRadius.circular(AppRadius.xs),
      ),
      child: Text(
        completed ? 'DONE' : 'PLANNED',
        style: Theme.of(context).textTheme.badge.copyWith(
          fontSize: 9,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.4,
          color: foreground,
        ),
      ),
    );
  }
}

class _Tag extends StatelessWidget {
  const _Tag({
    required this.label,
    required this.background,
    required this.foreground,
  });

  final String label;
  final Color background;
  final Color foreground;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color: background,
        borderRadius: AppRadius.circular(AppRadius.xs),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.badge.copyWith(color: foreground),
      ),
    );
  }
}
