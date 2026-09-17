/// Domain failures surfaced to the UI. Each carries a user-facing [message]
/// so screens never display raw exception strings.
sealed class AppFailure implements Exception {
  const AppFailure(this.message);

  final String message;

  @override
  String toString() => '$runtimeType: $message';
}

enum AiFailureKind { network, quotaExceeded, malformedResponse, unknown }

/// Failure raised while generating a session with Gemini.
class AiFailure extends AppFailure {
  const AiFailure(this.kind, String message, {this.cause}) : super(message);

  const AiFailure.network([Object? cause])
    : this(
        AiFailureKind.network,
        'No connection. Check your network and try again.',
        cause: cause,
      );

  const AiFailure.quotaExceeded([Object? cause])
    : this(
        AiFailureKind.quotaExceeded,
        'The coach is busy right now. Try again in a minute.',
        cause: cause,
      );

  const AiFailure.malformedResponse([Object? cause])
    : this(
        AiFailureKind.malformedResponse,
        'The plan came back incomplete. Let\'s generate it again.',
        cause: cause,
      );

  const AiFailure.unknown([Object? cause])
    : this(
        AiFailureKind.unknown,
        'Something went wrong while building your session. Please retry.',
        cause: cause,
      );

  final AiFailureKind kind;
  final Object? cause;

  String get title => switch (kind) {
    AiFailureKind.network => 'You are offline',
    AiFailureKind.quotaExceeded => 'Too many requests',
    AiFailureKind.malformedResponse => 'Incomplete plan',
    AiFailureKind.unknown => 'Generation failed',
  };
}

enum WeatherFailureKind {
  network,
  locationDenied,
  locationUnavailable,
  cityNotFound,
  unauthorized,
  malformedResponse,
  unknown,
}

/// Failure raised while fetching the weather. Never blocks generation.
class WeatherFailure extends AppFailure {
  const WeatherFailure(this.kind, String message, {this.cause})
    : super(message);

  const WeatherFailure.network([Object? cause])
    : this(
        WeatherFailureKind.network,
        'Weather unavailable offline.',
        cause: cause,
      );

  const WeatherFailure.locationDenied()
    : this(
        WeatherFailureKind.locationDenied,
        'Location access denied. Enter your city to get the weather.',
      );

  const WeatherFailure.locationUnavailable([Object? cause])
    : this(
        WeatherFailureKind.locationUnavailable,
        'Could not read your location. Enter your city instead.',
        cause: cause,
      );

  const WeatherFailure.cityNotFound(String city)
    : this(WeatherFailureKind.cityNotFound, 'No weather found for "$city".');

  const WeatherFailure.unauthorized()
    : this(
        WeatherFailureKind.unauthorized,
        'Weather service rejected the API key.',
      );

  const WeatherFailure.malformedResponse([Object? cause])
    : this(
        WeatherFailureKind.malformedResponse,
        'Weather data could not be read.',
        cause: cause,
      );

  const WeatherFailure.unknown([Object? cause])
    : this(
        WeatherFailureKind.unknown,
        'Weather unavailable right now.',
        cause: cause,
      );

  final WeatherFailureKind kind;
  final Object? cause;

  /// The manual-city fallback only makes sense for location problems.
  bool get needsCity =>
      kind == WeatherFailureKind.locationDenied ||
      kind == WeatherFailureKind.locationUnavailable;
}

enum AuthFailureKind {
  invalidEmail,
  userNotFound,
  wrongPassword,
  emailAlreadyInUse,
  weakPassword,
  userDisabled,
  tooManyRequests,
  network,
  cancelled,
  unknown,
}

/// Failure raised by the authentication flow, mapped from Firebase codes.
class AuthFailure extends AppFailure {
  const AuthFailure(this.kind, String message) : super(message);

  /// Maps a `FirebaseAuthException.code` to a friendly failure.
  factory AuthFailure.fromCode(String code) => switch (code) {
    'invalid-email' => const AuthFailure(
      AuthFailureKind.invalidEmail,
      'This email address is not valid.',
    ),
    'user-not-found' => const AuthFailure(
      AuthFailureKind.userNotFound,
      'No account matches this email.',
    ),
    'wrong-password' ||
    'invalid-credential' ||
    'INVALID_LOGIN_CREDENTIALS' => const AuthFailure(
      AuthFailureKind.wrongPassword,
      'Incorrect email or password.',
    ),
    'email-already-in-use' => const AuthFailure(
      AuthFailureKind.emailAlreadyInUse,
      'An account already exists with this email.',
    ),
    'weak-password' => const AuthFailure(
      AuthFailureKind.weakPassword,
      'Choose a stronger password (at least 8 characters).',
    ),
    'user-disabled' => const AuthFailure(
      AuthFailureKind.userDisabled,
      'This account has been disabled.',
    ),
    'too-many-requests' => const AuthFailure(
      AuthFailureKind.tooManyRequests,
      'Too many attempts. Please wait a moment and retry.',
    ),
    'network-request-failed' => const AuthFailure.network(),
    _ => const AuthFailure.unknown(),
  };

  const AuthFailure.network()
    : this(
        AuthFailureKind.network,
        'No connection. Check your network and retry.',
      );

  const AuthFailure.cancelled()
    : this(AuthFailureKind.cancelled, 'Sign-in was cancelled.');

  const AuthFailure.unknown()
    : this(AuthFailureKind.unknown, 'Something went wrong. Please try again.');

  final AuthFailureKind kind;

  bool get isCancelled => kind == AuthFailureKind.cancelled;
}
