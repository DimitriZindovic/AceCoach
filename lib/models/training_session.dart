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
  final DateTime? completedAt;

  static const double durationTolerance = 0.10;

  int get totalMinutes =>
      exercises.fold(0, (sum, e) => sum + e.estimatedDurationMinutes);

  bool get isCompleted => completedAt != null;
}
