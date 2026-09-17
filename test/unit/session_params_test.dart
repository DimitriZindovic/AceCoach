import 'package:ace_coach/models/session_params.dart';
import 'package:ace_coach/models/training_session.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/fixtures.dart';

void main() {
  group('SessionParams duration', () {
    test('accepts only the 15-minute grid between 30 and 120', () {
      expect(SessionParams.isDurationValid(30), isTrue);
      expect(SessionParams.isDurationValid(45), isTrue);
      expect(SessionParams.isDurationValid(120), isTrue);
      expect(SessionParams.isDurationValid(15), isFalse);
      expect(SessionParams.isDurationValid(50), isFalse);
      expect(SessionParams.isDurationValid(135), isFalse);
    });

    test('snaps arbitrary values to the closest step inside the range', () {
      expect(SessionParams.snapDuration(52), 45);
      expect(SessionParams.snapDuration(53), 60);
      expect(SessionParams.snapDuration(0), 30);
      expect(SessionParams.snapDuration(999), 120);
      expect(SessionParams.durationDivisions, 6);
    });

    test('is valid only once a stroke is selected', () {
      const empty = SessionParams();
      expect(empty.isValid, isFalse);
      expect(empty.copyWith(strokes: {Stroke.backhand}).isValid, isTrue);
      expect(
        empty.copyWith(strokes: {Stroke.backhand}, durationMinutes: 50).isValid,
        isFalse,
      );
    });

    test('orders strokes and labels them', () {
      const params = SessionParams(strokes: {Stroke.smash, Stroke.forehand});
      expect(params.orderedStrokes, [Stroke.forehand, Stroke.smash]);
      expect(params.strokesLabel, 'Forehand, Smash');
    });
  });

  group('TrainingSession duration consistency', () {
    test('tolerates a 10 % difference, rounded up', () {
      expect(
        TrainingSession.isDurationConsistent(
          requestedMinutes: 75,
          actualMinutes: 75,
        ),
        isTrue,
      );
      expect(
        TrainingSession.isDurationConsistent(
          requestedMinutes: 75,
          actualMinutes: 83,
        ),
        isTrue,
      );
      expect(
        TrainingSession.isDurationConsistent(
          requestedMinutes: 75,
          actualMinutes: 84,
        ),
        isFalse,
      );
      expect(
        TrainingSession.isDurationConsistent(
          requestedMinutes: 30,
          actualMinutes: 26,
        ),
        isFalse,
      );
    });

    test('sums the exercises and exposes the meta label', () {
      final session = Fixtures.session();
      expect(session.totalMinutes, 30);
      expect(session.hasConsistentDuration, isFalse);
      expect(session.metaLabel, '75 min · Intermediate · Forehand, Serve');
      expect(session.isCompleted, isFalse);
    });
  });
}
