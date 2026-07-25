import 'package:dartz/dartz.dart';
import 'package:uangku/core/error/failures.dart';
import 'package:uangku/features/recurring/domain/repositories/recurring_repository.dart';

class DeleteRecurring {
  final RecurringRepository repository;
  DeleteRecurring(this.repository);

  Future<Either<Failure, void>> call(String id) => repository.delete(id);
}
