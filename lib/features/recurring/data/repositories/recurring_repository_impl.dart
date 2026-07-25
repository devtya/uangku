import 'package:dartz/dartz.dart';
import 'package:uangku/core/error/failures.dart';
import 'package:uangku/features/recurring/data/datasources/recurring_local_datasource.dart';
import 'package:uangku/features/recurring/data/models/recurring_model.dart';
import 'package:uangku/features/recurring/domain/entities/recurring_entity.dart';
import 'package:uangku/features/recurring/domain/repositories/recurring_repository.dart';

class RecurringRepositoryImpl implements RecurringRepository {
  final RecurringLocalDataSource _localDataSource;

  RecurringRepositoryImpl(this._localDataSource);

  @override
  Stream<List<RecurringEntity>> watchAll() {
    return _localDataSource
        .watchAll()
        .map((models) => models.map((m) => m.entity).toList());
  }

  @override
  Future<List<RecurringEntity>> getActive() async {
    final models = await _localDataSource.getActive();
    return models.map((m) => m.entity).toList();
  }

  @override
  Future<Either<Failure, void>> add(RecurringEntity recurring) async {
    try {
      await _localDataSource.add(RecurringModel.fromEntity(recurring));
      return const Right(null);
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> update(RecurringEntity recurring) async {
    try {
      await _localDataSource.update(RecurringModel.fromEntity(recurring));
      return const Right(null);
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> delete(String id) async {
    try {
      await _localDataSource.delete(id);
      return const Right(null);
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }
}
