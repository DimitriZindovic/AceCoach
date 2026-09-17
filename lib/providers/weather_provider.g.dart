// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'weather_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(dio)
final dioProvider = DioProvider._();

final class DioProvider extends $FunctionalProvider<Dio, Dio, Dio>
    with $Provider<Dio> {
  DioProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'dioProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$dioHash();

  @$internal
  @override
  $ProviderElement<Dio> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  Dio create(Ref ref) {
    return dio(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Dio value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Dio>(value),
    );
  }
}

String _$dioHash() => r'52272c520495690ce71d79bd4c9b09eb0d9982e4';

@ProviderFor(weatherApiService)
final weatherApiServiceProvider = WeatherApiServiceProvider._();

final class WeatherApiServiceProvider
    extends
        $FunctionalProvider<
          WeatherApiService,
          WeatherApiService,
          WeatherApiService
        >
    with $Provider<WeatherApiService> {
  WeatherApiServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'weatherApiServiceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$weatherApiServiceHash();

  @$internal
  @override
  $ProviderElement<WeatherApiService> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  WeatherApiService create(Ref ref) {
    return weatherApiService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(WeatherApiService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<WeatherApiService>(value),
    );
  }
}

String _$weatherApiServiceHash() => r'366c356ed2537ac7a09fedf06dbe6b3936294b98';

@ProviderFor(locationService)
final locationServiceProvider = LocationServiceProvider._();

final class LocationServiceProvider
    extends
        $FunctionalProvider<LocationService, LocationService, LocationService>
    with $Provider<LocationService> {
  LocationServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'locationServiceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$locationServiceHash();

  @$internal
  @override
  $ProviderElement<LocationService> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  LocationService create(Ref ref) {
    return locationService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(LocationService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<LocationService>(value),
    );
  }
}

String _$locationServiceHash() => r'781de39d66b80cd814e0941c88d5ae9dd3af48cd';

@ProviderFor(weatherRepository)
final weatherRepositoryProvider = WeatherRepositoryProvider._();

final class WeatherRepositoryProvider
    extends
        $FunctionalProvider<
          WeatherRepository,
          WeatherRepository,
          WeatherRepository
        >
    with $Provider<WeatherRepository> {
  WeatherRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'weatherRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$weatherRepositoryHash();

  @$internal
  @override
  $ProviderElement<WeatherRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  WeatherRepository create(Ref ref) {
    return weatherRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(WeatherRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<WeatherRepository>(value),
    );
  }
}

String _$weatherRepositoryHash() => r'7f2053770c668654ca1f4b0d7002b2d9426614ed';

/// Today's weather. Cached for [ApiConstants.weatherCacheDuration], then
/// refreshed on the next read. Re-fetched when the home city changes.
///
/// Errors are [WeatherFailure]s; consumers must treat them as non-blocking.

@ProviderFor(currentWeather)
final currentWeatherProvider = CurrentWeatherProvider._();

/// Today's weather. Cached for [ApiConstants.weatherCacheDuration], then
/// refreshed on the next read. Re-fetched when the home city changes.
///
/// Errors are [WeatherFailure]s; consumers must treat them as non-blocking.

final class CurrentWeatherProvider
    extends $FunctionalProvider<AsyncValue<Weather>, Weather, FutureOr<Weather>>
    with $FutureModifier<Weather>, $FutureProvider<Weather> {
  /// Today's weather. Cached for [ApiConstants.weatherCacheDuration], then
  /// refreshed on the next read. Re-fetched when the home city changes.
  ///
  /// Errors are [WeatherFailure]s; consumers must treat them as non-blocking.
  CurrentWeatherProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'currentWeatherProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$currentWeatherHash();

  @$internal
  @override
  $FutureProviderElement<Weather> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<Weather> create(Ref ref) {
    return currentWeather(ref);
  }
}

String _$currentWeatherHash() => r'96b8dea6e7ec125af3f2e5ebe110db33624cc66e';
