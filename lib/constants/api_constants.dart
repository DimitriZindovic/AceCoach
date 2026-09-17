/// Endpoints, timeouts and `.env` keys. Values themselves live in `.env`.
abstract final class ApiConstants {
  // OpenWeatherMap
  static const String openWeatherBaseUrl = 'https://api.openweathermap.org';
  static const String openWeatherCurrentPath = '/data/2.5/weather';
  static const String openWeatherUnits = 'metric';
  static const Duration httpConnectTimeout = Duration(seconds: 10);
  static const Duration httpReceiveTimeout = Duration(seconds: 15);

  /// A weather snapshot older than this is refreshed on the next read.
  static const Duration weatherCacheDuration = Duration(minutes: 30);

  // Gemini (Firebase AI Logic)
  static const String defaultGeminiModel = 'gemini-2.5-flash';
  static const Duration aiTimeout = Duration(seconds: 45);

  // Location
  static const Duration locationTimeout = Duration(seconds: 8);

  // `.env` keys
  static const String envOpenWeatherApiKey = 'OPENWEATHER_API_KEY';
  static const String envGeminiModel = 'GEMINI_MODEL';
  static const String envFirebaseProjectId = 'FIREBASE_PROJECT_ID';
  static const String envFirebaseMessagingSenderId =
      'FIREBASE_MESSAGING_SENDER_ID';
  static const String envFirebaseStorageBucket = 'FIREBASE_STORAGE_BUCKET';
  static const String envFirebaseAuthDomain = 'FIREBASE_AUTH_DOMAIN';
  static const String envFirebaseAndroidApiKey = 'FIREBASE_ANDROID_API_KEY';
  static const String envFirebaseAndroidAppId = 'FIREBASE_ANDROID_APP_ID';
  static const String envFirebaseIosApiKey = 'FIREBASE_IOS_API_KEY';
  static const String envFirebaseIosAppId = 'FIREBASE_IOS_APP_ID';
  static const String envFirebaseIosBundleId = 'FIREBASE_IOS_BUNDLE_ID';
  static const String envGoogleServerClientId = 'GOOGLE_SERVER_CLIENT_ID';
  static const String envGoogleIosClientId = 'GOOGLE_IOS_CLIENT_ID';
}
