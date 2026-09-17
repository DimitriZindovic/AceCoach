import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

import '../models/exercise.dart';
import '../models/session_params.dart';
import '../models/training_session.dart';
import '../models/weather.dart';

part 'local_database_service.g.dart';

/// Saved sessions, one row per generated plan.
@DataClassName('TrainingSessionRow')
class TrainingSessions extends Table {
  TextColumn get id => text()();
  TextColumn get userId => text()();
  TextColumn get title => text()();
  TextColumn get summary => text()();
  DateTimeColumn get createdAt => dateTime()();
  IntColumn get durationMinutes => integer()();
  TextColumn get level => textEnum<SkillLevel>()();
  TextColumn get goal => textEnum<TacticalGoal>()();
  TextColumn get players => textEnum<PlayerCount>()();
  // Comma-separated `Stroke.name` values, in enum order.
  TextColumn get strokes => text()();
  BoolColumn get preferIndoor => boolean().withDefault(const Constant(false))();
  TextColumn get weatherJson => text().nullable()();
  BoolColumn get weatherUsed => boolean().withDefault(const Constant(false))();
  TextColumn get weatherAdvice => text().nullable()();
  DateTimeColumn get completedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

/// Drills of a saved session, ordered by [position].
@DataClassName('ExerciseRow')
class Exercises extends Table {
  TextColumn get sessionId =>
      text().references(TrainingSessions, #id, onDelete: KeyAction.cascade)();
  IntColumn get position => integer()();
  TextColumn get title => text()();
  TextColumn get description => text()();
  IntColumn get estimatedMinutes => integer()();
  TextColumn get technicalTip => text()();
  TextColumn get phase => textEnum<ExercisePhase>()();
  BoolColumn get indoorFriendly => boolean().withDefault(const Constant(true))();

  @override
  Set<Column> get primaryKey => {sessionId, position};
}

/// Small key-value store for user preferences (theme, home city).
@DataClassName('AppSettingRow')
class AppSettings extends Table {
  TextColumn get key => text()();
  TextColumn get value => text()();

  @override
  Set<Column> get primaryKey => {key};
}

/// Local SQLite database (drift). Saved sessions are fully readable offline.
@DriftDatabase(tables: [TrainingSessions, Exercises, AppSettings])
class LocalDatabaseService extends _$LocalDatabaseService {
  LocalDatabaseService([QueryExecutor? executor])
    : super(executor ?? driftDatabase(name: databaseName));

  static const String databaseName = 'acecoach';
  static const String themeModeKey = 'theme_mode';
  static const String homeCityKey = 'home_city';

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    beforeOpen: (details) async {
      await customStatement('PRAGMA foreign_keys = ON');
    },
  );

  // ------------------------------------------------------------ sessions

