import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:uangku/core/database/app_database.dart';
import 'package:uangku/features/pengeluaran/data/datasources/pengeluaran_local_datasource.dart';
import 'package:uangku/features/pengeluaran/data/models/pengeluaran_model.dart';
import 'package:uangku/features/pengeluaran/domain/entities/pengeluaran_entity.dart';

void main() {
  late AppDatabase db;
  late PengeluaranLocalDataSource ds;

  setUp(() {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    ds = PengeluaranLocalDataSource(db);
  });

  tearDown(() => db.close());

  PengeluaranModel entry(String id, {String? utangId}) {
    return PengeluaranModel.fromEntity(PengeluaranEntity(
      id: id,
      jumlah: 1000,
      kategoriId: 'kat',
      tanggal: DateTime(2026, 7, id.hashCode % 27 + 1),
      utangId: utangId,
    ));
  }

  test('watchByUtangId hanya mengembalikan entry milik utang itu', () async {
    await ds.addPengeluaran(entry('p1', utangId: 'utang-A'));
    await ds.addPengeluaran(entry('p2', utangId: 'utang-A'));
    await ds.addPengeluaran(entry('p3', utangId: 'utang-B'));
    await ds.addPengeluaran(entry('p4')); // pengeluaran biasa, tanpa utang

    final historyA = await ds.watchByUtangId('utang-A').first;
    expect(historyA.length, 2);
    expect(historyA.every((p) => p.utangId == 'utang-A'), isTrue);

    // Entry tanpa utangId tidak bocor ke history mana pun.
    expect((await ds.watchByUtangId('utang-B').first).length, 1);
  });

  test('kolom utangId tersimpan & terbaca (skema v2)', () async {
    await ds.addPengeluaran(entry('p1', utangId: 'utang-X'));
    final all = await ds.watchAllPengeluaran().first;
    expect(all.single.utangId, 'utang-X');
  });
}
