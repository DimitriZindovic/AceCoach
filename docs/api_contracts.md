# AceCoach — API contracts

Two external calls: OpenWeatherMap for today's conditions and Gemini (through
Firebase AI Logic) for the session itself. Keys and identifiers live in `.env`
(see `docs/setup_guide.md`).

---

## 1. OpenWeatherMap — current weather

| | |
|---|---|
| Client | `lib/services/weather_api_service.dart` (dio) |
| Base URL | `https://api.openweathermap.org` |
| Path | `GET /data/2.5/weather` |
| Query (device) | `lat=<double>&lon=<double>&units=metric&appid=<OPENWEATHER_API_KEY>` |
| Query (city fallback) | `q=<city>&units=metric&appid=<OPENWEATHER_API_KEY>` |
| Timeouts | connect 10 s · receive 15 s |
| Cache | 30 minutes in `currentWeatherProvider`, refreshed on pull-to-refresh or when the home city changes |

### Sample request

```
GET https://api.openweathermap.org/data/2.5/weather?lat=48.8446&lon=2.4353&units=metric&appid=••••
```

### Sample response (200)

```json
{
  "coord": { "lon": 2.4353, "lat": 48.8446 },
  "weather": [
    { "id": 500, "main": "Rain", "description": "light rain", "icon": "10d" }
  ],
  "base": "stations",
  "main": {
    "temp": 17.4,
    "feels_like": 17.1,
    "temp_min": 16.2,
    "temp_max": 18.9,
    "pressure": 1009,
    "humidity": 82
  },
  "visibility": 10000,
  "wind": { "speed": 4.6, "deg": 230 },
  "clouds": { "all": 90 },
  "dt": 1758016800,
  "sys": { "country": "FR", "sunrise": 1757998412, "sunset": 1758043251 },
  "timezone": 7200,
  "id": 6455259,
  "name": "Vincennes",
  "cod": 200
}
```

### Fields read by `Weather.fromOpenWeatherMap`

| JSON path | Model field | Notes |
|---|---|---|
| `main.temp` | `temperatureCelsius` | required, `FormatException` otherwise |
| `main.feels_like` | `feelsLikeCelsius` | defaults to `temp` |
| `main.humidity` | `humidityPercent` | defaults to 0 |
| `wind.speed` | `windSpeedMs` | m/s, defaults to 0 |
| `weather[0].id` | `conditionId` | drives `isRainy` (< 700), `verdict` |
| `weather[0].main` / `.description` / `.icon` | `condition`, `description`, `iconCode` | |
| `name` | `cityName` | |

Derived: `verdict` = `indoor` when rainy/stormy, `caution` when wind ≥ 10 m/s,
temperature ≥ 34 °C or ≤ 3 °C, otherwise `ideal`.

### Error mapping (`WeatherFailure`)

| HTTP / transport | `WeatherFailureKind` | UI |
|---|---|---|
| timeout, connection error | `network` | chip error state, retry icon |
| 401 | `unauthorized` | chip error state |
| 404 with `q=` | `cityNotFound` | chip error state |
| geolocator permission denied / service off | `locationDenied` | "Enter city" action |
| any other | `unknown` | chip error state |

A weather failure never blocks generation: the AI prompt is built without the
weather block and the result screen shows "Generated without today's weather".

---

## 2. Gemini — session generation (Firebase AI Logic)

| | |
|---|---|
| Client | `lib/services/ai_service.dart` (`firebase_ai`) |
| Backend | `FirebaseAI.googleAI()` (Gemini Developer API behind Firebase; no API key in the app) |
| Model | `GEMINI_MODEL` from `.env`, default `gemini-2.5-flash` |
| Generation config | `temperature: 0.8`, `responseMimeType: application/json`, `responseSchema` below |
| Timeout | 45 s |
| Retry | one automatic retry with `strictDuration` when the drills do not add up to the requested duration (±10 %) |

### System instruction

```
You are AceCoach, an experienced tennis coach who designs precise, safe and
motivating training sessions. You always answer with JSON that matches the
provided schema, written in English.
```

### Prompt template (`AiService.buildPrompt`)

```
Design a complete tennis training session.

Constraints:
- Total duration: exactly {duration} minutes. The sum of all estimatedDurationMinutes MUST equal {duration}.
- Player level: {Beginner|Intermediate|Advanced}.
- Strokes to work on: {Forehand, Serve, …}.
- Tactical goal: {Baseline play|Net approach|Physical|Mental}.
- Players on court: {Alone|With a partner|With a coach}.
- Weather right now: {temp}°C (feels like {feels}°C), {condition}, wind {km/h} km/h, humidity {h}%. Outdoor play is {suitable|not recommended}.
  ┆ or, when unavailable:
- Weather: unknown. Assume a standard outdoor hard court.
[- Because of the weather, favour drills that work on an indoor court and mark them indoorFriendly=true.]      ← when the weather is not outdoor-friendly
[- The session MUST be fully playable indoors: every exercise has indoorFriendly=true and needs no sun, wind or extra space.]  ← when the user chose "Indoor court only"
[- Propose a clearly different plan from the previous one titled "{previousTitle}": change the drills, not just the wording.]  ← on Regenerate
[- Your previous answer did not add up to {duration} minutes. Double-check the arithmetic before answering.]  ← on the automatic retry

Structure: one warm-up (phase "warmUp"), three to five main drills (phase "main"), one cool-down (phase "coolDown"). Between 4 and 8 exercises in total, each with a concrete title, a description with sets, repetitions and targets, a duration in whole minutes and one technical tip.
```

