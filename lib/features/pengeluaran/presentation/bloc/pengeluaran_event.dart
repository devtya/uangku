import 'package:equatable/equatable.dart';
import 'package:uangku/features/pengeluaran/domain/entities/pengeluaran_entity.dart';

abstract class PengeluaranEvent extends Equatable {
  const PengeluaranEvent();

  @override
  List<Object?> get props => [];
}

class PengeluaranWatchRequested extends PengeluaranEvent {
  const PengeluaranWatchRequested();
}

class PengeluaranAddRequested extends PengeluaranEvent {
  final double jumlah;
  final String kategoriId;
  final DateTime tanggal;
  final String? catatan;

  const PengeluaranAddRequested({
    required this.jumlah,
    required this.kategoriId,
    required this.tanggal,
    this.catatan,
  });

  @override
  List<Object?> get props => [jumlah, kategoriId, tanggal, catatan];
}

class PengeluaranUpdateRequested extends PengeluaranEvent {
  final PengeluaranEntity pengeluaran;

  const PengeluaranUpdateRequested(this.pengeluaran);

  @override
  List<Object?> get props => [pengeluaran];
}

class PengeluaranDeleteRequested extends PengeluaranEvent {
  final String id;

  const PengeluaranDeleteRequested(this.id);

  @override
  List<Object?> get props => [id];
}
