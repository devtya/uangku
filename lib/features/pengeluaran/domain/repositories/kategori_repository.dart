import 'package:dartz/dartz.dart';
import 'package:uangku/core/error/failures.dart';
import 'package:uangku/features/pengeluaran/domain/entities/kategori_entity.dart';

abstract class KategoriRepository {
  Stream<List<KategoriEntity>> watchKategoriPengeluaran();
  Future<Either<Failure, void>> addKategori(String nama);
  Future<Either<Failure, void>> deleteKategori(String id);
}
