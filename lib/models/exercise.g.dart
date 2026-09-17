// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'exercise.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Exercise _$ExerciseFromJson(Map<String, dynamic> json) => _Exercise(
  title: json['title'] as String,
  description: json['description'] as String,
  estimatedDurationMinutes: (json['estimatedDurationMinutes'] as num).toInt(),
  technicalTip: json['technicalTip'] as String,
  phase:
      $enumDecodeNullable(_$ExercisePhaseEnumMap, json['phase']) ??
      ExercisePhase.main,
  indoorFriendly: json['indoorFriendly'] as bool? ?? true,
);

Map<String, dynamic> _$ExerciseToJson(_Exercise instance) => <String, dynamic>{
  'title': instance.title,
  'description': instance.description,
  'estimatedDurationMinutes': instance.estimatedDurationMinutes,
  'technicalTip': instance.technicalTip,
  'phase': _$ExercisePhaseEnumMap[instance.phase]!,
  'indoorFriendly': instance.indoorFriendly,
};

const _$ExercisePhaseEnumMap = {
  ExercisePhase.warmUp: 'warmUp',
  ExercisePhase.main: 'main',
  ExercisePhase.coolDown: 'coolDown',
};
