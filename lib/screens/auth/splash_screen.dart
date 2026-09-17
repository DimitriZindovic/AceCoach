import 'package:flutter/material.dart';

import '../../constants/app_colors.dart';
import '../../constants/app_spacing.dart';
import '../../widgets/app_logo.dart';

/// Gradient splash shown while the first auth state resolves.
class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  static const String routePath = '/splash';

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return Scaffold(
      body: DecoratedBox(
        decoration: const BoxDecoration(gradient: AppColors.splashGradient),
        child: Stack(
          fit: StackFit.expand,
          children: [
            const Positioned(top: -120, right: -220, child: _Ring(size: 520)),
            const Positioned(bottom: -90, left: -120, child: _Ring(size: 340)),
            SafeArea(
              child: Column(
                children: [
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 112,
                          height: 112,
                          decoration: BoxDecoration(
                            color: AppColors.surface.withValues(alpha: 0.16),
                            borderRadius: BorderRadius.circular(34),
                            border: Border.all(
                              color: AppColors.surface.withValues(alpha: 0.34),
                            ),
                          ),
                          alignment: Alignment.center,
                          child: const AppLogo(),
                        ),
                        const SizedBox(height: AppSpacing.xxl + 2),
                        Text(
                          'AceCoach',
                          style: text.displaySmall?.copyWith(
                            color: AppColors.surface,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.xs),
                        Text(
                          'AI tennis training sessions',
                          style: text.bodySmall?.copyWith(
                            color: AppColors.surface.withValues(alpha: 0.92),
                            fontWeight: FontWeight.w500,
                            letterSpacing: 0.26,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 46),
                    child: SizedBox(
                      width: 120,
                      height: 3,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(2),
                        child: LinearProgressIndicator(
                          backgroundColor: AppColors.surface.withValues(
                            alpha: 0.2,
                          ),
                          color: AppColors.surface.withValues(alpha: 0.45),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Ring extends StatelessWidget {
  const _Ring({required this.size});

  final double size;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: AppColors.surface.withValues(alpha: 0.2)),
        ),
      ),
    );
  }
}
