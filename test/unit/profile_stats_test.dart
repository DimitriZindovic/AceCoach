import 'package:ace_coach/models/session_params.dart';
import 'package:ace_coach/providers/session_history_provider.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/fixtures.dart';

void main() {
  test('empty history yields zeros', () {
    final stats = ProfileStats.fromSessions(const []);
    expect(stats.savedCount, 0);
    expect(stats.completedCount, 0);
    expect(stats.totalMinutes, 0);
    expect(stats.topStroke, isNull);
    expect(stats.totalTimeLabel, '0 min');
  });

  test('only completed sessions count toward time and top stroke', () {
    final done = DateTime(2026, 9, 16);
    final stats = ProfileStats.fromSessions([
      Fixtures.session(
        id: 'a',
        durationMinutes: 75,
        completedAt: done,
        strokes: {Stroke.forehand, Stroke.serve},
      ),
      Fixtures.session(
        id: 'b',
        durationMinutes: 45,
        completedAt: done,
        strokes: {Stroke.serve},
      ),
      Fixtures.session(
        id: 'c',
        durationMinutes: 90,
        strokes: {Stroke.backhand},
      ),
    ]);

    expect(stats.savedCount, 3);
    expect(stats.completedCount, 2);
    expect(stats.totalMinutes, 120);
    expect(stats.topStroke, Stroke.serve);
    expect(stats.totalTimeLabel, '2h');
  });

  test('ties on the top stroke resolve in enum order', () {
    final done = DateTime(2026, 9, 16);
    final stats = ProfileStats.fromSessions([
      Fixtures.session(
        id: 'a',
        completedAt: done,
        strokes: {Stroke.smash, Stroke.volley},
      ),
    ]);
    expect(stats.topStroke, Stroke.volley);
  });

  test('formats the cumulative time', () {
    const base = ProfileStats(
      savedCount: 0,
      completedCount: 0,
      totalMinutes: 45,
    );
    expect(base.totalTimeLabel, '45 min');
    expect(
      const ProfileStats(
        savedCount: 0,
        completedCount: 0,
        totalMinutes: 65,
      ).totalTimeLabel,
      '1h 05',
    );
    expect(
      const ProfileStats(
        savedCount: 0,
        completedCount: 0,
        totalMinutes: 1290,
      ).totalTimeLabel,
      '21h 30',
    );
  });
}
