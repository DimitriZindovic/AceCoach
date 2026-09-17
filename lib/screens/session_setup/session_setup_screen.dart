import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../constants/app_colors.dart';
import '../../constants/app_spacing.dart';
import '../../constants/app_themes.dart';
import '../../models/session_params.dart';
import '../../models/weather.dart';
import '../../providers/session_form_provider.dart';
import '../../providers/session_generation_provider.dart';
import '../../providers/weather_provider.dart';
import '../../router/app_router.dart';
import '../../widgets/duration_slider.dart';
import '../../widgets/goal_selector.dart';
import '../../widgets/level_selector.dart';
import '../../widgets/primary_button.dart';
import '../../widgets/stroke_chip_group.dart';
import '../../widgets/weather_alert_banner.dart';

/// Session parameters: duration, level, strokes, goal, players present.
///
/// The design lays every parameter out on one scrolling screen, so the form
/// is a single guided page rather than a stepper.
class SessionSetupScreen extends ConsumerWidget {
  const SessionSetupScreen({super.key});

  static const String routePath = '/setup';

  void _generate(BuildContext context, WidgetRef ref) {
    // Fire and navigate: the result screen renders the loading state.
    ref.read(sessionGenerationProvider.notifier).generate();
    context.pushNamed(AppRoutes.sessionResult);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final params = ref.watch(sessionFormProvider);
    final form = ref.read(sessionFormProvider.notifier);
    final weather = ref.watch(currentWeatherProvider);
    final text = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: const Text('New session')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.screenHorizontal,
          AppSpacing.lg,
          AppSpacing.screenHorizontal,
          AppSpacing.xxl,
        ),
        children: [
          _WeatherHint(
            weather: weather,
            preferIndoor: params.preferIndoor,
            onPreferIndoor: () => form.setPreferIndoor(true),
            onRetry: () => ref.invalidate(currentWeatherProvider),
          ),
          DurationSlider(
            value: params.durationMinutes,
            onChanged: form.setDuration,
          ),
          const SizedBox(height: AppSpacing.lg),
          _Section(
            title: 'Level',
            child: LevelSelector(value: params.level, onChanged: form.setLevel),
          ),
          _Section(
            title: 'Shots to work on',
            trailing: params.strokes.isEmpty
                ? Text(
                    'Pick at least one',
                    style: text.badge.copyWith(
                      fontWeight: FontWeight.w500,
                      color: AppColors.textTertiary,
                    ),
                  )
                : null,
            child: StrokeChipGroup(
              selected: params.strokes,
              onToggle: form.toggleStroke,
            ),
          ),
          _Section(
            title: 'Goal',
            child: GoalSelector(value: params.goal, onChanged: form.setGoal),
          ),
          _Section(
            title: 'Players present',
            child: ChoicePillGroup<PlayerCount>(
              items: PlayerCount.values,
              selected: params.players,
              labelOf: (p) => p.label,
              onSelected: form.setPlayers,
            ),
          ),
          _IndoorSwitch(
            value: params.preferIndoor,
            onChanged: form.setPreferIndoor,
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.screenHorizontal,
            AppSpacing.md + 2,
            AppSpacing.screenHorizontal,
            AppSpacing.lg,
          ),
          child: PrimaryButton(
            label: 'Generate my session',
            icon: Icons.auto_awesome_outlined,
            height: AppSizes.ctaButtonHeight,
            onPressed: params.isValid ? () => _generate(context, ref) : null,
          ),
        ),
      ),
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({required this.title, required this.child, this.trailing});

  final String title;
  final Widget child;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: Theme.of(context).textTheme.sectionLabel),
              ?trailing,
            ],
          ),
          const SizedBox(height: AppSpacing.xxs),
          child,
        ],
      ),
    );
  }
}

/// Weather banner: warning when conditions are poor, info when ideal or when
/// the forecast is unavailable. Hidden while loading.
class _WeatherHint extends StatelessWidget {
  const _WeatherHint({
    required this.weather,
    required this.preferIndoor,
    required this.onPreferIndoor,
    required this.onRetry,
  });

  final AsyncValue<Weather> weather;
  final bool preferIndoor;
  final VoidCallback onPreferIndoor;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final Widget? banner = switch (weather) {
      AsyncValue(:final value?) => _forWeather(value),
      AsyncValue(hasError: true) => WeatherAlertBanner(
        icon: Icons.cloud_off_outlined,
        tone: BannerTone.info,
        message:
            'Weather unavailable. Your session will be generated without it.',
        actionLabel: 'Retry',
        onAction: onRetry,
      ),
      _ => null,
    };
    if (banner == null) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.lg),
      child: banner,
    );
  }

  Widget _forWeather(Weather weather) {
    final temp = weather.temperatureLabel;
    return switch (weather.verdict) {
      WeatherVerdict.ideal => WeatherAlertBanner(
        icon: Icons.wb_sunny_outlined,
        tone: BannerTone.info,
        message:
            '$temp and ${weather.conditionLabel.toLowerCase()} — outdoor '
            'session ideal, plan a hydration break every 20 minutes.',
      ),
      WeatherVerdict.caution => WeatherAlertBanner(
        icon: weather.isTooHot
            ? Icons.local_fire_department_outlined
            : Icons.air_rounded,
        message: weather.isTooHot
            ? 'Heat peaks at $temp — the session will be shortened in '
                  'intensity and favour shaded courts.'
            : weather.isTooCold
            ? 'Only $temp — a longer warm-up and layered clothing are '
                  'recommended.'
            : 'Wind at ${weather.windSpeedKmh} km/h — drills will favour '
                  'low, controlled trajectories.',
        actionLabel: preferIndoor ? null : 'Prefer indoor',
        onAction: preferIndoor ? null : onPreferIndoor,
      ),
      WeatherVerdict.indoor => WeatherAlertBanner(
        icon: Icons.umbrella_outlined,
        message:
            '${weather.conditionLabel} expected — indoor session recommended, '
            'drills adapted for hard indoor courts.',
        actionLabel: preferIndoor ? null : 'Indoor only',
        onAction: preferIndoor ? null : onPreferIndoor,
      ),
    };
  }
}

class _IndoorSwitch extends StatelessWidget {
  const _IndoorSwitch({required this.value, required this.onChanged});

  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;
    return Container(
      decoration: BoxDecoration(
        color: scheme.surface,
        borderRadius: AppRadius.circular(AppRadius.md),
        border: Border.all(color: scheme.outline),
      ),
      child: SwitchListTile.adaptive(
        value: value,
        onChanged: onChanged,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md + 2,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: AppRadius.circular(AppRadius.md),
        ),
        secondary: Icon(
          Icons.home_work_outlined,
          color: scheme.onSurfaceVariant,
          size: 20,
        ),
        title: Text('Indoor court only', style: text.sectionLabel),
        subtitle: Text(
          'Every drill works without sun, wind or extra space.',
          style: text.labelSmall?.copyWith(
            fontWeight: FontWeight.w400,
            letterSpacing: 0,
            color: scheme.onSurfaceVariant,
          ),
        ),
      ),
    );
  }
}
