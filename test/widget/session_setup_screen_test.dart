import 'package:ace_coach/constants/app_themes.dart';
import 'package:ace_coach/models/failures.dart';
import 'package:ace_coach/models/session_params.dart';
import 'package:ace_coach/models/weather.dart';
import 'package:ace_coach/providers/session_form_provider.dart';
import 'package:ace_coach/providers/weather_provider.dart';
import 'package:ace_coach/screens/session_setup/session_setup_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/fixtures.dart';

Future<ProviderContainer> _pump(
  WidgetTester tester, {
  required Future<Weather> Function() weather,
}) async {
  // A 360 × 800 dp phone, like the design frames.
  tester.view.physicalSize = const Size(1080, 2400);
  tester.view.devicePixelRatio = 3;
  addTearDown(tester.view.reset);

  await tester.pumpWidget(
    ProviderScope(
      retry: (_, _) => null,
      overrides: [currentWeatherProvider.overrideWith((ref) => weather())],
      child: MaterialApp(
        theme: AppThemes.light,
        home: const SessionSetupScreen(),
      ),
    ),
  );
  await tester.pumpAndSettle();
  return ProviderScope.containerOf(
    tester.element(find.byType(SessionSetupScreen)),
  );
}

Finder _generateButton() =>
    find.widgetWithText(FilledButton, 'Generate my session');

Future<void> _scrollToAndTap(WidgetTester tester, String label) async {
  await tester.scrollUntilVisible(
    find.text(label),
    120,
    scrollable: find.byType(Scrollable).first,
  );
  await tester.tap(find.text(label));
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('generation stays disabled until a stroke is selected', (
    tester,
  ) async {
    final container = await _pump(
      tester,
      weather: () async => Fixtures.sunnyWeather,
    );

    expect(find.text('New session'), findsOneWidget);
    expect(find.text('60 min'), findsOneWidget);
    expect(find.text('Pick at least one'), findsOneWidget);
    expect(tester.widget<FilledButton>(_generateButton()).onPressed, isNull);

    await tester.tap(find.text('Forehand'));
    await tester.pumpAndSettle();

    expect(find.text('Pick at least one'), findsNothing);
    expect(tester.widget<FilledButton>(_generateButton()).onPressed, isNotNull);
    expect(container.read(sessionFormProvider).strokes, {Stroke.forehand});

    await tester.tap(find.text('Forehand'));
    await tester.pumpAndSettle();
    expect(container.read(sessionFormProvider).strokes, isEmpty);
    expect(tester.widget<FilledButton>(_generateButton()).onPressed, isNull);
  });

  testWidgets('selections update the form state', (tester) async {
    final container = await _pump(
      tester,
      weather: () async => Fixtures.sunnyWeather,
    );

    await _scrollToAndTap(tester, 'Advanced');
    await _scrollToAndTap(tester, 'Serve');
    await _scrollToAndTap(tester, 'Physical');
    await _scrollToAndTap(tester, 'With a coach');

    final params = container.read(sessionFormProvider);
    expect(params.level, SkillLevel.advanced);
    expect(params.strokes, {Stroke.serve});
    expect(params.goal, TacticalGoal.physical);
    expect(params.players, PlayerCount.withCoach);
    expect(params.isValid, isTrue);
  });

  testWidgets('slider snaps the duration to 15-minute steps', (tester) async {
    final container = await _pump(
      tester,
      weather: () async => Fixtures.sunnyWeather,
    );

    final slider = find.byType(Slider);
    await tester.drag(slider, const Offset(400, 0));
    await tester.pumpAndSettle();

    expect(container.read(sessionFormProvider).durationMinutes, 120);
    expect(find.text('120 min'), findsWidgets);
  });

  testWidgets('shows the ideal-weather hint', (tester) async {
    await _pump(tester, weather: () async => Fixtures.sunnyWeather);
    expect(find.textContaining('outdoor session ideal'), findsOneWidget);
  });

  testWidgets('offers the indoor option when rain is expected', (tester) async {
    final container = await _pump(
      tester,
      weather: () async => Fixtures.sunnyWeather.copyWith(
        conditionId: 500,
        condition: 'Rain',
        description: 'light rain',
      ),
    );
    expect(find.textContaining('indoor session recommended'), findsOneWidget);

    await _scrollToAndTap(tester, 'Indoor only');
    expect(container.read(sessionFormProvider).preferIndoor, isTrue);
  });

  testWidgets('keeps the form usable when the weather fails', (tester) async {
    await _pump(
      tester,
      weather: () async => throw const WeatherFailure.network(),
    );
    expect(find.textContaining('Weather unavailable'), findsOneWidget);
    expect(_generateButton(), findsOneWidget);
  });
}
