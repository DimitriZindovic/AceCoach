import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../constants/api_constants.dart';
import '../models/weather.dart';
import '../repositories/weather_repository.dart';
import '../services/location_service.dart';
import '../services/weather_api_service.dart';
import 'app_settings_provider.dart';

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
    apiKey: dotenv.maybeGet(ApiConstants.envOpenWeatherApiKey) ?? '',
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

/// Today's weather. Cached for [ApiConstants.weatherCacheDuration], then
/// refreshed on the next read. Re-fetched when the home city changes.
///
/// Errors are [WeatherFailure]s; consumers must treat them as non-blocking.
@Riverpod(keepAlive: true)
Future<Weather> currentWeather(Ref ref) async {
  final city = await ref.watch(homeCityProvider.future);
  final weather = await ref
      .watch(weatherRepositoryProvider)
      .getCurrentWeather(fallbackCity: city);

  final timer = Timer(ApiConstants.weatherCacheDuration, ref.invalidateSelf);
  ref.onDispose(timer.cancel);
  return weather;
}
