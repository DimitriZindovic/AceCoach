import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'constants/api_constants.dart';

/// Firebase configuration read from `.env`, so no project identifier is
/// committed to the repository. See `docs/setup_guide.md`.
abstract final class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    return switch (defaultTargetPlatform) {
      TargetPlatform.iOS || TargetPlatform.macOS => ios,
      TargetPlatform.android => android,
      _ => throw UnsupportedError('AceCoach only targets Android and iOS.'),
    };
  }

  static FirebaseOptions get android => FirebaseOptions(
    apiKey: _require(ApiConstants.envFirebaseAndroidApiKey),
    appId: _require(ApiConstants.envFirebaseAndroidAppId),
    messagingSenderId: _require(ApiConstants.envFirebaseMessagingSenderId),
    projectId: _require(ApiConstants.envFirebaseProjectId),
    storageBucket: dotenv.maybeGet(ApiConstants.envFirebaseStorageBucket),
    authDomain: dotenv.maybeGet(ApiConstants.envFirebaseAuthDomain),
  );

  static FirebaseOptions get ios => FirebaseOptions(
    apiKey: _require(ApiConstants.envFirebaseIosApiKey),
    appId: _require(ApiConstants.envFirebaseIosAppId),
    messagingSenderId: _require(ApiConstants.envFirebaseMessagingSenderId),
    projectId: _require(ApiConstants.envFirebaseProjectId),
    storageBucket: dotenv.maybeGet(ApiConstants.envFirebaseStorageBucket),
    authDomain: dotenv.maybeGet(ApiConstants.envFirebaseAuthDomain),
    iosBundleId: dotenv.maybeGet(ApiConstants.envFirebaseIosBundleId),
    iosClientId: dotenv.maybeGet(ApiConstants.envGoogleIosClientId),
  );

  /// Keys still holding the `.env.example` placeholder count as missing.
  static String _require(String key) {
    final value = dotenv.maybeGet(key)?.trim();
    if (value == null || value.isEmpty || _isPlaceholder(value)) {
      throw StateError('Missing $key in .env');
    }
    return value;
  }

  static bool _isPlaceholder(String value) =>
      value.startsWith('your') ||
      value.contains('...') ||
      value.contains('000000000000');
}
