import 'package:drift/drift.dart';
import 'package:uangku/core/constants/app_constants.dart';
import 'package:uangku/core/database/app_database.dart';
import 'package:uangku/features/utang/data/models/utang_model.dart';

class UtangLocalDataSource {
  final AppDatabase _db;

  UtangLocalDataSource(this._db);

  Stream<List<UtangModel>> watchAllUtang() {
    final query = _db.select(_db.utangTable)
      ..where((t) => t.isDeleted.equals(false));
    return query.watch().map((rows) {
      final models = rows.map((row) => UtangModel.fromDrift(row)).toList();
      models.sort(_compare);
      return models;
    });
  }

  // belum_lunas dulu, lalu jatuhTempo terdekat (null di belakang), baru lunas.
  int _compare(UtangModel a, UtangModel b) {
    final aBelum = a.status == UtangStatus.belumLunas;
    final bBelum = b.status == UtangStatus.belumLunas;
    if (aBelum != bBelum) return aBelum ? -1 : 1;

    final aDue = a.jatuhTempo;
    final bDue = b.jatuhTempo;
    if (aDue == null && bDue == null) return 0;
    if (aDue == null) return 1;
    if (bDue == null) return -1;
    return aDue.compareTo(bDue);
  }

  Future<void> addUtang(UtangModel model) async {
    await _db.into(_db.utangTable).insert(model.toCompanion());
  }

  Future<void> updateUtang(UtangModel model) async {
    await _db.update(_db.utangTable).replace(model.toCompanion());
  }

  Future<void> deleteUtang(String id) async {
    await (_db.update(_db.utangTable)..where((t) => t.id.equals(id))).write(
      UtangTableCompanion(
        isDeleted: const Value(true),
        updatedAt: Value(DateTime.now()),
        isSynced: const Value(false),
      ),
    );
  }
}
