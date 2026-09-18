import 'package:flutter/foundation.dart' show immutable;
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../models/session_params.dart';
import '../models/training_session.dart';
import 'auth_provider.dart';
import 'session_generation_provider.dart';

part 'session_history_provider.g.dart';

@immutable
class ProfileStats {
  const ProfileStats({
    required this.savedCount,
    required this.totalMinutes,
    this.topStroke,
  });

  const ProfileStats.empty() : this(savedCount: 0, totalMinutes: 0);

  final int savedCount;

  final int totalMinutes;

  final Stroke? topStroke;

  String get totalTimeLabel {
    if (totalMinutes == 0) return '0 min';
    final hours = totalMinutes ~/ 60;
    final minutes = totalMinutes % 60;
    if (hours == 0) return '$minutes min';
    if (minutes == 0) return '${hours}h';
    return '${hours}h ${minutes.toString().padLeft(2, '0')}';
  }

  static ProfileStats fromSessions(List<TrainingSession> sessions) {
    final counts = <Stroke, int>{};
    var minutes = 0;
    for (final session in sessions) {
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
      totalMinutes: minutes,
      topStroke: top,
    );
  }
}

@Riverpod(keepAlive: true)
Stream<List<TrainingSession>> sessionHistory(Ref ref) {
  final user = ref.watch(authStateProvider).value;
  if (user == null) return Stream.value(const []);
  return ref.watch(sessionRepositoryProvider).watchHistory(user.uid);
}
