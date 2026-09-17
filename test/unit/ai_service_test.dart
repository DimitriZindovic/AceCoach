import 'package:ace_coach/models/exercise.dart';
import 'package:ace_coach/models/failures.dart';
import 'package:ace_coach/models/session_params.dart';
import 'package:ace_coach/services/ai_service.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/fixtures.dart';

void main() {
  group('AiService.parseDraft', () {
    test('parses a structured response into a draft', () {
      final draft = AiService.parseDraft(
        Fixtures.aiResponseJson,
        requestedMinutes: 75,
      );

      expect(draft.title, 'Aggressive baseline & first serve');
      expect(draft.summary, startsWith('Build depth'));
      expect(draft.weatherAdvice, contains('hydrate'));
      expect(draft.exercises, hasLength(5));
      expect(draft.totalMinutes, 75);

      final first = draft.exercises.first;
      expect(first.title, 'Dynamic warm-up');
      expect(first.estimatedDurationMinutes, 10);
      expect(first.phase, ExercisePhase.warmUp);
      expect(first.technicalTip, 'Keep the wrist loose.');
      expect(draft.exercises[3].indoorFriendly, isFalse);
      expect(draft.exercises.last.phase, ExercisePhase.coolDown);
    });

    test('defaults unknown phases and missing flags', () {
      final draft = AiService.parseDraft(
        '{"title":"T","summary":"S","exercises":[{"title":"A","description":"B",'
        '"estimatedDurationMinutes":30,"technicalTip":"C","phase":"sprint"}]}',
        requestedMinutes: 30,
      );
      expect(draft.exercises.single.phase, ExercisePhase.main);
      expect(draft.exercises.single.indoorFriendly, isTrue);
      expect(draft.weatherAdvice, isNull);
    });

    test('rejects text that is not JSON', () {
      expect(
        () => AiService.parseDraft(
          'Sure! Here is your plan…',
          requestedMinutes: 60,
        ),
        throwsA(
          isA<AiFailure>().having(
            (f) => f.kind,
            'kind',
            AiFailureKind.malformedResponse,
          ),
        ),
      );
    });

    test('rejects a payload missing required fields', () {
      expect(
        () => AiService.parseDraft(
          '{"title":"Only a title"}',
          requestedMinutes: 60,
        ),
        throwsA(isA<AiFailure>()),
      );
      expect(
        () => AiService.parseDraft('[1,2,3]', requestedMinutes: 60),
        throwsA(isA<AiFailure>()),
      );
      expect(
        () => AiService.parseDraft(
          '{"title":"T","summary":"S","exercises":[]}',
          requestedMinutes: 60,
        ),
        throwsA(isA<AiFailure>()),
      );
    });

    test('rejects an exercise with an invalid duration or wrong types', () {
      expect(
        () => AiService.parseDraft(
          '{"title":"T","summary":"S","exercises":[{"title":"A",'
          '"description":"B","estimatedDurationMinutes":-5,"technicalTip":"C"}]}',
          requestedMinutes: 60,
        ),
        throwsA(isA<AiFailure>()),
      );
      expect(
        () => AiService.parseDraft(
          '{"title":"T","summary":"S","exercises":[{"title":42,'
          '"description":"B","estimatedDurationMinutes":10,"technicalTip":"C"}]}',
          requestedMinutes: 60,
        ),
        throwsA(isA<AiFailure>()),
      );
    });
  });

  group('AiService.buildPrompt', () {
    const params = SessionParams(
      durationMinutes: 45,
      level: SkillLevel.advanced,
      strokes: {Stroke.serve, Stroke.volley},
      goal: TacticalGoal.netPlay,
      players: PlayerCount.withCoach,
    );

    test('includes every parameter and the duration constraint', () {
      final prompt = AiService.buildPrompt(params);
      expect(prompt, contains('exactly 45 minutes'));
      expect(prompt, contains('Advanced'));
      expect(prompt, contains('Serve, Volley'));
      expect(prompt, contains('Net approach'));
      expect(prompt, contains('With a coach'));
      expect(prompt, contains('Weather: unknown'));
    });

    test('adds weather, indoor and regeneration instructions', () {
      final prompt = AiService.buildPrompt(
        params.copyWith(preferIndoor: true),
        weather: Fixtures.sunnyWeather.copyWith(conditionId: 501),
        previousTitle: 'Old plan',
        strictDuration: true,
      );
      expect(prompt, contains('Weather right now'));
      expect(prompt, contains('favour drills that work on an indoor court'));
      expect(prompt, contains('MUST be fully playable indoors'));
      expect(prompt, contains('"Old plan"'));
      expect(prompt, contains('did not add up to 45 minutes'));
    });
  });
}
