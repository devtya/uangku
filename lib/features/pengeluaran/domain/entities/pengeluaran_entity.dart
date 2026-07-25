import 'package:equatable/equatable.dart';

class PengeluaranEntity extends Equatable {
  final String id;
  final double jumlah;
  final String kategoriId;
  final DateTime tanggal;
  final String? catatan;
  final String? utangId;

  const PengeluaranEntity({
    required this.id,
    required this.jumlah,
    required this.kategoriId,
    required this.tanggal,
    this.catatan,
    this.utangId,
  });

  PengeluaranEntity copyWith({
    String? id,
    double? jumlah,
    String? kategoriId,
    DateTime? tanggal,
    String? catatan,
    String? utangId,
  }) {
    return PengeluaranEntity(
      id: id ?? this.id,
      jumlah: jumlah ?? this.jumlah,
      kategoriId: kategoriId ?? this.kategoriId,
      tanggal: tanggal ?? this.tanggal,
      catatan: catatan ?? this.catatan,
      utangId: utangId ?? this.utangId,
    );
  }

  @override
  List<Object?> get props => [id, jumlah, kategoriId, tanggal, catatan, utangId];
}
