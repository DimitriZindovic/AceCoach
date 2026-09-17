import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../constants/app_colors.dart';
import '../../constants/app_spacing.dart';
import '../../constants/app_themes.dart';
import '../../providers/app_settings_provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/session_history_provider.dart';
import '../../widgets/home_city_dialog.dart';
import '../../widgets/primary_button.dart';
import '../../widgets/stat_tile.dart';

/// Global stats, account settings and sign-out.
class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  static const String routePath = '/profile';
  static const String appVersion = '1.0.0';

  Future<void> _editName(BuildContext context, WidgetRef ref) async {
    final current = ref.read(currentUserProvider)?.displayName ?? '';
    final name = await showDialog<String>(
      context: context,
      builder: (context) => _NameDialog(initial: current),
    );
    if (name == null || name.isEmpty || !context.mounted) return;
    final ok = await ref
        .read(authControllerProvider.notifier)
        .updateDisplayName(name);
    if (!context.mounted) return;
    final failure = ref.read(authControllerProvider.notifier).failure;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          ok ? 'Name updated.' : failure?.message ?? 'Update failed.',
        ),
      ),
    );
  }

  Future<void> _editCity(BuildContext context, WidgetRef ref) async {
    final current = ref.read(homeCityProvider).value;
    final city = await showHomeCityDialog(context, initial: current);
    if (city == null) return;
    await ref.read(homeCityProvider.notifier).setCity(city);
  }

  Future<void> _pickTheme(BuildContext context, WidgetRef ref) async {
    final current = ref.read(appThemeModeProvider).value ?? ThemeMode.system;
    final mode = await showModalBottomSheet<ThemeMode>(
      context: context,
      builder: (context) => _ThemeSheet(current: current),
    );
    if (mode != null) {
      await ref.read(appThemeModeProvider.notifier).setMode(mode);
    }
  }

  Future<void> _signOut(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Log out?'),
        content: const Text('Your saved sessions stay on this device.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: FilledButton.styleFrom(minimumSize: const Size(88, 44)),
            child: const Text('Log out'),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    await ref.read(authControllerProvider.notifier).signOut();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);
    final stats = ref.watch(profileStatsProvider);
    final themeMode = ref.watch(appThemeModeProvider).value ?? ThemeMode.system;
    final city = ref.watch(homeCityProvider).value;
    final auth = ref.watch(authControllerProvider);
    final text = Theme.of(context).textTheme;

    return Scaffold(
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          Container(
            padding: EdgeInsets.fromLTRB(
              AppSpacing.screenHorizontal,
              MediaQuery.paddingOf(context).top + AppSpacing.md + 2,
              AppSpacing.md,
              AppSpacing.xxl - 2,
            ),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [AppColors.primaryDark, AppColors.primary],
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: AppSizes.avatarLarge,
                  height: AppSizes.avatarLarge,
                  decoration: BoxDecoration(
                    color: AppColors.lime,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppColors.surface.withValues(alpha: 0.5),
                      width: 3,
                    ),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    user?.initials ?? '?',
                    style: text.titleLarge?.copyWith(
                      color: AppColors.primaryDeep,
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.md + 2),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user?.displayName?.isNotEmpty == true
                            ? user!.displayName!
                            : user?.firstName ?? 'Player',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: text.titleMedium?.copyWith(
                          fontSize: 19,
                          fontWeight: FontWeight.w700,
                          color: AppColors.surface,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        user?.email ?? '',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: text.caption.copyWith(
                          color: AppColors.surface.withValues(alpha: 0.88),
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  tooltip: 'Edit name',
                  onPressed: () => _editName(context, ref),
                  color: AppColors.surface,
                  icon: const Icon(Icons.edit_outlined, size: 20),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.screenHorizontal,
              AppSpacing.lg,
              AppSpacing.screenHorizontal,
              AppSpacing.xxl,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: StatTile(
                        value: '${stats.completedCount}',
                        label: 'Sessions completed',
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm + 2),
                    Expanded(
                      child: StatTile(
                        value: stats.totalTimeLabel,
                        label: 'Total training time',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.sm + 2),
                StatTile(
                  value: stats.topStroke?.label ?? '—',
                  label: stats.topStroke == null
                      ? 'Most-trained stroke · complete a session to find out'
                      : 'Most-trained stroke',
                ),
                const SizedBox(height: AppSpacing.md + 2),
                _SettingsCard(
                  rows: [
                    _SettingsRow(
                      icon: Icons.person_outline_rounded,
                      label: 'Personal info',
                      value: user?.displayName ?? '',
                      onTap: () => _editName(context, ref),
                    ),
                    _SettingsRow(
                      icon: Icons.place_outlined,
                      label: 'Home court',
                      value: city ?? 'Not set',
                      onTap: () => _editCity(context, ref),
                    ),
                    _SettingsRow(
                      icon: Icons.dark_mode_outlined,
                      label: 'Appearance',
                      value: _themeLabel(themeMode),
                      onTap: () => _pickTheme(context, ref),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.md + 2),
                PrimaryButton(
                  label: 'Log out',
                  icon: Icons.logout_rounded,
                  variant: AppButtonVariant.destructive,
                  isLoading: auth.isLoading,
                  onPressed: () => _signOut(context, ref),
                ),
                const SizedBox(height: AppSpacing.md + 2),
                Text(
                  'AceCoach $appVersion',
                  textAlign: TextAlign.center,
                  style: text.badge.copyWith(
                    fontWeight: FontWeight.w400,
                    color: AppColors.textDisabled,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static String _themeLabel(ThemeMode mode) => switch (mode) {
    ThemeMode.system => 'System',
    ThemeMode.light => 'Light',
    ThemeMode.dark => 'Dark',
  };
}

class _SettingsCard extends StatelessWidget {
  const _SettingsCard({required this.rows});

  final List<_SettingsRow> rows;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Material(
      color: scheme.surface,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: AppRadius.circular(AppRadius.xl),
        side: BorderSide(color: scheme.outlineVariant),
      ),
      child: Column(
        children: [
          for (var i = 0; i < rows.length; i++) ...[
            if (i > 0) Divider(color: scheme.surfaceContainerHigh),
            rows[i],
          ],
        ],
      ),
    );
  }
}

class _SettingsRow extends StatelessWidget {
  const _SettingsRow({
    required this.icon,
    required this.label,
    required this.value,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final String value;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;
    return ListTile(
      onTap: onTap,
      minTileHeight: 56,
      contentPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.md + 3),
      leading: Container(
        width: AppSizes.iconBoxSmall,
        height: AppSizes.iconBoxSmall,
        decoration: BoxDecoration(
          color: scheme.surfaceContainer,
          borderRadius: AppRadius.circular(AppRadius.sm),
        ),
        child: Icon(icon, size: 16, color: scheme.onSurfaceVariant),
      ),
      title: Text(
        label,
        style: text.bodySmall?.copyWith(
          color: scheme.onSurface,
          fontWeight: FontWeight.w500,
        ),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 140),
            child: Text(
              value,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: text.labelSmall?.copyWith(
                fontWeight: FontWeight.w400,
                letterSpacing: 0,
                color: AppColors.textTertiary,
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.xs),
          const Icon(
            Icons.chevron_right_rounded,
            size: 18,
            color: AppColors.chevron,
          ),
        ],
      ),
    );
  }
}

class _NameDialog extends StatefulWidget {
  const _NameDialog({required this.initial});

  final String initial;

  @override
  State<_NameDialog> createState() => _NameDialogState();
}

class _NameDialogState extends State<_NameDialog> {
  late final TextEditingController _controller = TextEditingController(
    text: widget.initial,
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Your name'),
      content: TextField(
        controller: _controller,
        autofocus: true,
        textCapitalization: TextCapitalization.words,
        textInputAction: TextInputAction.done,
        decoration: const InputDecoration(
          hintText: 'Display name',
          prefixIcon: Icon(Icons.person_outline_rounded, size: 18),
        ),
        onSubmitted: (value) => Navigator.of(context).pop(value.trim()),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: () => Navigator.of(context).pop(_controller.text.trim()),
          style: FilledButton.styleFrom(minimumSize: const Size(88, 44)),
          child: const Text('Save'),
        ),
      ],
    );
  }
}

class _ThemeSheet extends StatelessWidget {
  const _ThemeSheet({required this.current});

  final ThemeMode current;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.screenHorizontal,
          0,
          AppSpacing.screenHorizontal,
          AppSpacing.lg,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Appearance', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: AppSpacing.sm),
            RadioGroup<ThemeMode>(
              groupValue: current,
              onChanged: (mode) => Navigator.of(context).pop(mode),
              child: const Column(
                children: [
                  RadioListTile<ThemeMode>(
                    value: ThemeMode.system,
                    title: Text('System'),
                    subtitle: Text('Follow the device setting'),
                  ),
                  RadioListTile<ThemeMode>(
                    value: ThemeMode.light,
                    title: Text('Light'),
                  ),
                  RadioListTile<ThemeMode>(
                    value: ThemeMode.dark,
                    title: Text('Dark'),
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
