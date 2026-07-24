import 'package:equatable/equatable.dart';
import 'package:uangku/features/gaji/domain/entities/gaji_entity.dart';

abstract class GajiState extends Equatable {
  const GajiState();

  @override
  List<Object?> get props => [];
}

class GajiInitial extends GajiState {
  const GajiInitial();
}

class GajiLoading extends GajiState {
  const GajiLoading();
}

class GajiLoaded extends GajiState {
  final List<GajiEntity> gajiList;

  const GajiLoaded(this.gajiList);

  @override
  List<Object?> get props => [gajiList];
}

class GajiError extends GajiState {
  final String message;

  const GajiError(this.message);

  @override
  List<Object?> get props => [message];
}
