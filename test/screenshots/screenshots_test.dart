@Tags(['screenshots'])
library;

import 'dart:io';

import 'package:ace_coach/constants/app_themes.dart';
import 'package:ace_coach/models/session_params.dart';
import 'package:ace_coach/models/training_session.dart';
import 'package:ace_coach/models/weather.dart';
import 'package:ace_coach/providers/app_settings_provider.dart';
import 'package:ace_coach/providers/auth_provider.dart';
import 'package:ace_coach/providers/session_form_provider.dart';
import 'package:ace_coach/providers/session_generation_provider.dart';
import 'package:ace_coach/providers/session_history_provider.dart';
import 'package:ace_coach/providers/weather_provider.dart';
import 'package:ace_coach/router/app_shell.dart';
import 'package:ace_coach/screens/auth/login_screen.dart';
import 'package:ace_coach/screens/auth/splash_screen.dart';
import 'package:ace_coach/screens/history/history_screen.dart';
import 'package:ace_coach/screens/home/home_screen.dart';
import 'package:ace_coach/screens/profile/profile_screen.dart';
import 'package:ace_coach/screens/session_result/session_result_screen.dart';
import 'package:ace_coach/screens/session_setup/session_setup_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart' show Override;
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';

import '../helpers/fixtures.dart';

