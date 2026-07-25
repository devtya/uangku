import 'package:equatable/equatable.dart';
import 'package:uangku/features/utang/domain/entities/utang_entity.dart';

abstract class UtangState extends Equatable {
  const UtangState();

  @override
  List<Object?> get props => [];
}

class UtangInitial extends UtangState {
  const UtangInitial();
}

class UtangLoading extends UtangState {
  const UtangLoading();
}

class UtangLoaded extends UtangState {
  final List<UtangEntity> utangList;

  const UtangLoaded(this.utangList);

  @override
  List<Object?> get props => [utangList];
}

class UtangError extends UtangState {
  final String message;

  const UtangError(this.message);

  @override
  List<Object?> get props => [message];
}

/// Sinyal transien: pembayaran cicilan berhasil (untuk SnackBar).
/// Dipakai lewat listener; builder mengabaikannya agar list tidak flicker.
class UtangBayarSuccess extends UtangState {
  const UtangBayarSuccess();
}
