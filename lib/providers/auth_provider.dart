import 'package:firebase_auth/firebase_auth.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../models/app_exception.dart';
import '../models/app_user.dart';
import '../repositories/auth_repository.dart';
import '../services/auth_service.dart';

part 'auth_provider.g.dart';

@Riverpod(keepAlive: true)
bool firebaseReady(Ref ref) =>
    throw UnimplementedError('firebaseReadyProvider must be overridden');

@Riverpod(keepAlive: true)
AuthService? authService(Ref ref) {
  if (!ref.watch(firebaseReadyProvider)) return null;
  return AuthService(FirebaseAuth.instance);
}

@Riverpod(keepAlive: true)
AuthRepository authRepository(Ref ref) =>
    AuthRepository(ref.watch(authServiceProvider));

@Riverpod(keepAlive: true)
Stream<AppUser?> authState(Ref ref) =>
    ref.watch(authRepositoryProvider).watchUser();

@riverpod
AppUser? currentUser(Ref ref) => ref.watch(authStateProvider).value;

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

  Future<bool> sendPasswordReset(String email) =>
      _run(() => ref.read(authRepositoryProvider).sendPasswordReset(email));

  Future<bool> signOut() =>
      _run(() => ref.read(authRepositoryProvider).signOut());

  AppException? get failure {
    final error = state.error;
    return error is AppException ? error : null;
  }

  Future<bool> _run(Future<void> Function() action) async {
    state = const AsyncLoading();
    final result = await AsyncValue.guard(action);
    if (!ref.mounted) return !result.hasError;
    state = result;
    return !result.hasError;
  }
}
