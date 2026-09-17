abstract final class ApiConstants {
  static const String openWeatherBaseUrl = 'https://api.openweathermap.org';
  static const String openWeatherCurrentPath = '/data/2.5/weather';
  static const String openWeatherUnits = 'metric';
  static const Duration httpConnectTimeout = Duration(seconds: 10);
  static const Duration httpReceiveTimeout = Duration(seconds: 15);

  static const Duration weatherCacheDuration = Duration(minutes: 30);

  static const String defaultGeminiModel = 'gemini-2.5-flash';
  static const Duration aiTimeout = Duration(seconds: 45);

  static const Duration locationTimeout = Duration(seconds: 8);

  static const String openWeatherApiKey = String.fromEnvironment(
    'OPENWEATHER_API_KEY',
  );

  static const String geminiModel = String.fromEnvironment(
    'GEMINI_MODEL',
    defaultValue: defaultGeminiModel,
  );
}
