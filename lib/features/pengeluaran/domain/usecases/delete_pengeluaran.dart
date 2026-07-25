import 'package:dartz/dartz.dart';
import 'package:uangku/core/error/failures.dart';
import 'package:uangku/features/pengeluaran/domain/repositories/pengeluaran_repository.dart';

class DeletePengeluaran {
  final PengeluaranRepository repository;
  DeletePengeluaran(this.repository);

  Future<Either<Failure, void>> call(String id) =>
      repository.deletePengeluaran(id);
}
