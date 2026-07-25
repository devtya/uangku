import 'package:dartz/dartz.dart';
import 'package:uangku/core/error/failures.dart';
import 'package:uangku/features/utang/domain/repositories/utang_repository.dart';

class DeleteUtang {
  final UtangRepository repository;
  DeleteUtang(this.repository);

  Future<Either<Failure, void>> call(String id) => repository.deleteUtang(id);
}
