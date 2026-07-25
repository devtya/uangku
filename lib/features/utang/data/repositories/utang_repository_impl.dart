import 'package:dartz/dartz.dart';
import 'package:uangku/core/error/failures.dart';
import 'package:uangku/features/utang/data/datasources/utang_local_datasource.dart';
import 'package:uangku/features/utang/data/models/utang_model.dart';
import 'package:uangku/features/utang/domain/entities/utang_entity.dart';
import 'package:uangku/features/utang/domain/repositories/utang_repository.dart';

class UtangRepositoryImpl implements UtangRepository {
  final UtangLocalDataSource _localDataSource;

  UtangRepositoryImpl(this._localDataSource);

  @override
  Stream<List<UtangEntity>> watchAllUtang() {
    return _localDataSource.watchAllUtang().map(
          (models) => models.map((m) => m.toEntity()).toList(),
        );
  }

  @override
  Future<Either<Failure, void>> addUtang(UtangEntity utang) async {
    try {
      await _localDataSource.addUtang(UtangModel.fromEntity(utang));
      return const Right(null);
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> updateUtang(UtangEntity utang) async {
    try {
      await _localDataSource.updateUtang(UtangModel.fromEntity(utang));
      return const Right(null);
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteUtang(String id) async {
    try {
      await _localDataSource.deleteUtang(id);
      return const Right(null);
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }
}
