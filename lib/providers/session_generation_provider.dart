import 'package:flutter/foundation.dart' show immutable;
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../models/app_exception.dart';
import '../models/training_session.dart';
import '../repositories/session_repository.dart';
import '../services/ai_service.dart';
import '../services/local_database_service.dart';
import 'auth_provider.dart';
import 'session_form_provider.dart';
import 'weather_provider.dart';

part 'session_generation_provider.g.dart';

@Riverpod(keepAlive: true)
SessionRepository sessionRepository(Ref ref) {
  final database = LocalDatabaseService();
  ref.onDispose(database.close);
  return SessionRepository(
    AiService.fromFirebase(backend: AiBackend.agentPlatform),
    database,
  );
}

@immutable
class SessionGenerationState {
  const SessionGenerationState({
    this.session,
    this.isGenerating = false,
    this.failure,
  });

  final TrainingSession? session;
  final bool isGenerating;
  final AppException? failure;

  bool get hasSession => session != null;

  bool get hasFailure => failure != null;

  bool get weatherUnavailable => session != null && !session!.weatherUsed;

  SessionGenerationState copyWith({
    TrainingSession? Function()? session,
    bool? isGenerating,
    AppException? Function()? failure,
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

  Future<void> generate() => _generate(previousTitle: null);

  Future<void> regenerate() => _generate(previousTitle: state.session?.title);

  Future<bool> save() async {
    final session = state.session;
    if (session == null) return false;
    await ref.read(sessionRepositoryProvider).save(session);
    return true;
  }

  void clear() => state = const SessionGenerationState();

  Future<void> _generate({required String? previousTitle}) async {
    final user = ref.read(authStateProvider).value;
    if (user == null) {
      state = state.copyWith(
        isGenerating: false,
        failure: () => const AppException('You are not signed in.'),
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
    } on AppException catch (failure) {
      state = state.copyWith(isGenerating: false, failure: () => failure);
    } catch (error) {
      state = state.copyWith(
        isGenerating: false,
        failure: () => const AppException(
          'Something went wrong while building your session. Please retry.',
        ),
      );
    }
  }
}

