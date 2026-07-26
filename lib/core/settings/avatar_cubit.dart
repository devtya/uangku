import 'dart:async';
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

/// Pilihan avatar user, disimpan lokal di tabel sync_meta dan disinkronkan
/// lintas device lewat SyncService.
///
/// Nilai `avatar`:
/// - 'google' → foto Google, fallback inisial
/// - 'preset:<emoji>' → avatar emoji bawaan
/// - 'file:<namafile>' → foto galeri (file di folder dokumen app)
///
/// Meta pendamping (untuk sync last-write-wins):
/// - 'avatarUpdatedAt' → ms epoch perubahan terakhir
/// - 'avatarSynced' → '1' bila sudah terkirim ke cloud, '0' bila belum
class AvatarCubit extends Cubit<String?> {
  final AppDatabase _db;
  static const keyAvatar = 'avatar';
  StreamSubscription<SyncMetaTableData?>? _sub;

  AvatarCubit(this._db) : super(null) {
    // Reaktif: tiap perubahan baris 'avatar' (lokal maupun hasil pull sync)
    // langsung tercermin di UI.
    _sub = (_db.select(_db.syncMetaTable)..where((t) => t.key.equals(keyAvatar)))
        .watchSingleOrNull()
        .listen((row) => emit(row?.value));
  }

  /// Muat nilai awal secara sinkron sebelum UI dibangun.
  Future<void> load() async {
    final row = await (_db.select(_db.syncMetaTable)
          ..where((t) => t.key.equals(keyAvatar))
          ..limit(1))
        .getSingleOrNull();
    emit(row?.value);
  }

  Future<void> useGoogle() => _save('google');

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

  Future<void> _save(String value) async {
    if (!value.startsWith('file:')) await _deleteOldFile();
    // avatarSynced=0 → menandai pilihan lokal yang belum ter-push; SyncService
    // akan mengirimnya dan membiarkannya menang atas snapshot cloud sementara.
    await _db.batch((b) {
      b.insertAllOnConflictUpdate(_db.syncMetaTable, [
        SyncMetaTableCompanion(key: const Value(keyAvatar), value: Value(value)),
        SyncMetaTableCompanion(
            key: const Value('avatarSynced'), value: const Value('0')),
      ]);
    });
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

  @override
  Future<void> close() {
    _sub?.cancel();
    return super.close();
  }
}
