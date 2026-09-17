import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../services/local_database_service.dart';

part 'app_settings_provider.g.dart';

/// The single drift database instance, alive for the whole app.
@Riverpod(keepAlive: true)
LocalDatabaseService localDatabase(Ref ref) {
  final database = LocalDatabaseService();
  ref.onDispose(database.close);
  return database;
}

/// Light / dark / system, persisted in the local database.
@Riverpod(keepAlive: true)
class AppThemeMode extends _$AppThemeMode {
  @override
  Future<ThemeMode> build() async {
    final stored = await ref
        .watch(localDatabaseProvider)
        .readSetting(LocalDatabaseService.themeModeKey);
    return ThemeMode.values.asNameMap()[stored] ?? ThemeMode.system;
  }

  Future<void> setMode(ThemeMode mode) async {
    state = AsyncData(mode);
    await ref
        .read(localDatabaseProvider)
        .writeSetting(LocalDatabaseService.themeModeKey, mode.name);
  }
}

/// City used for the weather when device location is unavailable.
@Riverpod(keepAlive: true)
class HomeCity extends _$HomeCity {
  @override
  Future<String?> build() {
    return ref
        .watch(localDatabaseProvider)
        .readSetting(LocalDatabaseService.homeCityKey);
  }

  Future<void> setCity(String? city) async {
    final trimmed = city?.trim();
    final value = (trimmed == null || trimmed.isEmpty) ? null : trimmed;
    state = AsyncData(value);
    await ref
        .read(localDatabaseProvider)
        .writeSetting(LocalDatabaseService.homeCityKey, value);
  }
}
