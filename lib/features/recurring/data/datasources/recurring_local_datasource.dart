import 'package:drift/drift.dart';
import 'package:uangku/core/database/app_database.dart';
import 'package:uangku/features/recurring/data/models/recurring_model.dart';

class RecurringLocalDataSource {
  final AppDatabase _db;

  RecurringLocalDataSource(this._db);

  Stream<List<RecurringModel>> watchAll() {
    final query = _db.select(_db.recurringTable)
      ..where((t) => t.isDeleted.equals(false))
      ..orderBy([(t) => OrderingTerm(expression: t.updatedAt, mode: OrderingMode.desc)]);
    return query.watch().map(
          (rows) => rows.map((r) => RecurringModel.fromDrift(r)).toList(),
        );
  }

  Future<List<RecurringModel>> getActive() async {
    final rows = await (_db.select(_db.recurringTable)
          ..where((t) => t.isDeleted.equals(false) & t.aktif.equals(true)))
        .get();
    return rows.map((r) => RecurringModel.fromDrift(r)).toList();
  }

  Future<void> add(RecurringModel m) async {
    await _db.into(_db.recurringTable).insert(m.toCompanion());
  }

  Future<void> update(RecurringModel m) async {
    await _db.update(_db.recurringTable).replace(m.toCompanion());
  }

  Future<void> delete(String id) async {
    await (_db.update(_db.recurringTable)..where((t) => t.id.equals(id))).write(
      RecurringTableCompanion(
        isDeleted: const Value(true),
        updatedAt: Value(DateTime.now()),
        isSynced: const Value(false),
      ),
    );
  }
}
