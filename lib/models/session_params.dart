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

enum TacticalGoal {
  baselinePlay,
  netPlay,
  physical,
  mental;

  String get label => switch (this) {
    TacticalGoal.baselinePlay => 'Baseline play',
    TacticalGoal.netPlay => 'Net approach',
    TacticalGoal.physical => 'Physical',
    TacticalGoal.mental => 'Mental',
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
    this.durationMinutes = 60,
    this.level = SkillLevel.intermediate,
    this.strokes = const <Stroke>{},
    this.goal = TacticalGoal.baselinePlay,
    this.players = PlayerCount.withPartner,
    this.preferIndoor = false,
  });

  final int durationMinutes;
  final SkillLevel level;
  final Set<Stroke> strokes;
  final TacticalGoal goal;
  final PlayerCount players;
  final bool preferIndoor;

  factory SessionParams.fromJson(Map<String, dynamic> json) => SessionParams(
    durationMinutes: (json['duration'] as num).toInt(),
    level: SkillLevel.values.byName(json['level'] as String),
    strokes: {
      for (final name in json['strokes'] as List)
        Stroke.values.byName(name as String),
    },
    goal: TacticalGoal.values.byName(json['goal'] as String),
    players: PlayerCount.values.byName(json['players'] as String),
    preferIndoor: json['preferIndoor'] as bool,
  );

  Map<String, dynamic> toJson() => {
    'duration': durationMinutes,
    'level': level.name,
    'strokes': [for (final s in orderedStrokes) s.name],
    'goal': goal.name,
    'players': players.name,
    'preferIndoor': preferIndoor,
  };

  List<Stroke> get orderedStrokes =>
      Stroke.values.where(strokes.contains).toList();

  String get strokesLabel => orderedStrokes.map((s) => s.label).join(', ');
}
