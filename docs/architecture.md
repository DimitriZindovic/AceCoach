# AceCoach — Architecture

> Status: **as built**. Written as a plan before any feature code, then
> updated to match the shipped implementation.

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
| Splash | `screens/auth/splash_screen.dart` | Gradient splash while the first auth event resolves (design 01) |
| Login | `screens/auth/login_screen.dart` | Email/password + Google sign-in, "forgot password" sheet |
| Register | `screens/auth/register_screen.dart` | Account creation with inline validation |
| Home | `screens/home/home_screen.dart` | Greeting, `WeatherChip`, "New session" CTA, recent sessions, bottom navigation |
| Session setup | `screens/session_setup/session_setup_screen.dart` | Multi-step parameter form (duration → level → strokes → goal → players) |
| Session result | `screens/session_result/session_result_screen.dart` | Generated plan, weather banner, Regenerate / Save actions |
| History | `screens/history/history_screen.dart` | Saved sessions, search + filters (level, stroke, date range), delete |
| Session detail | `screens/history/session_detail_screen.dart` | Full read-only view of a saved session (offline) |
| Profile | `screens/profile/profile_screen.dart` | Stats, personal info, theme, sign out |

Home, New (setup), History and Profile are the four destinations of the
bottom navigation bar (as in the design), inside a `StatefulShellRoute` so each
tab keeps its own navigation stack. The result and detail screens are pushed on
the root navigator, above the bar.

---

## 3. Route table (`go_router`)

| Path | Name | Screen | Guard |
|---|---|---|---|
| `/splash` | `splash` | `SplashScreen` | shown while the first auth event is pending |
| `/login` | `login` | `LoginScreen` | public (redirects to `/` when signed in) |
| `/register` | `register` | `RegisterScreen` | public (redirects to `/` when signed in) |
| `/` | `home` | `HomeScreen` | auth required — shell tab 0 |
| `/setup` | `sessionSetup` | `SessionSetupScreen` | auth required — shell tab 1 |
| `/setup/result` | `sessionResult` | `SessionResultScreen` | auth required — root navigator (no bar) |
| `/history` | `history` | `HistoryScreen` | auth required — shell tab 2 |
| `/history/:sessionId` | `sessionDetail` | `SessionDetailScreen` | auth required — root navigator (no bar) |
| `/profile` | `profile` | `ProfileScreen` | auth required — shell tab 3 |

Redirect guard (`app_router.dart`):

```
auth = ref.read(authStateProvider)            // AsyncValue<AppUser?>
if auth.isLoading && !auth.hasValue → '/splash' (stay if already there)
if user == null                      → '/login' unless on an auth route
if user != null && (authRoute|splash)→ '/'
else                                 → null
```

The router is itself a `@riverpod` provider (`appRouterProvider`); it listens
to `authStateProvider` and pokes a `ChangeNotifier` passed as
`refreshListenable`, so the redirect re-evaluates whenever Firebase emits.

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
| `providers/app_settings_provider.dart` | `localDatabase`, `AppThemeMode`, `HomeCity` (both persisted in the drift key-value table) |
| `providers/auth_provider.dart` | `firebaseAuth`, `authService`, `authRepository`, `authState`, `currentUser`, `AuthController` |
| `providers/weather_provider.dart` | `dio`, `weatherApiService`, `locationService`, `weatherRepository`, `currentWeather` |
| `providers/session_form_provider.dart` | `SessionForm` (holds `SessionParams`; `isValid` lives on the model) |
| `providers/session_generation_provider.dart` | `aiService`, `sessionRepository`, `SessionGeneration` (`SessionGenerationState`: session / isGenerating / failure), `isCurrentSessionSaved` |
| `providers/session_history_provider.dart` | `sessionHistory`, `savedSession(id)`, `HistoryFilterNotifier`, `filteredHistory`, `profileStats`, `HistoryActions` |

`SessionGeneration` is `keepAlive: true` so the plan survives leaving and
re-entering the result screen; its state is an explicit three-state object
rather than an `AsyncValue`, because Riverpod 3 no longer lets a notifier keep
the previous value while loading, and the design shows the previous plan behind
the regeneration overlay. `currentWeather` is `keepAlive` and re-invalidates
itself after 30 minutes. The `ProviderContainer` is created with
`retry: (_, _) => null` so failing providers surface their error state at once
instead of retrying in the background.

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
  weather_advice        TEXT  NULL         one-sentence advice returned by the model
  prefer_indoor         BOOL  NOT NULL
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

