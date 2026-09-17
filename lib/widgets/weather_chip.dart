import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart' show AsyncValue;

import '../constants/app_colors.dart';
import '../constants/app_spacing.dart';
import '../constants/app_themes.dart';
import '../models/failures.dart';
import '../models/weather.dart';
import 'loading_overlay.dart';

/// Material icon for an OpenWeatherMap condition group.
IconData weatherIcon(Weather weather) {
  final id = weather.conditionId;
  if (id < 300) return Icons.thunderstorm_outlined;
  if (id < 400) return Icons.grain_rounded;
  if (id < 600) return Icons.water_drop_outlined;
  if (id < 700) return Icons.ac_unit_rounded;
  if (id < 800) return Icons.foggy;
  if (id == 800) return Icons.wb_sunny_outlined;
  return Icons.cloud_outlined;
}

/// The gradient weather card on the home screen, with explicit loading,
/// error and data states.
class WeatherChip extends StatelessWidget {
  const WeatherChip({
    super.key,
    required this.weather,
    this.onRetry,
    this.onEnterCity,
  });

  final AsyncValue<Weather> weather;
  final VoidCallback? onRetry;
  final VoidCallback? onEnterCity;

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: AppDurations.normal,
      child: switch (weather) {
        AsyncValue(:final value?) => _WeatherCard(weather: value),
        AsyncValue(:final error?) => _WeatherError(
          error: error,
          onRetry: onRetry,
          onEnterCity: onEnterCity,
        ),
        _ => const SkeletonBox(
          key: ValueKey('weather-loading'),
          height: 74,
          radius: AppRadius.xl,
        ),
      },
    );
  }
}

class _WeatherCard extends StatelessWidget {
  const _WeatherCard({required this.weather});

  final Weather weather;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return Semantics(
      label: 'Weather: ${weather.temperatureLabel}, ${weather.summary}',
      child: Container(
        key: const ValueKey('weather-data'),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.md + 2,
        ),
        decoration: BoxDecoration(
          gradient: AppColors.brandGradient,
          borderRadius: AppRadius.circular(AppRadius.xl),
          boxShadow: AppShadows.brandGlow,
        ),
        child: Row(
          children: [
            Icon(weatherIcon(weather), size: 34, color: AppColors.lime),
            const SizedBox(width: AppSpacing.md + 2),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    weather.temperatureLabel,
                    style: text.headlineSmall?.copyWith(
                      fontSize: 24,
                      height: 1,
                      color: AppColors.surface,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xxs),
                  Text(
                    weather.summary,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: text.caption.copyWith(
                      color: AppColors.surface.withValues(alpha: 0.9),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            _VerdictBadge(verdict: weather.verdict),
          ],
        ),
      ),
    );
  }
}

class _VerdictBadge extends StatelessWidget {
  const _VerdictBadge({required this.verdict});

  final WeatherVerdict verdict;

  @override
  Widget build(BuildContext context) {
    final (background, foreground) = switch (verdict) {
      WeatherVerdict.ideal => (AppColors.lime, AppColors.primaryDeep),
      WeatherVerdict.caution => (
        AppColors.warningSurface,
        AppColors.warningText,
      ),
      WeatherVerdict.indoor => (
        AppColors.surface.withValues(alpha: 0.92),
        AppColors.primaryDark,
      ),
    };
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm + 2,
        vertical: 5,
      ),
      decoration: BoxDecoration(
        color: background,
        borderRadius: AppRadius.circular(AppRadius.xxl),
      ),
      child: Text(
        verdict.label,
        style: Theme.of(context).textTheme.labelSmall
            ?.copyWith(color: foreground),
      ),
    );
  }
}

class _WeatherError extends StatelessWidget {
  const _WeatherError({required this.error, this.onRetry, this.onEnterCity});

  final Object error;
  final VoidCallback? onRetry;
  final VoidCallback? onEnterCity;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;
    final failure = error is WeatherFailure ? error as WeatherFailure : null;
    final message = failure?.message ?? 'Weather unavailable right now.';
    final showCity = onEnterCity != null && (failure?.needsCity ?? false);

    return Container(
      key: const ValueKey('weather-error'),
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        AppSpacing.md,
        AppSpacing.sm,
        AppSpacing.md,
      ),
      decoration: BoxDecoration(
        color: scheme.surfaceContainer,
        borderRadius: AppRadius.circular(AppRadius.xl),
        border: Border.all(color: scheme.outlineVariant),
      ),
      child: Row(
        children: [
          Icon(
            Icons.cloud_off_outlined,
            size: 26,
            color: scheme.onSurfaceVariant,
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'No weather',
                  style: text.titleSmall?.copyWith(fontSize: 14),
                ),
                const SizedBox(height: 2),
                Text(message, style: text.caption),
              ],
            ),
          ),
          if (showCity)
            TextButton(onPressed: onEnterCity, child: const Text('Enter city'))
          else if (onRetry != null)
            IconButton(
              onPressed: onRetry,
              tooltip: 'Retry weather',
              icon: const Icon(Icons.refresh_rounded),
            ),
        ],
      ),
    );
  }
}
