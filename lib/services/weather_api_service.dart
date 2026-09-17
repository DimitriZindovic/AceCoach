import 'package:dio/dio.dart';

import '../constants/api_constants.dart';
import '../models/failures.dart';

/// Raw HTTP client for the OpenWeatherMap "current weather" endpoint.
///
/// Returns the decoded JSON payload; the repository builds the model.
class WeatherApiService {
  WeatherApiService(this._dio, {required this._apiKey});

  final Dio _dio;
  final String _apiKey;

  Future<Map<String, dynamic>> fetchByCoordinates({
    required double latitude,
    required double longitude,
  }) {
    return _get({'lat': latitude, 'lon': longitude});
  }

  Future<Map<String, dynamic>> fetchByCity(String city) {
    return _get({'q': city});
  }

  Future<Map<String, dynamic>> _get(Map<String, Object> query) async {
    try {
      final response = await _dio.get<Map<String, dynamic>>(
        ApiConstants.openWeatherCurrentPath,
        queryParameters: {
          ...query,
          'units': ApiConstants.openWeatherUnits,
          'appid': _apiKey,
        },
      );
      final data = response.data;
      if (data == null) throw const WeatherFailure.malformedResponse();
      return data;
    } on DioException catch (error) {
      throw _mapDioError(error, query['q'] as String?);
    }
  }

  static const Set<DioExceptionType> _networkErrors = {
    DioExceptionType.connectionTimeout,
    DioExceptionType.sendTimeout,
    DioExceptionType.receiveTimeout,
    DioExceptionType.connectionError,
  };

  WeatherFailure _mapDioError(DioException error, String? city) {
    if (_networkErrors.contains(error.type)) {
      return WeatherFailure.network(error);
    }
    if (error.type == DioExceptionType.badResponse) {
      final status = error.response?.statusCode;
      if (status == 401) return const WeatherFailure.unauthorized();
      if (status == 404 && city != null) {
        return WeatherFailure.cityNotFound(city);
      }
    }
    return WeatherFailure.unknown(error);
  }
}
