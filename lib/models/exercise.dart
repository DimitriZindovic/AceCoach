import 'package:freezed_annotation/freezed_annotation.dart';

part 'exercise.freezed.dart';
part 'exercise.g.dart';

/// Position of an exercise inside the session.
enum ExercisePhase {
  warmUp,
  main,
  coolDown;

  String get label => switch (this) {
    ExercisePhase.warmUp => 'Warm-up',
    ExercisePhase.main => 'Main',
    ExercisePhase.coolDown => 'Cool-down',
  };
}

/// A single drill produced by the AI.
@freezed
abstract class Exercise with _$Exercise {
  const Exercise._();

  const factory Exercise({
    required String title,
    required String description,
    required int estimatedDurationMinutes,
    required String technicalTip,
    @Default(ExercisePhase.main) ExercisePhase phase,
    @Default(true) bool indoorFriendly,
  }) = _Exercise;

  factory Exercise.fromJson(Map<String, dynamic> json) =>
      _$ExerciseFromJson(json);

  bool get hasTip => technicalTip.trim().isNotEmpty;
}
