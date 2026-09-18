import 'package:flutter/material.dart';

import '../constants/app_spacing.dart';
import '../models/session_params.dart';
import 'level_selector.dart';

class StrokeChipGroup extends StatelessWidget {
  const StrokeChipGroup({
    super.key,
    required this.selected,
    required this.onToggle,
  });

  final Set<Stroke> selected;
  final ValueChanged<Stroke> onToggle;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: AppSpacing.sm,
      children: [
        for (final stroke in Stroke.values)
          SelectablePill(
            label: stroke.label,
            selected: selected.contains(stroke),
            accent: true,
            onTap: () => onToggle(stroke),
          ),
      ],
    );
  }
}
