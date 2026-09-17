import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';

/// Thin wrapper around Firebase Authentication and Google Sign-In.
///
/// It exposes raw Firebase types and lets exceptions bubble up; mapping them to
/// user-facing failures is the repository's job.
class AuthService {
  AuthService(
    this._auth,
    this._googleSignIn, {
    this._googleServerClientId,
    this._googleIosClientId,
  });

  final FirebaseAuth _auth;
  final GoogleSignIn _googleSignIn;
  final String? _googleServerClientId;
  final String? _googleIosClientId;

  // Google Sign-In must be initialised exactly once before use.
  Future<void>? _googleInitialization;

  /// Emits on sign-in, sign-out and profile updates (display name, photo).
  Stream<User?> userChanges() => _auth.userChanges();

  User? get currentUser => _auth.currentUser;

  Future<UserCredential> signInWithEmail({
    required String email,
    required String password,
  }) {
    return _auth.signInWithEmailAndPassword(email: email, password: password);
  }

  Future<UserCredential> registerWithEmail({
    required String email,
    required String password,
    required String displayName,
  }) async {
    final credential = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    await credential.user?.updateDisplayName(displayName);
    await credential.user?.reload();
    return credential;
  }

  Future<void> sendPasswordReset(String email) =>
      _auth.sendPasswordResetEmail(email: email);

  Future<UserCredential> signInWithGoogle() async {
    await _ensureGoogleInitialized();
    final account = await _googleSignIn.authenticate();
    final idToken = account.authentication.idToken;
    if (idToken == null) {
      throw const GoogleSignInException(
        code: GoogleSignInExceptionCode.unknownError,
        description: 'Google did not return an ID token.',
      );
    }
    final credential = GoogleAuthProvider.credential(idToken: idToken);
    return _auth.signInWithCredential(credential);
  }

  Future<void> signOut() async {
    await Future.wait([_auth.signOut(), _googleSignIn.signOut()]);
  }

  Future<void> updateDisplayName(String displayName) async {
    await _auth.currentUser?.updateDisplayName(displayName);
    await _auth.currentUser?.reload();
  }

  Future<void> _ensureGoogleInitialized() {
    // `clientId` is only read on Apple platforms; Android relies on the
    // web client id (`serverClientId`) to obtain an ID token for Firebase.
    final isApple =
        defaultTargetPlatform == TargetPlatform.iOS ||
        defaultTargetPlatform == TargetPlatform.macOS;
    return _googleInitialization ??= _googleSignIn.initialize(
      clientId: isApple ? _googleIosClientId : null,
      serverClientId: _googleServerClientId,
    );
  }
}
