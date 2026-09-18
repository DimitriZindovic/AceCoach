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

  factory TrainingSession.fromJson(Map<String, dynamic> json) {
    final weather = json['weather'];
    return TrainingSession(
      id: json['id'] as String,
      userId: json['userId'] as String,
      title: json['title'] as String,
      summary: json['summary'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      params: SessionParams.fromJson(json['params'] as Map<String, dynamic>),
      exercises: [
        for (final raw in json['exercises'] as List)
          Exercise.fromJson(raw as Map<String, dynamic>),
      ],
      weather: weather == null
          ? null
          : Weather.fromJson(weather as Map<String, dynamic>),
      weatherUsed: json['weatherUsed'] as bool? ?? false,
      weatherAdvice: json['weatherAdvice'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'userId': userId,
    'title': title,
    'summary': summary,
    'createdAt': createdAt.toIso8601String(),
    'params': params.toJson(),
    'exercises': [for (final exercise in exercises) exercise.toJson()],
    'weather': weather?.toJson(),
    'weatherUsed': weatherUsed,
    'weatherAdvice': weatherAdvice,
  };

  static const double durationTolerance = 0.10;

  int get totalMinutes =>
      exercises.fold(0, (sum, e) => sum + e.estimatedDurationMinutes);

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
