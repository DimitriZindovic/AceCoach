import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:firebase_ai/firebase_ai.dart';

import '../constants/api_constants.dart';
import '../models/app_exception.dart';
import '../models/exercise.dart';
import '../models/session_params.dart';
import '../models/weather.dart';

enum AiBackend {
  agentPlatform,
  googleAI;

  static AiBackend? fromName(String? value) {
    if (value == null) return null;
    final normalized = value.trim().toLowerCase();
    for (final backend in AiBackend.values) {
      if (backend.name.toLowerCase() == normalized) return backend;
    }
    return null;
  }
}

class AiSessionDraft {
  const AiSessionDraft({
    required this.title,
    required this.summary,
    required this.exercises,
    this.weatherAdvice,
  });

  final String title;
  final String summary;
  final List<Exercise> exercises;
  final String? weatherAdvice;

  int get totalMinutes =>
      exercises.fold(0, (sum, e) => sum + e.estimatedDurationMinutes);
}

class AiService {
  AiService(GenerativeModel model)
    : _modelName = 'gemini-3.6-flash',
      _backends = const [AiBackend.agentPlatform],
      _injectedModel = model;

  AiService.fromFirebase({String? modelName, AiBackend? backend})
    : _modelName = modelName ?? 'gemini-3.6-flash',
      _backends = backend == null ? AiBackend.values : [backend],
      _injectedModel = null;

  final String _modelName;
  final List<AiBackend> _backends;
  final GenerativeModel? _injectedModel;
  final Map<AiBackend, GenerativeModel> _models = {};

  AiBackend? _activeBackend;

  AiBackend? get activeBackend => _activeBackend;

  static const int _maxAttempts = 2;
  static const Duration _retryDelay = Duration(seconds: 1);

  static const String systemInstruction =
      'You are AceCoach, an experienced tennis coach who designs precise, '
      'safe and motivating training sessions. You always answer with JSON '
      'that matches the provided schema, written in English.';

  static final Schema responseSchema = Schema.object(
    properties: {
      'title': Schema.string(
        description: 'Short, motivating session title (max 6 words).',
      ),
      'summary': Schema.string(
        description: 'One or two sentences describing the session focus.',
      ),
      'weatherAdvice': Schema.string(
        description:
            'One practical sentence tied to the weather (court choice, '
            'hydration, clothing). Empty string when weather is unknown.',
        nullable: true,
      ),
      'exercises': Schema.array(
        minItems: 3,
        items: Schema.object(
          properties: {
            'title': Schema.string(description: 'Concrete drill name.'),
            'description': Schema.string(
              description:
                  'How to run the drill: sets, repetitions, targets, court '
                  'zones. Two to four sentences.',
            ),
            'estimatedDurationMinutes': Schema.integer(
              description: 'Duration of the drill in whole minutes.',
              minimum: 3,
              maximum: 60,
            ),
            'technicalTip': Schema.string(
              description: 'One technical cue the player should focus on.',
            ),
            'phase': Schema.enumString(
              enumValues: ExercisePhase.values.map((p) => p.name).toList(),
            ),
            'indoorFriendly': Schema.boolean(
              description: 'True when the drill works on an indoor court.',
            ),
          },
        ),
      ),
    },
    optionalProperties: ['weatherAdvice'],
  );

  static String buildPrompt(
    SessionParams params, {
    Weather? weather,
    String? previousTitle,
    bool strictDuration = false,
  }) {
    final duration = params.durationMinutes;
    final buffer = StringBuffer()
      ..writeln('Design a complete tennis training session.')
      ..writeln()
      ..writeln('Constraints:')
      ..writeln(
        '- Total duration: exactly $duration minutes. The sum of all '
        'estimatedDurationMinutes MUST equal $duration.',
      )
      ..writeln('- Player level: ${params.level.label}.')
      ..writeln('- Strokes to work on: ${params.strokesLabel}.')
      ..writeln('- Players on court: ${params.players.label}.');

    if (weather != null) {
      buffer.writeln('- Weather right now: ${weather.promptDescription}');
      if (!weather.isOutdoorFriendly) {
        buffer.writeln(
          '- Because of the weather, favour drills that work on an indoor '
          'court and mark them indoorFriendly=true.',
        );
      }
    } else {
      buffer.writeln(
        '- Weather: unknown. Assume a standard outdoor hard court.',
      );
    }

    if (params.preferIndoor) {
      buffer.writeln(
        '- The session MUST be fully playable indoors: every exercise has '
        'indoorFriendly=true and needs no sun, wind or extra space.',
      );
    }

    if (previousTitle != null) {
      buffer.writeln(
        '- Propose a clearly different plan from the previous one titled '
        '"$previousTitle": change the drills, not just the wording.',
      );
    }

    if (strictDuration) {
      buffer.writeln(
        '- Your previous answer did not add up to $duration minutes. '
        'Double-check the arithmetic before answering.',
      );
    }

    buffer
      ..writeln()
      ..writeln(
        'Structure: one warm-up (phase "warmUp"), three to five main drills '
        '(phase "main"), one cool-down (phase "coolDown"). Between 4 and 8 '
        'exercises in total, each with a concrete title, a description with '
        'sets, repetitions and targets, a duration in whole minutes and one '
        'technical tip.',
      );
    return buffer.toString();
  }

