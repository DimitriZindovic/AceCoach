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
Dio dio(Ref ref) {
  final dio = Dio(
    BaseOptions(
      baseUrl: ApiConstants.openWeatherBaseUrl,
      connectTimeout: ApiConstants.httpConnectTimeout,
      receiveTimeout: ApiConstants.httpReceiveTimeout,
    ),
  );
  ref.onDispose(dio.close);
  return dio;
}

@Riverpod(keepAlive: true)
WeatherApiService weatherApiService(Ref ref) {
  return WeatherApiService(
    ref.watch(dioProvider),
    apiKey: ApiConstants.openWeatherApiKey,
  );
}

@Riverpod(keepAlive: true)
LocationService locationService(Ref ref) => const LocationService();

@Riverpod(keepAlive: true)
WeatherRepository weatherRepository(Ref ref) {
  return WeatherRepository(
    ref.watch(weatherApiServiceProvider),
    ref.watch(locationServiceProvider),
  );
}

@Riverpod(keepAlive: true)
Future<Weather> currentWeather(Ref ref) async {
  final weather = await ref
      .watch(weatherRepositoryProvider)
      .getCurrentWeather();

  final timer = Timer(ApiConstants.weatherCacheDuration, ref.invalidateSelf);
  ref.onDispose(timer.cancel);
  return weather;
}
