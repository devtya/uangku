import 'package:dartz/dartz.dart';
import 'package:uangku/core/error/failures.dart';
import 'package:uangku/features/auth/domain/repositories/auth_repository.dart';

class SignOut {
  final AuthRepository repository;
  SignOut(this.repository);

  Future<Either<Failure, void>> call() => repository.signOut();
}
