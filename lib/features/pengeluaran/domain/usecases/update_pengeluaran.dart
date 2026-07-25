import 'package:dartz/dartz.dart';
import 'package:uangku/core/error/failures.dart';
import 'package:uangku/features/pengeluaran/domain/entities/pengeluaran_entity.dart';
import 'package:uangku/features/pengeluaran/domain/repositories/pengeluaran_repository.dart';

class UpdatePengeluaran {
  final PengeluaranRepository repository;
  UpdatePengeluaran(this.repository);

  Future<Either<Failure, void>> call(PengeluaranEntity pengeluaran) =>
      repository.updatePengeluaran(pengeluaran);
}
