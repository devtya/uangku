import 'package:equatable/equatable.dart';

class UtangEntity extends Equatable {
  final String id;
  final String namaUtang;
  final double jumlahTotal;
  final double jumlahTerbayar;
  final String status;
  final DateTime? jatuhTempo;
  final String? catatan;

  const UtangEntity({
    required this.id,
    required this.namaUtang,
    required this.jumlahTotal,
    required this.jumlahTerbayar,
    required this.status,
    this.jatuhTempo,
    this.catatan,
  });

  double get sisaUtang => jumlahTotal - jumlahTerbayar;

  double get progressPercent =>
      jumlahTotal > 0 ? (jumlahTerbayar / jumlahTotal).clamp(0.0, 1.0) : 0.0;

  UtangEntity copyWith({
    String? id,
    String? namaUtang,
    double? jumlahTotal,
    double? jumlahTerbayar,
    String? status,
    DateTime? jatuhTempo,
    String? catatan,
  }) {
    return UtangEntity(
      id: id ?? this.id,
      namaUtang: namaUtang ?? this.namaUtang,
      jumlahTotal: jumlahTotal ?? this.jumlahTotal,
      jumlahTerbayar: jumlahTerbayar ?? this.jumlahTerbayar,
      status: status ?? this.status,
      jatuhTempo: jatuhTempo ?? this.jatuhTempo,
      catatan: catatan ?? this.catatan,
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
      ];
}