  Future<AiSessionDraft> generateSession(
    SessionParams params, {
    Weather? weather,
    String? previousTitle,
    bool strictDuration = false,
  }) async {
    final prompt = buildPrompt(
      params,
      weather: weather,
      previousTitle: previousTitle,
      strictDuration: strictDuration,
    );

    final text = await _requestJson(prompt);

    if (text == null || text.trim().isEmpty) {
      throw const AppException(
        "The plan came back incomplete. Let's generate it again.",
      );
    }
    return parseDraft(text, requestedMinutes: params.durationMinutes);
  }

  Future<String?> _requestJson(String prompt) async {
    final active = _activeBackend;
    final candidates = active == null ? _backends : <AiBackend>[active];

    var failure = const AppException(
      'Something went wrong while building your session. Please retry.',
    );

    for (final backend in candidates) {
      final GenerativeModel model;
      try {
        model = _modelFor(backend);
      } on Object catch (error) {
        throw _mapStartupError(error);
      }

      var unavailable = false;
      for (
        var attempt = 1;
        attempt <= _maxAttempts && !unavailable;
        attempt++
      ) {
        try {
          final response = await model
              .generateContent([Content.text(prompt)])
              .timeout(ApiConstants.aiTimeout);
          _activeBackend = backend;
          return response.text;
        } on TimeoutException {
          throw const AppException(
            'No connection. Check your network and try again.',
          );
        } on SocketException {
          throw const AppException(
            'No connection. Check your network and try again.',
          );
        } on FirebaseAIException catch (error) {
          failure = _mapAiException(error);
          if (_isBackendUnavailable(error)) {
            unavailable = true;
          } else if (_isTransient(error) && attempt < _maxAttempts) {
            await Future<void>.delayed(_retryDelay * attempt);
          } else {
            throw failure;
          }
        } on Object catch (error) {
          throw _mapStartupError(error);
        }
      }
    }

    throw failure;
  }

  GenerativeModel _modelFor(AiBackend backend) {
    final injected = _injectedModel;
    if (injected != null) return injected;
    return _models.putIfAbsent(backend, () => _createModel(backend));
  }

  GenerativeModel _createModel(AiBackend backend) {
    final firebaseAi = switch (backend) {
      AiBackend.agentPlatform => FirebaseAI.agentPlatform(),
      AiBackend.googleAI => FirebaseAI.googleAI(),
    };
    return firebaseAi.generativeModel(
      model: _modelName,
      systemInstruction: Content.system(systemInstruction),
      generationConfig: GenerationConfig(
        temperature: 0.8,
        responseMimeType: 'application/json',
        responseSchema: responseSchema,
      ),
    );
  }

  static AiSessionDraft parseDraft(
    String jsonText, {
    required int requestedMinutes,
  }) {
    final Object? decoded;
    try {
      decoded = jsonDecode(jsonText);
    } on FormatException {
      throw const AppException(
        "The plan came back incomplete. Let's generate it again.",
      );
    }
    if (decoded is! Map<String, dynamic>) {
      throw const AppException(
        "The plan came back incomplete. Let's generate it again.",
      );
    }

    final title = decoded['title'];
    final summary = decoded['summary'];
    final rawExercises = decoded['exercises'];
    if (title is! String ||
        title.trim().isEmpty ||
        summary is! String ||
        rawExercises is! List ||
        rawExercises.isEmpty) {
      throw const AppException(
        "The plan came back incomplete. Let's generate it again.",
      );
    }

    final exercises = <Exercise>[];
    for (final raw in rawExercises) {
      if (raw is! Map<String, dynamic>) {
        throw const AppException(
          "The plan came back incomplete. Let's generate it again.",
        );
      }
      try {
        exercises.add(_parseExercise(raw));
      } on TypeError {
        throw const AppException(
          "The plan came back incomplete. Let's generate it again.",
        );
      } on ArgumentError {
        throw const AppException(
          "The plan came back incomplete. Let's generate it again.",
        );
      }
    }

    final advice = decoded['weatherAdvice'];
    return AiSessionDraft(
      title: title.trim(),
      summary: summary.trim(),
      exercises: exercises,
      weatherAdvice: advice is String && advice.trim().isNotEmpty
          ? advice.trim()
          : null,
    );
  }

