// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'session_form_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(SessionForm)
final sessionFormProvider = SessionFormProvider._();

final class SessionFormProvider
    extends $NotifierProvider<SessionForm, SessionParams> {
  SessionFormProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'sessionFormProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$sessionFormHash();

  @$internal
  @override
  SessionForm create() => SessionForm();

  Override overrideWithValue(SessionParams value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SessionParams>(value),
    );
  }
}

String _$sessionFormHash() => r'34edb00a9c1a73c311e660f3773fe912f4575efa';

abstract class _$SessionForm extends $Notifier<SessionParams> {
  SessionParams build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<SessionParams, SessionParams>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<SessionParams, SessionParams>,
              SessionParams,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
