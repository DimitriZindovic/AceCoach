// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'session_params.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SessionParams _$SessionParamsFromJson(Map<String, dynamic> json) =>
    _SessionParams(
      durationMinutes:
          (json['durationMinutes'] as num?)?.toInt() ??
          SessionParams.defaultDuration,
      level:
          $enumDecodeNullable(_$SkillLevelEnumMap, json['level']) ??
          SkillLevel.intermediate,
      strokes:
          (json['strokes'] as List<dynamic>?)
              ?.map((e) => $enumDecode(_$StrokeEnumMap, e))
              .toSet() ??
          const <Stroke>{},
      goal:
          $enumDecodeNullable(_$TacticalGoalEnumMap, json['goal']) ??
          TacticalGoal.baselinePlay,
      players:
          $enumDecodeNullable(_$PlayerCountEnumMap, json['players']) ??
          PlayerCount.withPartner,
      preferIndoor: json['preferIndoor'] as bool? ?? false,
    );

Map<String, dynamic> _$SessionParamsToJson(_SessionParams instance) =>
    <String, dynamic>{
      'durationMinutes': instance.durationMinutes,
      'level': _$SkillLevelEnumMap[instance.level]!,
      'strokes': instance.strokes.map((e) => _$StrokeEnumMap[e]!).toList(),
      'goal': _$TacticalGoalEnumMap[instance.goal]!,
      'players': _$PlayerCountEnumMap[instance.players]!,
      'preferIndoor': instance.preferIndoor,
    };

const _$SkillLevelEnumMap = {
  SkillLevel.beginner: 'beginner',
  SkillLevel.intermediate: 'intermediate',
  SkillLevel.advanced: 'advanced',
};

const _$StrokeEnumMap = {
  Stroke.forehand: 'forehand',
  Stroke.backhand: 'backhand',
  Stroke.serve: 'serve',
  Stroke.volley: 'volley',
  Stroke.smash: 'smash',
};

const _$TacticalGoalEnumMap = {
  TacticalGoal.baselinePlay: 'baselinePlay',
  TacticalGoal.netPlay: 'netPlay',
  TacticalGoal.physical: 'physical',
  TacticalGoal.mental: 'mental',
};

const _$PlayerCountEnumMap = {
  PlayerCount.alone: 'alone',
  PlayerCount.withPartner: 'withPartner',
  PlayerCount.withCoach: 'withCoach',
};
