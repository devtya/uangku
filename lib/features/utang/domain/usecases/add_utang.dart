import 'package:dartz/dartz.dart';
import 'package:uangku/core/error/failures.dart';
import 'package:uangku/features/utang/domain/entities/utang_entity.dart';
import 'package:uangku/features/utang/domain/repositories/utang_repository.dart';

class AddUtang {
  final UtangRepository repository;
  AddUtang(this.repository);

  Future<Either<Failure, void>> call(UtangEntity utang) =>
      repository.addUtang(utang);
}
