import 'package:dartz/dartz.dart';
import 'package:uangku/core/error/failures.dart';
import 'package:uangku/features/auth/domain/entities/user_entity.dart';

abstract class AuthRepository {
  Stream<UserEntity?> get authStateChanges;
  UserEntity? get currentUser;
  Future<Either<Failure, UserEntity>> signInWithGoogle();
  Future<Either<Failure, void>> signOut();
}
