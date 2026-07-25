import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';
import 'package:uangku/core/database/app_database.dart';
import 'package:uangku/features/pengeluaran/data/models/kategori_model.dart';

class KategoriLocalDataSource {
  final AppDatabase _db;

  KategoriLocalDataSource(this._db);

  static const _defaultPengeluaran = [
    'Makan',
    'Transport',
    'Belanja',
    'Tagihan',
    'Hiburan',
    'Kesehatan',
    'Lainnya',
  ];

  Stream<List<KategoriModel>> watchKategoriPengeluaran() {
    final query = _db.select(_db.kategoriTable)
      ..where((t) => t.tipe.equals('pengeluaran') & t.isDeleted.equals(false))
      ..orderBy([(t) => OrderingTerm(expression: t.nama)]);
    return query.watch().map(
          (rows) => rows.map((row) => KategoriModel.fromDrift(row)).toList(),
        );
  }

  Future<void> addKategori(String nama) async {
    await _db.into(_db.kategoriTable).insert(
          KategoriTableCompanion.insert(
            id: const Uuid().v4(),
            nama: nama,
            tipe: 'pengeluaran',
            updatedAt: DateTime.now(),
          ),
        );
  }

  Future<String?> getKategoriIdByNama(String nama) async {
    final row = await (_db.select(_db.kategoriTable)
          ..where((t) =>
              t.nama.equals(nama) &
              t.tipe.equals('pengeluaran') &
              t.isDeleted.equals(false))
          ..limit(1))
        .getSingleOrNull();
    return row?.id;
  }

  /// Pastikan sebuah kategori pengeluaran ada (idempotent, tanpa duplikat).
  Future<void> ensureKategori(String nama) async {
    final existing = await getKategoriIdByNama(nama);
    if (existing != null) return;
    await addKategori(nama);
  }

  Future<void> updateKategori(String id, String nama) async {
    await (_db.update(_db.kategoriTable)..where((t) => t.id.equals(id))).write(
      KategoriTableCompanion(
        nama: Value(nama),
        updatedAt: Value(DateTime.now()),
        isSynced: const Value(false),
      ),
    );
  }

  Future<void> deleteKategori(String id) async {
    await (_db.update(_db.kategoriTable)..where((t) => t.id.equals(id))).write(
      KategoriTableCompanion(
        isDeleted: const Value(true),
        updatedAt: Value(DateTime.now()),
        isSynced: const Value(false),
      ),
    );
  }

  /// Seed kategori default sekali saja kalau tabel masih kosong.
  Future<void> seedDefaultsIfEmpty() async {
    final count = await _db.kategoriTable.count().getSingle();
    if (count > 0) return;
    await _db.batch((b) {
      b.insertAll(
        _db.kategoriTable,
        _defaultPengeluaran.map(
          (nama) => KategoriTableCompanion.insert(
            id: const Uuid().v4(),
            nama: nama,
            tipe: 'pengeluaran',
            updatedAt: DateTime.now(),
          ),
        ),
      );
    });
  }
}
