import 'package:uuid/uuid.dart';

import '../models/app_exception.dart';
import '../models/session_params.dart';
import '../models/training_session.dart';
import '../models/weather.dart';
import '../services/ai_service.dart';
import '../services/local_database_service.dart';

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
        throw const AppException(
          "The plan came back incomplete. Let's generate it again.",
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


  bool _isConsistent(AiSessionDraft draft, SessionParams params) {
    return TrainingSession.isDurationConsistent(
      requestedMinutes: params.durationMinutes,
      actualMinutes: draft.totalMinutes,
    );
  }
}
