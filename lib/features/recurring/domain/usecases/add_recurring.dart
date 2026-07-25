import 'package:dartz/dartz.dart';
import 'package:uangku/core/error/failures.dart';
import 'package:uangku/features/recurring/domain/entities/recurring_entity.dart';
import 'package:uangku/features/recurring/domain/repositories/recurring_repository.dart';

class AddRecurring {
  final RecurringRepository repository;
  AddRecurring(this.repository);

  Future<Either<Failure, void>> call(RecurringEntity r) => repository.add(r);
}
