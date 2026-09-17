// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'session_history_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// All saved sessions of the signed-in user, newest first.

@ProviderFor(sessionHistory)
final sessionHistoryProvider = SessionHistoryProvider._();

/// All saved sessions of the signed-in user, newest first.

final class SessionHistoryProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<TrainingSession>>,
          List<TrainingSession>,
          Stream<List<TrainingSession>>
        >
    with
        $FutureModifier<List<TrainingSession>>,
        $StreamProvider<List<TrainingSession>> {
  /// All saved sessions of the signed-in user, newest first.
  SessionHistoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'sessionHistoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$sessionHistoryHash();

  @$internal
  @override
  $StreamProviderElement<List<TrainingSession>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<TrainingSession>> create(Ref ref) {
    return sessionHistory(ref);
  }
}

String _$sessionHistoryHash() => r'8434cfef0aceadb362d35007f935505f6fefc31f';

/// One saved session by id, read from the local database.

@ProviderFor(savedSession)
final savedSessionProvider = SavedSessionFamily._();

/// One saved session by id, read from the local database.

final class SavedSessionProvider
    extends
        $FunctionalProvider<
          AsyncValue<TrainingSession?>,
          TrainingSession?,
          FutureOr<TrainingSession?>
        >
    with $FutureModifier<TrainingSession?>, $FutureProvider<TrainingSession?> {
  /// One saved session by id, read from the local database.
  SavedSessionProvider._({
    required SavedSessionFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'savedSessionProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$savedSessionHash();

  @override
  String toString() {
    return r'savedSessionProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<TrainingSession?> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<TrainingSession?> create(Ref ref) {
    final argument = this.argument as String;
    return savedSession(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is SavedSessionProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$savedSessionHash() => r'c77a07149e1172d8b757b72a81b85669bc7c2b1b';

/// One saved session by id, read from the local database.

final class SavedSessionFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<TrainingSession?>, String> {
  SavedSessionFamily._()
    : super(
        retry: null,
        name: r'savedSessionProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// One saved session by id, read from the local database.

  SavedSessionProvider call(String sessionId) =>
      SavedSessionProvider._(argument: sessionId, from: this);

  @override
  String toString() => r'savedSessionProvider';
}

@ProviderFor(HistoryFilterNotifier)
final historyFilterProvider = HistoryFilterNotifierProvider._();

final class HistoryFilterNotifierProvider
    extends $NotifierProvider<HistoryFilterNotifier, HistoryFilter> {
  HistoryFilterNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'historyFilterProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$historyFilterNotifierHash();

  @$internal
  @override
  HistoryFilterNotifier create() => HistoryFilterNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(HistoryFilter value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<HistoryFilter>(value),
    );
  }
}

String _$historyFilterNotifierHash() =>
    r'0b1378f173e171d57902ef3e1e348cebf97ee8f9';

abstract class _$HistoryFilterNotifier extends $Notifier<HistoryFilter> {
  HistoryFilter build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<HistoryFilter, HistoryFilter>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<HistoryFilter, HistoryFilter>,
              HistoryFilter,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

/// History after search and filters.

@ProviderFor(filteredHistory)
final filteredHistoryProvider = FilteredHistoryProvider._();

/// History after search and filters.

final class FilteredHistoryProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<TrainingSession>>,
          AsyncValue<List<TrainingSession>>,
          AsyncValue<List<TrainingSession>>
        >
    with $Provider<AsyncValue<List<TrainingSession>>> {
  /// History after search and filters.
  FilteredHistoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'filteredHistoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$filteredHistoryHash();

  @$internal
  @override
  $ProviderElement<AsyncValue<List<TrainingSession>>> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  AsyncValue<List<TrainingSession>> create(Ref ref) {
    return filteredHistory(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<List<TrainingSession>> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AsyncValue<List<TrainingSession>>>(
        value,
      ),
    );
  }
}

String _$filteredHistoryHash() => r'ee42ce15dcd48394032c0fd2fa4925e04802d1ad';

/// Stats derived from the whole history.

@ProviderFor(profileStats)
final profileStatsProvider = ProfileStatsProvider._();

/// Stats derived from the whole history.

final class ProfileStatsProvider
    extends $FunctionalProvider<ProfileStats, ProfileStats, ProfileStats>
    with $Provider<ProfileStats> {
  /// Stats derived from the whole history.
  ProfileStatsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'profileStatsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$profileStatsHash();

  @$internal
  @override
  $ProviderElement<ProfileStats> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  ProfileStats create(Ref ref) {
    return profileStats(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ProfileStats value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ProfileStats>(value),
    );
  }
}

String _$profileStatsHash() => r'0c45624033d86a5c1503c45bb30ceb2d88e3f5ac';

/// Actions on saved sessions.

@ProviderFor(HistoryActions)
final historyActionsProvider = HistoryActionsProvider._();

/// Actions on saved sessions.
final class HistoryActionsProvider
    extends $NotifierProvider<HistoryActions, AsyncValue<void>> {
  /// Actions on saved sessions.
  HistoryActionsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'historyActionsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$historyActionsHash();

  @$internal
  @override
  HistoryActions create() => HistoryActions();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<void> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AsyncValue<void>>(value),
    );
  }
}

String _$historyActionsHash() => r'4afad1150904e9c83d1c200769e6db2f46edacf9';

/// Actions on saved sessions.

abstract class _$HistoryActions extends $Notifier<AsyncValue<void>> {
  AsyncValue<void> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<void>, AsyncValue<void>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<void>, AsyncValue<void>>,
              AsyncValue<void>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
