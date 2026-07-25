import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

import 'tables/gaji_table.dart';
import 'tables/pengeluaran_table.dart';
import 'tables/utang_table.dart';
import 'tables/kategori_table.dart';
import 'tables/sync_meta_table.dart';
import 'tables/recurring_table.dart';

part 'app_database.g.dart';

@DriftDatabase(
  tables: [
    GajiTable,
    PengeluaranTable,
    UtangTable,
    KategoriTable,
    SyncMetaTable,
    RecurringTable,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  /// Untuk test: pakai executor in-memory (NativeDatabase.memory()).
  AppDatabase.forTesting(super.executor);

  @override
  int get schemaVersion => 6;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onUpgrade: (m, from, to) async {
          // v2: tautkan entry cicilan ke utang terkait.
          if (from < 2) {
            await m.addColumn(pengeluaranTable, pengeluaranTable.utangId);
          }
          // v3: porsi gaji yang bebas dipakai (sisanya wajib disimpan).
          if (from < 3) {
            await m.addColumn(gajiTable, gajiTable.jumlahBebas);
          }
          // v4: metadata sync (lastUid untuk deteksi ganti akun).
          if (from < 4) {
            await m.createTable(syncMetaTable);
          }
          // v5: jenis utang (bulat/cicilan) + parameter cicilan.
          if (from < 5) {
            await m.addColumn(utangTable, utangTable.jenis);
            await m.addColumn(utangTable, utangTable.tenor);
            await m.addColumn(utangTable, utangTable.bungaPersen);
            await m.addColumn(utangTable, utangTable.tanggalMulai);
          }
          // v6: transaksi berulang.
          if (from < 6) {
            await m.createTable(recurringTable);
          }
        },
      );
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = p.join(dbFolder.path, 'uangku.sqlite');
    return NativeDatabase.createInBackground(File(file));
  });
}
