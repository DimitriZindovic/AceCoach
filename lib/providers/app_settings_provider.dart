import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../services/local_database_service.dart';

part 'app_settings_provider.g.dart';

@Riverpod(keepAlive: true)
LocalDatabaseService localDatabase(Ref ref) {
  final database = LocalDatabaseService();
  ref.onDispose(database.close);
  return database;
}
