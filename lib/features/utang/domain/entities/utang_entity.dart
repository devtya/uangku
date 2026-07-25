import 'package:equatable/equatable.dart';
import 'package:uangku/core/constants/app_constants.dart';

/// Satu baris jadwal cicilan (diturunkan, bukan disimpan).
class CicilanJadwal {
  final int nomor;
  final double nominal;
  final DateTime jatuhTempo;
  final bool lunas;

  const CicilanJadwal({
    required this.nomor,
    required this.nominal,
    required this.jatuhTempo,
    required this.lunas,
  });
}

class UtangEntity extends Equatable {
  final String id;
  final String namaUtang;
  final double jumlahTotal;
  final double jumlahTerbayar;
  final String status;
  final DateTime? jatuhTempo;
  final String? catatan;
  final String jenis;
  final int? tenor;
  final double? bungaPersen;
  final DateTime? tanggalMulai;

  const UtangEntity({
    required this.id,
    required this.namaUtang,
    required this.jumlahTotal,
    required this.jumlahTerbayar,
    required this.status,
    this.jatuhTempo,
    this.catatan,
    this.jenis = UtangJenis.bulat,
    this.tenor,
    this.bungaPersen,
    this.tanggalMulai,
  });

  double get sisaUtang => jumlahTotal - jumlahTerbayar;

  double get progressPercent =>
      jumlahTotal > 0 ? (jumlahTerbayar / jumlahTotal).clamp(0.0, 1.0) : 0.0;

  bool get isCicilan =>
      jenis == UtangJenis.cicilan && (tenor ?? 0) > 0 && tanggalMulai != null;

  /// Nominal cicilan per bulan (jumlahTotal sudah termasuk bunga).
  double get cicilanPerBulan =>
      isCicilan ? jumlahTotal / tenor! : 0;

  /// Jumlah cicilan yang sudah lunas (dari total yang terbayar).
  int get cicilanLunas {
    if (!isCicilan || cicilanPerBulan <= 0) return 0;
    return (jumlahTerbayar / cicilanPerBulan + 1e-6).floor().clamp(0, tenor!);
  }

  /// Jadwal cicilan: ke-i jatuh tempo = tanggalMulai + i bulan (i=1..tenor).
  List<CicilanJadwal> get jadwalCicilan {
    if (!isCicilan) return const [];
    final mulai = tanggalMulai!;
    final lunasCount = cicilanLunas;
    return List.generate(tenor!, (idx) {
      final n = idx + 1;
      return CicilanJadwal(
        nomor: n,
        nominal: cicilanPerBulan,
        jatuhTempo: DateTime(mulai.year, mulai.month + n, mulai.day),
        lunas: n <= lunasCount,
      );
    });
  }

  /// Jatuh tempo relevan berikutnya: cicilan belum lunas (cicilan) / jatuhTempo (bulat).
  DateTime? get jatuhTempoBerikutnya {
    if (!isCicilan) return jatuhTempo;
    if (status == UtangStatus.lunas) return null;
    final next = cicilanLunas; // index cicilan belum lunas pertama (0-based)
    if (next >= tenor!) return null;
    return DateTime(
        tanggalMulai!.year, tanggalMulai!.month + next + 1, tanggalMulai!.day);
  }

  UtangEntity copyWith({
    String? id,
    String? namaUtang,
    double? jumlahTotal,
    double? jumlahTerbayar,
    String? status,
    DateTime? jatuhTempo,
    String? catatan,
    String? jenis,
    int? tenor,
    double? bungaPersen,
    DateTime? tanggalMulai,
  }) {
    return UtangEntity(
      id: id ?? this.id,
      namaUtang: namaUtang ?? this.namaUtang,
      jumlahTotal: jumlahTotal ?? this.jumlahTotal,
      jumlahTerbayar: jumlahTerbayar ?? this.jumlahTerbayar,
      status: status ?? this.status,
      jatuhTempo: jatuhTempo ?? this.jatuhTempo,
      catatan: catatan ?? this.catatan,
      jenis: jenis ?? this.jenis,
      tenor: tenor ?? this.tenor,
      bungaPersen: bungaPersen ?? this.bungaPersen,
      tanggalMulai: tanggalMulai ?? this.tanggalMulai,
    );
  }

  @override
  List<Object?> get props => [
        id,
        namaUtang,
        jumlahTotal,
        jumlahTerbayar,
        status,
        jatuhTempo,
        catatan,
        jenis,
        tenor,
        bungaPersen,
        tanggalMulai,
      ];
}
