// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'session_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(sessionHistory)
final sessionHistoryProvider = SessionHistoryProvider._();

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

String _$sessionHistoryHash() => r'd7182c2358340bca29850beeefd14f16eb1f13c3';
