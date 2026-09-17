import 'package:freezed_annotation/freezed_annotation.dart';

part 'session_params.freezed.dart';
part 'session_params.g.dart';

/// Player level, drives the intensity and the vocabulary of the plan.
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

/// Strokes the player wants to work on. Multi-select.
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

/// Tactical theme of the session.
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

/// Who is on court, which changes the kind of drills that are possible.
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

/// Everything the user chooses before a session is generated.
@freezed
abstract class SessionParams with _$SessionParams {
  const SessionParams._();

  const factory SessionParams({
    @Default(SessionParams.defaultDuration) int durationMinutes,
    @Default(SkillLevel.intermediate) SkillLevel level,
    @Default(<Stroke>{}) Set<Stroke> strokes,
    @Default(TacticalGoal.baselinePlay) TacticalGoal goal,
    @Default(PlayerCount.withPartner) PlayerCount players,
    @Default(false) bool preferIndoor,
  }) = _SessionParams;

  factory SessionParams.fromJson(Map<String, dynamic> json) =>
      _$SessionParamsFromJson(json);

  static const int minDuration = 30;
  static const int maxDuration = 120;
  static const int durationStep = 15;
  static const int defaultDuration = 60;

  /// Number of slider divisions between [minDuration] and [maxDuration].
  static int get durationDivisions =>
      (maxDuration - minDuration) ~/ durationStep;

  /// Generation is only allowed once at least one stroke is selected.
  bool get isValid => strokes.isNotEmpty && isDurationValid(durationMinutes);

  /// Strokes in enum order, for stable display and prompts.
  List<Stroke> get orderedStrokes =>
      Stroke.values.where(strokes.contains).toList();

  String get strokesLabel => orderedStrokes.map((s) => s.label).join(', ');

  /// A duration is valid when it sits on the 15-minute grid inside the range.
  static bool isDurationValid(int minutes) =>
      minutes >= minDuration &&
      minutes <= maxDuration &&
      (minutes - minDuration) % durationStep == 0;

  /// Snaps any value to the closest valid duration.
  static int snapDuration(num minutes) {
    final steps = ((minutes - minDuration) / durationStep).round();
    final snapped = minDuration + steps * durationStep;
    return snapped.clamp(minDuration, maxDuration);
  }
}
