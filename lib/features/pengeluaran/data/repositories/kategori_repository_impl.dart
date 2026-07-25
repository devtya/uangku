import 'package:dartz/dartz.dart';
import 'package:uangku/core/error/failures.dart';
import 'package:uangku/features/pengeluaran/data/datasources/kategori_local_datasource.dart';
import 'package:uangku/features/pengeluaran/domain/entities/kategori_entity.dart';
import 'package:uangku/features/pengeluaran/domain/repositories/kategori_repository.dart';

class KategoriRepositoryImpl implements KategoriRepository {
  final KategoriLocalDataSource _localDataSource;

  KategoriRepositoryImpl(this._localDataSource);

  @override
  Stream<List<KategoriEntity>> watchKategoriPengeluaran() {
    return _localDataSource.watchKategoriPengeluaran().map(
          (models) => models.map((m) => m.toEntity()).toList(),
        );
  }

  @override
  Future<Either<Failure, void>> addKategori(String nama) async {
    try {
      await _localDataSource.addKategori(nama);
      return const Right(null);
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> updateKategori(String id, String nama) async {
    try {
      await _localDataSource.updateKategori(id, nama);
      return const Right(null);
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteKategori(String id) async {
    try {
      await _localDataSource.deleteKategori(id);
      return const Right(null);
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  @override
  Future<String?> getKategoriIdByNama(String nama) =>
      _localDataSource.getKategoriIdByNama(nama);
}
