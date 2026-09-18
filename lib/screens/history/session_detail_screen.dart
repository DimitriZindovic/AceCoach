import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../constants/app_colors.dart';
import '../../constants/app_spacing.dart';
import '../../models/training_session.dart';
import '../../providers/session_history_provider.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/exercise_card.dart';
import '../../widgets/loading_overlay.dart';
import '../../widgets/primary_button.dart';
import '../../widgets/session_plan_header.dart';

class SessionDetailScreen extends ConsumerWidget {
  const SessionDetailScreen({super.key, required this.sessionId});

  static const String sessionIdParameter = 'sessionId';
  static const String routeSegment = ':$sessionIdParameter';

  final String sessionId;

  Future<void> _delete(
    BuildContext context,
    WidgetRef ref,
    TrainingSession session,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete this session?'),
        content: Text(
          '"${session.title}" will be removed from your device. '
          'This cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.error,
              minimumSize: const Size(88, 44),
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (confirmed != true || !context.mounted) return;
    await ref.read(historyActionsProvider.notifier).delete(session.id);
    if (context.mounted) context.pop();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = ref.watch(savedSessionProvider(sessionId));
    final actions = ref.watch(historyActionsProvider);

    return Scaffold(
      body: switch (session) {
        AsyncValue(:final value?) => _Detail(
          session: value,
          isBusy: actions.isLoading,
          onDelete: () => _delete(context, ref, value),
          onToggleCompleted: () => ref
              .read(historyActionsProvider.notifier)
              .setCompleted(value.id, completed: !value.isCompleted),
        ),
        AsyncValue(hasValue: true) || AsyncValue(hasError: true) => Column(
          children: [
            SessionPlanHeader(
              title: 'Session not found',
              meta: '',
              eyebrow: 'History',
              weatherUsed: false,
              onBack: () => context.pop(),
            ),
            const Expanded(
              child: EmptyState(
                icon: Icons.search_off_rounded,
                title: 'This session is gone',
                message: 'It may have been deleted from this device.',
              ),
            ),
          ],
        ),
        _ => Column(
          children: [
            SessionPlanHeader(
              title: 'Loading…',
              meta: '',
              eyebrow: 'History',
              onBack: () => context.pop(),
            ),
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.all(AppSpacing.screenHorizontal),
                itemCount: 3,
                separatorBuilder: (_, _) =>
                    const SizedBox(height: AppSpacing.sm + 2),
                itemBuilder: (_, _) => const SkeletonCard(),
              ),
            ),
          ],
        ),
      },
    );
  }
}

class _Detail extends StatelessWidget {
  const _Detail({
    required this.session,
    required this.isBusy,
    required this.onDelete,
    required this.onToggleCompleted,
  });

  final TrainingSession session;
  final bool isBusy;
  final VoidCallback onDelete;
  final VoidCallback onToggleCompleted;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final dateLabel = DateFormat('EEEE d MMMM, HH:mm')
        .format(session.createdAt);

    return Column(
      children: [
        SessionPlanHeader(
          title: session.title,
          meta: '$dateLabel · ${session.metaLabel}',
          eyebrow: session.isCompleted ? 'Completed' : 'Saved session',
          weather: session.weather,
          weatherAdvice: session.weatherAdvice,
          weatherUsed: session.weatherUsed,
          onBack: () => context.pop(),
          actions: [
            IconButton(
              tooltip: 'Delete session',
              onPressed: isBusy ? null : onDelete,
              color: AppColors.surface,
              icon: const Icon(Icons.delete_outline_rounded),
            ),
          ],
        ),
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.screenHorizontal,
              AppSpacing.md + 2,
              AppSpacing.screenHorizontal,
              AppSpacing.md,
            ),
            itemCount: session.exercises.length + 1,
            separatorBuilder: (_, _) =>
                const SizedBox(height: AppSpacing.sm + 2),
            itemBuilder: (context, index) {
              if (index < session.exercises.length) {
                return ExerciseCard(
                  index: index + 1,
                  exercise: session.exercises[index],
                );
              }
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
                      '${session.exercises.length} exercises · '
                      '${session.totalMinutes} min · '
                      '${session.params.players.label}',
                      style: text.labelSmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.screenHorizontal,
              AppSpacing.md,
              AppSpacing.screenHorizontal,
              AppSpacing.md + 2,
            ),
            child: PrimaryButton(
              label: session.isCompleted
                  ? 'Mark as not completed'
                  : 'Mark as completed',
              icon: session.isCompleted
                  ? Icons.undo_rounded
                  : Icons.check_circle_outline_rounded,
              variant: session.isCompleted
                  ? AppButtonVariant.neutral
                  : AppButtonVariant.primary,
              isLoading: isBusy,
              onPressed: onToggleCompleted,
            ),
          ),
        ),
      ],
    );
  }
}
