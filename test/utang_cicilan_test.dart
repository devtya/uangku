import 'package:flutter_test/flutter_test.dart';
import 'package:uangku/core/constants/app_constants.dart';
import 'package:uangku/features/utang/domain/entities/utang_entity.dart';

void main() {
  // pokok 1.000.000, tenor 10, bunga 1%/bln → total bunga 100.000 → total 1.100.000.
  UtangEntity buat({double terbayar = 0}) => UtangEntity(
        id: 'u1',
        namaUtang: 'Motor',
        jumlahTotal: 1100000,
        jumlahTerbayar: terbayar,
        status: terbayar >= 1100000 ? UtangStatus.lunas : UtangStatus.belumLunas,
        jenis: UtangJenis.cicilan,
        tenor: 10,
        bungaPersen: 1,
        tanggalMulai: DateTime(2026, 1, 15),
      );

  test('cicilan/bulan = total ÷ tenor', () {
    expect(buat().cicilanPerBulan, 110000);
  });

  test('jadwal: tenor baris, cicilan pertama 1 bulan setelah mulai', () {
    final j = buat().jadwalCicilan;
    expect(j.length, 10);
    expect(j.first.nomor, 1);
    expect(j.first.nominal, 110000);
    expect(j.first.jatuhTempo, DateTime(2026, 2, 15)); // +1 bulan
    expect(j[1].jatuhTempo, DateTime(2026, 3, 15));
    expect(j.last.jatuhTempo, DateTime(2026, 11, 15)); // +10 bulan
  });

  test('status lunas per cicilan dari jumlahTerbayar', () {
    final u = buat(terbayar: 220000); // 2 cicilan
    expect(u.cicilanLunas, 2);
    final j = u.jadwalCicilan;
    expect(j[0].lunas, isTrue);
    expect(j[1].lunas, isTrue);
    expect(j[2].lunas, isFalse);
  });

  test('jatuh tempo berikutnya = cicilan belum lunas pertama', () {
    expect(buat(terbayar: 220000).jatuhTempoBerikutnya, DateTime(2026, 4, 15));
    // 2 lunas → berikutnya cicilan ke-3 (mulai +3 bulan)
  });

  test('utang bulat: tanpa jadwal, jatuh tempo = field jatuhTempo', () {
    final b = UtangEntity(
      id: 'b1',
      namaUtang: 'Teman',
      jumlahTotal: 500000,
      jumlahTerbayar: 0,
      status: UtangStatus.belumLunas,
      jenis: UtangJenis.bulat,
      jatuhTempo: DateTime(2026, 3, 1),
    );
    expect(b.isCicilan, isFalse);
    expect(b.jadwalCicilan, isEmpty);
    expect(b.jatuhTempoBerikutnya, DateTime(2026, 3, 1));
  });
}
