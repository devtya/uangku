import 'package:dartz/dartz.dart';
import 'package:uangku/core/error/failures.dart';
import 'package:uangku/features/gaji/domain/entities/gaji_entity.dart';
import 'package:uangku/features/gaji/domain/repositories/gaji_repository.dart';

class AddGaji {
  final GajiRepository repository;
  AddGaji(this.repository);

  Future<Either<Failure, void>> call(GajiEntity gaji) => repository.addGaji(gaji);
}
