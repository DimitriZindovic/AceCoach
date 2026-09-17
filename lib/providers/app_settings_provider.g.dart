// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_settings_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// The single drift database instance, alive for the whole app.

@ProviderFor(localDatabase)
final localDatabaseProvider = LocalDatabaseProvider._();

/// The single drift database instance, alive for the whole app.

final class LocalDatabaseProvider
    extends
        $FunctionalProvider<
          LocalDatabaseService,
          LocalDatabaseService,
          LocalDatabaseService
        >
    with $Provider<LocalDatabaseService> {
  /// The single drift database instance, alive for the whole app.
  LocalDatabaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'localDatabaseProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$localDatabaseHash();

  @$internal
  @override
  $ProviderElement<LocalDatabaseService> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  LocalDatabaseService create(Ref ref) {
    return localDatabase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(LocalDatabaseService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<LocalDatabaseService>(value),
    );
  }
}

String _$localDatabaseHash() => r'56bec9904fdc27659b4067ca95108b13e0c9ae5b';

/// Light / dark / system, persisted in the local database.

@ProviderFor(AppThemeMode)
final appThemeModeProvider = AppThemeModeProvider._();

/// Light / dark / system, persisted in the local database.
final class AppThemeModeProvider
    extends $AsyncNotifierProvider<AppThemeMode, ThemeMode> {
  /// Light / dark / system, persisted in the local database.
  AppThemeModeProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'appThemeModeProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$appThemeModeHash();

  @$internal
  @override
  AppThemeMode create() => AppThemeMode();
}

String _$appThemeModeHash() => r'0f73bb236cb2cf3715dbe73f866d37f4a2dc8cf4';

/// Light / dark / system, persisted in the local database.

abstract class _$AppThemeMode extends $AsyncNotifier<ThemeMode> {
  FutureOr<ThemeMode> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<ThemeMode>, ThemeMode>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<ThemeMode>, ThemeMode>,
              AsyncValue<ThemeMode>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

/// City used for the weather when device location is unavailable.

@ProviderFor(HomeCity)
final homeCityProvider = HomeCityProvider._();

/// City used for the weather when device location is unavailable.
final class HomeCityProvider extends $AsyncNotifierProvider<HomeCity, String?> {
  /// City used for the weather when device location is unavailable.
  HomeCityProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'homeCityProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$homeCityHash();

  @$internal
  @override
  HomeCity create() => HomeCity();
}

String _$homeCityHash() => r'23f36532cef751f8340eaa0dff1dc08a72ab6f3f';

/// City used for the weather when device location is unavailable.

abstract class _$HomeCity extends $AsyncNotifier<String?> {
  FutureOr<String?> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<String?>, String?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<String?>, String?>,
              AsyncValue<String?>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
