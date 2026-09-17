import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../constants/app_spacing.dart';
import '../models/session_params.dart';

/// Single-choice row of pills (level, players present).
///
/// The visual pill is 36 dp tall; its hit area is padded to 48 dp.
class ChoicePillGroup<T> extends StatelessWidget {
  const ChoicePillGroup({
    super.key,
    required this.items,
    required this.selected,
    required this.labelOf,
    required this.onSelected,
    this.wrap = false,
  });

  final List<T> items;
  final T? selected;
  final String Function(T item) labelOf;
  final ValueChanged<T> onSelected;

  /// Wrap to several lines instead of scrolling horizontally.
  final bool wrap;

  @override
  Widget build(BuildContext context) {
    final pills = [
      for (final item in items)
        SelectablePill(
          label: labelOf(item),
          selected: item == selected,
          onTap: () => onSelected(item),
        ),
    ];
    if (wrap) {
      return Wrap(spacing: AppSpacing.sm, children: pills);
    }
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      clipBehavior: Clip.none,
      child: Row(
        children: [
          for (var i = 0; i < pills.length; i++) ...[
            if (i > 0) const SizedBox(width: AppSpacing.sm),
            pills[i],
          ],
        ],
      ),
    );
  }
}

/// Beginner / Intermediate / Advanced.
class LevelSelector extends StatelessWidget {
  const LevelSelector({
    super.key,
    required this.value,
    required this.onChanged,
  });

  final SkillLevel value;
  final ValueChanged<SkillLevel> onChanged;

  @override
  Widget build(BuildContext context) {
    return ChoicePillGroup<SkillLevel>(
      items: SkillLevel.values,
      selected: value,
      labelOf: (level) => level.label,
      onSelected: onChanged,
    );
  }
}

/// A pill chip. [accent] switches the selected style from green fill to the
/// lime fill with a check mark used for multi-select strokes.
class SelectablePill extends StatelessWidget {
  const SelectablePill({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
    this.accent = false,
    this.dense = false,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;
  final bool accent;

  /// Smaller padding for the history filter row.
  final bool dense;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;
    final Color background;
    final Color foreground;
    if (!selected) {
      background = dense ? scheme.surfaceContainer : scheme.surface;
      foreground = scheme.onSurfaceVariant;
    } else if (accent) {
      background = AppColors.lime;
      foreground = AppColors.primaryDeep;
    } else if (dense) {
      background = scheme.inverseSurface;
      foreground = scheme.onInverseSurface;
    } else {
      background = AppColors.primary;
      foreground = AppColors.surface;
    }

    return Semantics(
      button: true,
      selected: selected,
      label: label,
      child: SizedBox(
        height: AppSizes.minTapTarget,
        child: Center(
          widthFactor: 1,
          child: Material(
            color: background,
            shape: StadiumBorder(
              side: BorderSide(
                color: selected || dense ? Colors.transparent : scheme.outline,
              ),
            ),
            child: InkWell(
              onTap: onTap,
              customBorder: const StadiumBorder(),
              child: AnimatedContainer(
                duration: AppDurations.fast,
                padding: EdgeInsets.symmetric(
                  horizontal: dense ? AppSpacing.md : AppSpacing.md + 2,
                  vertical: dense ? 7 : AppSpacing.sm,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (accent && selected) ...[
                      Icon(Icons.check_rounded, size: 14, color: foreground),
                      const SizedBox(width: AppSpacing.xxs),
                    ],
                    Text(
                      label,
                      style: (dense ? text.labelSmall : text.labelMedium)
                          ?.copyWith(
                            color: foreground,
                            fontWeight: selected
                                ? FontWeight.w600
                                : FontWeight.w500,
                          ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
