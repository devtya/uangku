import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:uangku/core/error/failures.dart';
import 'package:uangku/features/auth/domain/entities/user_entity.dart';
import 'package:uangku/features/auth/domain/repositories/auth_repository.dart';
import 'package:uangku/features/auth/data/datasources/auth_remote_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;

  AuthRepositoryImpl(this._remoteDataSource);

  @override
  Stream<UserEntity?> get authStateChanges {
    return _remoteDataSource.authStateChanges.map((firebaseUser) {
      if (firebaseUser == null) return null;
      return _mapFirebaseUser(firebaseUser);
    });
  }

  @override
  UserEntity? get currentUser {
    final firebaseUser = _remoteDataSource.currentUser;
    if (firebaseUser == null) return null;
    return _mapFirebaseUser(firebaseUser);
  }

  @override
  Future<Either<Failure, UserEntity>> signInWithGoogle() async {
    try {
      final user = await _remoteDataSource.signInWithGoogle();
      return Right(_mapFirebaseUser(user));
    } on PlatformException catch (e) {
      if (e.code == 'SIGN_IN_ABORTED') {
        return const Left(Failure('Proses masuk dibatalkan'));
      }
      return Left(Failure(e.message ?? 'Terjadi kesalahan'));
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> signOut() async {
    try {
      await _remoteDataSource.signOut();
      return const Right(null);
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  UserEntity _mapFirebaseUser(User user) {
    return UserEntity(
      uid: user.uid,
      email: user.email ?? '',
      displayName: user.displayName,
      photoUrl: user.photoURL,
    );
  }
}
