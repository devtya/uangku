import 'package:drift/drift.dart';

/// Key-value kecil untuk metadata sync (mis. lastUid untuk deteksi ganti akun).
class SyncMetaTable extends Table {
  TextColumn get key => text()();
  TextColumn get value => text()();

  @override
  Set<Column> get primaryKey => {key};
}
