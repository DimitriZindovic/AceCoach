import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

import '../models/exercise.dart';
import '../models/session_params.dart';
import '../models/training_session.dart';
import '../models/weather.dart';

part 'local_database_service.g.dart';

class Sessions extends Table {
  TextColumn get id => text()();
  TextColumn get userId => text()();
  TextColumn get title => text()();
  TextColumn get summary => text()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get completedAt => dateTime().nullable()();
  TextColumn get paramsJson => text()();
  TextColumn get exercisesJson => text()();
  TextColumn get weatherJson => text().nullable()();
  BoolColumn get weatherUsed => boolean().withDefault(const Constant(false))();
  TextColumn get weatherAdvice => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

@DriftDatabase(tables: [Sessions])
class LocalDatabaseService extends _$LocalDatabaseService {
  LocalDatabaseService([QueryExecutor? executor])
    : super(executor ?? driftDatabase(name: 'acecoach'));

  @override
  int get schemaVersion => 3;

  @override
  MigrationStrategy get migration =>
      MigrationStrategy(onUpgrade: (m, from, to) => m.createAll());

  Stream<List<TrainingSession>> watchSessions(String userId) {
    final query = select(sessions)
      ..where((s) => s.userId.equals(userId))
      ..orderBy([(s) => OrderingTerm.desc(s.createdAt)]);
    return query.watch().map((rows) => rows.map(_toSession).toList());
  }

  Future<void> insertSession(TrainingSession session) =>
      into(sessions).insertOnConflictUpdate(_toRow(session));

  Future<TrainingSession?> findSession(String id) async {
    final row = await (select(
      sessions,
    )..where((s) => s.id.equals(id))).getSingleOrNull();
    return row == null ? null : _toSession(row);
  }

  Future<void> deleteSession(String id) =>
      (delete(sessions)..where((s) => s.id.equals(id))).go();

  Future<void> setCompleted(String id, DateTime? completedAt) {
    return (update(sessions)..where((s) => s.id.equals(id))).write(
      SessionsCompanion(completedAt: Value(completedAt)),
    );
  }

  SessionsCompanion _toRow(TrainingSession session) {
    return SessionsCompanion.insert(
      id: session.id,
      userId: session.userId,
      title: session.title,
      summary: session.summary,
      createdAt: session.createdAt,
      completedAt: Value(session.completedAt),
      paramsJson: jsonEncode(session.params.toJson()),
      exercisesJson: jsonEncode([
        for (final exercise in session.exercises) exercise.toJson(),
      ]),
      weatherJson: Value(
        session.weather == null ? null : jsonEncode(session.weather!.toJson()),
      ),
      weatherUsed: Value(session.weatherUsed),
      weatherAdvice: Value(session.weatherAdvice),
    );
  }

  TrainingSession _toSession(Session row) {
    return TrainingSession(
      id: row.id,
      userId: row.userId,
      title: row.title,
      summary: row.summary,
      createdAt: row.createdAt,
      completedAt: row.completedAt,
      params: SessionParams.fromJson(
        jsonDecode(row.paramsJson) as Map<String, dynamic>,
      ),
      exercises: [
        for (final raw in jsonDecode(row.exercisesJson) as List)
          Exercise.fromJson(raw as Map<String, dynamic>),
      ],
      weatherUsed: row.weatherUsed,
      weatherAdvice: row.weatherAdvice,
      weather: row.weatherJson == null
          ? null
          : Weather.fromJson(
              jsonDecode(row.weatherJson!) as Map<String, dynamic>,
            ),
    );
  }
}
