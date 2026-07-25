import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:uangku/core/database/app_database.dart';
import 'package:uangku/features/gaji/data/datasources/gaji_local_datasource.dart';
import 'package:uangku/features/gaji/data/models/gaji_model.dart';
import 'package:uangku/features/gaji/domain/entities/gaji_entity.dart';

void main() {
  late AppDatabase db;
  late GajiLocalDataSource ds;

  setUp(() {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    ds = GajiLocalDataSource(db);
  });

  tearDown(() => db.close());

  test('split gaji: jumlahBebas tersimpan, jumlahTersimpan = total - bebas', () async {
    await ds.addGaji(GajiModel.fromEntity(GajiEntity(
      id: 'g1',
      jumlah: 3000000,
      jumlahBebas: 1200000,
      tanggal: DateTime(2026, 7, 25),
    )));
    final g = (await ds.watchAllGaji().first).single.toEntity();
    expect(g.jumlahBebas, 1200000);
    expect(g.jumlahTersimpan, 1800000);
  });

  test('baris lama (jumlahBebas null) dianggap bebas penuh', () async {
    // Simulasi row pra-migrasi: kolom jumlahBebas absen (null).
    await db.into(db.gajiTable).insert(GajiTableCompanion.insert(
          id: 'old',
          jumlah: 5000000,
          tanggal: DateTime(2026, 1, 1),
          updatedAt: DateTime(2026, 1, 1),
        ));
    final g = (await ds.watchAllGaji().first).single.toEntity();
    expect(g.jumlahBebas, 5000000); // bebas penuh
    expect(g.jumlahTersimpan, 0);
  });
}
