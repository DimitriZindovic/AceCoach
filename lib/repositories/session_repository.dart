import 'package:uuid/uuid.dart';

import '../models/failures.dart';
import '../models/session_params.dart';
import '../models/training_session.dart';
import '../models/weather.dart';
import '../services/ai_service.dart';
import '../services/local_database_service.dart';

/// Orchestrates AI generation (remote) and the saved history (local).
class SessionRepository {
  SessionRepository(
    this._ai,
    this._database, {
    Uuid? uuid,
    DateTime Function()? now,
  }) : _uuid = uuid ?? const Uuid(),
       _now = now ?? DateTime.now;

  final AiService _ai;
  final LocalDatabaseService _database;
  final Uuid _uuid;
  final DateTime Function() _now;

  /// Generates a session. Retries once when the drills do not add up to the
  /// requested duration, then gives up with a malformed-response failure.
  Future<TrainingSession> generate({
    required SessionParams params,
    required String userId,
    Weather? weather,
    String? previousTitle,
  }) async {
    var draft = await _ai.generateSession(
      params,
      weather: weather,
      previousTitle: previousTitle,
    );
    if (!_isConsistent(draft, params)) {
      draft = await _ai.generateSession(
        params,
        weather: weather,
        previousTitle: previousTitle,
        strictDuration: true,
      );
      if (!_isConsistent(draft, params)) {
        throw AiFailure.malformedResponse(
          'Drills add up to ${draft.totalMinutes} min, '
          'expected ${params.durationMinutes}',
        );
      }
    }

    return TrainingSession(
      id: _uuid.v4(),
      userId: userId,
      title: draft.title,
      summary: draft.summary,
      createdAt: _now(),
      params: params,
      exercises: draft.exercises,
      weather: weather,
      weatherUsed: weather != null,
      weatherAdvice: draft.weatherAdvice,
    );
  }

  Future<void> save(TrainingSession session) =>
      _database.insertSession(session);

  Stream<List<TrainingSession>> watchHistory(String userId) =>
      _database.watchSessions(userId);

  Future<TrainingSession?> find(String id) => _database.findSession(id);

  Future<void> delete(String id) => _database.deleteSession(id);

  Future<void> setCompleted(String id, {required bool completed}) =>
      _database.setCompleted(id, completed ? _now() : null);

  bool _isConsistent(AiSessionDraft draft, SessionParams params) {
    return TrainingSession.isDurationConsistent(
      requestedMinutes: params.durationMinutes,
      actualMinutes: draft.totalMinutes,
    );
  }
}
