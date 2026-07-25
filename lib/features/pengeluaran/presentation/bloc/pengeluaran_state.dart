import 'package:equatable/equatable.dart';
import 'package:uangku/features/pengeluaran/domain/entities/pengeluaran_entity.dart';

abstract class PengeluaranState extends Equatable {
  const PengeluaranState();

  @override
  List<Object?> get props => [];
}

class PengeluaranInitial extends PengeluaranState {
  const PengeluaranInitial();
}

class PengeluaranLoading extends PengeluaranState {
  const PengeluaranLoading();
}

class PengeluaranLoaded extends PengeluaranState {
  final List<PengeluaranEntity> pengeluaranList;

  const PengeluaranLoaded(this.pengeluaranList);

  @override
  List<Object?> get props => [pengeluaranList];
}

class PengeluaranError extends PengeluaranState {
  final String message;

  const PengeluaranError(this.message);

  @override
  List<Object?> get props => [message];
}
