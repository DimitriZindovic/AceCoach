import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../constants/app_spacing.dart';
import '../constants/app_themes.dart';

class SessionPlanHeader extends StatelessWidget {
  const SessionPlanHeader({
    super.key,
    required this.title,
    required this.meta,
    this.eyebrow = 'AI generated',
    this.onBack,
    this.actions = const [],
  });

  final String title;
  final String meta;
  final String eyebrow;
  final VoidCallback? onBack;
  final List<Widget> actions;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;

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
              ],
            ),
          ),
        ],
      ),
    );
  }
}
