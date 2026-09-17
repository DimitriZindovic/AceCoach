import 'package:freezed_annotation/freezed_annotation.dart';

import 'exercise.dart';
import 'session_params.dart';
import 'weather.dart';

part 'training_session.freezed.dart';
part 'training_session.g.dart';

/// A generated (and possibly saved) training plan.
@freezed
abstract class TrainingSession with _$TrainingSession {
  const TrainingSession._();

  const factory TrainingSession({
    required String id,
    required String userId,
    required String title,
    required String summary,
    required DateTime createdAt,
    required SessionParams params,
    required List<Exercise> exercises,
    Weather? weather,
    @Default(false) bool weatherUsed,
    String? weatherAdvice,
    DateTime? completedAt,
  }) = _TrainingSession;

  factory TrainingSession.fromJson(Map<String, dynamic> json) =>
      _$TrainingSessionFromJson(json);

  /// Tolerance between the requested duration and the sum of the drills.
  static const double durationTolerance = 0.10;

  int get totalMinutes =>
      exercises.fold(0, (sum, e) => sum + e.estimatedDurationMinutes);

  bool get isCompleted => completedAt != null;

  /// True when the drills add up to the requested duration, within tolerance.
  bool get hasConsistentDuration => isDurationConsistent(
    requestedMinutes: params.durationMinutes,
    actualMinutes: totalMinutes,
  );

  static bool isDurationConsistent({
    required int requestedMinutes,
    required int actualMinutes,
  }) {
    final tolerance = (requestedMinutes * durationTolerance).ceil();
    return (actualMinutes - requestedMinutes).abs() <= tolerance;
  }

  /// "75 min · Intermediate · Forehand, Serve"
  String get metaLabel =>
      '${params.durationMinutes} min · ${params.level.label} · ${params.strokesLabel}';
}