### Response schema (`AiService.responseSchema`)

Expressed as JSON Schema; the Dart code builds the equivalent `Schema` object.

```json
{
  "type": "object",
  "required": ["title", "summary", "exercises"],
  "properties": {
    "title":   { "type": "string", "description": "Short, motivating session title (max 6 words)." },
    "summary": { "type": "string", "description": "One or two sentences describing the session focus." },
    "weatherAdvice": {
      "type": "string", "nullable": true,
      "description": "One practical sentence tied to the weather (court choice, hydration, clothing). Empty string when weather is unknown."
    },
    "exercises": {
      "type": "array", "minItems": 3,
      "items": {
        "type": "object",
        "required": ["title", "description", "estimatedDurationMinutes", "technicalTip", "phase", "indoorFriendly"],
        "properties": {
          "title":       { "type": "string" },
          "description": { "type": "string" },
          "estimatedDurationMinutes": { "type": "integer", "minimum": 3, "maximum": 60 },
          "technicalTip": { "type": "string" },
          "phase":        { "type": "string", "enum": ["warmUp", "main", "coolDown"] },
          "indoorFriendly": { "type": "boolean" }
        }
      }
    }
  }
}
```

### Sample generated session

Request: 75 min · Intermediate · Forehand, Serve · Baseline play · With a
partner · 22 °C clear sky.

```json
{
  "title": "Aggressive baseline & first serve",
  "summary": "Build depth from the baseline, then convert with the first serve.",
  "weatherAdvice": "22°C and sunny — outdoor court, hydrate every 20 min.",
  "exercises": [
    { "title": "Dynamic warm-up", "description": "Mini-tennis inside the service boxes, then lateral shuffles.", "estimatedDurationMinutes": 10, "technicalTip": "Keep the wrist loose — feel the ball, don't push it.", "phase": "warmUp", "indoorFriendly": true },
    { "title": "Cross-court forehand depth", "description": "Four sets of 12 balls, landing behind the service line. Finish the swing high and across the body for topspin.", "estimatedDurationMinutes": 20, "technicalTip": "Load the outside leg before contact.", "phase": "main", "indoorFriendly": true },
    { "title": "First-serve targets", "description": "Cones in the T and wide corners, 5 × 10 serves alternating sides.", "estimatedDurationMinutes": 25, "technicalTip": "Toss slightly into the court.", "phase": "main", "indoorFriendly": true },
    { "title": "Point play: serve + 1", "description": "Serve then attack the first ball, 3 games to 4 points.", "estimatedDurationMinutes": 15, "technicalTip": "Split-step as the return is struck.", "phase": "main", "indoorFriendly": false },
    { "title": "Cool-down", "description": "Easy jog and static stretching for the shoulders and hips.", "estimatedDurationMinutes": 5, "technicalTip": "Breathe out on every stretch.", "phase": "coolDown", "indoorFriendly": true }
  ]
}
```

### Parsing and validation (`AiService.parseDraft`)

1. `jsonDecode` — a `FormatException` becomes `AiFailure.malformedResponse`.
2. Root must be an object with non-empty `title`, `summary` and `exercises`.
3. Every exercise needs a non-empty title and description and a positive
   duration; unknown `phase` values fall back to `main`, missing
   `indoorFriendly` to `true`.
4. `SessionRepository.generate` checks the duration: the sum of the drills must
   be within 10 % (rounded up) of the requested duration. One retry, then
   `AiFailure.malformedResponse`.

### Error mapping (`AiFailure`)

| Cause | `AiFailureKind` | Title / message shown |
|---|---|---|
| `SocketException`, `TimeoutException`, messages containing "network"/"connection" | `network` | "You are offline" — "No connection. Check your network and try again." |
| `ServerException` with 429 / quota / RESOURCE_EXHAUSTED / rate limit | `quotaExceeded` | "Too many requests" — "The coach is busy right now. Try again in a minute." |
| invalid JSON, schema mismatch, duration check failed | `malformedResponse` | "Incomplete plan" — "The plan came back incomplete. Let's generate it again." |
| anything else | `unknown` | "Generation failed" — "Something went wrong while building your session. Please retry." |

Every failure offers a retry: an empty result screen shows "Try again"; a
failed regeneration keeps the previous plan and shows a snackbar with "Retry".
