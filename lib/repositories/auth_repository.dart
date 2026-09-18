import 'package:firebase_auth/firebase_auth.dart';

import '../models/app_exception.dart';
import '../models/app_user.dart';
import '../services/auth_service.dart';

class AuthRepository {
  AuthRepository(this._service);

  final AuthService? _service;

  bool get isAvailable => _service != null;

  Stream<AppUser?> watchUser() {
    final service = _service;
    if (service == null) return Stream.value(null);
    return service.userChanges().map(
      (user) => user == null ? null : _toAppUser(user),
    );
  }

  AppUser? get currentUser {
    final user = _service?.currentUser;
    return user == null ? null : _toAppUser(user);
  }

  Future<AppUser> signIn({required String email, required String password}) {
    return _guard(() async {
      final credential = await _require().signInWithEmail(
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
      final credential = await _require().registerWithEmail(
        email: email.trim(),
        password: password,
        displayName: displayName.trim(),
      );
      return _toAppUser(_require().currentUser ?? credential.user!);
    });
  }

  Future<void> signOut() => _guard(() => _require().signOut());

  AuthService _require() {
    final service = _service;
    if (service == null) {
      throw const AppException(
        'Firebase is not configured in this build. Add '
        'android/app/google-services.json.',
      );
    }
    return service;
  }

  Future<T> _guard<T>(Future<T> Function() action) async {
    try {
      return await action();
    } on FirebaseAuthException catch (error) {
      throw AppException(_messageFor(error.code));
    } on AppException {
      rethrow;
    } catch (_) {
      throw const AppException('Something went wrong. Please try again.');
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

  String _messageFor(String code) => switch (code) {
    'invalid-email' => 'This email address is not valid.',
    'user-not-found' ||
    'wrong-password' ||
    'invalid-credential' => 'Incorrect email or password.',
    'email-already-in-use' => 'An account already exists with this email.',
    'weak-password' => 'Choose a stronger password (at least 8 characters).',
    'user-disabled' => 'This account has been disabled.',
    'too-many-requests' => 'Too many attempts. Please wait a moment and retry.',
    'network-request-failed' => 'No connection. Check your network and retry.',
    _ => 'Something went wrong. Please try again.',
  };
}
