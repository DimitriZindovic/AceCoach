import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../constants/app_colors.dart';
import '../../constants/app_spacing.dart';
import '../../models/session_params.dart';
import '../../models/training_session.dart';
import '../../providers/session_history_provider.dart';
import '../../router/app_router.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/level_selector.dart';
import '../../widgets/loading_overlay.dart';
import '../../widgets/session_card.dart';
import '../session_setup/session_setup_screen.dart';
import 'session_detail_screen.dart';

class HistoryScreen extends ConsumerStatefulWidget {
  const HistoryScreen({super.key});

  static const String routePath = '/history';

  @override
  ConsumerState<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends ConsumerState<HistoryScreen> {
  late final TextEditingController _searchController = TextEditingController(
    text: ref.read(historyFilterProvider).query,
  );

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _pickDateRange() async {
    final filter = ref.read(historyFilterProvider);
    final now = DateTime.now();
    final range = await showDateRangePicker(
      context: context,
      firstDate: DateTime(now.year - 2),
      lastDate: now,
      initialDateRange: filter.dateRange,
      helpText: 'Filter by date',
    );
    if (range != null) {
      ref.read(historyFilterProvider.notifier).setDateRange(range);
    }
  }

  Future<bool> _confirmDelete(TrainingSession session) async {
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
    return confirmed ?? false;
  }

  Future<void> _delete(TrainingSession session) async {
    await ref.read(historyActionsProvider.notifier).delete(session.id);
    if (!mounted) return;
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text('"${session.title}" deleted.')));
  }

  void _clearFilters() {
    _searchController.clear();
    ref.read(historyFilterProvider.notifier).clear();
  }

  @override
  Widget build(BuildContext context) {
    final filter = ref.watch(historyFilterProvider);
    final filterNotifier = ref.read(historyFilterProvider.notifier);
    final sessions = ref.watch(filteredHistoryProvider);
    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;

    return Scaffold(
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.fromLTRB(
              AppSpacing.screenHorizontal,
              MediaQuery.paddingOf(context).top + AppSpacing.md + 2,
              AppSpacing.screenHorizontal,
              AppSpacing.lg,
            ),
            decoration: BoxDecoration(
              color: scheme.surface,
              border: Border(bottom: BorderSide(color: scheme.outlineVariant)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('History', style: text.titleLarge),
                const SizedBox(height: AppSpacing.md + 2),
                _SearchField(
                  controller: _searchController,
                  onChanged: filterNotifier.setQuery,
                ),
                const SizedBox(height: AppSpacing.md + 2),
                _FilterRow(
                  filter: filter,
                  onClear: _clearFilters,
                  onLevel: filterNotifier.setLevel,
                  onStroke: filterNotifier.setStroke,
                  onDateRange: _pickDateRange,
                  onClearDateRange: () => filterNotifier.setDateRange(null),
                ),
              ],
            ),
          ),
          Expanded(
            child: switch (sessions) {
              AsyncValue(:final value?) when value.isNotEmpty =>
                ListView.separated(
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.screenHorizontal,
                    AppSpacing.md + 2,
                    AppSpacing.screenHorizontal,
                    AppSpacing.xxl,
                  ),
                  itemCount: value.length,
                  separatorBuilder: (_, _) =>
                      const SizedBox(height: AppSpacing.sm + 2),
                  itemBuilder: (context, index) {
                    final session = value[index];
                    return Dismissible(
                      key: ValueKey(session.id),
                      direction: DismissDirection.endToStart,
                      confirmDismiss: (_) => _confirmDelete(session),
                      onDismissed: (_) => _delete(session),
                      background: const _DeleteBackground(),
                      child: SessionCard(
                        session: session,
                        onTap: () => context.pushNamed(
                          AppRoutes.sessionDetail,
                          pathParameters: {
                            SessionDetailScreen.sessionIdParameter: session.id,
                          },
                        ),
                      ),
                    );
                  },
                ),
              AsyncValue(:final value?) when value.isEmpty && filter.isActive =>
                EmptyState(
                  icon: Icons.search_off_rounded,
                  title: 'No session matches',
                  message: 'Try another keyword or clear the filters.',
                  actionLabel: 'Clear filters',
                  onAction: _clearFilters,
                ),
              AsyncValue(:final value?) when value.isEmpty => EmptyState(
                icon: Icons.sports_tennis_rounded,
                title: 'No sessions yet',
                message:
                    'Generate a session and save it to read it here, even '
                    'offline.',
                actionLabel: 'Create a session',
                onAction: () => context.go(SessionSetupScreen.routePath),
              ),
              AsyncValue(hasError: true) => EmptyState(
                icon: Icons.error_outline_rounded,
                isError: true,
                title: 'History unavailable',
                message: 'Your saved sessions could not be loaded.',
                actionLabel: 'Retry',
                onAction: () => ref.invalidate(sessionHistoryProvider),
              ),
              _ => ListView.separated(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.screenHorizontal,
                  AppSpacing.md + 2,
                  AppSpacing.screenHorizontal,
                  AppSpacing.xxl,
                ),
                itemCount: 5,
                separatorBuilder: (_, _) =>
                    const SizedBox(height: AppSpacing.sm + 2),
                itemBuilder: (_, _) => const SkeletonCard(minHeight: 72),
              ),
            },
          ),
        ],
      ),
    );
  }
}

