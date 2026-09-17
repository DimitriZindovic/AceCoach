// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'training_session.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TrainingSession _$TrainingSessionFromJson(Map<String, dynamic> json) =>
    _TrainingSession(
      id: json['id'] as String,
      userId: json['userId'] as String,
      title: json['title'] as String,
      summary: json['summary'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      params: SessionParams.fromJson(json['params'] as Map<String, dynamic>),
      exercises: (json['exercises'] as List<dynamic>)
          .map((e) => Exercise.fromJson(e as Map<String, dynamic>))
          .toList(),
      weather: json['weather'] == null
          ? null
          : Weather.fromJson(json['weather'] as Map<String, dynamic>),
      weatherUsed: json['weatherUsed'] as bool? ?? false,
      weatherAdvice: json['weatherAdvice'] as String?,
      completedAt: json['completedAt'] == null
          ? null
          : DateTime.parse(json['completedAt'] as String),
    );

Map<String, dynamic> _$TrainingSessionToJson(_TrainingSession instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'title': instance.title,
      'summary': instance.summary,
      'createdAt': instance.createdAt.toIso8601String(),
      'params': instance.params,
      'exercises': instance.exercises,
      'weather': instance.weather,
      'weatherUsed': instance.weatherUsed,
      'weatherAdvice': instance.weatherAdvice,
      'completedAt': instance.completedAt?.toIso8601String(),
    };
