import 'package:dartz/dartz.dart';
import 'package:uangku/core/error/failures.dart';
import 'package:uangku/features/pengeluaran/domain/repositories/kategori_repository.dart';

class AddKategori {
  final KategoriRepository repository;
  AddKategori(this.repository);

  Future<Either<Failure, void>> call(String nama) =>
      repository.addKategori(nama);
}
