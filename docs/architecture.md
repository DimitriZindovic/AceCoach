# AceCoach — Architecture

> Status: **plan** (phase 1). Written before any feature code. Sections marked
> `PENDING DESIGN IMPORT` will be completed once the Claude Design project has
> been imported (see §9).

AceCoach is a Flutter (iOS + Android) app that generates personalised tennis
training sessions with Gemini, taking the day's weather into account. Sessions
can be saved locally and read offline.

---

## 1. Layer diagram

Strict one-way dependency. A layer may only import the layer directly below it.

```
┌────────────────────────────────────────────────────────────────┐
│  screens/  +  widgets/           (Flutter UI, ConsumerWidget)  │
│  ─ read/watch providers, dispatch intents, never touch I/O     │
└──────────────────────────────┬─────────────────────────────────┘
                               │ ref.watch / ref.read
┌──────────────────────────────▼─────────────────────────────────┐
│  providers/                 (Riverpod @riverpod code-gen)      │
│  ─ UI state machines: form, generation, history, weather, auth │
└──────────────────────────────┬─────────────────────────────────┘
                               │ plain Dart calls
┌──────────────────────────────▼─────────────────────────────────┐
│  repositories/              (single source of truth)           │
│  ─ orchestrate services, map exceptions → domain failures,     │
│    decide local vs remote                                      │
└──────────────────────────────┬─────────────────────────────────┘
                               │ plain Dart calls
┌──────────────────────────────▼─────────────────────────────────┐
│  services/                  (thin clients, no Riverpod import) │
│  AuthService · WeatherApiService · AiService · LocationService  │
│  LocalDatabaseService (drift)                                  │
└──────────────────────────────┬─────────────────────────────────┘
                               │
   Firebase Auth   OpenWeatherMap (dio)   Gemini   geolocator   SQLite
```

Rules enforced in code review and by `riverpod_lint`:

- `services/` never imports `package:flutter_riverpod` or `package:flutter/widgets.dart`.
- `repositories/` never import a screen or a provider.
- Screens never import `services/` or `dio`.
- Every service/repository instance is exposed to the graph through a
  provider in `providers/` (e.g. `sessionRepositoryProvider`), so tests can
  override it with `ProviderScope(overrides: [...])`.

`models/` are shared by all layers (pure Dart, `freezed` + `json_serializable`).

---

## 2. Screen list

| Screen | File | Purpose |
|---|---|---|
| Login | `screens/auth/login_screen.dart` | Email/password + Google sign-in, "forgot password" sheet |
| Register | `screens/auth/register_screen.dart` | Account creation with inline validation |
| Home | `screens/home/home_screen.dart` | Greeting, `WeatherChip`, "New session" CTA, recent sessions, bottom navigation |
| Session setup | `screens/session_setup/session_setup_screen.dart` | Multi-step parameter form (duration → level → strokes → goal → players) |
| Session result | `screens/session_result/session_result_screen.dart` | Generated plan, weather banner, Regenerate / Save actions |
| History | `screens/history/history_screen.dart` | Saved sessions, search + filters (level, stroke, date range), delete |
| Session detail | `screens/history/session_detail_screen.dart` | Full read-only view of a saved session (offline) |
| Profile | `screens/profile/profile_screen.dart` | Stats, personal info, theme, sign out |

Home, History and Profile share a bottom navigation bar inside a
`StatefulShellRoute` so each tab keeps its own navigation stack.

---

## 3. Route table (`go_router`)

| Path | Name | Screen | Guard |
|---|---|---|---|
| `/login` | `login` | `LoginScreen` | public (redirects to `/` when signed in) |
| `/register` | `register` | `RegisterScreen` | public (redirects to `/` when signed in) |
| `/` | `home` | `HomeScreen` | auth required — shell tab 0 |
| `/history` | `history` | `HistoryScreen` | auth required — shell tab 1 |
| `/history/:sessionId` | `sessionDetail` | `SessionDetailScreen` | auth required — pushed on tab 1 |
| `/profile` | `profile` | `ProfileScreen` | auth required — shell tab 2 |
| `/setup` | `sessionSetup` | `SessionSetupScreen` | auth required — full-screen, outside the shell |
| `/setup/result` | `sessionResult` | `SessionResultScreen` | auth required — full-screen, outside the shell |

