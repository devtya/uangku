import 'package:drift/drift.dart';
import 'package:uangku/core/constants/app_constants.dart';
import 'package:uangku/core/database/app_database.dart';
import 'package:uangku/features/utang/domain/entities/utang_entity.dart';

class UtangModel {
  final String id;
  final String namaUtang;
  final double jumlahTotal;
  final double jumlahTerbayar;
  final String status;
  final DateTime? jatuhTempo;
  final String? catatan;
  final DateTime updatedAt;
  final bool isSynced;
  final bool isDeleted;

  const UtangModel({
    required this.id,
    required this.namaUtang,
    required this.jumlahTotal,
    required this.jumlahTerbayar,
    required this.status,
    this.jatuhTempo,
    this.catatan,
    required this.updatedAt,
    required this.isSynced,
    required this.isDeleted,
  });

  /// Status selalu diturunkan dari terbayar vs total (source of truth tunggal).
  static String deriveStatus(double terbayar, double total) =>
      (total > 0 && terbayar >= total)
          ? UtangStatus.lunas
          : UtangStatus.belumLunas;

  factory UtangModel.fromEntity(UtangEntity entity) {
    return UtangModel(
      id: entity.id,
      namaUtang: entity.namaUtang,
      jumlahTotal: entity.jumlahTotal,
      jumlahTerbayar: entity.jumlahTerbayar,
      status: deriveStatus(entity.jumlahTerbayar, entity.jumlahTotal),
      jatuhTempo: entity.jatuhTempo,
      catatan: entity.catatan,
      updatedAt: DateTime.now(),
      isSynced: false,
      isDeleted: false,
    );
  }

  UtangEntity toEntity() {
    return UtangEntity(
      id: id,
      namaUtang: namaUtang,
      jumlahTotal: jumlahTotal,
      jumlahTerbayar: jumlahTerbayar,
      status: status,
      jatuhTempo: jatuhTempo,
      catatan: catatan,
    );
  }

  factory UtangModel.fromDrift(UtangTableData data) {
    return UtangModel(
      id: data.id,
      namaUtang: data.namaUtang,
      jumlahTotal: data.jumlahTotal,
      jumlahTerbayar: data.jumlahTerbayar,
      status: data.status,
      jatuhTempo: data.jatuhTempo,
      catatan: data.catatan,
      updatedAt: data.updatedAt,
      isSynced: data.isSynced,
      isDeleted: data.isDeleted,
    );
  }

  UtangTableCompanion toCompanion() {
    return UtangTableCompanion(
      id: Value(id),
      namaUtang: Value(namaUtang),
      jumlahTotal: Value(jumlahTotal),
      jumlahTerbayar: Value(jumlahTerbayar),
      status: Value(status),
      jatuhTempo: Value(jatuhTempo),
      catatan: Value(catatan),
      updatedAt: Value(updatedAt),
      isSynced: Value(isSynced),
      isDeleted: Value(isDeleted),
    );
  }
}
