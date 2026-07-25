import 'package:drift/drift.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uangku/core/database/app_database.dart';

/// ThemeMode yang dipilih user, disimpan lokal di tabel sync_meta.
class ThemeCubit extends Cubit<ThemeMode> {
  final AppDatabase _db;
  static const _key = 'themeMode';

  ThemeCubit(this._db) : super(ThemeMode.system);

  Future<void> load() async {
    final row = await (_db.select(_db.syncMetaTable)
          ..where((t) => t.key.equals(_key))
          ..limit(1))
        .getSingleOrNull();
    emit(_parse(row?.value));
  }

  Future<void> setMode(ThemeMode mode) async {
    emit(mode);
    await _db.into(_db.syncMetaTable).insertOnConflictUpdate(
        SyncMetaTableCompanion(key: Value(_key), value: Value(mode.name)));
  }

  ThemeMode _parse(String? v) {
    switch (v) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      default:
        return ThemeMode.system;
    }
  }
}
