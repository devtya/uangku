import 'package:drift/drift.dart';

class UtangTable extends Table {
  TextColumn get id => text()();
  TextColumn get namaUtang => text()();
  RealColumn get jumlahTotal => real()();
  RealColumn get jumlahTerbayar => real().withDefault(const Constant(0))();
  TextColumn get status => text()();
  DateTimeColumn? get jatuhTempo => dateTime().nullable()();
  TextColumn? get catatan => text().nullable()();
  DateTimeColumn get updatedAt => dateTime()();
  BoolColumn get isSynced => boolean().withDefault(const Constant(false))();
  BoolColumn get isDeleted => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}
