import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';

import '../models/training_session.dart';

class LocalDatabaseService {
  final StreamController<void> _changes = StreamController<void>.broadcast();

  List<TrainingSession>? _cache;

  Future<void> close() => _changes.close();

  Stream<List<TrainingSession>> watchSessions(String userId) async* {
    yield await _sessionsOf(userId);
    await for (final _ in _changes.stream) {
      yield await _sessionsOf(userId);
    }
  }

  Future<void> insertSession(TrainingSession session) async {
    final sessions = await _read();
    await _write([
      ...sessions.where((s) => s.id != session.id),
      session,
    ]);
  }

  Future<List<TrainingSession>> _sessionsOf(String userId) async {
    final sessions = await _read();
    return sessions.where((s) => s.userId == userId).toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  Future<File> _file() async {
    final directory = await getApplicationDocumentsDirectory();
    return File('${directory.path}/sessions.json');
  }

  Future<List<TrainingSession>> _read() async {
    final cached = _cache;
    if (cached != null) return cached;

    final file = await _file();
    if (!file.existsSync()) return _cache = const [];
    try {
      final raw = jsonDecode(await file.readAsString()) as List;
      return _cache = [
        for (final item in raw)
          TrainingSession.fromJson(item as Map<String, dynamic>),
      ];
    } on Object {
      return _cache = const [];
    }
  }

  Future<void> _write(List<TrainingSession> sessions) async {
    _cache = sessions;
    final file = await _file();
    await file.writeAsString(
      jsonEncode([for (final session in sessions) session.toJson()]),
    );
    _changes.add(null);
  }
}
