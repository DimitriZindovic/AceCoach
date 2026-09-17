import 'package:ace_coach/models/session_params.dart';
import 'package:ace_coach/providers/session_history_provider.dart';
import 'package:flutter/material.dart' show DateTimeRange;
import 'package:flutter_test/flutter_test.dart';

import '../helpers/fixtures.dart';

void main() {
  final sessions = [
    Fixtures.session(id: 'a', createdAt: DateTime(2026, 9, 15)),
    Fixtures.session(
      id: 'b',
      title: 'Serve rhythm ladder',
      createdAt: DateTime(2026, 9, 13),
      level: SkillLevel.advanced,
      strokes: {Stroke.serve},
    ),
    Fixtures.session(
      id: 'c',
      title: 'Net approach & volley hands',
      createdAt: DateTime(2026, 9, 10),
      strokes: {Stroke.volley},
    ),
    Fixtures.session(
      id: 'd',
      title: 'Indoor backhand consistency',
      createdAt: DateTime(2026, 9, 4),
      level: SkillLevel.beginner,
      strokes: {Stroke.backhand},
    ),
  ];

  List<String> ids(HistoryFilter filter) =>
      filter.apply(sessions).map((s) => s.id).toList();

  test('empty filter keeps everything in order', () {
    expect(const HistoryFilter().isActive, isFalse);
    expect(ids(const HistoryFilter()), ['a', 'b', 'c', 'd']);
  });

  test(
    'search matches title, summary and exercise titles, case-insensitive',
    () {
      // Title only.
      expect(ids(const HistoryFilter(query: 'RHYTHM')), ['b']);
      expect(ids(const HistoryFilter(query: 'volley')), ['c']);
      // Every fixture summary mentions the serve.
      expect(ids(const HistoryFilter(query: 'serve')), ['a', 'b', 'c', 'd']);
      // Exercise titles.
      expect(ids(const HistoryFilter(query: 'warm-up')), ['a', 'b', 'c', 'd']);
      expect(ids(const HistoryFilter(query: '  ')), ['a', 'b', 'c', 'd']);
      expect(ids(const HistoryFilter(query: 'no such thing')), isEmpty);
    },
  );

  test('filters by level and stroke', () {
    expect(ids(const HistoryFilter(level: SkillLevel.advanced)), ['b']);
    expect(ids(const HistoryFilter(stroke: Stroke.serve)), ['a', 'b']);
    expect(
      ids(
        const HistoryFilter(
          level: SkillLevel.intermediate,
          stroke: Stroke.serve,
        ),
      ),
      ['a'],
    );
  });

  test('filters by inclusive date range on calendar days', () {
    final filter = HistoryFilter(
      dateRange: DateTimeRange(
        start: DateTime(2026, 9, 10, 23, 59),
        end: DateTime(2026, 9, 13),
      ),
    );
    expect(ids(filter), ['b', 'c']);
  });

  test('copyWith can clear a criterion', () {
    const filter = HistoryFilter(query: 'serve', level: SkillLevel.advanced);
    final cleared = filter.copyWith(level: () => null);
    expect(cleared.level, isNull);
    expect(cleared.query, 'serve');
    expect(cleared.isActive, isTrue);
  });
}
