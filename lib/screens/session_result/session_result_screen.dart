import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../constants/app_spacing.dart';
import '../../models/training_session.dart';
import '../../providers/session_form_provider.dart';
import '../../providers/session_generation_provider.dart';
import '../../providers/session_history_provider.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/exercise_card.dart';
import '../../widgets/primary_button.dart';
import '../../widgets/session_plan_header.dart';

class SessionResultScreen extends ConsumerWidget {
  const SessionResultScreen({super.key});

  static const String routeSegment = 'result';
  static const String routePath = '/setup/result';

  Future<void> _save(BuildContext context, WidgetRef ref) async {
    final messenger = ScaffoldMessenger.of(context);
    final notifier = ref.read(sessionGenerationProvider.notifier);

    final bool saved;
    try {
      saved = await notifier.save();
    } on Object {
      if (!context.mounted) return;
      messenger.showSnackBar(
        const SnackBar(
          content: Text('Could not save this session. Please retry.'),
        ),
      );
      return;
    }
    if (!saved || !context.mounted) return;
    messenger.showSnackBar(
      const SnackBar(content: Text('Session saved to your history.')),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
    final savedIds = ref.watch(sessionHistoryProvider).value ?? const [];
    final currentId = ref.watch(sessionGenerationProvider).session?.id;
    final isSaved =
        currentId != null && savedIds.any((saved) => saved.id == currentId);
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
            onBack: () => context.pop(),
          ),
          Expanded(
            child: switch (state) {
              SessionGenerationState(:final session?) => _PlanList(
                session: session,
              ),
              SessionGenerationState(:final failure?) => EmptyState(
                icon: Icons.error_outline_rounded,
                isError: true,
                title: 'Generation failed',
                message: failure.message,
                actionLabel: 'Try again',
                onAction: notifier.generate,
              ),
              _ => const SizedBox.shrink(),
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
  const _PlanList({required this.session});

  final TrainingSession session;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.screenHorizontal,
        AppSpacing.md + 2,
        AppSpacing.screenHorizontal,
        AppSpacing.md,
      ),
      itemCount: session.exercises.length + 1,
      separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.sm + 2),
      itemBuilder: (context, index) {
        if (index < session.exercises.length) {
          return ExerciseCard(
            index: index + 1,
            exercise: session.exercises[index],
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
