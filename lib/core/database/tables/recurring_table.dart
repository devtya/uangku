import 'package:drift/drift.dart';

/// Aturan transaksi berulang (pendapatan/pengeluaran) — di-generate saat app dibuka.
class RecurringTable extends Table {
  TextColumn get id => text()();
  TextColumn get tipe => text()(); // pendapatan | pengeluaran
  RealColumn get nominal => real()();
  // Khusus pendapatan: porsi bebas dipakai; null = bebas penuh.
  RealColumn? get nominalBebas => real().nullable()();
  TextColumn get frekuensi => text()(); // harian | mingguan | bulanan
  DateTimeColumn get tanggalMulai => dateTime()();
  DateTimeColumn? get tanggalAkhir => dateTime().nullable()();
  // Tanggal occurrence terakhir yang sudah di-generate.
  DateTimeColumn? get terakhirDibuat => dateTime().nullable()();
  TextColumn? get sumber => text().nullable()(); // pendapatan
  TextColumn? get kategoriId => text().nullable()(); // pengeluaran
  TextColumn? get catatan => text().nullable()();
  BoolColumn get aktif => boolean().withDefault(const Constant(true))();
  DateTimeColumn get updatedAt => dateTime()();
  BoolColumn get isSynced => boolean().withDefault(const Constant(false))();
  BoolColumn get isDeleted => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}
