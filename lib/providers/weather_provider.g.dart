// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'weather_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(currentWeather)
final currentWeatherProvider = CurrentWeatherProvider._();

final class CurrentWeatherProvider
    extends $FunctionalProvider<AsyncValue<Weather>, Weather, FutureOr<Weather>>
    with $FutureModifier<Weather>, $FutureProvider<Weather> {
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

String _$currentWeatherHash() => r'60998ddab8939a72570aaedba24edd417d67a62b';
