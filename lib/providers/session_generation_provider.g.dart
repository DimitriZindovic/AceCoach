// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'session_generation_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(aiService)
final aiServiceProvider = AiServiceProvider._();

final class AiServiceProvider
    extends $FunctionalProvider<AiService, AiService, AiService>
    with $Provider<AiService> {
  AiServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'aiServiceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$aiServiceHash();

  @$internal
  @override
  $ProviderElement<AiService> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  AiService create(Ref ref) {
    return aiService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AiService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AiService>(value),
    );
  }
}

String _$aiServiceHash() => r'11384c22729353f6a88317c83c49736cf05bc90e';

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

String _$sessionRepositoryHash() => r'73c48ea538d18d25423f4233c930a295824c546f';

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

String _$sessionGenerationHash() => r'94d3793db995a1a793574a34c6431753dfd347b5';

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

@ProviderFor(isCurrentSessionSaved)
final isCurrentSessionSavedProvider = IsCurrentSessionSavedProvider._();

final class IsCurrentSessionSavedProvider
    extends $FunctionalProvider<bool, bool, bool>
    with $Provider<bool> {
  IsCurrentSessionSavedProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'isCurrentSessionSavedProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$isCurrentSessionSavedHash();

  @$internal
  @override
  $ProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  bool create(Ref ref) {
    return isCurrentSessionSaved(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$isCurrentSessionSavedHash() =>
    r'2cc65e450dd97c98a03bf4df6d249057b11a7d15';
