import 'package:ace_coach/models/weather.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/fixtures.dart';

void main() {
  group('Weather.fromOpenWeatherMap', () {
    test('parses the current weather payload', () {
      final weather = Weather.fromOpenWeatherMap(
        Fixtures.openWeatherRainJson,
        now: DateTime(2026, 9, 16, 12),
      );

      expect(weather.temperatureCelsius, 17.4);
      expect(weather.feelsLikeCelsius, 17.1);
      expect(weather.humidityPercent, 82);
      expect(weather.windSpeedMs, 4.6);
      expect(weather.conditionId, 500);
      expect(weather.condition, 'Rain');
      expect(weather.description, 'light rain');
      expect(weather.cityName, 'Vincennes');
      expect(weather.fetchedAt, DateTime(2026, 9, 16, 12));
      expect(weather.source, WeatherSource.device);
    });

    test('derives the outdoor verdict from the condition group', () {
      final rain = Weather.fromOpenWeatherMap(Fixtures.openWeatherRainJson);
      expect(rain.isRainy, isTrue);
      expect(rain.isOutdoorFriendly, isFalse);
      expect(rain.verdict, WeatherVerdict.indoor);
      expect(rain.conditionLabel, 'Light rain');
      expect(rain.windSpeedKmh, 17);

      final sunny = Fixtures.sunnyWeather;
      expect(sunny.verdict, WeatherVerdict.ideal);
      expect(sunny.summary, contains('Perfect outdoors'));

      final windy = sunny.copyWith(windSpeedMs: 12);
      expect(windy.verdict, WeatherVerdict.caution);

      final hot = sunny.copyWith(temperatureCelsius: 36);
      expect(hot.verdict, WeatherVerdict.caution);
    });

    test('tolerates missing optional fields', () {
      final weather = Weather.fromOpenWeatherMap({
        'weather': [
          {'id': 800},
        ],
        'main': {'temp': 20},
      });
      expect(weather.condition, 'Clear');
      expect(weather.windSpeedMs, 0);
      expect(weather.humidityPercent, 0);
      expect(weather.cityName, '');
    });

    test('throws FormatException on a malformed payload', () {
      expect(
        () => Weather.fromOpenWeatherMap(const {}),
        throwsA(isA<FormatException>()),
      );
      expect(
        () => Weather.fromOpenWeatherMap(const {
          'weather': <Object>[],
          'main': {'temp': 20},
        }),
        throwsA(isA<FormatException>()),
      );
      expect(
        () => Weather.fromOpenWeatherMap(const {
          'weather': [
            {'id': 800},
          ],
          'main': {'temp': 'warm'},
        }),
        throwsA(isA<FormatException>()),
      );
    });
  });

  test('Weather JSON round trip keeps every field', () {
    final weather = Fixtures.sunnyWeather.copyWith(source: WeatherSource.city);
    final restored = Weather.fromJson(weather.toJson());
    expect(restored, weather);
  });
}