Redirect guard (`app_router.dart`):

```
authState = ref.watch(authStateProvider)      // AsyncValue<AppUser?>
if authState.isLoading            → stay (splash / no redirect)
if user == null && !isAuthRoute   → '/login'
if user != null &&  isAuthRoute   → '/'
else                              → null
```

The router is itself a `@riverpod` provider (`appRouterProvider`) so the
redirect re-evaluates whenever the Firebase auth stream emits. A
`GoRouterRefreshStream`-style `Listenable` bridges the stream to
`refreshListenable`.

Each screen exposes `static const routePath` / `routeName` constants, mirroring
the `static const routeName` habit from `flutter_cours`.

---

## 4. Provider graph

All providers use `@riverpod` code generation. Naming: `xxxProvider` for
values, `XxxNotifier` classes for mutable state.

```
                 ┌────────────────────┐
                 │ firebaseAuth       │ (FirebaseAuth.instance)
                 └─────────┬──────────┘
                 ┌─────────▼──────────┐   ┌──────────────────┐
                 │ authService        │   │ googleSignIn     │
                 └─────────┬──────────┘   └────────┬─────────┘
                 ┌─────────▼─────────────────────────▼───────┐
                 │ authRepository                            │
                 └─────────┬──────────────────┬──────────────┘
        ┌──────────────────▼───┐   ┌──────────▼─────────────┐
        │ authState (Stream)   │   │ AuthController (async  │
        │ AsyncValue<AppUser?> │   │ sign-in/up/reset/out)  │
        └──────────┬───────────┘   └────────────────────────┘
                   │
       ┌───────────▼─────────┐
       │ appRouter           │  (redirect guard)
       └─────────────────────┘

┌──────────────┐ ┌──────────────────┐ ┌──────────────────────┐
│ dio          │ │ locationService  │ │ localDatabase (drift)│
└──────┬───────┘ └────────┬─────────┘ └──────────┬───────────┘
┌──────▼───────┐          │                      │
│ weatherApi   │          │                      │
│ Service      │          │                      │
└──────┬───────┘          │                      │
┌──────▼──────────────────▼──┐        ┌──────────▼───────────┐
│ weatherRepository          │        │ sessionRepository     │◄── aiService ◄── geminiModel
└──────┬─────────────────────┘        └──────────┬───────────┘
┌──────▼─────────────────────┐                   │
│ currentWeather             │                   │
│ AsyncValue<WeatherSnapshot>│                   │
│ (+ ManualCityNotifier)     │                   │
└──────┬─────────────────────┘                   │
       │        ┌────────────────────┐           │
       │        │ SessionFormNotifier│           │
       │        │ (SessionParams,    │           │
       │        │  step, validation) │           │
       │        └─────────┬──────────┘           │
       │                  │                      │
┌──────▼──────────────────▼──────────────────────▼───────┐
│ SessionGenerationNotifier                              │
│ AsyncValue<TrainingSession>  generate() / regenerate() │
│ save()                                                 │
└────────────────────────────────────────────────────────┘
                                                 │
┌────────────────────────────┐   ┌───────────────▼──────────┐
│ HistoryFilterNotifier      │──►│ sessionHistory (Stream)  │
│ (query, level, stroke,     │   │ AsyncValue<List<Training │
│  date range)               │   │ Session>>                │
└────────────────────────────┘   └───────────────┬──────────┘
                                 ┌───────────────▼──────────┐
                                 │ profileStats (derived)   │
                                 │ total, minutes, top      │
                                 │ stroke                   │
                                 └──────────────────────────┘
```

Files:

| File | Providers |
|---|---|
| `providers/auth_provider.dart` | `firebaseAuth`, `authService`, `authRepository`, `authState`, `AuthController` |
| `providers/weather_provider.dart` | `dio`, `weatherApiService`, `locationService`, `weatherRepository`, `ManualCityNotifier`, `currentWeather` |
| `providers/session_form_provider.dart` | `SessionFormNotifier` (holds `SessionParams` + current step + `isValid`) |
| `providers/session_generation_provider.dart` | `geminiModel`, `aiService`, `localDatabase`, `sessionRepository`, `SessionGenerationNotifier` |
| `providers/session_history_provider.dart` | `HistoryFilterNotifier`, `sessionHistory`, `profileStats` |

