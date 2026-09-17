import '../models/failures.dart';
import '../models/weather.dart';
import '../services/location_service.dart';
import '../services/weather_api_service.dart';

/// Fetches today's weather from the device position, falling back to a
/// user-provided city when location is unavailable.
class WeatherRepository {
  WeatherRepository(this._api, this._location);

  final WeatherApiService _api;
  final LocationService _location;

  /// Device position first, then [fallbackCity]. Throws a [WeatherFailure].
  Future<Weather> getCurrentWeather({String? fallbackCity}) async {
    try {
      final position = await _location.getCurrentPosition();
      final json = await _api.fetchByCoordinates(
        latitude: position.latitude,
        longitude: position.longitude,
      );
      return _parse(json, WeatherSource.device);
    } on LocationException catch (error) {
      if (fallbackCity != null && fallbackCity.trim().isNotEmpty) {
        return getWeatherForCity(fallbackCity);
      }
      throw error.isPermissionProblem
          ? const WeatherFailure.locationDenied()
          : WeatherFailure.locationUnavailable(error);
    }
  }

  Future<Weather> getWeatherForCity(String city) async {
    final json = await _api.fetchByCity(city.trim());
    return _parse(json, WeatherSource.city);
  }

  Weather _parse(Map<String, dynamic> json, WeatherSource source) {
    try {
      return Weather.fromOpenWeatherMap(json, source: source);
    } on FormatException catch (error) {
      throw WeatherFailure.malformedResponse(error);
    } on TypeError catch (error) {
      throw WeatherFailure.malformedResponse(error);
    }
  }
}
