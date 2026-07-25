import 'package:dartz/dartz.dart';
import 'package:uangku/core/error/failures.dart';
import 'package:uangku/features/pengeluaran/domain/entities/pengeluaran_entity.dart';
import 'package:uangku/features/pengeluaran/domain/repositories/pengeluaran_repository.dart';

class AddPengeluaran {
  final PengeluaranRepository repository;
  AddPengeluaran(this.repository);

  Future<Either<Failure, void>> call(PengeluaranEntity pengeluaran) =>
      repository.addPengeluaran(pengeluaran);
}