`SessionGenerationNotifier` is `keepAlive: false`: leaving the result screen
disposes the in-flight generation. `currentWeather` is cached for 30 minutes
via `ref.cacheFor` (a small extension) so tab switches do not refetch.

---

## 5. Data flow — external calls

### 5.1 Weather (OpenWeatherMap)

```
HomeScreen ──watch──► currentWeather
                        │
                        ▼
              weatherRepository.getCurrentWeather()
                        │
        ┌───────────────┼────────────────────────────┐
        ▼                                            ▼
locationService.getPosition()          (permission denied / timeout)
  geolocator: check → request → get                  │
        │                                            ▼
        ▼                                 ManualCityNotifier.city
weatherApiService.byCoordinates(lat, lon)  weatherApiService.byCity(name)
        │                                            │
        └──────────────► dio GET /data/2.5/weather ◄─┘
                         ?units=metric&appid=…
                                  │
                                  ▼
                    Weather.fromJson(json)  →  WeatherSnapshot
                    (temp, condition, wind, humidity, isRainy,
                     isOutdoorFriendly, fetchedAt, source)
```

Failure policy: any error becomes `WeatherFailure` (network, permission,
cityNotFound, unknown). The provider exposes `AsyncError`; the Home screen
renders the chip in its error state with a retry and a "Enter city" action.
Session generation **never awaits** weather: `SessionGenerationNotifier`
reads `currentWeather.valueOrNull` and proceeds with `null` if absent, setting
`TrainingSession.weatherUsed = false` so the result screen can say so.

### 5.2 AI generation (Gemini)

```
SessionSetupScreen ──"Generate"──► SessionGenerationNotifier.generate()
                                      │
                                      ├─ params  = ref.read(sessionFormProvider).params
                                      ├─ weather = ref.read(currentWeatherProvider).valueOrNull
                                      ▼
                          sessionRepository.generate(params, weather)
                                      │
                                      ▼
                          aiService.generateSession(params, weather)
                                      │
                    ┌─────────────────┼──────────────────────┐
                    ▼                 ▼                      ▼
          buildPrompt(params,   GenerationConfig(        responseSchema
          weather) — template   responseMimeType:        Schema.object({
          in api_contracts.md   'application/json')      title, summary,
                                                         warmUp, exercises[],
                                                         coolDown, …})
                    └─────────────────┬──────────────────────┘
                                      ▼
                      model.generateContent([Content.text(prompt)])
                                      │
                                      ▼
                     jsonDecode(text) → GeneratedSessionDto.fromJson
                                      │
                       validateDuration(dto, params.duration)
                       |Σ exercise minutes − requested| ≤ 10 %
                                      │
                                      ▼
                     TrainingSession (id = uuid v4, createdAt = now,
                     params, weather snapshot, exercises, isSaved=false)
```

Error mapping in `AiService` (never leaks raw exception text):

| Cause | `AiFailure` | UI copy |
|---|---|---|
| `SocketException`, `DioException` timeouts | `network` | "No connection. Check your network and retry." |
| `GenerativeAIException` with 429 / RESOURCE_EXHAUSTED | `quotaExceeded` | "The coach is busy right now. Try again in a minute." |
| `FormatException`, schema mismatch, duration check failed | `malformedResponse` | "The plan came back incomplete. Let's generate it again." |
| anything else | `unknown` | "Something went wrong. Please retry." |

`regenerate()` re-runs the same flow with a "propose a different plan than
the previous one" hint and shows the `LoadingOverlay` over the previous plan.
`save()` delegates to `sessionRepository.save(session)` → drift insert.

---

## 6. Local persistence (drift)

Choice: **drift** (`drift` + `drift_flutter` + `drift_dev`). It is actively
maintained, type-safe, code-generated like the rest of the stack, and its
reactive `watch()` queries feed the history list for free. `sqflite` would
force hand-written SQL and manual JSON round-trips for the exercise list.

`sqlite3_flutter_libs` is **not** added: its latest release is `0.6.0+eol`
and its pub.dev description reads "Not used anymore, update to version 3.x of
package:sqlite3 instead". `drift_flutter` 0.3.1 already depends on
`sqlite3 ^3.0.0`, which ships the native library itself.

