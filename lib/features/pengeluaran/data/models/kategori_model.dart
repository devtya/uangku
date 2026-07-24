import 'package:drift/drift.dart';
import 'package:uangku/core/database/app_database.dart';
import 'package:uangku/features/pengeluaran/domain/entities/kategori_entity.dart';

class KategoriModel {
  final String id;
  final String nama;
  final String tipe;
  final DateTime updatedAt;
  final bool isSynced;
  final bool isDeleted;

  const KategoriModel({
    required this.id,
    required this.nama,
    required this.tipe,
    required this.updatedAt,
    required this.isSynced,
    required this.isDeleted,
  });

  KategoriEntity toEntity() {
    return KategoriEntity(id: id, nama: nama, tipe: tipe);
  }

  factory KategoriModel.fromDrift(KategoriTableData data) {
    return KategoriModel(
      id: data.id,
      nama: data.nama,
      tipe: data.tipe,
      updatedAt: data.updatedAt,
      isSynced: data.isSynced,
      isDeleted: data.isDeleted,
    );
  }

  KategoriTableCompanion toCompanion() {
    return KategoriTableCompanion(
      id: Value(id),
      nama: Value(nama),
      tipe: Value(tipe),
      updatedAt: Value(updatedAt),
      isSynced: Value(isSynced),
      isDeleted: Value(isDeleted),
    );
  }
}
