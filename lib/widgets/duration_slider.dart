import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../constants/app_spacing.dart';
import '../constants/app_themes.dart';
import '../models/session_params.dart';

/// Session duration, 30 to 120 minutes in 15-minute steps.
class DurationSlider extends StatelessWidget {
  const DurationSlider({
    super.key,
    required this.value,
    required this.onChanged,
  });

  final int value;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Text('Duration', style: text.sectionLabel),
            Text(
              '$value min',
              style: text.sectionLabel.copyWith(
                fontWeight: FontWeight.w700,
                color: isDark ? AppColors.lime : AppColors.primaryDark,
              ),
            ),
          ],
        ),
        Semantics(
          slider: true,
          label: 'Session duration',
          value: '$value minutes',
          child: Slider(
            value: value.toDouble(),
            min: SessionParams.minDuration.toDouble(),
            max: SessionParams.maxDuration.toDouble(),
            divisions: SessionParams.durationDivisions,
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
            onChanged: (v) => onChanged(SessionParams.snapDuration(v)),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '${SessionParams.minDuration} min',
              style: text.badge.copyWith(
                fontWeight: FontWeight.w500,
                color: AppColors.textTertiary,
              ),
            ),
            Text(
              '${SessionParams.maxDuration} min',
              style: text.badge.copyWith(
                fontWeight: FontWeight.w500,
                color: AppColors.textTertiary,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
