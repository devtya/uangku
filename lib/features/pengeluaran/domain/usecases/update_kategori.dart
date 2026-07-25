import 'package:dartz/dartz.dart';
import 'package:uangku/core/error/failures.dart';
import 'package:uangku/features/pengeluaran/domain/repositories/kategori_repository.dart';

class UpdateKategori {
  final KategoriRepository repository;
  UpdateKategori(this.repository);

  Future<Either<Failure, void>> call(String id, String nama) =>
      repository.updateKategori(id, nama);
}
