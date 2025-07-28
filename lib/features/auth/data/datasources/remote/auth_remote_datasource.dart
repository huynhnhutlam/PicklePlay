import 'package:pickle_app/core/error/exceptions.dart';
import 'package:pickle_app/features/auth/data/models/user_model.dart';

abstract class AuthRemoteDataSource {
  /// Signs in a user with [email] and [password]
  ///
  /// Throws a [ServerException] for all error codes.
  Future<UserModel> signInWithEmailAndPassword({
    required String email,
    required String password,
  });

  /// Creates a new user with [email], [password], and [name]
  ///
  /// Throws a [ServerException] for all error codes.
  Future<UserModel> signUpWithEmailAndPassword({
    required String email,
    required String password,
    required String name,
  });

  /// Signs in with Google
  ///
  // /// Throws a [ServerException] for all error codes.
  // Future<UserModel> signInWithGoogle();

  // /// Signs in with Apple
  // ///
  // /// Throws a [ServerException] for all error codes.
  // Future<UserModel> signInWithApple();

  /// Signs out the current user
  ///
  /// Throws a [ServerException] for all error codes.
  Future<void> signOut();

  /// Gets the current user
  ///
  /// Returns null if no user is signed in.
  /// Throws a [ServerException] for all error codes.
  Future<UserModel?> getCurrentUser();

  /// Sends a password reset email to [email]
  ///
  /// Throws a [ServerException] for all error codes.
  Future<void> sendPasswordResetEmail(String email);

  /// Refreshes the authentication token
  ///
  /// Throws a [ServerException] for all error codes.
  Future<UserModel> refreshToken(String refreshToken);
}
