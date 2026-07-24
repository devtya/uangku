import 'package:dartz/dartz.dart';
import 'package:uangku/core/error/failures.dart';
import 'package:uangku/features/gaji/domain/entities/gaji_entity.dart';

abstract class GajiRepository {
  Stream<List<GajiEntity>> watchAllGaji();
  Future<Either<Failure, void>> addGaji(GajiEntity gaji);
  Future<Either<Failure, void>> updateGaji(GajiEntity gaji);
  Future<Either<Failure, void>> deleteGaji(String id);
}
