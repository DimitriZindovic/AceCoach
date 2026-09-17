import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app.dart';
import 'constants/app_spacing.dart';
import 'constants/app_themes.dart';
import 'firebase_options.dart';
import 'providers/app_settings_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  // Secrets and Firebase identifiers come from the bundled `.env` asset.
  await dotenv.load();

  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } on Object catch (error) {
    // A missing key must be obvious in development instead of a blank screen.
    runApp(_ConfigurationErrorApp(message: '$error'));
    return;
  }

  // Providers never auto-retry: every async surface shows its own error state.
  final container = ProviderContainer(retry: (_, _) => null);

  // Open the local database and read the theme before the first frame so the
  // app never flashes the wrong theme.
  await container.read(appThemeModeProvider.future);

  runApp(
    UncontrolledProviderScope(container: container, child: const AceCoachApp()),
  );
}

/// Shown when Firebase cannot be configured (missing `.env` values).
class _ConfigurationErrorApp extends StatelessWidget {
  const _ConfigurationErrorApp({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AceCoach',
      theme: AppThemes.light,
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.xxl),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Configuration needed',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: AppSpacing.md),
                Text(
                  'AceCoach could not start because Firebase is not '
                  'configured. Copy `.env.example` to `.env`, fill in the '
                  'values and restart. See docs/setup_guide.md.',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: AppSpacing.lg),
                Text(message, style: Theme.of(context).textTheme.bodySmall),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
