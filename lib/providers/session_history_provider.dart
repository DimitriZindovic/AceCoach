import 'package:flutter/foundation.dart' show immutable;
import 'package:flutter/material.dart' show DateTimeRange, DateUtils;
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../models/session_params.dart';
import '../models/training_session.dart';
import 'auth_provider.dart';
import 'session_generation_provider.dart';

part 'session_history_provider.g.dart';

/// Search and filter criteria for the history screen.
@immutable
class HistoryFilter {
  const HistoryFilter({
    this.query = '',
    this.level,
    this.stroke,
    this.dateRange,
  });

  final String query;
  final SkillLevel? level;
  final Stroke? stroke;
  final DateTimeRange? dateRange;

  bool get isActive =>
      query.trim().isNotEmpty ||
      level != null ||
      stroke != null ||
      dateRange != null;

  HistoryFilter copyWith({
    String? query,
    SkillLevel? Function()? level,
    Stroke? Function()? stroke,
    DateTimeRange? Function()? dateRange,
  }) {
    return HistoryFilter(
      query: query ?? this.query,
      level: level == null ? this.level : level(),
      stroke: stroke == null ? this.stroke : stroke(),
      dateRange: dateRange == null ? this.dateRange : dateRange(),
    );
  }

  /// Applies the filter. Pure, so it is unit-tested without a database.
  List<TrainingSession> apply(List<TrainingSession> sessions) {
    final needle = query.trim().toLowerCase();
    return sessions.where((session) {
      if (level != null && session.params.level != level) return false;
      if (stroke != null && !session.params.strokes.contains(stroke)) {
        return false;
      }
      if (dateRange case final range?) {
        final day = DateUtils.dateOnly(session.createdAt);
        if (day.isBefore(DateUtils.dateOnly(range.start)) ||
            day.isAfter(DateUtils.dateOnly(range.end))) {
          return false;
        }
      }
      if (needle.isEmpty) return true;
      return session.title.toLowerCase().contains(needle) ||
          session.summary.toLowerCase().contains(needle) ||
          session.exercises.any((e) => e.title.toLowerCase().contains(needle));
    }).toList();
  }
}

/// Aggregates shown on the profile and home screens.
@immutable
class ProfileStats {
  const ProfileStats({
    required this.savedCount,
    required this.completedCount,
    required this.totalMinutes,
    this.topStroke,
  });

  const ProfileStats.empty()
    : this(savedCount: 0, completedCount: 0, totalMinutes: 0);

  final int savedCount;
  final int completedCount;

  /// Cumulative training time over *completed* sessions, in minutes.
  final int totalMinutes;

  /// Stroke appearing most often in completed sessions; ties resolve in
  /// enum order.
  final Stroke? topStroke;

  /// "21h 30" style label; "0 min" when nothing is completed yet.
  String get totalTimeLabel {
    if (totalMinutes == 0) return '0 min';
    final hours = totalMinutes ~/ 60;
    final minutes = totalMinutes % 60;
    if (hours == 0) return '$minutes min';
    if (minutes == 0) return '${hours}h';
    return '${hours}h ${minutes.toString().padLeft(2, '0')}';
  }

  static ProfileStats fromSessions(List<TrainingSession> sessions) {
    final completed = sessions.where((s) => s.isCompleted).toList();
    final counts = <Stroke, int>{};
    var minutes = 0;
    for (final session in completed) {
      minutes += session.params.durationMinutes;
      for (final stroke in session.params.strokes) {
        counts.update(stroke, (n) => n + 1, ifAbsent: () => 1);
      }
    }
    Stroke? top;
    var best = 0;
    for (final stroke in Stroke.values) {
      final n = counts[stroke] ?? 0;
      if (n > best) {
        best = n;
        top = stroke;
      }
    }
    return ProfileStats(
      savedCount: sessions.length,
      completedCount: completed.length,
      totalMinutes: minutes,
      topStroke: top,
    );
  }
}

/// All saved sessions of the signed-in user, newest first.
@Riverpod(keepAlive: true)
Stream<List<TrainingSession>> sessionHistory(Ref ref) {
  final user = ref.watch(currentUserProvider);
  if (user == null) return Stream.value(const []);
  return ref.watch(sessionRepositoryProvider).watchHistory(user.uid);
}

/// One saved session by id, read from the local database.
@riverpod
Future<TrainingSession?> savedSession(Ref ref, String sessionId) {
  // Watching the history keeps the detail screen in sync with edits.
  final history = ref.watch(sessionHistoryProvider).value;
  final fromHistory = history?.where((s) => s.id == sessionId).firstOrNull;
  if (fromHistory != null) return Future.value(fromHistory);
  return ref.watch(sessionRepositoryProvider).find(sessionId);
}

@Riverpod(keepAlive: true)
class HistoryFilterNotifier extends _$HistoryFilterNotifier {
  @override
  HistoryFilter build() => const HistoryFilter();

  void setQuery(String query) => state = state.copyWith(query: query);

  void setLevel(SkillLevel? level) =>
      state = state.copyWith(level: () => level);

  void setStroke(Stroke? stroke) =>
      state = state.copyWith(stroke: () => stroke);

  void setDateRange(DateTimeRange? range) =>
      state = state.copyWith(dateRange: () => range);

  void clear() => state = const HistoryFilter();
}

/// History after search and filters.
@riverpod
AsyncValue<List<TrainingSession>> filteredHistory(Ref ref) {
  final filter = ref.watch(historyFilterProvider);
  return ref.watch(sessionHistoryProvider).whenData(filter.apply);
}

/// Stats derived from the whole history.
@riverpod
ProfileStats profileStats(Ref ref) {
  final sessions = ref.watch(sessionHistoryProvider).value ?? const [];
  return ProfileStats.fromSessions(sessions);
}

/// Actions on saved sessions.
@riverpod
class HistoryActions extends _$HistoryActions {
  @override
  AsyncValue<void> build() => const AsyncData(null);

  Future<void> delete(String id) =>
      _run(() => ref.read(sessionRepositoryProvider).delete(id));

  Future<void> setCompleted(String id, {required bool completed}) => _run(
    () => ref
        .read(sessionRepositoryProvider)
        .setCompleted(id, completed: completed),
  );

  Future<void> _run(Future<void> Function() action) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(action);
  }
}
