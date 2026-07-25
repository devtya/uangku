import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';
import 'package:uangku/features/pengeluaran/domain/entities/pengeluaran_entity.dart';
import 'package:uangku/features/pengeluaran/domain/usecases/add_pengeluaran.dart';
import 'package:uangku/features/pengeluaran/domain/usecases/delete_pengeluaran.dart';
import 'package:uangku/features/pengeluaran/domain/usecases/update_pengeluaran.dart';
import 'package:uangku/features/pengeluaran/domain/usecases/watch_all_pengeluaran.dart';
import 'package:uangku/features/pengeluaran/presentation/bloc/pengeluaran_event.dart';
import 'package:uangku/features/pengeluaran/presentation/bloc/pengeluaran_state.dart';

class PengeluaranBloc extends Bloc<PengeluaranEvent, PengeluaranState> {
  final WatchAllPengeluaran _watchAllPengeluaran;
  final AddPengeluaran _addPengeluaran;
  final UpdatePengeluaran _updatePengeluaran;
  final DeletePengeluaran _deletePengeluaran;
  StreamSubscription<List<PengeluaranEntity>>? _subscription;

  PengeluaranBloc({
    required WatchAllPengeluaran watchAllPengeluaran,
    required AddPengeluaran addPengeluaran,
    required UpdatePengeluaran updatePengeluaran,
    required DeletePengeluaran deletePengeluaran,
  })  : _watchAllPengeluaran = watchAllPengeluaran,
        _addPengeluaran = addPengeluaran,
        _updatePengeluaran = updatePengeluaran,
        _deletePengeluaran = deletePengeluaran,
        super(const PengeluaranInitial()) {
    on<PengeluaranWatchRequested>(_onWatchRequested);
    on<PengeluaranAddRequested>(_onAddRequested);
    on<PengeluaranUpdateRequested>(_onUpdateRequested);
    on<PengeluaranDeleteRequested>(_onDeleteRequested);
    on<_PengeluaranListUpdated>(_onListUpdated);
    on<_PengeluaranErrorOccurred>(_onErrorOccurred);
  }

  void _onWatchRequested(
    PengeluaranWatchRequested event,
    Emitter<PengeluaranState> emit,
  ) {
    _subscription?.cancel();
    emit(const PengeluaranLoading());
    _subscription = _watchAllPengeluaran().listen(
      (list) => add(_PengeluaranListUpdated(list)),
      onError: (e) => add(_PengeluaranErrorOccurred(e.toString())),
    );
  }

  void _onAddRequested(
    PengeluaranAddRequested event,
    Emitter<PengeluaranState> emit,
  ) async {
    final pengeluaran = PengeluaranEntity(
      id: const Uuid().v4(),
      jumlah: event.jumlah,
      kategoriId: event.kategoriId,
      tanggal: event.tanggal,
      catatan: event.catatan,
    );
    final result = await _addPengeluaran(pengeluaran);
    result.fold(
      (failure) => emit(PengeluaranError(failure.message)),
      (_) {},
    );
  }

  void _onUpdateRequested(
    PengeluaranUpdateRequested event,
    Emitter<PengeluaranState> emit,
  ) async {
    final result = await _updatePengeluaran(event.pengeluaran);
    result.fold(
      (failure) => emit(PengeluaranError(failure.message)),
      (_) {},
    );
  }

  void _onDeleteRequested(
    PengeluaranDeleteRequested event,
    Emitter<PengeluaranState> emit,
  ) async {
    final result = await _deletePengeluaran(event.id);
    result.fold(
      (failure) => emit(PengeluaranError(failure.message)),
      (_) {},
    );
  }

  void _onListUpdated(
    _PengeluaranListUpdated event,
    Emitter<PengeluaranState> emit,
  ) {
    emit(PengeluaranLoaded(event.list));
  }

  void _onErrorOccurred(
    _PengeluaranErrorOccurred event,
    Emitter<PengeluaranState> emit,
  ) {
    emit(PengeluaranError(event.message));
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}

class _PengeluaranListUpdated extends PengeluaranEvent {
  final List<PengeluaranEntity> list;
  const _PengeluaranListUpdated(this.list);
}

class _PengeluaranErrorOccurred extends PengeluaranEvent {
  final String message;
  const _PengeluaranErrorOccurred(this.message);
}
