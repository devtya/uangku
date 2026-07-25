import 'package:drift/drift.dart';
import 'package:uangku/core/database/app_database.dart';
import 'package:uangku/features/pengeluaran/domain/entities/pengeluaran_entity.dart';

class PengeluaranModel {
  final String id;
  final double jumlah;
  final String kategoriId;
  final DateTime tanggal;
  final String? catatan;
  final String? utangId;
  final DateTime updatedAt;
  final bool isSynced;
  final bool isDeleted;

  const PengeluaranModel({
    required this.id,
    required this.jumlah,
    required this.kategoriId,
    required this.tanggal,
    this.catatan,
    this.utangId,
    required this.updatedAt,
    required this.isSynced,
    required this.isDeleted,
  });

  factory PengeluaranModel.fromEntity(PengeluaranEntity entity) {
    return PengeluaranModel(
      id: entity.id,
      jumlah: entity.jumlah,
      kategoriId: entity.kategoriId,
      tanggal: entity.tanggal,
      catatan: entity.catatan,
      utangId: entity.utangId,
      updatedAt: DateTime.now(),
      isSynced: false,
      isDeleted: false,
    );
  }

  PengeluaranEntity toEntity() {
    return PengeluaranEntity(
      id: id,
      jumlah: jumlah,
      kategoriId: kategoriId,
      tanggal: tanggal,
      catatan: catatan,
      utangId: utangId,
    );
  }

  factory PengeluaranModel.fromDrift(PengeluaranTableData data) {
    return PengeluaranModel(
      id: data.id,
      jumlah: data.jumlah,
      kategoriId: data.kategoriId,
      tanggal: data.tanggal,
      catatan: data.catatan,
      utangId: data.utangId,
      updatedAt: data.updatedAt,
      isSynced: data.isSynced,
      isDeleted: data.isDeleted,
    );
  }

  PengeluaranTableCompanion toCompanion() {
    return PengeluaranTableCompanion(
      id: Value(id),
      jumlah: Value(jumlah),
      kategoriId: Value(kategoriId),
      tanggal: Value(tanggal),
      catatan: Value(catatan),
      utangId: Value(utangId),
      updatedAt: Value(updatedAt),
      isSynced: Value(isSynced),
      isDeleted: Value(isDeleted),
    );
  }
}
