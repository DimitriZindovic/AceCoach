import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:firebase_ai/firebase_ai.dart';

import '../constants/api_constants.dart';
import '../models/exercise.dart';
import '../models/failures.dart';
import '../models/session_params.dart';
import '../models/weather.dart';

/// The parsed, validated output of one Gemini call, before it becomes a
/// [TrainingSession] (the repository adds identity and timestamps).
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

/// Gemini client (through Firebase AI Logic): prompt building, structured JSON
/// output and response parsing.
class AiService {
  AiService(this._model);

  /// Builds the production model. Requires `Firebase.initializeApp` first.
  factory AiService.fromFirebase({String? modelName}) {
    final model = FirebaseAI.googleAI().generativeModel(
      model: modelName ?? ApiConstants.defaultGeminiModel,
      systemInstruction: Content.system(systemInstruction),
      generationConfig: GenerationConfig(
        temperature: 0.8,
        responseMimeType: 'application/json',
        responseSchema: responseSchema,
      ),
    );
    return AiService(model);
  }

  final GenerativeModel _model;

  static const String systemInstruction =
      'You are AceCoach, an experienced tennis coach who designs precise, '
      'safe and motivating training sessions. You always answer with JSON '
      'that matches the provided schema, written in English.';

  /// JSON schema enforced by Gemini's structured output mode.
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

  /// Builds the user prompt from the parameters and the optional weather.
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
      ..writeln('- Tactical goal: ${params.goal.label}.')
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

  /// Calls Gemini and returns a validated draft.
  ///
  /// Throws an [AiFailure] describing the problem (network, quota, malformed).
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

    final String? text;
    try {
      final response = await _model
          .generateContent([Content.text(prompt)])
          .timeout(ApiConstants.aiTimeout);
      text = response.text;
    } on AiFailure {
      rethrow;
    } on SocketException catch (error) {
      throw AiFailure.network(error);
    } on TimeoutException catch (error) {
      throw AiFailure.network(error);
    } on ServerException catch (error) {
      throw _mapServerException(error);
    } on FirebaseAIException catch (error) {
      throw _mapServerException(error);
    } catch (error) {
      throw AiFailure.unknown(error);
    }

    if (text == null || text.trim().isEmpty) {
      throw const AiFailure.malformedResponse('Empty response');
    }
    return parseDraft(text, requestedMinutes: params.durationMinutes);
  }

  /// Parses the JSON text returned by the model and validates it.
  ///
  /// Pure and synchronous so it can be unit-tested without a model.
  static AiSessionDraft parseDraft(
    String jsonText, {
    required int requestedMinutes,
  }) {
    final Object? decoded;
    try {
      decoded = jsonDecode(jsonText);
    } on FormatException catch (error) {
      throw AiFailure.malformedResponse(error);
    }
    if (decoded is! Map<String, dynamic>) {
      throw const AiFailure.malformedResponse('Root is not an object');
    }

    final title = decoded['title'];
    final summary = decoded['summary'];
    final rawExercises = decoded['exercises'];
    if (title is! String ||
        title.trim().isEmpty ||
        summary is! String ||
        rawExercises is! List ||
        rawExercises.isEmpty) {
      throw const AiFailure.malformedResponse('Missing required fields');
    }

    final exercises = <Exercise>[];
    for (final raw in rawExercises) {
      if (raw is! Map<String, dynamic>) {
        throw const AiFailure.malformedResponse('Exercise is not an object');
      }
      try {
        exercises.add(_parseExercise(raw));
      } on TypeError catch (error) {
        throw AiFailure.malformedResponse(error);
      } on ArgumentError catch (error) {
        throw AiFailure.malformedResponse(error);
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

  static AiFailure _mapServerException(FirebaseAIException error) {
    final message = error.message.toLowerCase();
    if (message.contains('429') ||
        message.contains('quota') ||
        message.contains('resource_exhausted') ||
        message.contains('rate limit')) {
      return AiFailure.quotaExceeded(error);
    }
    if (message.contains('socket') ||
        message.contains('network') ||
        message.contains('failed host lookup') ||
        message.contains('connection')) {
      return AiFailure.network(error);
    }
    return AiFailure.unknown(error);
  }
}
