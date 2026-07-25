import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:uangku/core/database/app_database.dart';
import 'package:uangku/features/pengeluaran/data/datasources/kategori_local_datasource.dart';

void main() {
  late AppDatabase db;
  late KategoriLocalDataSource ds;

  setUp(() {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    ds = KategoriLocalDataSource(db);
  });

  tearDown(() => db.close());

  test('seed default: 7 kategori pengeluaran saat tabel kosong', () async {
    await ds.seedDefaultsIfEmpty();
    final list = await ds.watchKategoriPengeluaran().first;
    expect(list.length, 7);
    expect(
      list.map((k) => k.nama).toSet(),
      {'Makan', 'Transport', 'Belanja', 'Tagihan', 'Hiburan', 'Kesehatan', 'Lainnya'},
    );
    expect(list.every((k) => k.tipe == 'pengeluaran'), isTrue);
  });

  test('seed idempotent: tidak dobel kalau sudah ada isi', () async {
    await ds.seedDefaultsIfEmpty();
    await ds.seedDefaultsIfEmpty();
    final list = await ds.watchKategoriPengeluaran().first;
    expect(list.length, 7);
  });

  test('soft delete: kategori terhapus tidak muncul di watch', () async {
    await ds.seedDefaultsIfEmpty();
    final before = await ds.watchKategoriPengeluaran().first;
    await ds.deleteKategori(before.first.id);
    final after = await ds.watchKategoriPengeluaran().first;
    expect(after.length, 6);
  });

  test('rename: nama kategori berubah, jumlah tetap', () async {
    await ds.seedDefaultsIfEmpty();
    final before = await ds.watchKategoriPengeluaran().first;
    final target = before.firstWhere((k) => k.nama == 'Makan');
    await ds.updateKategori(target.id, 'Makanan & Minuman');
    final after = await ds.watchKategoriPengeluaran().first;
    expect(after.length, 7);
    expect(after.any((k) => k.nama == 'Makanan & Minuman'), isTrue);
    expect(after.any((k) => k.nama == 'Makan'), isFalse);
  });
}
