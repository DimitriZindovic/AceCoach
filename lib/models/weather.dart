import 'package:freezed_annotation/freezed_annotation.dart';

part 'weather.freezed.dart';
part 'weather.g.dart';

/// How suitable the conditions are for an outdoor session.
enum WeatherVerdict {
  ideal,
  caution,
  indoor;

  String get label => switch (this) {
    WeatherVerdict.ideal => 'Ideal',
    WeatherVerdict.caution => 'Caution',
    WeatherVerdict.indoor => 'Indoor',
  };
}

/// Where the coordinates used for the lookup came from.
enum WeatherSource { device, city }

/// Current weather snapshot, flattened from the OpenWeatherMap payload.
@freezed
abstract class Weather with _$Weather {
  const Weather._();

  const factory Weather({
    required double temperatureCelsius,
    required double feelsLikeCelsius,
    required int humidityPercent,
    required double windSpeedMs,
    required int conditionId,
    required String condition,
    required String description,
    required String iconCode,
    required String cityName,
    required DateTime fetchedAt,
    @Default(WeatherSource.device) WeatherSource source,
  }) = _Weather;

  factory Weather.fromJson(Map<String, dynamic> json) =>
      _$WeatherFromJson(json);

  /// Parses the `GET /data/2.5/weather` response (metric units).
  ///
  /// Throws a [FormatException] when a required field is missing so the
  /// caller can report a malformed payload instead of a null crash.
  factory Weather.fromOpenWeatherMap(
    Map<String, dynamic> json, {
    WeatherSource source = WeatherSource.device,
    DateTime? now,
  }) {
    final main = json['main'];
    final wind = json['wind'];
    final weatherList = json['weather'];
    if (main is! Map<String, dynamic> ||
        weatherList is! List ||
        weatherList.isEmpty ||
        weatherList.first is! Map<String, dynamic>) {
      throw const FormatException('Unexpected OpenWeatherMap payload');
    }
    final first = weatherList.first as Map<String, dynamic>;
    final temp = main['temp'];
    if (temp is! num) {
      throw const FormatException('Missing temperature');
    }

    return Weather(
      temperatureCelsius: temp.toDouble(),
      feelsLikeCelsius: (main['feels_like'] as num?)?.toDouble() ?? temp.toDouble(),
      humidityPercent: (main['humidity'] as num?)?.toInt() ?? 0,
      windSpeedMs: wind is Map<String, dynamic>
          ? (wind['speed'] as num?)?.toDouble() ?? 0
          : 0,
      conditionId: (first['id'] as num?)?.toInt() ?? 800,
      condition: first['main'] as String? ?? 'Clear',
      description: first['description'] as String? ?? '',
      iconCode: first['icon'] as String? ?? '01d',
      cityName: json['name'] as String? ?? '',
      fetchedAt: now ?? DateTime.now(),
      source: source,
    );
  }

  // OpenWeatherMap condition groups: 2xx thunderstorm, 3xx drizzle,
  // 5xx rain, 6xx snow, 7xx atmosphere, 800 clear, 80x clouds.
  bool get isRainy => conditionId < 700;

  bool get isStormy => conditionId < 300;

  bool get isTooWindy => windSpeedMs >= 10;

  bool get isTooHot => temperatureCelsius >= 34;

  bool get isTooCold => temperatureCelsius <= 3;

  bool get isOutdoorFriendly => !isRainy && !isTooWindy && !isTooHot && !isTooCold;

  WeatherVerdict get verdict {
    if (isRainy || isStormy) return WeatherVerdict.indoor;
    if (isTooWindy || isTooHot || isTooCold) return WeatherVerdict.caution;
    return WeatherVerdict.ideal;
  }

  int get windSpeedKmh => (windSpeedMs * 3.6).round();

  String get temperatureLabel => '${temperatureCelsius.round()}°C';

  /// Sentence-case description, e.g. "Light rain".
  String get conditionLabel {
    if (description.isEmpty) return condition;
    return description[0].toUpperCase() + description.substring(1);
  }

  /// One-line summary shown in the weather chip.
  String get summary {
    final suffix = switch (verdict) {
      WeatherVerdict.ideal => 'Perfect outdoors',
      WeatherVerdict.caution => 'Adapt the intensity',
      WeatherVerdict.indoor => 'Indoor recommended',
    };
    return '$conditionLabel · Wind $windSpeedKmh km/h · $suffix';
  }

  /// Compact description used inside the AI prompt.
  String get promptDescription =>
      '${temperatureCelsius.round()}°C (feels like ${feelsLikeCelsius.round()}°C), '
      '$conditionLabel, wind $windSpeedKmh km/h, humidity $humidityPercent%. '
      'Outdoor play is ${isOutdoorFriendly ? 'suitable' : 'not recommended'}.';
}
