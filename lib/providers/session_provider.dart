import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../models/training_session.dart';
import 'app_settings_provider.dart';
import 'auth_provider.dart';

part 'session_provider.g.dart';

@Riverpod(keepAlive: true)
Stream<List<TrainingSession>> sessionHistory(Ref ref) {
  final user = ref.watch(currentUserProvider);
  if (user == null) return Stream.value(const []);
  return ref.watch(localDatabaseProvider).watchSessions(user.uid);
}
