import 'package:drift/drift.dart';

class KategoriTable extends Table {
  TextColumn get id => text()();
  TextColumn get nama => text()();
  TextColumn get tipe => text()();
  DateTimeColumn get updatedAt => dateTime()();
  BoolColumn get isSynced => boolean().withDefault(const Constant(false))();
  BoolColumn get isDeleted => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}