app_settings
  key                   TEXT  PK           theme_mode | home_city
  value                 TEXT  NOT NULL

primary keys: training_sessions(id), exercises(session_id, position), app_settings(key)
```

Row classes are generated as `TrainingSessionRow` / `ExerciseRow` /
`AppSettingRow` (`@DataClassName`) so they never clash with the domain models.

Queries exposed by `LocalDatabaseService`:

- `watchSessions(userId)` → `Stream<List<TrainingSession>>` (joins exercises)
- `findSession(id)`
- `insertSession(session)` — transaction: session row + exercise rows
- `deleteSession(id)`
- `setCompleted(id, DateTime?)`
- `readSetting(key)` / `writeSetting(key, value)`

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
live next to their model with a `label` getter. Icons are mapped in the widget
layer (`goalIcon`, `weatherIcon`) so models never import Flutter.

`models/failures.dart` holds the sealed `AppFailure` hierarchy (`AiFailure`,
`WeatherFailure`, `AuthFailure`), each with a user-facing message, so raw
exception strings never reach a screen.

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

## 9. Design tokens (from `design/AceCoach.dc.html`)

The Claude Design project "AceCoach mobile app mockup" (7 frames, 360 × 640
at 1:3 of 1080 × 1920) is checked in under `design/` for reference. Every value
below is read from it; the only derived values are the dark-mode surfaces.

**Typography** — Poppins 400 / 500 / 600 / 700 (bundled, OFL).

| Slot | Size / weight | Used for |
|---|---|---|
| `displaySmall` | 40 / 700 | splash wordmark |
| `headlineMedium` | 26 / 700 | auth title |
| `headlineSmall` | 22 / 700 | greeting, result title |
| `titleLarge` | 20 / 700 | screen titles, stat values |
| `titleMedium` | 17 / 600 | app bar |
| `titleSmall` | 15 / 600 | section headings |
| `bodyLarge/Medium/Small` | 16 / 14 / 13 | body, inputs, meta |
| `labelLarge/Medium/Small` | 15 / 12 / 11 · 600 | buttons, chips, eyebrow |
| `sectionLabel`, `fieldLabel`, `caption`, `badge` | 13/600 · 11/600 · 12/400 · 10/600 | extension `AppTextStyles` |

**Colours** (`AppColors`)

| Token | Hex | Role |
|---|---|---|
| `primary` / `primaryDark` / `primaryDeep` | `#4CAF50` / `#2E7D32` / `#1B5E20` | brand greens |
| `primaryContainer` | `#E8F5E9` | icon boxes, duration badge |
| `lime` / `limeDark` | `#DCE775` / `#A8D24A` | accent, selected strokes, splash gradient |
| `ink` | `#101512` | text, dark surfaces (CTA card, result header) |
| `textSecondary` / `textTertiary` / `textDisabled` / `chevron` | `#5C6660` / `#8A948E` / `#A9B2AC` / `#C3CAC5` | text hierarchy |
| `background` / `canvas` / `surface` | `#FAFAFA` / `#EDEFEC` / `#FFFFFF` | grounds |
| `surfaceMuted` / `surfaceMutedAlt` / `hairline` / `outline` | `#F2F4F2` / `#F4F6F4` / `#EFF1EF` / `#E0E4E0` | chips, dividers, borders |
| `warningSurface` / `warningBorder` / `warningText` | `#FFF8E1` / `#F5E6A8` / `#6B5B12` | weather banner |
| `tipSurface` / `tipIcon` | `#FFFDF2` / `#B59A0A` | technical tip box |
| `error` / `errorContainer` | `#C62828` / `#FFCDD2` | destructive |
| `darkBackground` … `darkOutline` | `#101512` `#171C19` `#1F2521` `#242A26` `#2E352F` | **derived** dark surfaces |

**Shape and spacing** (`AppRadius`, `AppSpacing`, `AppSizes`, `AppShadows`)

- Radii: 8 badge · 10 icon box · 14 input / goal card · 16 button / banner ·
  18 card · 20 pill / CTA · 23 search · 34 phone frame.
- Screen padding 22 dp; section gap 18; component gaps 4 / 6 / 8 / 10 / 12 / 16.
- Buttons 50 dp (CTA 54), inputs 52, search 46, tap targets ≥ 48.
- Shadows: card `0 2 8 ink@5%`, primary glow `0 8 18 primary@32%`, brand glow
  `0 8 18 primaryDark@22%`.

