import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../constants/app_spacing.dart';
import '../../models/training_session.dart';
import '../../providers/session_form_provider.dart';
import '../../providers/session_generation_provider.dart';
import '../../providers/weather_provider.dart';
import '../../router/app_router.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/exercise_card.dart';
import '../../widgets/loading_overlay.dart';
import '../../widgets/primary_button.dart';
import '../../widgets/session_plan_header.dart';
import '../../widgets/weather_alert_banner.dart';
import '../history/session_detail_screen.dart';

class SessionResultScreen extends ConsumerWidget {
  const SessionResultScreen({super.key});

  static const String routeSegment = 'result';
  static const String routePath = '/setup/result';

  Future<void> _save(BuildContext context, WidgetRef ref) async {
    final messenger = ScaffoldMessenger.of(context);
    final notifier = ref.read(sessionGenerationProvider.notifier);
    final id = ref.read(sessionGenerationProvider).session?.id;
    final saved = await notifier.save();
    if (!saved || !context.mounted) return;
    messenger.showSnackBar(
      SnackBar(
        content: const Text('Session saved to your history.'),
        action: id == null
            ? null
            : SnackBarAction(
                label: 'View',
                onPressed: () => context.pushNamed(
                  AppRoutes.sessionDetail,
                  pathParameters: {SessionDetailScreen.sessionIdParameter: id},
                ),
              ),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // A failure during a regeneration keeps the previous plan; tell the user.
    ref.listen(sessionGenerationProvider, (previous, next) {
      final failure = next.failure;
      if (failure != null && next.hasSession && previous?.failure != failure) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(failure.message),
            action: SnackBarAction(
              label: 'Retry',
              onPressed: ref
                  .read(sessionGenerationProvider.notifier)
                  .regenerate,
            ),
          ),
        );
      }
    });

    final state = ref.watch(sessionGenerationProvider);
    final params = ref.watch(sessionFormProvider);
    final isSaved = ref.watch(isCurrentSessionSavedProvider);
    final weather = ref.watch(currentWeatherProvider).value;
    final notifier = ref.read(sessionGenerationProvider.notifier);
    final session = state.session;

    return Scaffold(
      body: Column(
        children: [
          SessionPlanHeader(
            title: session?.title ?? 'Your session',
            meta:
                session?.metaLabel ??
                '${params.durationMinutes} min · ${params.level.label} · '
                    '${params.strokesLabel}',
            weather: session?.weather ?? weather,
            weatherAdvice: session?.weatherAdvice,
            weatherUsed: session?.weatherUsed ?? weather != null,
            onBack: () => context.pop(),
          ),
          Expanded(
            child: switch (state) {
              SessionGenerationState(:final session?) => LoadingOverlay(
                isLoading: state.isGenerating,
                message: 'Regenerating a different plan…',
                child: _PlanList(
                  session: session,
                  showIndoorOffer:
                      !params.preferIndoor &&
                      session.weather != null &&
                      !session.weather!.isOutdoorFriendly,
                  onAdjustIndoor: notifier.adjustForIndoor,
                ),
              ),
              SessionGenerationState(:final failure?) => EmptyState(
                icon: Icons.error_outline_rounded,
                isError: true,
                title: 'Generation failed',
                message: failure.message,
                actionLabel: 'Try again',
                onAction: notifier.generate,
              ),
              _ => const LoadingOverlay(
                isLoading: true,
                message: 'Building your session…',
                child: _SkeletonPlan(),
              ),
            },
          ),
          if (session != null)
            SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.screenHorizontal,
                  AppSpacing.md,
                  AppSpacing.screenHorizontal,
                  AppSpacing.md + 2,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: PrimaryButton(
                        label: 'Regenerate',
                        icon: Icons.refresh_rounded,
                        variant: AppButtonVariant.neutral,
                        dense: true,
                        onPressed: state.isGenerating
                            ? null
                            : notifier.regenerate,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm + 2),
                    Expanded(
                      child: PrimaryButton(
                        label: isSaved ? 'Saved' : 'Save',
                        dense: true,
                        icon: isSaved
                            ? Icons.check_rounded
                            : Icons.save_alt_rounded,
                        onPressed: isSaved || state.isGenerating
                            ? null
                            : () => _save(context, ref),
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _PlanList extends StatelessWidget {
  const _PlanList({
    required this.session,
    required this.showIndoorOffer,
    required this.onAdjustIndoor,
  });

  final TrainingSession session;
  final bool showIndoorOffer;
  final VoidCallback onAdjustIndoor;

  @override
  Widget build(BuildContext context) {
    final banners = <Widget>[
      if (!session.weatherUsed)
        const WeatherAlertBanner(
          icon: Icons.cloud_off_outlined,
          tone: BannerTone.info,
          message:
              "Generated without today's weather. Drills assume a standard "
              'outdoor court.',
        ),
      if (showIndoorOffer)
        WeatherAlertBanner(
          icon: Icons.umbrella_outlined,
          message:
              'The weather is not ideal outdoors. Want a version that works '
              'on an indoor court?',
          actionLabel: 'Adjust for indoor',
          onAction: onAdjustIndoor,
        ),
    ];

    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.screenHorizontal,
        AppSpacing.md + 2,
        AppSpacing.screenHorizontal,
        AppSpacing.md,
      ),
      itemCount: banners.length + session.exercises.length + 1,
      separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.sm + 2),
      itemBuilder: (context, index) {
        if (index < banners.length) return banners[index];
        final exerciseIndex = index - banners.length;
        if (exerciseIndex < session.exercises.length) {
          return ExerciseCard(
            index: exerciseIndex + 1,
            exercise: session.exercises[exerciseIndex],
          );
        }
        return _SummaryFooter(session: session);
      },
    );
  }
}

class _SummaryFooter extends StatelessWidget {
  const _SummaryFooter({required this.session});

  final TrainingSession session;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.xxs,
        vertical: AppSpacing.xs,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(session.summary, style: text.bodySmall),
          const SizedBox(height: AppSpacing.xs),
          Text(
            '${session.exercises.length} exercises · ${session.totalMinutes} min total',
            style: text.labelSmall?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

class _SkeletonPlan extends StatelessWidget {
  const _SkeletonPlan();

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.screenHorizontal,
        AppSpacing.md + 2,
        AppSpacing.screenHorizontal,
        AppSpacing.md,
      ),
      itemCount: 4,
      separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.sm + 2),
      itemBuilder: (_, index) => SkeletonCard(minHeight: index == 0 ? 120 : 96),
    );
  }
}
