import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../constants/api_constants.dart';
import '../models/app_user.dart';
import '../models/failures.dart';
import '../repositories/auth_repository.dart';
import '../services/auth_service.dart';

part 'auth_provider.g.dart';

@Riverpod(keepAlive: true)
FirebaseAuth firebaseAuth(Ref ref) => FirebaseAuth.instance;

@Riverpod(keepAlive: true)
AuthService authService(Ref ref) {
  return AuthService(
    ref.watch(firebaseAuthProvider),
    GoogleSignIn.instance,
    googleServerClientId: dotenv.maybeGet(ApiConstants.envGoogleServerClientId),
    googleIosClientId: dotenv.maybeGet(ApiConstants.envGoogleIosClientId),
  );
}

@Riverpod(keepAlive: true)
AuthRepository authRepository(Ref ref) =>
    AuthRepository(ref.watch(authServiceProvider));

/// The signed-in user, `null` when signed out. Drives the router guard.
@Riverpod(keepAlive: true)
Stream<AppUser?> authState(Ref ref) =>
    ref.watch(authRepositoryProvider).watchUser();

/// Convenience accessor for screens that need the user synchronously.
@riverpod
AppUser? currentUser(Ref ref) => ref.watch(authStateProvider).value;

/// Runs the auth actions and exposes their loading / error state.
///
/// Every method returns `true` on success so callers can navigate or show a
/// confirmation; the failure, if any, is available in [state].
@riverpod
class AuthController extends _$AuthController {
  @override
  AsyncValue<void> build() => const AsyncData(null);

  Future<bool> signIn({required String email, required String password}) {
    return _run(
      () => ref
          .read(authRepositoryProvider)
          .signIn(email: email, password: password),
    );
  }

  Future<bool> register({
    required String email,
    required String password,
    required String displayName,
  }) {
    return _run(
      () => ref
          .read(authRepositoryProvider)
          .register(email: email, password: password, displayName: displayName),
    );
  }

  Future<bool> signInWithGoogle() =>
      _run(() => ref.read(authRepositoryProvider).signInWithGoogle());

  Future<bool> sendPasswordReset(String email) =>
      _run(() => ref.read(authRepositoryProvider).sendPasswordReset(email));

  Future<bool> signOut() =>
      _run(() => ref.read(authRepositoryProvider).signOut());

  Future<bool> updateDisplayName(String displayName) => _run(
    () => ref.read(authRepositoryProvider).updateDisplayName(displayName),
  );

  /// The failure behind the current error state, if any.
  AuthFailure? get failure {
    final error = state.error;
    return error is AuthFailure ? error : null;
  }

  Future<bool> _run(Future<void> Function() action) async {
    state = const AsyncLoading();
    final result = await AsyncValue.guard(action);
    // A cancelled Google sheet is not an error worth showing.
    if (result.error case AuthFailure(isCancelled: true)) {
      state = const AsyncData(null);
      return false;
    }
    state = result;
    return !result.hasError;
  }
}
