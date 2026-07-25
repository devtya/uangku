import 'package:drift/drift.dart';
import 'package:uangku/core/database/app_database.dart';
import 'package:uangku/features/recurring/domain/entities/recurring_entity.dart';

class RecurringModel {
  final RecurringEntity entity;
  final DateTime updatedAt;
  final bool isSynced;
  final bool isDeleted;

  const RecurringModel({
    required this.entity,
    required this.updatedAt,
    required this.isSynced,
    required this.isDeleted,
  });

  factory RecurringModel.fromEntity(RecurringEntity e) => RecurringModel(
        entity: e,
        updatedAt: DateTime.now(),
        isSynced: false,
        isDeleted: false,
      );

  factory RecurringModel.fromDrift(RecurringTableData d) => RecurringModel(
        entity: RecurringEntity(
          id: d.id,
          tipe: d.tipe,
          nominal: d.nominal,
          nominalBebas: d.nominalBebas,
          frekuensi: d.frekuensi,
          tanggalMulai: d.tanggalMulai,
          tanggalAkhir: d.tanggalAkhir,
          terakhirDibuat: d.terakhirDibuat,
          sumber: d.sumber,
          kategoriId: d.kategoriId,
          catatan: d.catatan,
          aktif: d.aktif,
        ),
        updatedAt: d.updatedAt,
        isSynced: d.isSynced,
        isDeleted: d.isDeleted,
      );

  RecurringTableCompanion toCompanion() {
    final e = entity;
    return RecurringTableCompanion(
      id: Value(e.id),
      tipe: Value(e.tipe),
      nominal: Value(e.nominal),
      nominalBebas: Value(e.nominalBebas),
      frekuensi: Value(e.frekuensi),
      tanggalMulai: Value(e.tanggalMulai),
      tanggalAkhir: Value(e.tanggalAkhir),
      terakhirDibuat: Value(e.terakhirDibuat),
      sumber: Value(e.sumber),
      kategoriId: Value(e.kategoriId),
      catatan: Value(e.catatan),
      aktif: Value(e.aktif),
      updatedAt: Value(updatedAt),
      isSynced: Value(isSynced),
      isDeleted: Value(isDeleted),
    );
  }
}
