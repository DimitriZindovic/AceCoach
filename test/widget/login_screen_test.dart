import 'package:ace_coach/providers/auth_provider.dart';
import 'package:ace_coach/screens/auth/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

Future<void> pumpLoginScreen(WidgetTester tester) async {
  tester.view.physicalSize = const Size(1080, 2400);
  tester.view.devicePixelRatio = 3;
  addTearDown(tester.view.reset);
  await tester.pumpWidget(
    ProviderScope(
      overrides: [firebaseReadyProvider.overrideWithValue(false)],
      child: const MaterialApp(home: LoginScreen()),
    ),
  );
}

void main() {
  testWidgets('shows the email and password fields', (tester) async {
    await pumpLoginScreen(tester);

    expect(find.text('Welcome back'), findsOneWidget);
    expect(find.text('Email'), findsOneWidget);
    expect(find.text('Password'), findsOneWidget);
    expect(find.text('Log in'), findsOneWidget);
    expect(find.textContaining('Google'), findsNothing);
  });

  testWidgets('rejects an empty form', (tester) async {
    await pumpLoginScreen(tester);

    await tester.tap(find.text('Log in'));
    await tester.pump();

    expect(find.text('Enter your email address.'), findsOneWidget);
    expect(find.text('Enter your password.'), findsOneWidget);
  });

  testWidgets('rejects a malformed email', (tester) async {
    await pumpLoginScreen(tester);

    await tester.enterText(find.byType(TextFormField).first, 'not-an-email');
    await tester.pump();

    expect(find.text('Enter a valid email address.'), findsOneWidget);
  });

  testWidgets('toggles password visibility', (tester) async {
    await pumpLoginScreen(tester);

    expect(find.byTooltip('Show password'), findsOneWidget);
    await tester.tap(find.byTooltip('Show password'));
    await tester.pump();
    expect(find.byTooltip('Hide password'), findsOneWidget);
  });

  testWidgets('opens the password reset sheet', (tester) async {
    await pumpLoginScreen(tester);

    await tester.tap(find.text('Forgot password?'));
    await tester.pumpAndSettle();

    expect(find.text('Reset your password'), findsOneWidget);
    expect(find.text('Send reset link'), findsOneWidget);
  });

  testWidgets('reports a missing Firebase configuration on submit', (
    tester,
  ) async {
    await pumpLoginScreen(tester);

    await tester.enterText(find.byType(TextFormField).first, 'a@example.com');
    await tester.enterText(find.byType(TextFormField).last, 'password');
    await tester.tap(find.text('Log in'));
    await tester.pumpAndSettle();

    expect(find.textContaining('Firebase is not configured'), findsOneWidget);
  });
}
