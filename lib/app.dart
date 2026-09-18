import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'constants/app_themes.dart';
import 'router/app_router.dart';

class AceCoachApp extends ConsumerWidget {
  const AceCoachApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp.router(
      title: 'AceCoach',
      debugShowCheckedModeBanner: false,
      theme: AppThemes.light,
      routerConfig: ref.watch(appRouterProvider),
    );
  }
}
