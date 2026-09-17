import 'package:dio/dio.dart';

import '../constants/api_constants.dart';
import '../models/app_exception.dart';

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
      if (data == null) {
        throw const AppException('Weather data could not be read.');
      }
      return data;
    } on DioException catch (error) {
      throw _mapDioError(error);
    }
  }

  static const Set<DioExceptionType> _networkErrors = {
    DioExceptionType.connectionTimeout,
    DioExceptionType.sendTimeout,
    DioExceptionType.receiveTimeout,
    DioExceptionType.connectionError,
  };

  AppException _mapDioError(DioException error) {
    if (_networkErrors.contains(error.type)) {
      return const AppException('Weather unavailable offline.');
    }
    if (error.type == DioExceptionType.badResponse) {
      final status = error.response?.statusCode;
      if (status == 401) {
        return const AppException('Weather service rejected the API key.');
      }
    }
    return const AppException('Weather unavailable right now.');
  }
}
