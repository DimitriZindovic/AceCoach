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

class Weather {
  const Weather({
    required this.temperatureCelsius,
    required this.feelsLikeCelsius,
    required this.humidityPercent,
    required this.windSpeedMs,
    required this.conditionId,
    required this.description,
  });

  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
      temperatureCelsius: (json['temperature'] as num).toDouble(),
      feelsLikeCelsius: (json['feelsLike'] as num).toDouble(),
      humidityPercent: (json['humidity'] as num).toInt(),
      windSpeedMs: (json['wind'] as num).toDouble(),
      conditionId: (json['conditionId'] as num).toInt(),
      description: json['description'] as String,
    );
  }

  factory Weather.fromOpenWeatherMap(Map<String, dynamic> json) {
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
    if (temp is! num) throw const FormatException('Missing temperature');

    final description = first['description'] as String? ?? '';
    return Weather(
      temperatureCelsius: temp.toDouble(),
      feelsLikeCelsius:
          (main['feels_like'] as num?)?.toDouble() ?? temp.toDouble(),
      humidityPercent: (main['humidity'] as num?)?.toInt() ?? 0,
      windSpeedMs: wind is Map<String, dynamic>
          ? (wind['speed'] as num?)?.toDouble() ?? 0
          : 0,
      conditionId: (first['id'] as num?)?.toInt() ?? 800,
      description: description.isEmpty
          ? first['main'] as String? ?? 'Clear'
          : description,
    );
  }

  final double temperatureCelsius;
  final double feelsLikeCelsius;
  final int humidityPercent;
  final double windSpeedMs;
  final int conditionId;
  final String description;

  Map<String, dynamic> toJson() => {
    'temperature': temperatureCelsius,
    'feelsLike': feelsLikeCelsius,
    'humidity': humidityPercent,
    'wind': windSpeedMs,
    'conditionId': conditionId,
    'description': description,
  };

  bool get isRainy => conditionId < 700;

  bool get isStormy => conditionId < 300;

  bool get isTooWindy => windSpeedMs >= 10;

  bool get isTooHot => temperatureCelsius >= 34;

  bool get isTooCold => temperatureCelsius <= 3;

  bool get isOutdoorFriendly =>
      conditionId >= 700 &&
      windSpeedMs < 10 &&
      temperatureCelsius > 3 &&
      temperatureCelsius < 34;

  WeatherVerdict get verdict {
    if (conditionId < 700) return WeatherVerdict.indoor;
    return isOutdoorFriendly ? WeatherVerdict.ideal : WeatherVerdict.caution;
  }

  int get windSpeedKmh => (windSpeedMs * 3.6).round();

  String get temperatureLabel => '${temperatureCelsius.round()}°C';

  String get conditionLabel =>
      description[0].toUpperCase() + description.substring(1);

  String get label => conditionLabel;

  String get promptDescription =>
      '${temperatureCelsius.round()}°C (feels like ${feelsLikeCelsius.round()}°C), '
      '$conditionLabel, wind $windSpeedKmh km/h, humidity $humidityPercent%. '
      'Outdoor play is ${isOutdoorFriendly ? 'suitable' : 'not recommended'}.';

  String get summary {
    final suffix = switch (verdict) {
      WeatherVerdict.ideal => 'Perfect outdoors',
      WeatherVerdict.caution => 'Adapt the intensity',
      WeatherVerdict.indoor => 'Indoor recommended',
    };
    return '$label · Wind $windSpeedKmh km/h · $suffix';
  }
}
