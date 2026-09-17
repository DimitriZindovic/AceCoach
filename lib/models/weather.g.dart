// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'weather.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Weather _$WeatherFromJson(Map<String, dynamic> json) => _Weather(
  temperatureCelsius: (json['temperatureCelsius'] as num).toDouble(),
  feelsLikeCelsius: (json['feelsLikeCelsius'] as num).toDouble(),
  humidityPercent: (json['humidityPercent'] as num).toInt(),
  windSpeedMs: (json['windSpeedMs'] as num).toDouble(),
  conditionId: (json['conditionId'] as num).toInt(),
  condition: json['condition'] as String,
  description: json['description'] as String,
  iconCode: json['iconCode'] as String,
  cityName: json['cityName'] as String,
  fetchedAt: DateTime.parse(json['fetchedAt'] as String),
  source:
      $enumDecodeNullable(_$WeatherSourceEnumMap, json['source']) ??
      WeatherSource.device,
);

Map<String, dynamic> _$WeatherToJson(_Weather instance) => <String, dynamic>{
  'temperatureCelsius': instance.temperatureCelsius,
  'feelsLikeCelsius': instance.feelsLikeCelsius,
  'humidityPercent': instance.humidityPercent,
  'windSpeedMs': instance.windSpeedMs,
  'conditionId': instance.conditionId,
  'condition': instance.condition,
  'description': instance.description,
  'iconCode': instance.iconCode,
  'cityName': instance.cityName,
  'fetchedAt': instance.fetchedAt.toIso8601String(),
  'source': _$WeatherSourceEnumMap[instance.source]!,
};

const _$WeatherSourceEnumMap = {
  WeatherSource.device: 'device',
  WeatherSource.city: 'city',
};
