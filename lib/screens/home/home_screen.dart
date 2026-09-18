import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../constants/app_colors.dart';
import '../../constants/app_spacing.dart';
import '../../constants/app_themes.dart';
import '../../models/training_session.dart';
import '../../providers/auth_provider.dart';
import '../../providers/session_history_provider.dart';
import '../../providers/weather_provider.dart';
import '../../router/app_router.dart';
import '../../widgets/session_card.dart';
import '../../widgets/weather_chip.dart';
import '../session_setup/session_setup_screen.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  static const String routePath = '/';

  Future<void> _refreshWeather(WidgetRef ref) async {
    ref.invalidate(currentWeatherProvider);
    try {
      await ref.read(currentWeatherProvider.future);
    } on Object {
      return;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authStateProvider).value;
    final weather = ref.watch(currentWeatherProvider);
    final history = ref.watch(sessionHistoryProvider);
    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () => _refreshWeather(ref),
        edgeOffset: MediaQuery.paddingOf(context).top,
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Container(
                padding: EdgeInsets.fromLTRB(
                  AppSpacing.screenHorizontal,
                  MediaQuery.paddingOf(context).top + AppSpacing.md + 2,
                  AppSpacing.screenHorizontal,
                  AppSpacing.section,
                ),
                decoration: BoxDecoration(
                  color: scheme.surface,
                  border: Border(
                    bottom: BorderSide(color: scheme.outlineVariant),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                DateFormat('EEEE, d MMMM')
                                    .format(DateTime.now()),
                                style: text.caption.copyWith(
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Row(
                                children: [
                                  Flexible(
                                    child: Text(
                                      'Hi ${user?.firstName ?? 'there'}',
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: text.headlineSmall,
                                    ),
                                  ),
                                  const SizedBox(width: AppSpacing.xs),
                                  const Icon(
                                    Icons.waving_hand_rounded,
                                    size: 22,
                                    color: AppColors.tipIcon,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: AppSpacing.md),
                        _Avatar(initials: user?.initials ?? '?'),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    WeatherChip(
                      weather: weather,
                      onRetry: () => _refreshWeather(ref),
                    ),
                  ],
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.screenHorizontal,
                AppSpacing.section,
                AppSpacing.screenHorizontal,
                AppSpacing.xxl,
              ),
              sliver: SliverList.list(
                children: [
                  _NewSessionCard(
                    onTap: () => context.go(SessionSetupScreen.routePath),
                  ),
                  if (history.value?.isNotEmpty ?? false) ...[
                    const SizedBox(height: AppSpacing.section),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        Text('Recent sessions', style: text.titleSmall),
                        TextButton(
                          onPressed: () => context.goNamed(AppRoutes.history),
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppSpacing.sm,
                            ),
                            visualDensity: VisualDensity.compact,
                          ),
                          child: const Text('See all'),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    _RecentSessions(history: history),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Avatar extends StatelessWidget {
  const _Avatar({required this.initials});

  final String initials;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: AppSizes.avatarSmall,
      height: AppSizes.avatarSmall,
      decoration: BoxDecoration(
        color: AppColors.primaryContainer,
        shape: BoxShape.circle,
        border: Border.all(color: AppColors.lime, width: 2),
      ),
      alignment: Alignment.center,
      child: Text(
        initials,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
          fontWeight: FontWeight.w700,
          color: AppColors.primaryDark,
        ),
      ),
    );
  }
}

class _NewSessionCard extends StatelessWidget {
  const _NewSessionCard({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;
    return Semantics(
      button: true,
      label: 'Create a new session',
      child: Material(
        color: scheme.inverseSurface,
        borderRadius: AppRadius.circular(AppRadius.xxl),
        child: InkWell(
          onTap: onTap,
          borderRadius: AppRadius.circular(AppRadius.xxl),
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.section),
            child: Row(
              children: [
                Container(
                  width: AppSizes.iconBoxLarge,
                  height: AppSizes.iconBoxLarge,
                  decoration: BoxDecoration(
                    color: AppColors.lime,
                    borderRadius: AppRadius.circular(AppRadius.md),
                  ),
                  child: const Icon(
                    Icons.auto_awesome_outlined,
                    color: AppColors.primaryDeep,
                    size: 24,
                  ),
                ),
                const SizedBox(width: AppSpacing.md + 2),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Create a new session',
                        style: text.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: scheme.onInverseSurface,
                          height: 1.2,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        "AI-built around today's conditions",
                        style: text.caption.copyWith(
                          color: AppColors.textDisabled,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.chevron_right_rounded,
                  color: AppColors.lime,
                  size: 22,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _RecentSessions extends StatelessWidget {
  const _RecentSessions({required this.history});

  final AsyncValue<List<TrainingSession>> history;

  static const double _height = 150;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: _height,
      child: switch (history) {
        AsyncValue(:final value?) when value.isNotEmpty => ListView.separated(
          scrollDirection: Axis.horizontal,
          clipBehavior: Clip.none,
          itemCount: value.length.clamp(0, 5),
          separatorBuilder: (_, _) => const SizedBox(width: AppSpacing.md),
          itemBuilder: (context, index) =>
              RecentSessionCard(session: value[index]),
        ),
        _ => const SizedBox.shrink(),
      },
    );
  }
}