**Screens covered by the design**: splash, login, home, setup, generated
session, history, profile. **Designed from the same tokens**: register,
forgot-password sheet, session detail (reuses the result anatomy), theme
sheet, home-city dialog, and every loading / error / empty state.

**Design vs. specification arbitration**

- The design shows the setup as a single scrolling page, not a stepper; the
  design wins (§1.1 of the brief makes it the source of truth for layouts).
- The design's bottom bar has four destinations including "New"; the setup
  screen is therefore a shell tab, not a full-screen push.
- "Players present" and the "indoor only" switch are not in the mockup; they
  use the pill and tile components already present on that screen.
- The design displays °F; the app stores and shows °C (`units=metric`).
- The history badge in the design ("SYNCED" / "LOCAL") maps to
  "DONE" / "PLANNED" since sessions are local only and completion feeds the
  stats.

## 10. Tooling facts recorded during planning

- Flutter 3.47.4 stable · Dart 3.13.3 (`~/flutter/bin`, not on the shell `PATH`).
- Existing project: `~/Sites/ace_coach` (package `ace_coach`), Android only —
  iOS must be added with `flutter create --platforms=ios .`.
- Not yet a git repository.
- `firebase` and `flutterfire` CLIs are not installed; CocoaPods and the
  Android SDK are missing on the build machine, so native builds were not run
  here (see README quality gates for what was verified).
- pub.dev, 2026-09-17: flutter_riverpod 3.4.3 · riverpod_annotation 4.0.7 ·
  riverpod_generator 4.0.9 · riverpod_lint 3.1.9 · custom_lint 0.8.1 ·
  go_router 18.0.1 · firebase_core 4.15.0 · firebase_auth 6.7.0 ·
  google_sign_in 7.2.0 · dio 5.11.1 · freezed 4.0.1 · freezed_annotation 3.1.0 ·
  json_serializable 6.14.1 · json_annotation 4.12.0 · build_runner 2.16.1 ·
  drift 2.35.0 · drift_flutter 0.3.1 · drift_dev 2.35.0 ·
  firebase_ai 4.0.0 (replaces `google_generative_ai`, whose README is marked
  **[Deprecated]** by Google) · flutter_dotenv 6.0.1 ·
  geolocator 14.0.3 · google_fonts 8.2.1 · intl 0.20.3 · flutter_lints 6.0.0 ·
  mocktail 1.0.5 · uuid 4.6.0.

---

## 11. Decisions taken after the plan review

1. **Project location** — built inside the existing `~/Sites/ace_coach`
   (package `ace_coach`, Android id `com.acecoach.ace_coach`, iOS bundle
   `com.acecoach.aceCoach`) instead of a new `acecoach_app/` folder.
2. **Gemini SDK** — `firebase_ai` (Firebase AI Logic) instead of the deprecated
   `google_generative_ai`. Same structured-output API; the Gemini key stays
   server-side behind the Firebase project, so `.env` only carries the model
   name.
3. **SQLite** — `sqlite3_flutter_libs` dropped (end of life); `drift_flutter`
   brings `sqlite3` 3.x with the native library.
4. **Lints** — `riverpod_lint` 3.1 is a native analyzer plugin declared under
   the top-level `plugins:` key; `custom_lint` is no longer needed and is
   incompatible with it, so it is not in the project.

## 12. Files added beyond the prescribed tree

| File | Why |
|---|---|
| `lib/firebase_options.dart` | Firebase options built from `.env` so no identifier is committed |
| `lib/models/failures.dart` | sealed domain failures shared by services, repositories and UI |
| `lib/providers/app_settings_provider.dart` | database instance, persisted theme mode and home city |
| `lib/router/app_shell.dart` | bottom navigation shell for `StatefulShellRoute` |
| `lib/screens/auth/splash_screen.dart` | design frame 01 |
| `lib/screens/auth/auth_form_widgets.dart` | validators, labelled field, error banner, Google glyph shared by login and register |
| `lib/widgets/app_logo.dart`, `goal_selector.dart`, `weather_alert_banner.dart`, `session_plan_header.dart`, `stat_tile.dart`, `home_city_dialog.dart` | components present in the design but absent from the prescribed widget list |
| `test/helpers/fixtures.dart`, `test/flutter_test_config.dart`, `test/screenshots/` | shared test data, offline fonts in tests, on-demand screenshot goldens |
| `assets/google_fonts/` | Poppins bundled (OFL) so the app and tests never fetch fonts |
| `design/` | the imported Claude Design source, kept as the visual reference |