  /// Emits the user's saved sessions, newest first, with their exercises.
  Stream<List<TrainingSession>> watchSessions(String userId) {
    final query = select(trainingSessions)
      ..where((t) => t.userId.equals(userId))
      ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]);
    return query.watch().asyncMap(_attachExercises);
  }

  Future<TrainingSession?> findSession(String id) async {
    final row = await (select(
      trainingSessions,
    )..where((t) => t.id.equals(id))).getSingleOrNull();
    if (row == null) return null;
    final sessions = await _attachExercises([row]);
    return sessions.single;
  }

  Future<void> insertSession(TrainingSession session) {
    return transaction(() async {
      await into(trainingSessions).insertOnConflictUpdate(_toRow(session));
      await (delete(
        exercises,
      )..where((e) => e.sessionId.equals(session.id))).go();
      await batch((batch) {
        batch.insertAll(exercises, [
          for (var i = 0; i < session.exercises.length; i++)
            _toExerciseRow(session.id, i, session.exercises[i]),
        ]);
      });
    });
  }

  Future<void> deleteSession(String id) {
    return transaction(() async {
      await (delete(exercises)..where((e) => e.sessionId.equals(id))).go();
      await (delete(trainingSessions)..where((t) => t.id.equals(id))).go();
    });
  }

  Future<void> setCompleted(String id, DateTime? completedAt) {
    return (update(trainingSessions)..where((t) => t.id.equals(id))).write(
      TrainingSessionsCompanion(completedAt: Value(completedAt)),
    );
  }

  // ------------------------------------------------------------ settings

  Future<String?> readSetting(String key) async {
    final row = await (select(
      appSettings,
    )..where((s) => s.key.equals(key))).getSingleOrNull();
    return row?.value;
  }

  Future<void> writeSetting(String key, String? value) async {
    if (value == null) {
      await (delete(appSettings)..where((s) => s.key.equals(key))).go();
      return;
    }
    await into(
      appSettings,
    ).insertOnConflictUpdate(AppSettingsCompanion.insert(key: key, value: value));
  }

  // ------------------------------------------------------------ mapping

  Future<List<TrainingSession>> _attachExercises(
    List<TrainingSessionRow> rows,
  ) async {
    if (rows.isEmpty) return const [];
    final ids = rows.map((r) => r.id).toList();
    final exerciseRows =
        await (select(exercises)
              ..where((e) => e.sessionId.isIn(ids))
              ..orderBy([(e) => OrderingTerm.asc(e.position)]))
            .get();
    final bySession = <String, List<Exercise>>{};
    for (final row in exerciseRows) {
      bySession.putIfAbsent(row.sessionId, () => []).add(_fromExerciseRow(row));
    }
    return [
      for (final row in rows) _fromRow(row, bySession[row.id] ?? const []),
    ];
  }

  TrainingSessionsCompanion _toRow(TrainingSession session) {
    final params = session.params;
    return TrainingSessionsCompanion.insert(
      id: session.id,
      userId: session.userId,
      title: session.title,
      summary: session.summary,
      createdAt: session.createdAt,
      durationMinutes: params.durationMinutes,
      level: params.level,
      goal: params.goal,
      players: params.players,
      strokes: params.orderedStrokes.map((s) => s.name).join(','),
      preferIndoor: Value(params.preferIndoor),
      weatherJson: Value(
        session.weather == null ? null : jsonEncode(session.weather!.toJson()),
      ),
      weatherUsed: Value(session.weatherUsed),
      weatherAdvice: Value(session.weatherAdvice),
      completedAt: Value(session.completedAt),
    );
  }

  TrainingSession _fromRow(TrainingSessionRow row, List<Exercise> drills) {
    final strokes = row.strokes
        .split(',')
        .where((name) => name.isNotEmpty)
        .map((name) => Stroke.values.byName(name))
        .toSet();
    return TrainingSession(
      id: row.id,
      userId: row.userId,
      title: row.title,
      summary: row.summary,
      createdAt: row.createdAt,
      params: SessionParams(
        durationMinutes: row.durationMinutes,
        level: row.level,
        strokes: strokes,
        goal: row.goal,
        players: row.players,
        preferIndoor: row.preferIndoor,
      ),
      exercises: drills,
      weather: row.weatherJson == null
          ? null
          : Weather.fromJson(jsonDecode(row.weatherJson!) as Map<String, dynamic>),
      weatherUsed: row.weatherUsed,
      weatherAdvice: row.weatherAdvice,
      completedAt: row.completedAt,
    );
  }

  ExercisesCompanion _toExerciseRow(String sessionId, int position, Exercise e) {
    return ExercisesCompanion.insert(
      sessionId: sessionId,
      position: position,
      title: e.title,
      description: e.description,
      estimatedMinutes: e.estimatedDurationMinutes,
      technicalTip: e.technicalTip,
      phase: e.phase,
      indoorFriendly: Value(e.indoorFriendly),
    );
  }

  Exercise _fromExerciseRow(ExerciseRow row) {
    return Exercise(
      title: row.title,
      description: row.description,
      estimatedDurationMinutes: row.estimatedMinutes,
      technicalTip: row.technicalTip,
      phase: row.phase,
      indoorFriendly: row.indoorFriendly,
    );
  }
}
