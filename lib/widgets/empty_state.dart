import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../constants/app_spacing.dart';
import 'primary_button.dart';

class EmptyState extends StatelessWidget {
  const EmptyState({
    super.key,
    required this.icon,
    required this.title,
    required this.message,
    this.actionLabel,
    this.onAction,
    this.isError = false,
  });

  final IconData icon;
  final String title;
  final String message;
  final String? actionLabel;
  final VoidCallback? onAction;

  final bool isError;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final boxColor = isError
        ? AppColors.errorContainer
        : AppColors.primaryContainer;
    final iconColor = isError ? AppColors.error : AppColors.primaryDark;

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.screenHorizontal + AppSpacing.md,
          vertical: AppSpacing.xxl,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: boxColor,
                borderRadius: AppRadius.circular(AppRadius.xxl),
              ),
              child: Icon(icon, size: 30, color: iconColor),
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              title,
              textAlign: TextAlign.center,
              style: theme.textTheme.titleSmall,
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              message,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodySmall,
            ),
            if (actionLabel != null && onAction != null) ...[
              const SizedBox(height: AppSpacing.xl),
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 240),
                child: PrimaryButton(
                  label: actionLabel!,
                  onPressed: onAction,
                  variant: isError
                      ? AppButtonVariant.neutral
                      : AppButtonVariant.primary,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
