import 'package:flutter/foundation.dart' show immutable;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../constants/api_constants.dart';
import '../models/failures.dart';
import '../models/training_session.dart';
import '../repositories/session_repository.dart';
import '../services/ai_service.dart';
import 'app_settings_provider.dart';
import 'auth_provider.dart';
import 'session_form_provider.dart';
import 'session_history_provider.dart';
import 'weather_provider.dart';

part 'session_generation_provider.g.dart';

@Riverpod(keepAlive: true)
AiService aiService(Ref ref) {
  return AiService.fromFirebase(
    modelName: dotenv.maybeGet(ApiConstants.envGeminiModel),
  );
}

@Riverpod(keepAlive: true)
SessionRepository sessionRepository(Ref ref) {
  return SessionRepository(
    ref.watch(aiServiceProvider),
    ref.watch(localDatabaseProvider),
  );
}

/// Loading / data / error state of the AI generation.
///
/// The three states are explicit so the result screen can keep the previous
/// plan visible behind the loading overlay during a regeneration.
@immutable
class SessionGenerationState {
  const SessionGenerationState({
    this.session,
    this.isGenerating = false,
    this.failure,
  });

  final TrainingSession? session;
  final bool isGenerating;
  final AiFailure? failure;

  bool get hasSession => session != null;

  bool get hasFailure => failure != null;

  /// Whether the last generation ran without weather context.
  bool get weatherUnavailable => session != null && !session!.weatherUsed;

  SessionGenerationState copyWith({
    TrainingSession? Function()? session,
    bool? isGenerating,
    AiFailure? Function()? failure,
  }) {
    return SessionGenerationState(
      session: session == null ? this.session : session(),
      isGenerating: isGenerating ?? this.isGenerating,
      failure: failure == null ? this.failure : failure(),
    );
  }
}

@Riverpod(keepAlive: true)
class SessionGeneration extends _$SessionGeneration {
  @override
  SessionGenerationState build() => const SessionGenerationState();

  /// Generates a plan from the current form. Weather is read but never
  /// awaited: a missing or failed forecast degrades to a weather-less prompt.
  Future<void> generate() => _generate(previousTitle: null);

  /// Produces a different proposal for the same parameters.
  Future<void> regenerate() => _generate(previousTitle: state.session?.title);

  /// Re-runs generation constrained to indoor-friendly drills.
  Future<void> adjustForIndoor() {
    ref.read(sessionFormProvider.notifier).setPreferIndoor(true);
    return _generate(previousTitle: state.session?.title);
  }

  /// Persists the current plan locally. Returns `false` if there is none.
  Future<bool> save() async {
    final session = state.session;
    if (session == null) return false;
    await ref.read(sessionRepositoryProvider).save(session);
    return true;
  }

  /// Drops the result and the failure, e.g. when starting a new setup.
  void clear() => state = const SessionGenerationState();

  Future<void> _generate({required String? previousTitle}) async {
    final user = ref.read(currentUserProvider);
    if (user == null) {
      state = state.copyWith(
        isGenerating: false,
        failure: () => const AiFailure.unknown('Not signed in'),
      );
      return;
    }
    final params = ref.read(sessionFormProvider);
    final weather = ref.read(currentWeatherProvider).value;

    state = state.copyWith(isGenerating: true, failure: () => null);
    try {
      final session = await ref
          .read(sessionRepositoryProvider)
          .generate(
            params: params,
            userId: user.uid,
            weather: weather,
            previousTitle: previousTitle,
          );
      state = SessionGenerationState(session: session);
    } on AiFailure catch (failure) {
      state = state.copyWith(isGenerating: false, failure: () => failure);
    } catch (error) {
      state = state.copyWith(
        isGenerating: false,
        failure: () => AiFailure.unknown(error),
      );
    }
  }
}

/// True when the generated session is already in the local history.
@riverpod
bool isCurrentSessionSaved(Ref ref) {
  final id = ref.watch(sessionGenerationProvider).session?.id;
  if (id == null) return false;
  final history = ref.watch(sessionHistoryProvider).value ?? const [];
  return history.any((session) => session.id == id);
}
