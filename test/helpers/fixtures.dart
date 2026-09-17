import 'package:ace_coach/models/app_user.dart';
import 'package:ace_coach/models/exercise.dart';
import 'package:ace_coach/models/session_params.dart';
import 'package:ace_coach/models/training_session.dart';
import 'package:ace_coach/models/weather.dart';

/// Shared test data.
abstract final class Fixtures {
  static const AppUser user = AppUser(
    uid: 'user-1',
    email: 'marc.delaunay@mail.com',
    displayName: 'Marc Delaunay',
  );

  /// A real `GET /data/2.5/weather` payload (metric), trimmed to the fields
  /// the app reads plus a few it ignores.
  static const Map<String, dynamic> openWeatherRainJson = {
    'coord': {'lon': 2.4353, 'lat': 48.8446},
    'weather': [
      {'id': 500, 'main': 'Rain', 'description': 'light rain', 'icon': '10d'},
    ],
    'base': 'stations',
    'main': {
      'temp': 17.4,
      'feels_like': 17.1,
      'temp_min': 16.2,
      'temp_max': 18.9,
      'pressure': 1009,
      'humidity': 82,
    },
    'visibility': 10000,
    'wind': {'speed': 4.6, 'deg': 230},
    'clouds': {'all': 90},
    'dt': 1758016800,
    'sys': {'country': 'FR', 'sunrise': 1757998412, 'sunset': 1758043251},
    'timezone': 7200,
    'id': 6455259,
    'name': 'Vincennes',
    'cod': 200,
  };

  static Weather get sunnyWeather => Weather(
    temperatureCelsius: 22,
    feelsLikeCelsius: 22,
    humidityPercent: 40,
    windSpeedMs: 2.5,
    conditionId: 800,
    condition: 'Clear',
    description: 'clear sky',
    iconCode: '01d',
    cityName: 'Vincennes',
    fetchedAt: DateTime(2026, 9, 16, 10),
  );

  static const Exercise warmUp = Exercise(
    title: 'Dynamic warm-up',
    description: 'Mini-tennis inside the service boxes, then lateral shuffles.',
    estimatedDurationMinutes: 10,
    technicalTip: 'Keep the wrist loose — feel the ball, don\'t push it.',
    phase: ExercisePhase.warmUp,
  );

  static const Exercise forehandDepth = Exercise(
    title: 'Cross-court forehand depth',
    description: 'Four sets of 12 balls landing behind the service line.',
    estimatedDurationMinutes: 20,
    technicalTip: '',
  );

  /// Valid structured output, as Gemini returns it in JSON mode.
  static const String aiResponseJson = '''
{
  "title": "Aggressive baseline & first serve",
  "summary": "Build depth from the baseline, then convert with the first serve.",
  "weatherAdvice": "22°C and sunny — outdoor court, hydrate every 20 min.",
  "exercises": [
    {"title": "Dynamic warm-up", "description": "Mini-tennis inside the service boxes, then lateral shuffles.", "estimatedDurationMinutes": 10, "technicalTip": "Keep the wrist loose.", "phase": "warmUp", "indoorFriendly": true},
    {"title": "Cross-court forehand depth", "description": "Four sets of 12 balls landing behind the service line.", "estimatedDurationMinutes": 20, "technicalTip": "Finish the swing high and across the body.", "phase": "main", "indoorFriendly": true},
    {"title": "First-serve targets", "description": "Cones in the T and wide corners, 5 x 10 serves alternating sides.", "estimatedDurationMinutes": 25, "technicalTip": "Toss slightly into the court.", "phase": "main", "indoorFriendly": true},
    {"title": "Point play: serve + 1", "description": "Serve then attack the first ball, 3 games to 4 points.", "estimatedDurationMinutes": 15, "technicalTip": "Split-step as the return is struck.", "phase": "main", "indoorFriendly": false},
    {"title": "Cool-down", "description": "Easy jog and static stretching for the shoulders and hips.", "estimatedDurationMinutes": 5, "technicalTip": "Breathe out on every stretch.", "phase": "coolDown", "indoorFriendly": true}
  ]
}
''';

  static TrainingSession session({
    String id = 'session-1',
    String title = 'Aggressive baseline & first serve',
    DateTime? createdAt,
    SkillLevel level = SkillLevel.intermediate,
    Set<Stroke> strokes = const {Stroke.forehand, Stroke.serve},
    int durationMinutes = 75,
    DateTime? completedAt,
    List<Exercise> exercises = const [warmUp, forehandDepth],
  }) {
    return TrainingSession(
      id: id,
      userId: user.uid,
      title: title,
      summary: 'Build depth from the baseline, then convert with the serve.',
      createdAt: createdAt ?? DateTime(2026, 9, 15, 18),
      params: SessionParams(
        durationMinutes: durationMinutes,
        level: level,
        strokes: strokes,
      ),
      exercises: exercises,
      weather: sunnyWeather,
      weatherUsed: true,
      weatherAdvice: '22°C and sunny — outdoor court, hydrate every 20 min.',
      completedAt: completedAt,
    );
  }
}
