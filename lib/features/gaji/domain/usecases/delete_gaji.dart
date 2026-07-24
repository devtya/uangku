import 'package:dartz/dartz.dart';
import 'package:uangku/core/error/failures.dart';
import 'package:uangku/features/gaji/domain/repositories/gaji_repository.dart';

class DeleteGaji {
  final GajiRepository repository;
  DeleteGaji(this.repository);

  Future<Either<Failure, void>> call(String id) => repository.deleteGaji(id);
}
