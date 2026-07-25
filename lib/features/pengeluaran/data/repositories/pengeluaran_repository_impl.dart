import 'package:dartz/dartz.dart';
import 'package:uangku/core/error/failures.dart';
import 'package:uangku/features/pengeluaran/data/datasources/pengeluaran_local_datasource.dart';
import 'package:uangku/features/pengeluaran/data/models/pengeluaran_model.dart';
import 'package:uangku/features/pengeluaran/domain/entities/pengeluaran_entity.dart';
import 'package:uangku/features/pengeluaran/domain/repositories/pengeluaran_repository.dart';

class PengeluaranRepositoryImpl implements PengeluaranRepository {
  final PengeluaranLocalDataSource _localDataSource;

  PengeluaranRepositoryImpl(this._localDataSource);

  @override
  Stream<List<PengeluaranEntity>> watchAllPengeluaran() {
    return _localDataSource.watchAllPengeluaran().map(
          (models) => models.map((m) => m.toEntity()).toList(),
        );
  }

  @override
  Future<Either<Failure, void>> addPengeluaran(PengeluaranEntity pengeluaran) async {
    try {
      await _localDataSource.addPengeluaran(PengeluaranModel.fromEntity(pengeluaran));
      return const Right(null);
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> updatePengeluaran(PengeluaranEntity pengeluaran) async {
    try {
      await _localDataSource.updatePengeluaran(PengeluaranModel.fromEntity(pengeluaran));
      return const Right(null);
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deletePengeluaran(String id) async {
    try {
      await _localDataSource.deletePengeluaran(id);
      return const Right(null);
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }
}
