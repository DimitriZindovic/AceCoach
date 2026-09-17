import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../constants/app_spacing.dart';

/// Dims [child] and shows a progress card while [isLoading] is true.
///
/// The content underneath stays laid out, so a regeneration keeps the previous
/// plan visible instead of collapsing to a spinner.
class LoadingOverlay extends StatelessWidget {
  const LoadingOverlay({
    super.key,
    required this.isLoading,
    required this.child,
    this.message,
  });

  final bool isLoading;
  final Widget child;
  final String? message;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Stack(
      fit: StackFit.passthrough,
      children: [
        IgnorePointer(ignoring: isLoading, child: child),
        Positioned.fill(
          child: IgnorePointer(
            ignoring: !isLoading,
            child: AnimatedOpacity(
              duration: AppDurations.normal,
              opacity: isLoading ? 1 : 0,
              child: ColoredBox(
                color: Theme.of(context).scaffoldBackgroundColor
                    .withValues(alpha: 0.72),
                child: Center(
                  child: Semantics(
                    liveRegion: true,
                    label: message ?? 'Loading',
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.xl,
                        vertical: AppSpacing.lg,
                      ),
                      decoration: BoxDecoration(
                        color: scheme.surface,
                        borderRadius: AppRadius.circular(AppRadius.xl),
                        border: Border.all(color: scheme.outlineVariant),
                        boxShadow: AppShadows.card,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const SizedBox(
                            width: 28,
                            height: 28,
                            child: CircularProgressIndicator(strokeWidth: 3),
                          ),
                          if (message != null) ...[
                            const SizedBox(height: AppSpacing.md),
                            Text(
                              message!,
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/// A softly pulsing placeholder block for skeleton states.
class SkeletonBox extends StatefulWidget {
  const SkeletonBox({
    super.key,
    this.width,
    this.height = 16,
    this.radius = AppRadius.xs,
  });

  final double? width;
  final double height;
  final double radius;

  @override
  State<SkeletonBox> createState() => _SkeletonBoxState();
}

class _SkeletonBoxState extends State<SkeletonBox>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1100),
  )..repeat(reverse: true);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return ExcludeSemantics(
      child: FadeTransition(
        opacity: Tween<double>(begin: 0.45, end: 1).animate(
          CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
        ),
        child: Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkSurfaceMuted : AppColors.hairline,
            borderRadius: AppRadius.circular(widget.radius),
          ),
        ),
      ),
    );
  }
}

/// Skeleton of an [ExerciseCard]-sized block, at least [minHeight] tall.
class SkeletonCard extends StatelessWidget {
  const SkeletonCard({super.key, this.minHeight = 96});

  final double minHeight;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      constraints: BoxConstraints(minHeight: minHeight),
      padding: const EdgeInsets.all(AppSpacing.md + 2),
      decoration: BoxDecoration(
        color: scheme.surface,
        borderRadius: AppRadius.circular(AppRadius.xl),
        border: Border.all(color: scheme.outlineVariant),
      ),
      child: const Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SkeletonBox(width: 28, height: 28, radius: AppRadius.sm),
          SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SkeletonBox(width: 160, height: 14),
                SizedBox(height: AppSpacing.sm),
                SkeletonBox(height: 10),
                SizedBox(height: AppSpacing.xs),
                SkeletonBox(width: 200, height: 10),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