  static Exercise _parseExercise(Map<String, dynamic> raw) {
    final minutes = raw['estimatedDurationMinutes'];
    if (minutes is! num || minutes <= 0) {
      throw ArgumentError('Invalid exercise duration: $minutes');
    }
    final phaseName = raw['phase'];
    final phase = ExercisePhase.values.firstWhere(
      (p) => p.name == phaseName,
      orElse: () => ExercisePhase.main,
    );
    final exercise = Exercise(
      title: (raw['title'] as String).trim(),
      description: (raw['description'] as String).trim(),
      estimatedDurationMinutes: minutes.round(),
      technicalTip: (raw['technicalTip'] as String? ?? '').trim(),
      phase: phase,
      indoorFriendly: raw['indoorFriendly'] as bool? ?? true,
    );
    if (exercise.title.isEmpty || exercise.description.isEmpty) {
      throw ArgumentError('Exercise has an empty title or description');
    }
    return exercise;
  }

  static bool _isBackendUnavailable(FirebaseAIException error) {
    if (error is ServiceApiNotEnabled) return true;
    final message = error.message.toLowerCase();
    return message.contains('permission_denied') ||
        message.contains('permission denied') ||
        message.contains('not_found') ||
        message.contains('not found') ||
        message.contains('is not enabled') ||
        message.contains('has not been used') ||
        message.contains('403') ||
        message.contains('404');
  }

  static bool _isTransient(FirebaseAIException error) {
    final message = error.message.toLowerCase();
    return message.contains('server error [500]') ||
        message.contains('server error [502]') ||
        message.contains('server error [503]') ||
        message.contains('server error [504]') ||
        message.contains('high demand') ||
        message.contains('overloaded') ||
        message.contains('unavailable') ||
        message.contains('try again later');
  }

  static AppException _mapAiException(FirebaseAIException error) {
    if (error is ServiceApiNotEnabled) {
      return const AppException(
        'Firebase AI Logic is not enabled on this project yet. Open the '
        'Firebase console, go to AI Logic and click "Get started".',
      );
    }
    if (error is QuotaExceeded) {
      final quotaMessage = error.message.toLowerCase();
      if (quotaMessage.contains('free_tier') ||
          quotaMessage.contains('free tier') ||
          quotaMessage.contains('perday')) {
        return const AppException(
          'The daily free Gemini quota for this Firebase project is used up. '
          'Enable billing on the project or try again tomorrow.',
        );
      }
      return const AppException(
        'The coach is busy right now. Try again in a minute.',
      );
    }
    if (error is UnsupportedUserLocation) {
      return const AppException(
        'Firebase AI Logic is not available from your current location.',
      );
    }
    if (error is InvalidApiKey) {
      return const AppException(
        'This build is not linked to a valid Firebase project. Check the '
        'google-services.json and GoogleService-Info.plist files.',
      );
    }

    if (_isTransient(error)) {
      return const AppException(
        'The coach is busy right now. Try again in a minute.',
      );
    }

    final message = error.message.toLowerCase();
    if (message.contains('429') ||
        message.contains('quota') ||
        message.contains('resource_exhausted') ||
        message.contains('rate limit')) {
      return const AppException(
        'The coach is busy right now. Try again in a minute.',
      );
    }
    if (message.contains('socket') ||
        message.contains('network') ||
        message.contains('failed host lookup') ||
        message.contains('connection')) {
      return const AppException(
        'No connection. Check your network and try again.',
      );
    }
    return const AppException(
      'Something went wrong while building your session. Please retry.',
    );
  }

  static AppException _mapStartupError(Object error) {
    if (error is AppException) return error;
    final message = error.toString().toLowerCase();
    if (message.contains('no firebase app') ||
        message.contains('firebase has not been correctly initialized')) {
      return const AppException(
        'Firebase is not configured on this build, so sessions cannot be '
        'generated.',
      );
    }
    return const AppException(
      'Something went wrong while building your session. Please retry.',
    );
  }
}
