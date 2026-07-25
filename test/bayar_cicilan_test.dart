import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:uangku/core/constants/app_constants.dart';
import 'package:uangku/core/database/app_database.dart';
import 'package:uangku/features/pengeluaran/data/datasources/kategori_local_datasource.dart';
import 'package:uangku/features/pengeluaran/data/datasources/pengeluaran_local_datasource.dart';
import 'package:uangku/features/pengeluaran/data/repositories/kategori_repository_impl.dart';
import 'package:uangku/features/pengeluaran/data/repositories/pengeluaran_repository_impl.dart';
import 'package:uangku/features/utang/data/datasources/utang_local_datasource.dart';
import 'package:uangku/features/utang/data/repositories/utang_repository_impl.dart';
import 'package:uangku/features/utang/domain/entities/utang_entity.dart';
import 'package:uangku/features/utang/domain/usecases/bayar_cicilan_utang.dart';

void main() {
  late AppDatabase db;
  late UtangRepositoryImpl utangRepo;
  late PengeluaranRepositoryImpl pengeluaranRepo;
  late BayarCicilanUtang bayar;

  setUp(() async {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    await KategoriLocalDataSource(db).ensureKategori(kKategoriCicilanUtang);
    utangRepo = UtangRepositoryImpl(UtangLocalDataSource(db));
    pengeluaranRepo = PengeluaranRepositoryImpl(PengeluaranLocalDataSource(db));
    bayar = BayarCicilanUtang(
      utangRepo,
      pengeluaranRepo,
      KategoriRepositoryImpl(KategoriLocalDataSource(db)),
    );
  });

  tearDown(() => db.close());

  Future<void> seedUtang() => utangRepo.addUtang(const UtangEntity(
        id: 'u1',
        namaUtang: 'Motor',
        jumlahTotal: 1000000,
        jumlahTerbayar: 0,
        status: UtangStatus.belumLunas,
      ));

  test('bayar melebihi sisa: utang mentok di total, pengeluaran = sisa aktual', () async {
    await seedUtang();
    final res = await bayar('u1', 1500000, DateTime(2026, 7, 25));
    expect(res.isRight(), isTrue);

    final u = await utangRepo.getUtangById('u1');
    expect(u!.jumlahTerbayar, 1000000);
    expect(u.status, UtangStatus.lunas);

    final history = await pengeluaranRepo.watchByUtangId('u1').first;
    expect(history.single.jumlah, 1000000); // bukan 1.500.000
  });

  test('bayar sebagian: pengeluaran = jumlah bayar persis', () async {
    await seedUtang();
    await bayar('u1', 400000, DateTime(2026, 7, 25));
    final u = await utangRepo.getUtangById('u1');
    expect(u!.jumlahTerbayar, 400000);
    expect(u.status, UtangStatus.belumLunas);
    final history = await pengeluaranRepo.watchByUtangId('u1').first;
    expect(history.single.jumlah, 400000);
  });
}
