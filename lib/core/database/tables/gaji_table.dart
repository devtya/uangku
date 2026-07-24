import 'package:drift/drift.dart';

class GajiTable extends Table {
  TextColumn get id => text()();
  RealColumn get jumlah => real()();
  DateTimeColumn get tanggal => dateTime()();
  TextColumn? get catatan => text().nullable()();
  DateTimeColumn get updatedAt => dateTime()();
  BoolColumn get isSynced => boolean().withDefault(const Constant(false))();
  BoolColumn get isDeleted => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}
