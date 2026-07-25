import 'package:dartz/dartz.dart';
import 'package:uangku/core/error/failures.dart';
import 'package:uangku/features/recurring/domain/entities/recurring_entity.dart';

abstract class RecurringRepository {
  Stream<List<RecurringEntity>> watchAll();
  Future<List<RecurringEntity>> getActive();
  Future<Either<Failure, void>> add(RecurringEntity recurring);
  Future<Either<Failure, void>> update(RecurringEntity recurring);
  Future<Either<Failure, void>> delete(String id);
}
