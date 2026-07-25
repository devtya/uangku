import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';
import 'package:uangku/core/notifications/notification_service.dart';
import 'package:uangku/core/constants/app_constants.dart';
import 'package:uangku/features/utang/domain/entities/utang_entity.dart';
import 'package:uangku/features/utang/domain/usecases/add_utang.dart';
import 'package:uangku/features/utang/domain/usecases/bayar_cicilan_utang.dart';
import 'package:uangku/features/utang/domain/usecases/delete_utang.dart';
import 'package:uangku/features/utang/domain/usecases/update_utang.dart';
import 'package:uangku/features/utang/domain/usecases/watch_all_utang.dart';
import 'package:uangku/features/utang/presentation/bloc/utang_event.dart';
import 'package:uangku/features/utang/presentation/bloc/utang_state.dart';

class UtangBloc extends Bloc<UtangEvent, UtangState> {
  final WatchAllUtang _watchAllUtang;
  final AddUtang _addUtang;
  final UpdateUtang _updateUtang;
  final DeleteUtang _deleteUtang;
  final BayarCicilanUtang _bayarCicilanUtang;
  final NotificationService _notificationService;
  StreamSubscription<List<UtangEntity>>? _subscription;

  UtangBloc({
    required WatchAllUtang watchAllUtang,
    required AddUtang addUtang,
    required UpdateUtang updateUtang,
    required DeleteUtang deleteUtang,
    required BayarCicilanUtang bayarCicilanUtang,
    required NotificationService notificationService,
  })  : _watchAllUtang = watchAllUtang,
        _addUtang = addUtang,
        _updateUtang = updateUtang,
        _deleteUtang = deleteUtang,
        _bayarCicilanUtang = bayarCicilanUtang,
        _notificationService = notificationService,
        super(const UtangInitial()) {
    on<UtangWatchRequested>(_onWatchRequested);
    on<UtangAddRequested>(_onAddRequested);
    on<UtangUpdateRequested>(_onUpdateRequested);
    on<UtangDeleteRequested>(_onDeleteRequested);
    on<UtangBayarCicilanRequested>(_onBayarCicilanRequested);
    on<_UtangListUpdated>(_onListUpdated);
    on<_UtangErrorOccurred>(_onErrorOccurred);
  }

  void _onWatchRequested(
    UtangWatchRequested event,
    Emitter<UtangState> emit,
  ) {
    _subscription?.cancel();
    emit(const UtangLoading());
    _subscription = _watchAllUtang().listen(
      (list) => add(_UtangListUpdated(list)),
      onError: (e) => add(_UtangErrorOccurred(e.toString())),
    );
  }

  void _onAddRequested(
    UtangAddRequested event,
    Emitter<UtangState> emit,
  ) async {
    final utang = UtangEntity(
      id: const Uuid().v4(),
      namaUtang: event.namaUtang,
      jumlahTotal: event.jumlahTotal,
      jumlahTerbayar: 0,
      status: UtangStatus.belumLunas,
      jatuhTempo: event.jatuhTempo,
      catatan: event.catatan,
      jenis: event.jenis,
      tenor: event.tenor,
      bungaPersen: event.bungaPersen,
      tanggalMulai: event.tanggalMulai,
    );
    final result = await _addUtang(utang);
    result.fold(
      (failure) => emit(UtangError(failure.message)),
      (_) {},
    );
  }

  void _onUpdateRequested(
    UtangUpdateRequested event,
    Emitter<UtangState> emit,
  ) async {
    final result = await _updateUtang(event.utang);
    result.fold(
      (failure) => emit(UtangError(failure.message)),
      (_) {},
    );
  }

  void _onDeleteRequested(
    UtangDeleteRequested event,
    Emitter<UtangState> emit,
  ) async {
    final result = await _deleteUtang(event.id);
    result.fold(
      (failure) => emit(UtangError(failure.message)),
      (_) {},
    );
  }

  void _onBayarCicilanRequested(
    UtangBayarCicilanRequested event,
    Emitter<UtangState> emit,
  ) async {
    final result =
        await _bayarCicilanUtang(event.utangId, event.jumlah, event.tanggal);
    result.fold(
      (failure) => emit(UtangError(failure.message)),
      (_) => emit(const UtangBayarSuccess()),
    );
  }

  void _onListUpdated(
    _UtangListUpdated event,
    Emitter<UtangState> emit,
  ) {
    emit(UtangLoaded(event.list));
    // Jadwalkan ulang notifikasi jatuh tempo tiap data utang berubah.
    _notificationService.rescheduleUtang(event.list);
  }

  void _onErrorOccurred(
    _UtangErrorOccurred event,
    Emitter<UtangState> emit,
  ) {
    emit(UtangError(event.message));
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}

class _UtangListUpdated extends UtangEvent {
  final List<UtangEntity> list;
  const _UtangListUpdated(this.list);
}

class _UtangErrorOccurred extends UtangEvent {
  final String message;
  const _UtangErrorOccurred(this.message);
}
