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

class Exercise {
  const Exercise({
    required this.title,
    required this.description,
    required this.estimatedDurationMinutes,
    required this.technicalTip,
    this.phase = ExercisePhase.main,
    this.indoorFriendly = true,
  });

  final String title;
  final String description;
  final int estimatedDurationMinutes;
  final String technicalTip;
  final ExercisePhase phase;
  final bool indoorFriendly;

  bool get hasTip => technicalTip.trim().isNotEmpty;

  factory Exercise.fromJson(Map<String, dynamic> json) => Exercise(
    title: json['title'] as String,
    description: json['description'] as String,
    estimatedDurationMinutes: (json['minutes'] as num).toInt(),
    technicalTip: json['tip'] as String,
    phase: ExercisePhase.values.byName(json['phase'] as String),
    indoorFriendly: json['indoorFriendly'] as bool,
  );

  Map<String, dynamic> toJson() => {
    'title': title,
    'description': description,
    'minutes': estimatedDurationMinutes,
    'tip': technicalTip,
    'phase': phase.name,
    'indoorFriendly': indoorFriendly,
  };
}
