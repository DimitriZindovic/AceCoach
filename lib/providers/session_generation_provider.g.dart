// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'session_generation_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(sessionRepository)
final sessionRepositoryProvider = SessionRepositoryProvider._();

final class SessionRepositoryProvider
    extends
        $FunctionalProvider<
          SessionRepository,
          SessionRepository,
          SessionRepository
        >
    with $Provider<SessionRepository> {
  SessionRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'sessionRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$sessionRepositoryHash();

  @$internal
  @override
  $ProviderElement<SessionRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  SessionRepository create(Ref ref) {
    return sessionRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SessionRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SessionRepository>(value),
    );
  }
}

String _$sessionRepositoryHash() => r'22fb3ce1546f4ce896d5ef53579a0ad51b5bbd15';

@ProviderFor(SessionGeneration)
final sessionGenerationProvider = SessionGenerationProvider._();

final class SessionGenerationProvider
    extends $NotifierProvider<SessionGeneration, SessionGenerationState> {
  SessionGenerationProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'sessionGenerationProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$sessionGenerationHash();

  @$internal
  @override
  SessionGeneration create() => SessionGeneration();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SessionGenerationState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SessionGenerationState>(value),
    );
  }
}

String _$sessionGenerationHash() => r'3c9c5d8726b22d4ef0ee2cf9cef721387ab60004';

abstract class _$SessionGeneration extends $Notifier<SessionGenerationState> {
  SessionGenerationState build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref =
        this.ref as $Ref<SessionGenerationState, SessionGenerationState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<SessionGenerationState, SessionGenerationState>,
              SessionGenerationState,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
