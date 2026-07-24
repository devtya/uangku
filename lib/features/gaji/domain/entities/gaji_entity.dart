import 'package:equatable/equatable.dart';

class GajiEntity extends Equatable {
  final String id;
  final double jumlah;
  final DateTime tanggal;
  final String? catatan;

  const GajiEntity({
    required this.id,
    required this.jumlah,
    required this.tanggal,
    this.catatan,
  });

  GajiEntity copyWith({
    String? id,
    double? jumlah,
    DateTime? tanggal,
    String? catatan,
  }) {
    return GajiEntity(
      id: id ?? this.id,
      jumlah: jumlah ?? this.jumlah,
      tanggal: tanggal ?? this.tanggal,
      catatan: catatan ?? this.catatan,
    );
  }

  @override
  List<Object?> get props => [id, jumlah, tanggal, catatan];
}
