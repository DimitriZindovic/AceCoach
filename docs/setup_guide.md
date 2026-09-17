# AceCoach — Setup guide

## 1. Prerequisites

| Tool | Version used |
|---|---|
| Flutter (stable) | 3.47.4 — Dart 3.13.3 |
| Xcode | 16+ with an iOS 17+ simulator |
| Android Studio / SDK | API 35, JDK 17 |
| CocoaPods | latest (`sudo gem install cocoapods`) |
| A Firebase project | free Spark plan is enough |
| An OpenWeatherMap account | free tier |

```bash
flutter doctor
```

## 2. Clone and install

```bash
git clone <repository-url> ace_coach
cd ace_coach
flutter pub get
dart run build_runner build --delete-conflicting-outputs
```

Generated files (`*.g.dart`, `*.freezed.dart`) are committed, so the last step
is only needed after editing a model, a provider or the database.

## 3. Firebase project (Android + iOS)

1. Go to <https://console.firebase.google.com> → **Add project**.
2. **Authentication → Sign-in method**: enable **Email/Password** and
   **Google**. Set a support email for Google.
3. **Build → Firebase AI Logic → Get started**, choose the **Gemini Developer
   API** backend. This is what `firebase_ai` calls; no Gemini API key ever
   ships in the app.
4. **Project settings → Your apps → Add app**:
   - **Android**: package name `com.acecoach.ace_coach`. Add the SHA-1 and
     SHA-256 of your debug keystore (`cd android && ./gradlew signingReport`)
     so Google Sign-In works. Download nothing yet.
   - **iOS**: bundle id `com.acecoach.aceCoach` (see
     `ios/Runner.xcodeproj`). Download `GoogleService-Info.plist` — it is only
     needed to copy values from; the app reads its config from `.env`.
5. Copy the identifiers into `.env` (next section). You can read them from
   **Project settings → General → Your apps → SDK setup and configuration**
   or from the downloaded `google-services.json` / `GoogleService-Info.plist`.

### Google Sign-In client ids

- **Web client id** (`GOOGLE_SERVER_CLIENT_ID`): Firebase creates it when you
  enable Google sign-in. Find it in **Google Cloud console → APIs & Services →
  Credentials → OAuth 2.0 Client IDs → Web client (auto created by Google
  Service)**. Android needs it to obtain an ID token.
- **iOS client id** (`GOOGLE_IOS_CLIENT_ID`): the `CLIENT_ID` value in
  `GoogleService-Info.plist`. Also add it to `ios/Runner/Info.plist` together
  with its reversed form as a URL scheme:

```xml
<key>GIDClientID</key>
<string>000000000000-yyyy.apps.googleusercontent.com</string>
<key>CFBundleURLTypes</key>
<array>
  <dict>
    <key>CFBundleURLSchemes</key>
    <array>
      <string>com.googleusercontent.apps.000000000000-yyyy</string>
    </array>
  </dict>
</array>
```

## 4. OpenWeatherMap key

Create a key at <https://home.openweathermap.org/api_keys> (activation takes
up to two hours). The app uses the free **Current Weather Data** endpoint.

## 5. `.env`

```bash
cp .env.example .env
```

Fill in every value. `.env` is git-ignored **and** bundled as a Flutter asset:
the build fails if the file is missing, and the app shows a "Configuration
needed" screen if a Firebase value is still a placeholder.

| Key | Where to find it |
|---|---|
| `OPENWEATHER_API_KEY` | OpenWeatherMap → API keys |
| `GEMINI_MODEL` | any JSON-mode Gemini model, e.g. `gemini-2.5-flash` |
| `FIREBASE_PROJECT_ID`, `FIREBASE_MESSAGING_SENDER_ID`, `FIREBASE_STORAGE_BUCKET`, `FIREBASE_AUTH_DOMAIN` | Firebase → Project settings → General |
| `FIREBASE_ANDROID_API_KEY`, `FIREBASE_ANDROID_APP_ID` | `google-services.json` → `api_key.current_key`, `client_info.mobilesdk_app_id` |
| `FIREBASE_IOS_API_KEY`, `FIREBASE_IOS_APP_ID`, `FIREBASE_IOS_BUNDLE_ID` | `GoogleService-Info.plist` → `API_KEY`, `GOOGLE_APP_ID`, `BUNDLE_ID` |
| `GOOGLE_SERVER_CLIENT_ID` | Google Cloud → Credentials → Web client |
| `GOOGLE_IOS_CLIENT_ID` | `GoogleService-Info.plist` → `CLIENT_ID` |

## 6. Platform permissions

Already declared in the project:

- **Android** (`android/app/src/main/AndroidManifest.xml`): `INTERNET`,
  `ACCESS_COARSE_LOCATION`, `ACCESS_FINE_LOCATION`.
- **iOS** (`ios/Runner/Info.plist`): `NSLocationWhenInUseUsageDescription`.

Location is optional: when denied, the home screen offers to enter a city.

## 7. Run

```bash
flutter devices
flutter run -d <device-id>          # debug
flutter run --release -d <device-id>
```

First iOS run: `cd ios && pod install && cd ..` if Flutter does not do it.

## 8. Quality gates

```bash
flutter analyze        # must print "No issues found!"
flutter test           # unit + widget tests
dart format --set-exit-if-changed lib test
```

`riverpod_lint` runs inside `flutter analyze` (native analyzer plugin declared
in `analysis_options.yaml`), so no extra command is needed.

## 9. Troubleshooting

| Symptom | Fix |
|---|---|
| Build error "No file or variants found for asset: .env" | `cp .env.example .env` |
| "Configuration needed" screen at launch | a `FIREBASE_*` value is missing or still a placeholder |
| Google sign-in returns to the app without signing in (Android) | SHA-1 missing in Firebase, or wrong `GOOGLE_SERVER_CLIENT_ID` |
| `PlatformException(sign_in_failed)` on iOS | `GIDClientID` / URL scheme missing in `Info.plist` |
| AI generation fails with "Too many requests" | Gemini free-tier quota; wait a minute |
| AI generation fails immediately with "Generation failed" | Firebase AI Logic not enabled for the project, or the Gemini Developer API is disabled in Google Cloud |
