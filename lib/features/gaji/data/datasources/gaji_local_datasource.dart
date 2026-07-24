import 'package:drift/drift.dart';
import 'package:uangku/core/database/app_database.dart';
import 'package:uangku/features/gaji/data/models/gaji_model.dart';

class GajiLocalDataSource {
  final AppDatabase _db;

  GajiLocalDataSource(this._db);

  Stream<List<GajiModel>> watchAllGaji() {
    final query = _db.select(_db.gajiTable)
      ..where((t) => t.isDeleted.equals(false))
      ..orderBy([(t) => OrderingTerm(expression: t.tanggal, mode: OrderingMode.desc)]);
    return query.watch().map(
          (rows) => rows.map((row) => GajiModel.fromDrift(row)).toList(),
        );
  }

  Future<void> addGaji(GajiModel model) async {
    await _db.into(_db.gajiTable).insert(model.toCompanion());
  }

  Future<void> updateGaji(GajiModel model) async {
    await _db.update(_db.gajiTable).replace(model.toCompanion());
  }

  Future<void> deleteGaji(String id) async {
    await (_db.update(_db.gajiTable)..where((t) => t.id.equals(id))).write(
      GajiTableCompanion(
        isDeleted: const Value(true),
        updatedAt: Value(DateTime.now()),
        isSynced: const Value(false),
      ),
    );
  }
}
