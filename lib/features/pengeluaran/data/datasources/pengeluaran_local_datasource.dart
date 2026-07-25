import 'package:drift/drift.dart';
import 'package:uangku/core/database/app_database.dart';
import 'package:uangku/features/pengeluaran/data/models/pengeluaran_model.dart';

class PengeluaranLocalDataSource {
  final AppDatabase _db;

  PengeluaranLocalDataSource(this._db);

  Stream<List<PengeluaranModel>> watchAllPengeluaran() {
    final query = _db.select(_db.pengeluaranTable)
      ..where((t) => t.isDeleted.equals(false))
      ..orderBy([(t) => OrderingTerm(expression: t.tanggal, mode: OrderingMode.desc)]);
    return query.watch().map(
          (rows) => rows.map((row) => PengeluaranModel.fromDrift(row)).toList(),
        );
  }

  Stream<List<PengeluaranModel>> watchByUtangId(String utangId) {
    final query = _db.select(_db.pengeluaranTable)
      ..where((t) => t.utangId.equals(utangId) & t.isDeleted.equals(false))
      ..orderBy([(t) => OrderingTerm(expression: t.tanggal, mode: OrderingMode.desc)]);
    return query.watch().map(
          (rows) => rows.map((row) => PengeluaranModel.fromDrift(row)).toList(),
        );
  }

  Future<void> addPengeluaran(PengeluaranModel model) async {
    await _db.into(_db.pengeluaranTable).insert(model.toCompanion());
  }

  Future<void> updatePengeluaran(PengeluaranModel model) async {
    await _db.update(_db.pengeluaranTable).replace(model.toCompanion());
  }

  Future<void> deletePengeluaran(String id) async {
    await (_db.update(_db.pengeluaranTable)..where((t) => t.id.equals(id))).write(
      PengeluaranTableCompanion(
        isDeleted: const Value(true),
        updatedAt: Value(DateTime.now()),
        isSynced: const Value(false),
      ),
    );
  }
}