Schema (version 1):

```
training_sessions
  id                    TEXT  PK           uuid v4
  user_id               TEXT  NOT NULL     Firebase uid — history is per account
  title                 TEXT  NOT NULL
  summary               TEXT  NOT NULL
  created_at            INT   NOT NULL     epoch ms, UTC
  duration_minutes      INT   NOT NULL     requested duration
  level                 TEXT  NOT NULL     enum name (beginner|intermediate|advanced)
  goal                  TEXT  NOT NULL     enum name (baseline|net|physical|mental)
  player_count          TEXT  NOT NULL     enum name (alone|partner|coach)
  strokes               TEXT  NOT NULL     comma-separated enum names
  weather_json          TEXT  NULL         WeatherSnapshot as JSON, null if unavailable
  weather_used          BOOL  NOT NULL
  completed_at          INT   NULL         set when the user marks it done (stats)

exercises
  id                    TEXT  PK           uuid v4
  session_id            TEXT  FK → training_sessions.id ON DELETE CASCADE
  position              INT   NOT NULL     order in the plan
  title                 TEXT  NOT NULL
  description           TEXT  NOT NULL
  estimated_minutes     INT   NOT NULL
  technical_tip         TEXT  NOT NULL
  phase                 TEXT  NOT NULL     warmUp | main | coolDown
  indoor_friendly       BOOL  NOT NULL

indexes: training_sessions(user_id, created_at DESC), exercises(session_id, position)
```

Queries exposed by `LocalDatabaseService`:

- `watchSessions(userId)` → `Stream<List<TrainingSession>>` (joins exercises)
- `insertSession(session)` — transaction: session row + exercise rows
- `deleteSession(id)`
- `markCompleted(id, DateTime)`

Search and filters (`HistoryFilterNotifier`) are applied **in Dart** on the
watched list: the data set is small (hundreds of rows at most), keeping the
logic unit-testable without a database. Stats for the profile screen are
derived the same way.

---

## 7. Models

| Model | Kind | Notes |
|---|---|---|
| `AppUser` | freezed | uid, email, displayName, photoUrl, createdAt |
| `SessionParams` | freezed | duration (int, 30–120 step 15), `SkillLevel`, `Set<Stroke>`, `TacticalGoal`, `PlayerCount` |
| `TrainingSession` | freezed + json | id, userId, title, summary, createdAt, params, weather?, weatherUsed, exercises, completedAt? |
| `Exercise` | freezed + json | title, description, estimatedDurationMinutes, technicalTip, phase, indoorFriendly |
| `WeatherSnapshot` | freezed + json | `fromJson` for the OWM payload + `fromOpenWeatherMap()` mapper; `isOutdoorFriendly` getter |

Enums (`SkillLevel`, `Stroke`, `TacticalGoal`, `PlayerCount`, `ExercisePhase`)
live next to `SessionParams` with a `label` getter and, where useful, an
`icon` getter, so widgets never switch on enum values.

---

## 8. Style arbitration (`flutter_cours` vs. this architecture)

Extracted from `~/Sites/flutter_cours` (11 files, ~1 000 lines):

- **Naming**: `snake_case` files, `PascalCase` widgets suffixed by role
  (`FiltersView`, `SettingsController`, `SettingsService`), `static const routeName`.
- **Class ordering**: constructor → `static const` → fields → `createState`/`build`.
- **Composition**: small UI pieces are top-level helper *functions*
  returning `Widget` (`sectionTitle`, `choiceChipItem`, `counterItem`).
- **Imports**: `package:flutter` first, then `package:<self>` or relative,
  groups separated by a blank line; relative imports inside a feature folder.
- **Quotes**: single quotes for imports, keys and route names; double quotes
  for user-visible copy.
- **Formatting**: Dart 3.x tall-style formatter output, `const` on
  constructors where the analyzer suggests it, explicit `MainAxisAlignment.x`
  (no dot-shorthand `.center`).
- **Comments**: `///` doc comment on every public class and method, short
  `//` comments explaining *why* before non-obvious blocks; English.
- **Colors**: hard-coded `Color(0xff8046EB)` literals; `withValues(alpha:)`
  for opacity.
