import 'package:dartz/dartz.dart';
import 'package:uangku/core/error/failures.dart';
import 'package:uangku/features/gaji/domain/entities/gaji_entity.dart';
import 'package:uangku/features/gaji/domain/repositories/gaji_repository.dart';

class UpdateGaji {
  final GajiRepository repository;
  UpdateGaji(this.repository);

  Future<Either<Failure, void>> call(GajiEntity gaji) => repository.updateGaji(gaji);
}
