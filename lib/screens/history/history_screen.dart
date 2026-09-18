import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../constants/app_colors.dart';
import '../../constants/app_spacing.dart';
import '../../models/session_params.dart';
import '../../providers/session_history_provider.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/level_selector.dart';
import '../../widgets/session_card.dart';

class HistoryScreen extends ConsumerStatefulWidget {
  const HistoryScreen({super.key});

  static const String routePath = '/history';

  @override
  ConsumerState<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends ConsumerState<HistoryScreen> {
  final TextEditingController _searchController = TextEditingController();

  SkillLevel? _level;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _clearFilters() {
    _searchController.clear();
    setState(() => _level = null);
  }

  @override
  Widget build(BuildContext context) {
    final level = _level;
    final sessions = ref
        .watch(sessionHistoryProvider)
        .whenData(
          (all) => level == null
              ? all
              : all.where((s) => s.params.level == level).toList(),
        );
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
                _SearchField(controller: _searchController),
                const SizedBox(height: AppSpacing.md + 2),
                _FilterRow(
                  level: _level,
                  onClear: _clearFilters,
                  onLevel: (level) => setState(() => _level = level),
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
                  itemBuilder: (context, index) =>
                      SessionCard(session: value[index]),
                ),
              AsyncValue(:final value?) when value.isEmpty && _level != null =>
                EmptyState(
                  icon: Icons.search_off_rounded,
                  title: 'No session matches',
                  message: 'Try another level or clear the filters.',
                  actionLabel: 'Clear filters',
                  onAction: _clearFilters,
                ),
              AsyncValue(:final value?) when value.isEmpty =>
                const SizedBox.shrink(),
              AsyncValue(hasError: true) => EmptyState(
                icon: Icons.error_outline_rounded,
                isError: true,
                title: 'History unavailable',
                message: 'Your saved sessions could not be loaded.',
                actionLabel: 'Retry',
                onAction: () => ref.invalidate(sessionHistoryProvider),
              ),
              _ => const SizedBox.shrink(),
            },
          ),
        ],
      ),
    );
  }
}

class _SearchField extends StatelessWidget {
  const _SearchField({required this.controller});

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return SizedBox(
      height: AppSizes.searchHeight,
      child: TextField(
        controller: controller,
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
                    onPressed: controller.clear,
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
    required this.level,
    required this.onClear,
    required this.onLevel,
  });

  final SkillLevel? level;
  final VoidCallback onClear;
  final ValueChanged<SkillLevel?> onLevel;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      clipBehavior: Clip.none,
      child: Row(
        children: [
          SelectablePill(
            label: 'All',
            dense: true,
            selected: level == null,
            onTap: onClear,
          ),
          for (final value in SkillLevel.values) ...[
            const SizedBox(width: AppSpacing.sm),
            SelectablePill(
              label: value.label,
              dense: true,
              selected: level == value,
              onTap: () => onLevel(level == value ? null : value),
            ),
          ],
        ],
      ),
    );
  }
}
