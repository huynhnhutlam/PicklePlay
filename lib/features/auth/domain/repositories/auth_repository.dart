import 'package:dartz/dartz.dart';
import 'package:pickle_app/core/error/failures.dart';
import 'package:pickle_app/features/auth/domain/entities/user_entity.dart';

abstract class AuthRepository {
  /// Signs in a user with [email] and [password]
  ///
  /// Returns [UserEntity] on success
  /// Returns [Failure] on error
  Future<Either<Failure, UserEntity>> signInWithEmailAndPassword({
    required String email,
    required String password,
  });

  /// Creates a new user with [email], [password], and [name]
  ///
  /// Returns [UserEntity] on success
  /// Returns [Failure] on error
  Future<Either<Failure, UserEntity>> signUpWithEmailAndPassword({
    required String email,
    required String password,
    required String name,
  });

  /// Signs in with Google
  ///
  /// Returns [UserEntity] on success
  // /// Returns [Failure] on error
  // Future<Either<Failure, UserEntity>> signInWithGoogle();

  // /// Signs in with Apple
  // ///
  // /// Returns [UserEntity] on success
  // /// Returns [Failure] on error
  // Future<Either<Failure, UserEntity>> signInWithApple();

  /// Signs out the current user
  ///
  /// Returns [void] on success
  /// Returns [Failure] on error
  Future<Either<Failure, void>> signOut();

  /// Gets the current user
  ///
  /// Returns [UserEntity] if a user is signed in, null otherwise
  /// Returns [Failure] on error
  Future<Either<Failure, UserEntity?>> getCurrentUser();

  /// Sends a password reset email to [email]
  ///
  /// Returns [void] on success
  /// Returns [Failure] on error
  Future<Either<Failure, void>> sendPasswordResetEmail(String email);
}
