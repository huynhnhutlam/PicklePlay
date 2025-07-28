import 'package:equatable/equatable.dart';
import 'package:pickle_app/features/auth/domain/entities/user_entity.dart';

enum AuthStatus { initial, loading, authenticated, unauthenticated, failure }

class AuthState extends Equatable {
  final AuthStatus status;
  final UserEntity? user;
  final String? error;
  final bool isFirstTimeUser;

  const AuthState({
    this.status = AuthStatus.initial,
    this.user,
    this.error,
    this.isFirstTimeUser = true,
  });

  factory AuthState.initial() => const AuthState();

  AuthState copyWith({
    AuthStatus? status,
    UserEntity? user,
    String? error,
    bool? isFirstTimeUser,
  }) {
    return AuthState(
      status: status ?? this.status,
      user: user ?? this.user,
      error: error,
      isFirstTimeUser: isFirstTimeUser ?? this.isFirstTimeUser,
    );
  }

  bool get isAuthenticated => status == AuthStatus.authenticated && user != null;
  bool get isUnauthenticated => status == AuthStatus.unauthenticated;
  bool get isLoading => status == AuthStatus.loading;
  bool get hasError => status == AuthStatus.failure && error != null;

  @override
  List<Object?> get props => [status, user, error, isFirstTimeUser];

  @override
  String toString() {
    return 'AuthState { status: $status, user: ${user != null ? 'present' : 'null'}, error: $error, isFirstTimeUser: $isFirstTimeUser }';
  }
}
