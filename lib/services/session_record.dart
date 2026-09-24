import 'dart:convert';

import 'package:isar_community/isar.dart';

import '../models/training_session.dart';

part 'session_record.g.dart';

@collection
class SessionRecord {
  SessionRecord();

  factory SessionRecord.fromSession(TrainingSession session) => SessionRecord()
    ..sessionId = session.id
    ..userId = session.userId
    ..createdAt = session.createdAt
    ..payload = jsonEncode(session.toJson());

  Id id = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  late String sessionId;

  @Index()
  late String userId;

  late DateTime createdAt;

  late String payload;

  TrainingSession toSession() =>
      TrainingSession.fromJson(jsonDecode(payload) as Map<String, dynamic>);
}
