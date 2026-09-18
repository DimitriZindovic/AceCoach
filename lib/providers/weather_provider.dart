import 'dart:async';

import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../constants/api_constants.dart';
import '../models/weather.dart';
import '../repositories/weather_repository.dart';
import '../services/location_service.dart';
import '../services/weather_api_service.dart';

part 'weather_provider.g.dart';

@Riverpod(keepAlive: true)
Future<Weather> currentWeather(Ref ref) async {
  final dio = Dio(
    BaseOptions(
      baseUrl: ApiConstants.openWeatherBaseUrl,
      connectTimeout: ApiConstants.httpConnectTimeout,
      receiveTimeout: ApiConstants.httpReceiveTimeout,
    ),
  );
  ref.onDispose(dio.close);

  final repository = WeatherRepository(
    WeatherApiService(dio, apiKey: ApiConstants.openWeatherApiKey),
    const LocationService(),
  );

  final weather = await repository.getCurrentWeather();

  final timer = Timer(ApiConstants.weatherCacheDuration, ref.invalidateSelf);
  ref.onDispose(timer.cancel);
  return weather;
}
