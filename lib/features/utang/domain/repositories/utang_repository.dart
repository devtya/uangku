import 'package:dartz/dartz.dart';
import 'package:uangku/core/error/failures.dart';
import 'package:uangku/features/utang/domain/entities/utang_entity.dart';

abstract class UtangRepository {
  Stream<List<UtangEntity>> watchAllUtang();
  Future<Either<Failure, void>> addUtang(UtangEntity utang);
  Future<Either<Failure, void>> updateUtang(UtangEntity utang);
  Future<Either<Failure, void>> deleteUtang(String id);
}
