import 'package:equatable/equatable.dart';
import 'package:uangku/features/gaji/domain/entities/gaji_entity.dart';

abstract class GajiEvent extends Equatable {
  const GajiEvent();

  @override
  List<Object?> get props => [];
}

class GajiWatchRequested extends GajiEvent {
  const GajiWatchRequested();
}

class GajiAddRequested extends GajiEvent {
  final double jumlah;
  final double jumlahBebas;
  final DateTime tanggal;
  final String? catatan;

  const GajiAddRequested({
    required this.jumlah,
    required this.jumlahBebas,
    required this.tanggal,
    this.catatan,
  });

  @override
  List<Object?> get props => [jumlah, jumlahBebas, tanggal, catatan];
}

class GajiUpdateRequested extends GajiEvent {
  final GajiEntity gaji;

  const GajiUpdateRequested(this.gaji);

  @override
  List<Object?> get props => [gaji];
}

class GajiDeleteRequested extends GajiEvent {
  final String id;

  const GajiDeleteRequested(this.id);

  @override
  List<Object?> get props => [id];
}
