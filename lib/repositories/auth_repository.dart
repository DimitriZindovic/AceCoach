import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../models/app_user.dart';
import '../models/failures.dart';
import '../services/auth_service.dart';

/// Single source of truth for the signed-in user.
///
/// Translates Firebase / Google exceptions into [AuthFailure]s.
class AuthRepository {
  AuthRepository(this._service);

  final AuthService _service;

  Stream<AppUser?> watchUser() => _service.userChanges().map(
    (user) => user == null ? null : _toAppUser(user),
  );

  AppUser? get currentUser {
    final user = _service.currentUser;
    return user == null ? null : _toAppUser(user);
  }

  Future<AppUser> signIn({required String email, required String password}) {
    return _guard(() async {
      final credential = await _service.signInWithEmail(
        email: email.trim(),
        password: password,
      );
      return _toAppUser(credential.user!);
    });
  }

  Future<AppUser> register({
    required String email,
    required String password,
    required String displayName,
  }) {
    return _guard(() async {
      final credential = await _service.registerWithEmail(
        email: email.trim(),
        password: password,
        displayName: displayName.trim(),
      );
      return _toAppUser(_service.currentUser ?? credential.user!);
    });
  }

  Future<AppUser> signInWithGoogle() {
    return _guard(() async {
      final credential = await _service.signInWithGoogle();
      return _toAppUser(credential.user!);
    });
  }

  Future<void> sendPasswordReset(String email) =>
      _guard(() => _service.sendPasswordReset(email.trim()));

  Future<void> signOut() => _guard(_service.signOut);

  Future<void> updateDisplayName(String displayName) =>
      _guard(() => _service.updateDisplayName(displayName.trim()));

  Future<T> _guard<T>(Future<T> Function() action) async {
    try {
      return await action();
    } on FirebaseAuthException catch (error) {
      throw AuthFailure.fromCode(error.code);
    } on GoogleSignInException catch (error) {
      if (error.code == GoogleSignInExceptionCode.canceled) {
        throw const AuthFailure.cancelled();
      }
      throw const AuthFailure.unknown();
    } on AuthFailure {
      rethrow;
    } catch (_) {
      throw const AuthFailure.unknown();
    }
  }

  AppUser _toAppUser(User user) {
    return AppUser(
      uid: user.uid,
      email: user.email ?? '',
      displayName: user.displayName,
      photoUrl: user.photoURL,
      createdAt: user.metadata.creationTime,
    );
  }
}
