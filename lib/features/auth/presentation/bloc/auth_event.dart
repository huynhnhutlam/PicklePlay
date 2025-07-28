import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class AuthCheckRequested extends AuthEvent {
  const AuthCheckRequested();
}

class SignInRequested extends AuthEvent {
  final String email;
  final String password;

  const SignInRequested({
    required this.email,
    required this.password,
  });

  @override
  List<Object?> get props => [email, password];
}

class SignUpRequested extends AuthEvent {
  final String email;
  final String password;
  final String name;

  const SignUpRequested({
    required this.email,
    required this.password,
    required this.name,
  });

  @override
  List<Object?> get props => [email, password, name];
}

class SignInWithGoogleRequested extends AuthEvent {
  const SignInWithGoogleRequested();
}

class SignInWithAppleRequested extends AuthEvent {
  const SignInWithAppleRequested();
}

class SignOutRequested extends AuthEvent {
  const SignOutRequested();
}

class SendPasswordResetEmailRequested extends AuthEvent {
  final String email;

  const SendPasswordResetEmailRequested(this.email);

  @override
  List<Object?> get props => [email];
}

class AuthStatusChanged extends AuthEvent {
  final bool isAuthenticated;
  final bool isFirstTimeUser;

  const AuthStatusChanged({
    required this.isAuthenticated,
    this.isFirstTimeUser = false,
  });

  @override
  List<Object?> get props => [isAuthenticated, isFirstTimeUser];
}

class AuthErrorOccurred extends AuthEvent {
  final String error;

  const AuthErrorOccurred(this.error);

  @override
  List<Object?> get props => [error];
}
