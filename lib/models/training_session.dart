import 'exercise.dart';
import 'session_params.dart';
import 'weather.dart';

class TrainingSession {
  const TrainingSession({
    required this.id,
    required this.userId,
    required this.title,
    required this.summary,
    required this.createdAt,
    required this.params,
    required this.exercises,
    this.weather,
    this.weatherUsed = false,
    this.weatherAdvice,
    this.completedAt,
  });

  final String id;
  final String userId;
  final String title;
  final String summary;
  final DateTime createdAt;
  final SessionParams params;
  final List<Exercise> exercises;
  final Weather? weather;
  final bool weatherUsed;
  final String? weatherAdvice;
  final DateTime? completedAt;

  static const double durationTolerance = 0.10;

  int get totalMinutes =>
      exercises.fold(0, (sum, e) => sum + e.estimatedDurationMinutes);

  bool get isCompleted => completedAt != null;

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

  String get metaLabel =>
      '${params.durationMinutes} min · ${params.level.label} · ${params.strokesLabel}';
}
