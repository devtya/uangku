import 'package:dartz/dartz.dart';
import 'package:uangku/core/error/failures.dart';
import 'package:uangku/features/pengeluaran/domain/entities/pengeluaran_entity.dart';

abstract class PengeluaranRepository {
  Stream<List<PengeluaranEntity>> watchAllPengeluaran();
  Future<Either<Failure, void>> addPengeluaran(PengeluaranEntity pengeluaran);
  Future<Either<Failure, void>> updatePengeluaran(PengeluaranEntity pengeluaran);
  Future<Either<Failure, void>> deletePengeluaran(String id);
}
