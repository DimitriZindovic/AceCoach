import 'package:ace_coach/constants/app_themes.dart';
import 'package:ace_coach/models/training_session.dart';
import 'package:ace_coach/providers/session_history_provider.dart';
import 'package:ace_coach/screens/history/history_screen.dart';
import 'package:ace_coach/widgets/empty_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/fixtures.dart';

Future<void> _pump(
  WidgetTester tester, {
  required Stream<List<TrainingSession>> Function() history,
}) async {
  await tester.pumpWidget(
    ProviderScope(
      retry: (_, _) => null,
      overrides: [sessionHistoryProvider.overrideWith((ref) => history())],
      child: MaterialApp(theme: AppThemes.light, home: const HistoryScreen()),
    ),
  );
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('shows the empty state with a call to action', (tester) async {
    await _pump(tester, history: () => Stream.value(const []));

    expect(find.byType(EmptyState), findsOneWidget);
    expect(find.text('No sessions yet'), findsOneWidget);
    expect(find.text('Create a session'), findsOneWidget);
  });

  testWidgets('shows a "no match" state when filters hide everything', (
    tester,
  ) async {
    await _pump(tester, history: () => Stream.value([Fixtures.session()]));
    expect(find.text('Aggressive baseline & first serve'), findsOneWidget);

    await tester.enterText(find.byType(TextField), 'backhand volley');
    await tester.pumpAndSettle();

    expect(find.text('No session matches'), findsOneWidget);
    expect(find.text('Clear filters'), findsOneWidget);

    await tester.tap(find.text('Clear filters'));
    await tester.pumpAndSettle();
    expect(find.text('Aggressive baseline & first serve'), findsOneWidget);
  });

  testWidgets('shows an error state with retry', (tester) async {
    await _pump(tester, history: () => Stream.error(Exception('boom')));
    expect(find.text('History unavailable'), findsOneWidget);
    expect(find.text('Retry'), findsOneWidget);
  });
}
