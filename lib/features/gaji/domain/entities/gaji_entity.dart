import 'package:equatable/equatable.dart';

class GajiEntity extends Equatable {
  final String id;
  final double jumlah;
  final double jumlahBebas;
  final DateTime tanggal;
  final String? catatan;

  const GajiEntity({
    required this.id,
    required this.jumlah,
    required this.jumlahBebas,
    required this.tanggal,
    this.catatan,
  });

  /// Porsi yang wajib disimpan (tidak boleh disentuh).
  double get jumlahTersimpan => jumlah - jumlahBebas;

  GajiEntity copyWith({
    String? id,
    double? jumlah,
    double? jumlahBebas,
    DateTime? tanggal,
    String? catatan,
  }) {
    return GajiEntity(
      id: id ?? this.id,
      jumlah: jumlah ?? this.jumlah,
      jumlahBebas: jumlahBebas ?? this.jumlahBebas,
      tanggal: tanggal ?? this.tanggal,
      catatan: catatan ?? this.catatan,
    );
  }

  @override
  List<Object?> get props => [id, jumlah, jumlahBebas, tanggal, catatan];
}
