// Explicit default arguments document the contract verified on the mock.
// ignore_for_file: avoid_redundant_argument_values

import 'package:ace_coach/models/exercise.dart';
import 'package:ace_coach/models/failures.dart';
import 'package:ace_coach/models/session_params.dart';
import 'package:ace_coach/repositories/session_repository.dart';
import 'package:ace_coach/services/ai_service.dart';
import 'package:ace_coach/services/local_database_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../helpers/fixtures.dart';

class _MockAiService extends Mock implements AiService {}

class _MockDatabase extends Mock implements LocalDatabaseService {}

void main() {
  late _MockAiService ai;
  late _MockDatabase database;
  late SessionRepository repository;

  const params = SessionParams(durationMinutes: 60, strokes: {Stroke.forehand});

  AiSessionDraft draft(List<int> minutes) => AiSessionDraft(
    title: 'Plan',
    summary: 'Summary',
    exercises: [
      for (final m in minutes)
        Exercise(
          title: 'Drill $m',
          description: 'Do it',
          estimatedDurationMinutes: m,
          technicalTip: '',
        ),
    ],
  );

  setUpAll(() {
    registerFallbackValue(params);
    registerFallbackValue(Fixtures.session());
  });

  setUp(() {
    ai = _MockAiService();
    database = _MockDatabase();
    repository = SessionRepository(
      ai,
      database,
      now: () => DateTime(2026, 9, 16),
    );
  });

  test('wraps a consistent draft into a session with identity', () async {
    when(
      () => ai.generateSession(
        any(),
        weather: any(named: 'weather'),
        previousTitle: any(named: 'previousTitle'),
        strictDuration: any(named: 'strictDuration'),
      ),
    ).thenAnswer((_) async => draft([10, 40, 10]));

    final session = await repository.generate(
      params: params,
      userId: 'u1',
      weather: Fixtures.sunnyWeather,
    );

    expect(session.id, isNotEmpty);
    expect(session.userId, 'u1');
    expect(session.createdAt, DateTime(2026, 9, 16));
    expect(session.weatherUsed, isTrue);
    expect(session.totalMinutes, 60);
    verify(
      () => ai.generateSession(
        params,
        weather: Fixtures.sunnyWeather,
        previousTitle: null,
        strictDuration: false,
      ),
    ).called(1);
  });

  test(
    'retries once with strictDuration when the drills do not add up',
    () async {
      var calls = 0;
      when(
        () => ai.generateSession(
          any(),
          weather: any(named: 'weather'),
          previousTitle: any(named: 'previousTitle'),
          strictDuration: any(named: 'strictDuration'),
        ),
      ).thenAnswer(
        (_) async => ++calls == 1 ? draft([10, 10]) : draft([20, 40]),
      );

      final session = await repository.generate(params: params, userId: 'u1');

      expect(calls, 2);
      expect(session.totalMinutes, 60);
      expect(session.weatherUsed, isFalse);
      verify(
        () => ai.generateSession(
          params,
          weather: null,
          previousTitle: null,
          strictDuration: true,
        ),
      ).called(1);
    },
  );

  test('gives up with a malformed-response failure after the retry', () async {
    when(
      () => ai.generateSession(
        any(),
        weather: any(named: 'weather'),
        previousTitle: any(named: 'previousTitle'),
        strictDuration: any(named: 'strictDuration'),
      ),
    ).thenAnswer((_) async => draft([5, 5]));

    expect(
      () => repository.generate(params: params, userId: 'u1'),
      throwsA(
        isA<AiFailure>().having(
          (f) => f.kind,
          'kind',
          AiFailureKind.malformedResponse,
        ),
      ),
    );
  });

  test('delegates persistence to the database', () async {
    when(() => database.insertSession(any())).thenAnswer((_) async {});
    when(() => database.deleteSession(any())).thenAnswer((_) async {});
    when(() => database.setCompleted(any(), any())).thenAnswer((_) async {});

    final session = Fixtures.session();
    await repository.save(session);
    await repository.delete(session.id);
    await repository.setCompleted(session.id, completed: true);

    verify(() => database.insertSession(session)).called(1);
    verify(() => database.deleteSession(session.id)).called(1);
    verify(() => database.setCompleted(session.id, DateTime(2026, 9, 16)))
        .called(1);
  });
}
