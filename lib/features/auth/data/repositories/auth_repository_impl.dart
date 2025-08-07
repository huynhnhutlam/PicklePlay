import 'package:dartz/dartz.dart';
import 'package:pickle_app/core/error/exceptions.dart';
import 'package:pickle_app/core/error/failures.dart';
import 'package:pickle_app/features/auth/data/datasources/remote/auth_remote_datasource.dart';
import 'package:pickle_app/features/auth/domain/entities/user_entity.dart';
import 'package:pickle_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: AuthRepository)
class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, UserEntity>> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final user = await remoteDataSource.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return Right(user.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.toString()));
    } on Exception catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> signUpWithEmailAndPassword({
    required String email,
    required String password,
    required String name,
  }) async {
    // try {
    final user = await remoteDataSource.signUpWithEmailAndPassword(
      email: email,
      password: password,
      name: name,
    );
    return Right(user.toEntity());
    // } on ServerException catch (e) {
    //   return Left(ServerFailure(e.toString()));
    // } on Exception catch (e) {
    //   return Left(ServerFailure(e.toString()));
    // }
  }

  // @override
  // Future<Either<Failure, UserEntity>> signInWithGoogle() async {
  //   try {
  //     final user = await remoteDataSource.signInWithGoogle();
  //     return Right(user);
  //   } on ServerException catch (e) {
  //     return Left(ServerFailure(e.toString()));
  //   } on Exception catch (e) {
  //     return Left(ServerFailure(e.toString()));
  //   }
  // }

  // @override
  // Future<Either<Failure, UserEntity>> signInWithApple() async {
  //   try {
  //     final user = await remoteDataSource.signInWithApple();
  //     return Right(user);
  //   } on ServerException catch (e) {
  //     return Left(ServerFailure(e.toString()));
  //   } on Exception catch (e) {
  //     return Left(ServerFailure(e.toString()));
  //   }
  // }

  @override
  Future<Either<Failure, void>> signOut() async {
    try {
      await remoteDataSource.signOut();
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.toString()));
    } on Exception catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserEntity?>> getCurrentUser() async {
    try {
      final user = await remoteDataSource.getCurrentUser();
      return Right(user?.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.toString()));
    } on Exception catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> sendPasswordResetEmail(String email) async {
    try {
      await remoteDataSource.sendPasswordResetEmail(email);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.toString()));
    } on Exception catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
