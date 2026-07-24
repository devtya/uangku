import 'package:equatable/equatable.dart';

class KategoriEntity extends Equatable {
  final String id;
  final String nama;
  final String tipe;

  const KategoriEntity({
    required this.id,
    required this.nama,
    required this.tipe,
  });

  @override
  List<Object?> get props => [id, nama, tipe];
}
