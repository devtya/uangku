import 'package:equatable/equatable.dart';
import 'package:uangku/features/utang/domain/entities/utang_entity.dart';

abstract class UtangEvent extends Equatable {
  const UtangEvent();

  @override
  List<Object?> get props => [];
}

class UtangWatchRequested extends UtangEvent {
  const UtangWatchRequested();
}

class UtangAddRequested extends UtangEvent {
  final String namaUtang;
  final double jumlahTotal;
  final DateTime? jatuhTempo;
  final String? catatan;
  final String jenis;
  final int? tenor;
  final double? bungaPersen;
  final DateTime? tanggalMulai;

  const UtangAddRequested({
    required this.namaUtang,
    required this.jumlahTotal,
    this.jatuhTempo,
    this.catatan,
    required this.jenis,
    this.tenor,
    this.bungaPersen,
    this.tanggalMulai,
  });

  @override
  List<Object?> get props =>
      [namaUtang, jumlahTotal, jatuhTempo, catatan, jenis, tenor, bungaPersen, tanggalMulai];
}

class UtangUpdateRequested extends UtangEvent {
  final UtangEntity utang;

  const UtangUpdateRequested(this.utang);

  @override
  List<Object?> get props => [utang];
}

class UtangDeleteRequested extends UtangEvent {
  final String id;

  const UtangDeleteRequested(this.id);

  @override
  List<Object?> get props => [id];
}

class UtangBayarCicilanRequested extends UtangEvent {
  final String utangId;
  final double jumlah;
  final DateTime tanggal;

  const UtangBayarCicilanRequested({
    required this.utangId,
    required this.jumlah,
    required this.tanggal,
  });

  @override
  List<Object?> get props => [utangId, jumlah, tanggal];
}
