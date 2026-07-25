import 'package:flutter_test/flutter_test.dart';
import 'package:uangku/core/constants/app_constants.dart';
import 'package:uangku/features/recurring/domain/entities/recurring_entity.dart';

RecurringEntity r({
  required String frekuensi,
  required DateTime mulai,
  DateTime? terakhir,
  DateTime? akhir,
  bool aktif = true,
}) =>
    RecurringEntity(
      id: 'r',
      tipe: RecurringTipe.pendapatan,
      nominal: 15000,
      frekuensi: frekuensi,
      tanggalMulai: mulai,
      tanggalAkhir: akhir,
      terakhirDibuat: terakhir,
      aktif: aktif,
    );

void main() {
  test('harian: dari mulai s/d hari ini', () {
    final due = r(frekuensi: RecurringFrekuensi.harian, mulai: DateTime(2026, 7, 20))
        .occurrencesDue(DateTime(2026, 7, 25));
    expect(due.length, 6); // 20..25
    expect(due.first, DateTime(2026, 7, 20));
    expect(due.last, DateTime(2026, 7, 25));
  });

  test('idempoten: setelah terakhirDibuat=hari ini, tidak ada lagi', () {
    final due = r(
      frekuensi: RecurringFrekuensi.harian,
      mulai: DateTime(2026, 7, 20),
      terakhir: DateTime(2026, 7, 25),
    ).occurrencesDue(DateTime(2026, 7, 25));
    expect(due, isEmpty);
  });

  test('mingguan', () {
    final due = r(frekuensi: RecurringFrekuensi.mingguan, mulai: DateTime(2026, 7, 1))
        .occurrencesDue(DateTime(2026, 7, 25));
    expect(due, [
      DateTime(2026, 7, 1),
      DateTime(2026, 7, 8),
      DateTime(2026, 7, 15),
      DateTime(2026, 7, 22),
    ]);
  });

  test('bulanan', () {
    final due = r(frekuensi: RecurringFrekuensi.bulanan, mulai: DateTime(2026, 5, 15))
        .occurrencesDue(DateTime(2026, 7, 25));
    expect(due, [
      DateTime(2026, 5, 15),
      DateTime(2026, 6, 15),
      DateTime(2026, 7, 15),
    ]);
  });

  test('tanggal akhir membatasi', () {
    final due = r(
      frekuensi: RecurringFrekuensi.harian,
      mulai: DateTime(2026, 7, 20),
      akhir: DateTime(2026, 7, 22),
    ).occurrencesDue(DateTime(2026, 7, 25));
    expect(due, [
      DateTime(2026, 7, 20),
      DateTime(2026, 7, 21),
      DateTime(2026, 7, 22),
    ]);
  });

  test('nonaktif: tidak generate', () {
    final due = r(
      frekuensi: RecurringFrekuensi.harian,
      mulai: DateTime(2026, 7, 20),
      aktif: false,
    ).occurrencesDue(DateTime(2026, 7, 25));
    expect(due, isEmpty);
  });
}
