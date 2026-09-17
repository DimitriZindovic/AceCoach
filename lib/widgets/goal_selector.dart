import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../constants/app_spacing.dart';
import '../models/session_params.dart';

IconData goalIcon(TacticalGoal goal) => switch (goal) {
  TacticalGoal.baselinePlay => Icons.bar_chart_rounded,
  TacticalGoal.netPlay => Icons.sports_tennis_rounded,
  TacticalGoal.physical => Icons.bolt_rounded,
  TacticalGoal.mental => Icons.psychology_outlined,
};

class GoalSelector extends StatelessWidget {
  const GoalSelector({super.key, required this.value, required this.onChanged});

  final TacticalGoal value;
  final ValueChanged<TacticalGoal> onChanged;

  @override
  Widget build(BuildContext context) {
    const goals = TacticalGoal.values;
    return Column(
      children: [
        for (var row = 0; row < goals.length; row += 2) ...[
          if (row > 0) const SizedBox(height: AppSpacing.sm),
          Row(
            children: [
              for (var i = row; i < row + 2 && i < goals.length; i++) ...[
                if (i > row) const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: _GoalCard(
                    goal: goals[i],
                    selected: goals[i] == value,
                    onTap: () => onChanged(goals[i]),
                  ),
                ),
              ],
            ],
          ),
        ],
      ],
    );
  }
}

class _GoalCard extends StatelessWidget {
  const _GoalCard({
    required this.goal,
    required this.selected,
    required this.onTap,
  });

  final TacticalGoal goal;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;
    final background = selected ? scheme.inverseSurface : scheme.surface;
    final foreground = selected
        ? scheme.onInverseSurface
        : scheme.onSurfaceVariant;

    return Semantics(
      button: true,
      selected: selected,
      label: goal.label,
      child: Material(
        color: background,
        borderRadius: AppRadius.circular(AppRadius.md),
        child: InkWell(
          onTap: onTap,
          borderRadius: AppRadius.circular(AppRadius.md),
          child: AnimatedContainer(
            duration: AppDurations.fast,
            constraints: const BoxConstraints(minHeight: AppSizes.minTapTarget),
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.sm + 3,
            ),
            decoration: BoxDecoration(
              borderRadius: AppRadius.circular(AppRadius.md),
              border: Border.all(
                color: selected ? Colors.transparent : scheme.outline,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  goalIcon(goal),
                  size: 16,
                  color: selected ? AppColors.lime : foreground,
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Text(
                    goal.label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: text.labelMedium?.copyWith(
                      color: foreground,
                      fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
