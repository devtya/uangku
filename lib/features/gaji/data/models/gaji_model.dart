import 'package:drift/drift.dart';
import 'package:uangku/core/database/app_database.dart';
import 'package:uangku/features/gaji/domain/entities/gaji_entity.dart';

class GajiModel {
  final String id;
  final double jumlah;
  final DateTime tanggal;
  final String? catatan;
  final DateTime updatedAt;
  final bool isSynced;
  final bool isDeleted;

  const GajiModel({
    required this.id,
    required this.jumlah,
    required this.tanggal,
    this.catatan,
    required this.updatedAt,
    required this.isSynced,
    required this.isDeleted,
  });

  factory GajiModel.fromEntity(GajiEntity entity) {
    return GajiModel(
      id: entity.id,
      jumlah: entity.jumlah,
      tanggal: entity.tanggal,
      catatan: entity.catatan,
      updatedAt: DateTime.now(),
      isSynced: false,
      isDeleted: false,
    );
  }

  GajiEntity toEntity() {
    return GajiEntity(
      id: id,
      jumlah: jumlah,
      tanggal: tanggal,
      catatan: catatan,
    );
  }

  factory GajiModel.fromDrift(GajiTableData data) {
    return GajiModel(
      id: data.id,
      jumlah: data.jumlah,
      tanggal: data.tanggal,
      catatan: data.catatan,
      updatedAt: data.updatedAt,
      isSynced: data.isSynced,
      isDeleted: data.isDeleted,
    );
  }

  GajiTableCompanion toCompanion() {
    return GajiTableCompanion(
      id: Value(id),
      jumlah: Value(jumlah),
      tanggal: Value(tanggal),
      catatan: Value(catatan),
      updatedAt: Value(updatedAt),
      isSynced: Value(isSynced),
      isDeleted: Value(isDeleted),
    );
  }
}
