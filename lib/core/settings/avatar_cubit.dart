import 'dart:io';

import 'package:drift/drift.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:uangku/core/database/app_database.dart';

/// Path folder dokumen app, di-set sekali saat init agar widget avatar bisa
/// membangun File secara sinkron (tanpa FutureBuilder yang berkedip).
String? appDocumentsPath;

/// Pilihan avatar user, disimpan lokal di tabel sync_meta.
///
/// Nilai yang mungkin:
/// - null/'google' → default: foto Google, fallback inisial
/// - 'preset:<emoji>' → avatar emoji bawaan
/// - 'file:<namafile>' → foto galeri yang disalin ke folder dokumen app
class AvatarCubit extends Cubit<String?> {
  final AppDatabase _db;
  static const _key = 'avatar';

  AvatarCubit(this._db) : super(null);

  Future<void> load() async {
    final row = await (_db.select(_db.syncMetaTable)
          ..where((t) => t.key.equals(_key))
          ..limit(1))
        .getSingleOrNull();
    emit(row?.value);
  }

  Future<void> useGoogle() => _save(null);

  Future<void> usePreset(String emoji) => _save('preset:$emoji');

  /// Salin file terpilih ke folder dokumen app, simpan namafile.
  Future<void> useCustomFile(String sourcePath) async {
    final dir = await getApplicationDocumentsDirectory();
    final name = 'avatar_${DateTime.now().millisecondsSinceEpoch}'
        '${p.extension(sourcePath)}';
    final dest = File(p.join(dir.path, name));
    await File(sourcePath).copy(dest.path);
    await _deleteOldFile();
    await _save('file:$name');
  }

  Future<void> _save(String? value) async {
    await _deleteOldFileIf(value);
    if (value == null) {
      await (_db.delete(_db.syncMetaTable)..where((t) => t.key.equals(_key)))
          .go();
    } else {
      await _db.into(_db.syncMetaTable).insertOnConflictUpdate(
          SyncMetaTableCompanion(key: Value(_key), value: Value(value)));
    }
    emit(value);
  }

  /// Hapus file lama bila pindah ke pilihan non-file.
  Future<void> _deleteOldFileIf(String? next) async {
    if (next != null && next.startsWith('file:')) return;
    await _deleteOldFile();
  }

  Future<void> _deleteOldFile() async {
    final current = state;
    if (current == null || !current.startsWith('file:')) return;
    try {
      final dir = await getApplicationDocumentsDirectory();
      final f = File(p.join(dir.path, current.substring(5)));
      if (await f.exists()) await f.delete();
    } catch (e) {
      debugPrint('Gagal hapus avatar lama: $e');
    }
  }
}
