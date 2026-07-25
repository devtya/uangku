import 'package:equatable/equatable.dart';
import 'package:uangku/core/constants/app_constants.dart';

class RecurringEntity extends Equatable {
  final String id;
  final String tipe; // pendapatan | pengeluaran
  final double nominal;
  final double? nominalBebas; // pendapatan: porsi bebas; null = bebas penuh
  final String frekuensi; // harian | mingguan | bulanan
  final DateTime tanggalMulai;
  final DateTime? tanggalAkhir;
  final DateTime? terakhirDibuat;
  final String? sumber;
  final String? kategoriId;
  final String? catatan;
  final bool aktif;

  const RecurringEntity({
    required this.id,
    required this.tipe,
    required this.nominal,
    this.nominalBebas,
    required this.frekuensi,
    required this.tanggalMulai,
    this.tanggalAkhir,
    this.terakhirDibuat,
    this.sumber,
    this.kategoriId,
    this.catatan,
    this.aktif = true,
  });

  bool get isPendapatan => tipe == RecurringTipe.pendapatan;

  /// Occurrence berikutnya setelah [from] sesuai frekuensi.
  DateTime nextOccurrence(DateTime from) {
    switch (frekuensi) {
      case RecurringFrekuensi.harian:
        return from.add(const Duration(days: 1));
      case RecurringFrekuensi.mingguan:
        return from.add(const Duration(days: 7));
      case RecurringFrekuensi.bulanan:
      default:
        return DateTime(from.year, from.month + 1, from.day);
    }
  }

  /// Tanggal-tanggal yang harus di-generate sampai [today] (inklusif),
  /// mulai dari occurrence pertama yang belum dibuat.
  List<DateTime> occurrencesDue(DateTime today) {
    if (!aktif) return const [];
    final t = DateTime(today.year, today.month, today.day);
    var next = terakhirDibuat == null
        ? _dateOnly(tanggalMulai)
        : nextOccurrence(_dateOnly(terakhirDibuat!));
    final akhir = tanggalAkhir == null ? null : _dateOnly(tanggalAkhir!);
    final out = <DateTime>[];
    // batas aman agar tidak loop tak hingga
    var guard = 0;
    while (!next.isAfter(t) &&
        (akhir == null || !next.isAfter(akhir)) &&
        guard < 3660) {
      out.add(next);
      next = nextOccurrence(next);
      guard++;
    }
    return out;
  }

  DateTime _dateOnly(DateTime d) => DateTime(d.year, d.month, d.day);

  RecurringEntity copyWith({
    String? id,
    String? tipe,
    double? nominal,
    double? nominalBebas,
    String? frekuensi,
    DateTime? tanggalMulai,
    DateTime? tanggalAkhir,
    DateTime? terakhirDibuat,
    String? sumber,
    String? kategoriId,
    String? catatan,
    bool? aktif,
  }) {
    return RecurringEntity(
      id: id ?? this.id,
      tipe: tipe ?? this.tipe,
      nominal: nominal ?? this.nominal,
      nominalBebas: nominalBebas ?? this.nominalBebas,
      frekuensi: frekuensi ?? this.frekuensi,
      tanggalMulai: tanggalMulai ?? this.tanggalMulai,
      tanggalAkhir: tanggalAkhir ?? this.tanggalAkhir,
      terakhirDibuat: terakhirDibuat ?? this.terakhirDibuat,
      sumber: sumber ?? this.sumber,
      kategoriId: kategoriId ?? this.kategoriId,
      catatan: catatan ?? this.catatan,
      aktif: aktif ?? this.aktif,
    );
  }

  @override
  List<Object?> get props => [
        id,
        tipe,
        nominal,
        nominalBebas,
        frekuensi,
        tanggalMulai,
        tanggalAkhir,
        terakhirDibuat,
        sumber,
        kategoriId,
        catatan,
        aktif,
      ];
}
