import 'package:dartz/dartz.dart';
import 'package:uangku/core/error/failures.dart';
import 'package:uangku/features/gaji/data/datasources/gaji_local_datasource.dart';
import 'package:uangku/features/gaji/data/models/gaji_model.dart';
import 'package:uangku/features/gaji/domain/entities/gaji_entity.dart';
import 'package:uangku/features/gaji/domain/repositories/gaji_repository.dart';

class GajiRepositoryImpl implements GajiRepository {
  final GajiLocalDataSource _localDataSource;

  GajiRepositoryImpl(this._localDataSource);

  @override
  Stream<List<GajiEntity>> watchAllGaji() {
    return _localDataSource.watchAllGaji().map(
      (models) => models.map((m) => m.toEntity()).toList(),
    );
  }

  @override
  Future<Either<Failure, void>> addGaji(GajiEntity gaji) async {
    try {
      final model = GajiModel.fromEntity(gaji);
      await _localDataSource.addGaji(model);
      return const Right(null);
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> updateGaji(GajiEntity gaji) async {
    try {
      final model = GajiModel.fromEntity(gaji);
      await _localDataSource.updateGaji(model);
      return const Right(null);
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteGaji(String id) async {
    try {
      await _localDataSource.deleteGaji(id);
      return const Right(null);
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }
}
