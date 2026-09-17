import '../models/app_exception.dart';
import '../models/weather.dart';
import '../services/location_service.dart';
import '../services/weather_api_service.dart';

class WeatherRepository {
  WeatherRepository(this._api, this._location);

  final WeatherApiService _api;
  final LocationService _location;

  Future<Weather> getCurrentWeather() async {
    final ({double latitude, double longitude}) coordinates;
    try {
      coordinates = await _location.getCurrentPosition();
    } on AppException {
      throw const AppException('Could not read your location.');
    }

    final json = await _api.fetchByCoordinates(
      latitude: coordinates.latitude,
      longitude: coordinates.longitude,
    );
    return _parse(json);
  }

  Weather _parse(Map<String, dynamic> json) {
    try {
      return Weather.fromOpenWeatherMap(json);
    } on FormatException {
      throw const AppException('Weather data could not be read.');
    } on TypeError {
      throw const AppException('Weather data could not be read.');
    }
  }
}
