import 'package:dartz/dartz.dart';
import 'package:uangku/core/error/failures.dart';
import 'package:uangku/features/pengeluaran/domain/repositories/kategori_repository.dart';

class DeleteKategori {
  final KategoriRepository repository;
  DeleteKategori(this.repository);

  Future<Either<Failure, void>> call(String id) =>
      repository.deleteKategori(id);
}