- **State**: `ChangeNotifier` controller + plain service, glued with
  `ListenableBuilder`; `StatefulWidget` + `setState` for local form state.

Where the two conflict, **architecture wins for structure, `flutter_cours`
wins for style**:

| Topic | `flutter_cours` | Decision |
|---|---|---|
| State management | `ChangeNotifier` controllers | Riverpod `@riverpod` notifiers (architecture). Controller *naming* kept: `AuthController`, `SessionFormNotifier`. |
| Navigation | `onGenerateRoute` switch | `go_router` (architecture). `static const routePath` kept on every screen (style). |
| Colors | inline hex literals | Tokens in `app_colors.dart`, referenced through `Theme.of(context).colorScheme` and `AppColors` (architecture, required by the design-token rule). |
| Widget composition | public top-level helper functions | Screen-local pieces stay helper functions but **private** (`_sectionTitle`) to avoid a global namespace; anything reused across screens or holding state becomes a class in `widgets/` (architecture tree). |
| Local form state | `setState` | `setState` is kept for purely visual state (step animation, expanded/collapsed); form *data* lives in `SessionFormNotifier` so it survives navigation and is testable. |
| Quotes | mixed | Mirror the corpus: single quotes for code-level strings, double quotes for user-visible copy. `prefer_single_quotes` stays **off**. |
| Dot shorthands | not used | Not used, even though Dart 3.13 supports them. |

---

## 9. Design tokens — `PENDING DESIGN IMPORT`

The Claude Design project
`https://claude.ai/design/p/c3836bc8-b2ad-4392-a845-8b5514218b82` could not
be read from this session: no `claude_design` MCP server is configured and
`DesignSync` requires a one-time `/design-login` from an interactive session.
No palette has been invented in the meantime.

To fill in: colour palette (light/dark), type scale and font family, spacing
rhythm, corner radii, elevation, component anatomy for buttons / cards /
chips / slider / bottom bar, and the list of screens present in the design.
Everything in `constants/app_colors.dart`, `app_themes.dart` and
`app_spacing.dart` will be derived from those values.

---

## 10. Tooling facts recorded during planning

- Flutter 3.47.4 stable · Dart 3.13.3 (`~/flutter/bin`, not on the shell `PATH`).
- Existing project: `~/Sites/ace_coach` (package `ace_coach`), Android only —
  iOS must be added with `flutter create --platforms=ios .`.
- Not yet a git repository.
- `firebase` and `flutterfire` CLIs are not installed.
- pub.dev, 2026-09-17: flutter_riverpod 3.4.3 · riverpod_annotation 4.0.7 ·
  riverpod_generator 4.0.9 · riverpod_lint 3.1.9 · custom_lint 0.8.1 ·
  go_router 18.0.1 · firebase_core 4.15.0 · firebase_auth 6.7.0 ·
  google_sign_in 7.2.0 · dio 5.11.1 · freezed 4.0.1 · freezed_annotation 3.1.0 ·
  json_serializable 6.14.1 · json_annotation 4.12.0 · build_runner 2.16.1 ·
  drift 2.35.0 · drift_flutter 0.3.1 · drift_dev 2.35.0 ·
  google_generative_ai 0.4.7 (last release 2025-04, README marked
  **[Deprecated]** in favour of `firebase_ai` 4.0.0) · flutter_dotenv 6.0.1 ·
  geolocator 14.0.3 · google_fonts 8.2.1 · intl 0.20.3 · flutter_lints 6.0.0 ·
  mocktail 1.0.5 · uuid 4.6.0.

---

## 11. Open questions (blocking phase 2)

1. **Design import** — needs `/design-login` in an interactive Claude Code
   session on this machine, or the exported `AceCoach.dc.html` + `support.js`
   dropped into `design/` at the project root.
2. **Project location** — the spec says `acecoach_app/`; this plan assumes we
   build inside the existing `~/Sites/ace_coach` (package `ace_coach`) that is
   already open in the IDE.
3. **Gemini SDK** — the spec mandates `google_generative_ai`, whose README is
   now marked *Deprecated* by Google in favour of `firebase_ai` (Firebase AI
   Logic, same `responseSchema` / JSON-mode API, key stays server-side behind
   Firebase). Default if no answer: keep `google_generative_ai` as specified.
