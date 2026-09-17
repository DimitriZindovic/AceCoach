// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'session_form_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// State of the session setup form. Kept alive so the user's choices survive
/// a tab switch until a session is generated.

@ProviderFor(SessionForm)
final sessionFormProvider = SessionFormProvider._();

/// State of the session setup form. Kept alive so the user's choices survive
/// a tab switch until a session is generated.
final class SessionFormProvider
    extends $NotifierProvider<SessionForm, SessionParams> {
  /// State of the session setup form. Kept alive so the user's choices survive
  /// a tab switch until a session is generated.
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

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SessionParams value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SessionParams>(value),
    );
  }
}

String _$sessionFormHash() => r'8fdd926cd3f28533c804877b1434cd96da308919';

/// State of the session setup form. Kept alive so the user's choices survive
/// a tab switch until a session is generated.

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
