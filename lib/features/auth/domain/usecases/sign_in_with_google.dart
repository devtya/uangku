import 'package:dartz/dartz.dart';
import 'package:uangku/core/error/failures.dart';
import 'package:uangku/features/auth/domain/entities/user_entity.dart';
import 'package:uangku/features/auth/domain/repositories/auth_repository.dart';

class SignInWithGoogle {
  final AuthRepository repository;
  SignInWithGoogle(this.repository);

  Future<Either<Failure, UserEntity>> call() => repository.signInWithGoogle();
}
