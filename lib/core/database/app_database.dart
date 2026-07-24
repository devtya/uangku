import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

import 'tables/gaji_table.dart';
import 'tables/pengeluaran_table.dart';
import 'tables/utang_table.dart';
import 'tables/kategori_table.dart';

part 'app_database.g.dart';

@DriftDatabase(
  tables: [
    GajiTable,
    PengeluaranTable,
    UtangTable,
    KategoriTable,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  /// Untuk test: pakai executor in-memory (NativeDatabase.memory()).
  AppDatabase.forTesting(super.executor);

  @override
  int get schemaVersion => 1;
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = p.join(dbFolder.path, 'uangku.sqlite');
    return NativeDatabase.createInBackground(File(file));
  });
}
