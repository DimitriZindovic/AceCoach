import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart' show debugPrint;
import 'package:isar_community/isar.dart';
import 'package:path_provider/path_provider.dart';

import '../models/training_session.dart';
import 'session_record.dart';

class LocalDatabaseService {
  static const String _legacyFileName = 'sessions.json';

  Future<Isar?>? _opening;

  Future<Isar?> _open() => _opening ??= _openOnce();

  Future<void> close() async {
    final isar = await _opening;
    await isar?.close();
    _opening = null;
  }

  Stream<List<TrainingSession>> watchSessions(String userId) async* {
    final isar = await _open();
    if (isar == null) {
      yield const [];
      return;
    }
    yield* isar.sessionRecords
        .filter()
        .userIdEqualTo(userId)
        .sortByCreatedAtDesc()
        .watch(fireImmediately: true)
        .map((records) => [for (final record in records) record.toSession()]);
  }

  Future<void> insertSession(TrainingSession session) async {
    final isar = await _open();
    if (isar == null) return;
    await isar.writeTxn(
      () => isar.sessionRecords.putBySessionId(
        SessionRecord.fromSession(session),
      ),
    );
  }

  Future<Isar?> _openOnce() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final isar = await Isar.open(
        [SessionRecordSchema],
        directory: directory.path,
        name: 'ace_coach',
      );
      await _importLegacySessions(isar, directory);
      return isar;
    } on Object catch (error) {
      debugPrint('Isar failed to open, history is disabled: $error');
      return null;
    }
  }

  Future<void> _importLegacySessions(Isar isar, Directory directory) async {
    final file = File('${directory.path}/$_legacyFileName');
    if (!file.existsSync()) return;
    try {
      final raw = jsonDecode(await file.readAsString()) as List;
      final records = [
        for (final item in raw)
          SessionRecord.fromSession(
            TrainingSession.fromJson(item as Map<String, dynamic>),
          ),
      ];
      if (records.isNotEmpty) {
        await isar.writeTxn(
          () => isar.sessionRecords.putAllBySessionId(records),
        );
      }
    } on Object catch (error) {
      debugPrint('Legacy sessions could not be imported: $error');
    }
    await file.delete();
  }
}
