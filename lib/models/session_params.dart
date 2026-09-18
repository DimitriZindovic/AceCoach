enum SkillLevel {
  beginner,
  intermediate,
  advanced;

  String get label => switch (this) {
    SkillLevel.beginner => 'Beginner',
    SkillLevel.intermediate => 'Intermediate',
    SkillLevel.advanced => 'Advanced',
  };
}

enum Stroke {
  forehand,
  backhand,
  serve,
  volley,
  smash;

  String get label => switch (this) {
    Stroke.forehand => 'Forehand',
    Stroke.backhand => 'Backhand',
    Stroke.serve => 'Serve',
    Stroke.volley => 'Volley',
    Stroke.smash => 'Smash',
  };
}

enum PlayerCount {
  alone,
  withPartner,
  withCoach;

  String get label => switch (this) {
    PlayerCount.alone => 'Alone',
    PlayerCount.withPartner => 'With a partner',
    PlayerCount.withCoach => 'With a coach',
  };
}

class SessionParams {
  const SessionParams({
    this.durationMinutes = defaultDuration,
    this.level = SkillLevel.intermediate,
    this.strokes = const <Stroke>{},
    this.players = PlayerCount.withPartner,
    this.preferIndoor = false,
  });

  final int durationMinutes;
  final SkillLevel level;
  final Set<Stroke> strokes;
  final PlayerCount players;
  final bool preferIndoor;

  static const int minDuration = 30;
  static const int maxDuration = 120;
  static const int durationStep = 15;
  static const int defaultDuration = 60;

  SessionParams copyWith({
    int? durationMinutes,
    SkillLevel? level,
    Set<Stroke>? strokes,
    PlayerCount? players,
    bool? preferIndoor,
  }) {
    return SessionParams(
      durationMinutes: durationMinutes ?? this.durationMinutes,
      level: level ?? this.level,
      strokes: strokes ?? this.strokes,
      players: players ?? this.players,
      preferIndoor: preferIndoor ?? this.preferIndoor,
    );
  }

  static int get durationDivisions =>
      (maxDuration - minDuration) ~/ durationStep;

  bool get isValid => strokes.isNotEmpty && isDurationValid(durationMinutes);

  static bool isDurationValid(int minutes) =>
      minutes >= minDuration &&
      minutes <= maxDuration &&
      (minutes - minDuration) % durationStep == 0;

  static int snapDuration(num minutes) {
    final steps = ((minutes - minDuration) / durationStep).round();
    final snapped = minDuration + steps * durationStep;
    return snapped.clamp(minDuration, maxDuration);
  }

  factory SessionParams.fromJson(Map<String, dynamic> json) => SessionParams(
    durationMinutes: (json['duration'] as num).toInt(),
    level: SkillLevel.values.byName(json['level'] as String),
    strokes: {
      for (final name in json['strokes'] as List)
        Stroke.values.byName(name as String),
    },
    players: PlayerCount.values.byName(json['players'] as String),
    preferIndoor: json['preferIndoor'] as bool,
  );

  Map<String, dynamic> toJson() => {
    'duration': durationMinutes,
    'level': level.name,
    'strokes': [for (final s in orderedStrokes) s.name],
    'players': players.name,
    'preferIndoor': preferIndoor,
  };

  List<Stroke> get orderedStrokes =>
      Stroke.values.where(strokes.contains).toList();

  String get strokesLabel => orderedStrokes.map((s) => s.label).join(', ');
}
