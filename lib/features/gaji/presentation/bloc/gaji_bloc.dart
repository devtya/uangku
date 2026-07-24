import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';
import 'package:uangku/features/gaji/domain/entities/gaji_entity.dart';
import 'package:uangku/features/gaji/domain/usecases/add_gaji.dart';
import 'package:uangku/features/gaji/domain/usecases/delete_gaji.dart';
import 'package:uangku/features/gaji/domain/usecases/update_gaji.dart';
import 'package:uangku/features/gaji/domain/usecases/watch_all_gaji.dart';
import 'package:uangku/features/gaji/presentation/bloc/gaji_event.dart';
import 'package:uangku/features/gaji/presentation/bloc/gaji_state.dart';

class GajiBloc extends Bloc<GajiEvent, GajiState> {
  final WatchAllGaji _watchAllGaji;
  final AddGaji _addGaji;
  final UpdateGaji _updateGaji;
  final DeleteGaji _deleteGaji;
  StreamSubscription<List<GajiEntity>>? _gajiSubscription;

  GajiBloc({
    required WatchAllGaji watchAllGaji,
    required AddGaji addGaji,
    required UpdateGaji updateGaji,
    required DeleteGaji deleteGaji,
  })  : _watchAllGaji = watchAllGaji,
        _addGaji = addGaji,
        _updateGaji = updateGaji,
        _deleteGaji = deleteGaji,
        super(const GajiInitial()) {
    on<GajiWatchRequested>(_onWatchRequested);
    on<GajiAddRequested>(_onAddRequested);
    on<GajiUpdateRequested>(_onUpdateRequested);
    on<GajiDeleteRequested>(_onDeleteRequested);
    on<_GajiListUpdated>(_onListUpdated);
    on<_GajiErrorOccurred>(_onErrorOccurred);
  }

  void _onWatchRequested(
    GajiWatchRequested event,
    Emitter<GajiState> emit,
  ) {
    _gajiSubscription?.cancel();
    emit(const GajiLoading());
    _gajiSubscription = _watchAllGaji().listen(
      (list) => add(_GajiListUpdated(list)),
      onError: (e) => add(_GajiErrorOccurred(e.toString())),
    );
  }

  void _onAddRequested(
    GajiAddRequested event,
    Emitter<GajiState> emit,
  ) async {
    final gaji = GajiEntity(
      id: const Uuid().v4(),
      jumlah: event.jumlah,
      tanggal: event.tanggal,
      catatan: event.catatan,
    );
    final result = await _addGaji(gaji);
    result.fold(
      (failure) => emit(GajiError(failure.message)),
      (_) {},
    );
  }

  void _onUpdateRequested(
    GajiUpdateRequested event,
    Emitter<GajiState> emit,
  ) async {
    final result = await _updateGaji(event.gaji);
    result.fold(
      (failure) => emit(GajiError(failure.message)),
      (_) {},
    );
  }

  void _onDeleteRequested(
    GajiDeleteRequested event,
    Emitter<GajiState> emit,
  ) async {
    final result = await _deleteGaji(event.id);
    result.fold(
      (failure) => emit(GajiError(failure.message)),
      (_) {},
    );
  }

  void _onListUpdated(
    _GajiListUpdated event,
    Emitter<GajiState> emit,
  ) {
    emit(GajiLoaded(event.list));
  }

  void _onErrorOccurred(
    _GajiErrorOccurred event,
    Emitter<GajiState> emit,
  ) {
    emit(GajiError(event.message));
  }

  @override
  Future<void> close() {
    _gajiSubscription?.cancel();
    return super.close();
  }
}

class _GajiListUpdated extends GajiEvent {
  final List<GajiEntity> list;
  const _GajiListUpdated(this.list);
}

class _GajiErrorOccurred extends GajiEvent {
  final String message;
  const _GajiErrorOccurred(this.message);
}