/// Renders every screen with fake data into `docs/screenshots/*.png`.
///
/// Run with:
/// `flutter test --run-skipped --tags screenshots --update-goldens`
void main() {
  // flutter_test does not load the Material icon font; read it from the SDK.
  setUpAll(() async {
    final root =
        Platform.environment['FLUTTER_ROOT'] ??
        '${Platform.environment['HOME']}/flutter';
    final file = File(
      '$root/bin/cache/artifacts/material_fonts/MaterialIcons-Regular.otf',
    );
    if (!file.existsSync()) return;
    final bytes = await file.readAsBytes();
    final loader = FontLoader('MaterialIcons')
      ..addFont(Future.value(ByteData.sublistView(bytes)));
    await loader.load();
  });

  final rain = Fixtures.sunnyWeather.copyWith(
    temperatureCelsius: 17,
    feelsLikeCelsius: 16,
    conditionId: 500,
    condition: 'Rain',
    description: 'light rain',
    windSpeedMs: 4.6,
  );

  final history = [
    Fixtures.session(
      id: 'a',
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
      completedAt: DateTime.now(),
    ),
    Fixtures.session(
      id: 'b',
      title: 'Serve rhythm ladder',
      createdAt: DateTime.now().subtract(const Duration(days: 3)),
      level: SkillLevel.advanced,
      strokes: {Stroke.serve},
      durationMinutes: 45,
      completedAt: DateTime.now(),
    ),
    Fixtures.session(
      id: 'c',
      title: 'Net approach & volley hands',
      createdAt: DateTime.now().subtract(const Duration(days: 6)),
      strokes: {Stroke.volley},
      durationMinutes: 60,
    ),
    Fixtures.session(
      id: 'd',
      title: 'Footwork and split-step timing',
      createdAt: DateTime.now().subtract(const Duration(days: 9)),
      strokes: {Stroke.forehand, Stroke.backhand},
      durationMinutes: 50,
      completedAt: DateTime.now(),
    ),
    Fixtures.session(
      id: 'e',
      title: 'Indoor backhand consistency',
      createdAt: DateTime.now().subtract(const Duration(days: 12)),
      strokes: {Stroke.backhand},
      durationMinutes: 90,
    ),
  ];

  final fullSession = Fixtures.session(
    exercises: [
      Fixtures.warmUp,
      Fixtures.forehandDepth.copyWith(
        technicalTip: 'Finish the swing high and across the body for topspin.',
      ),
      Fixtures.forehandDepth.copyWith(
        title: 'First-serve targets',
        description:
            'Cones in the T and wide corners, 5 × 10 serves alternating sides.',
        estimatedDurationMinutes: 25,
        technicalTip: 'Toss slightly into the court.',
      ),
      Fixtures.forehandDepth.copyWith(
        title: 'Point play: serve + 1',
        description: 'Serve then attack the first ball, 3 games to 4 points.',
        estimatedDurationMinutes: 15,
        technicalTip: 'Split-step as the return is struck.',
      ),
      Fixtures.forehandDepth.copyWith(
        title: 'Cool-down',
        description: 'Easy jog and static stretching for shoulders and hips.',
        estimatedDurationMinutes: 5,
        technicalTip: '',
      ),
    ],
  );

  List<Override> overrides({
    Weather? weather,
    List<TrainingSession>? sessions,
    TrainingSession? generated,
    ThemeMode themeMode = ThemeMode.light,
  }) => [
    currentUserProvider.overrideWithValue(Fixtures.user),
    currentWeatherProvider.overrideWith((ref) async => weather ?? rain),
    sessionHistoryProvider.overrideWith(
      (ref) => Stream.value(sessions ?? history),
    ),
    appThemeModeProvider.overrideWith(() => _FakeThemeMode(themeMode)),
    homeCityProvider.overrideWith(() => _FakeHomeCity('Vincennes')),
    sessionGenerationProvider.overrideWith(
      () => _FakeGeneration(SessionGenerationState(session: generated)),
    ),
    sessionFormProvider.overrideWith(
      () => _FakeForm(
        const SessionParams(
          durationMinutes: 75,
          strokes: {Stroke.forehand, Stroke.serve},
        ),
      ),
    ),
  ];

  Future<void> capture(
    WidgetTester tester,
    String name,
    Widget screen, {
    List<Override>? providerOverrides,
    ThemeMode themeMode = ThemeMode.light,
    int shellIndex = -1,
  }) async {
    tester.view.physicalSize = const Size(1080, 2340);
    tester.view.devicePixelRatio = 3;
    tester.platformDispatcher.platformBrightnessTestValue =
        themeMode == ThemeMode.dark ? Brightness.dark : Brightness.light;
    addTearDown(tester.view.reset);
    addTearDown(tester.platformDispatcher.clearPlatformBrightnessTestValue);

    final Widget home = shellIndex < 0
        ? screen
        : _ShellPreview(index: shellIndex, child: screen);

    await tester.pumpWidget(
      ProviderScope(
        retry: (_, _) => null,
        overrides: providerOverrides ?? overrides(themeMode: themeMode),
        child: MaterialApp(
          theme: AppThemes.light,
          darkTheme: AppThemes.dark,
          themeMode: themeMode,
          debugShowCheckedModeBanner: false,
          home: MediaQuery(
            // Simulate a notch-less status bar and home indicator.
            data: MediaQueryData(
              size: const Size(360, 780),
              devicePixelRatio: 3,
              padding: const EdgeInsets.only(top: 24, bottom: 20),
              platformBrightness: themeMode == ThemeMode.dark
                  ? Brightness.dark
                  : Brightness.light,
            ),
            child: home,
          ),
        ),
      ),
    );
    await GoogleFonts.pendingFonts();
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 600));
    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('../../docs/screenshots/$name.png'),
    );
  }

  testWidgets('01 splash', (tester) async {
    await capture(tester, '01_splash', const SplashScreen());
  });

  testWidgets('02 login', (tester) async {
    await capture(tester, '02_login', const LoginScreen());
  });

  testWidgets('03 home', (tester) async {
    await capture(
      tester,
      '03_home',
      const HomeScreen(),
      providerOverrides: overrides(weather: Fixtures.sunnyWeather),
      shellIndex: 0,
    );
  });

  testWidgets('04 setup', (tester) async {
    await capture(
      tester,
      '04_setup',
      const SessionSetupScreen(),
      shellIndex: 1,
    );
  });

  testWidgets('05 result', (tester) async {
    await capture(
      tester,
      '05_result',
      const SessionResultScreen(),
      providerOverrides: overrides(
        weather: Fixtures.sunnyWeather,
        generated: fullSession,
      ),
    );
  });

  testWidgets('06 history', (tester) async {
    await capture(tester, '06_history', const HistoryScreen(), shellIndex: 2);
  });

  testWidgets('07 profile', (tester) async {
    await capture(tester, '07_profile', const ProfileScreen(), shellIndex: 3);
  });

  testWidgets('08 result dark', (tester) async {
    await capture(
      tester,
      '08_result_dark',
      const SessionResultScreen(),
      themeMode: ThemeMode.dark,
      providerOverrides: overrides(
        weather: Fixtures.sunnyWeather,
        generated: fullSession,
        themeMode: ThemeMode.dark,
      ),
    );
  });

  testWidgets('09 home dark', (tester) async {
    await capture(
      tester,
      '09_home_dark',
      const HomeScreen(),
      themeMode: ThemeMode.dark,
      providerOverrides: overrides(
        weather: Fixtures.sunnyWeather,
        themeMode: ThemeMode.dark,
      ),
      shellIndex: 0,
    );
  });
}

/// Wraps a screen in the real bottom navigation, without a router.
class _ShellPreview extends StatelessWidget {
  const _ShellPreview({required this.index, required this.child});

  final int index;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      bottomNavigationBar: AppNavigationBar(
        currentIndex: index,
        onDestinationSelected: (_) {},
      ),
    );
  }
}

class _FakeThemeMode extends AppThemeMode {
  _FakeThemeMode(this.mode);

  final ThemeMode mode;

  @override
  Future<ThemeMode> build() async => mode;
}

class _FakeHomeCity extends HomeCity {
  _FakeHomeCity(this.city);

  final String city;

  @override
  Future<String?> build() async => city;
}

class _FakeGeneration extends SessionGeneration {
  _FakeGeneration(this.initial);

  final SessionGenerationState initial;

  @override
  SessionGenerationState build() => initial;
}

class _FakeForm extends SessionForm {
  _FakeForm(this.initial);

  final SessionParams initial;

  @override
  SessionParams build() => initial;
}