class _SearchField extends StatelessWidget {
  const _SearchField({required this.controller, required this.onChanged});

  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return SizedBox(
      height: AppSizes.searchHeight,
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        textInputAction: TextInputAction.search,
        style: Theme.of(context).textTheme.bodySmall
            ?.copyWith(color: scheme.onSurface),
        decoration: InputDecoration(
          hintText: 'Search a session',
          filled: true,
          fillColor: scheme.surfaceContainer,
          contentPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          prefixIcon: const Icon(Icons.search_rounded, size: 18),
          suffixIcon: ValueListenableBuilder<TextEditingValue>(
            valueListenable: controller,
            builder: (context, value, _) => value.text.isEmpty
                ? const SizedBox.shrink()
                : IconButton(
                    tooltip: 'Clear search',
                    onPressed: () {
                      controller.clear();
                      onChanged('');
                    },
                    icon: const Icon(Icons.close_rounded, size: 18),
                  ),
          ),
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(23)),
            borderSide: BorderSide.none,
          ),
          enabledBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(23)),
            borderSide: BorderSide.none,
          ),
          focusedBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(23)),
            borderSide: BorderSide(color: AppColors.primary, width: 1.5),
          ),
        ),
      ),
    );
  }
}

class _FilterRow extends StatelessWidget {
  const _FilterRow({
    required this.filter,
    required this.onClear,
    required this.onLevel,
    required this.onStroke,
    required this.onDateRange,
    required this.onClearDateRange,
  });

  final HistoryFilter filter;
  final VoidCallback onClear;
  final ValueChanged<SkillLevel?> onLevel;
  final ValueChanged<Stroke?> onStroke;
  final VoidCallback onDateRange;
  final VoidCallback onClearDateRange;

  @override
  Widget build(BuildContext context) {
    final range = filter.dateRange;
    final rangeLabel = range == null
        ? 'Date range'
        : '${DateFormat('d MMM').format(range.start)} – '
              '${DateFormat('d MMM').format(range.end)}';

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      clipBehavior: Clip.none,
      child: Row(
        children: [
          SelectablePill(
            label: 'All',
            dense: true,
            selected: !filter.isActive,
            onTap: onClear,
          ),
          const SizedBox(width: AppSpacing.sm),
          SelectablePill(
            label: rangeLabel,
            dense: true,
            selected: range != null,
            onTap: range == null ? onDateRange : onClearDateRange,
          ),
          for (final level in SkillLevel.values) ...[
            const SizedBox(width: AppSpacing.sm),
            SelectablePill(
              label: level.label,
              dense: true,
              selected: filter.level == level,
              onTap: () => onLevel(filter.level == level ? null : level),
            ),
          ],
          for (final stroke in Stroke.values) ...[
            const SizedBox(width: AppSpacing.sm),
            SelectablePill(
              label: stroke.label,
              dense: true,
              selected: filter.stroke == stroke,
              onTap: () => onStroke(filter.stroke == stroke ? null : stroke),
            ),
          ],
        ],
      ),
    );
  }
}

class _DeleteBackground extends StatelessWidget {
  const _DeleteBackground();

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerRight,
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
      decoration: BoxDecoration(
        color: AppColors.errorContainer,
        borderRadius: AppRadius.circular(AppRadius.xl),
      ),
      child: const Icon(Icons.delete_outline_rounded, color: AppColors.error),
    );
  }
}
