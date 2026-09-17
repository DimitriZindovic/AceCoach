import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'constants/app_themes.dart';
import 'providers/app_settings_provider.dart';
import 'router/app_router.dart';

/// Root widget: router, light and dark themes, persisted theme mode.
class AceCoachApp extends ConsumerWidget {
  const AceCoachApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);
    final themeMode = ref.watch(appThemeModeProvider).value ?? ThemeMode.system;

    return MaterialApp.router(
      title: 'AceCoach',
      debugShowCheckedModeBanner: false,
      theme: AppThemes.light,
      darkTheme: AppThemes.dark,
      themeMode: themeMode,
      routerConfig: router,
    );
  }
}
