import 'package:ace_coach/constants/app_themes.dart';
import 'package:ace_coach/widgets/exercise_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/fixtures.dart';

Widget _wrap(Widget child) => MaterialApp(
  theme: AppThemes.light,
  home: Scaffold(
    body: Padding(padding: const EdgeInsets.all(16), child: child),
  ),
);

void main() {
  testWidgets('shows index, title, duration, description and tip', (
    tester,
  ) async {
    await tester.pumpWidget(
      _wrap(const ExerciseCard(index: 1, exercise: Fixtures.warmUp)),
    );

    expect(find.text('1'), findsOneWidget);
    expect(find.text('Dynamic warm-up'), findsOneWidget);
    expect(find.text('10 min'), findsOneWidget);
    expect(find.textContaining('Mini-tennis'), findsOneWidget);
    expect(find.textContaining('Keep the wrist loose'), findsOneWidget);
    expect(find.byIcon(Icons.lightbulb_outline_rounded), findsOneWidget);
  });

  testWidgets('hides the tip box when the tip is empty', (tester) async {
    await tester.pumpWidget(
      _wrap(const ExerciseCard(index: 2, exercise: Fixtures.forehandDepth)),
    );

    expect(find.text('2'), findsOneWidget);
    expect(find.text('20 min'), findsOneWidget);
    expect(find.byIcon(Icons.lightbulb_outline_rounded), findsNothing);
  });

  testWidgets('exposes an accessible label', (tester) async {
    await tester.pumpWidget(
      _wrap(const ExerciseCard(index: 1, exercise: Fixtures.warmUp)),
    );
    expect(
      find.bySemanticsLabel(RegExp(r'Exercise 1, Dynamic warm-up, 10 minutes')),
      findsOneWidget,
    );
  });
}
