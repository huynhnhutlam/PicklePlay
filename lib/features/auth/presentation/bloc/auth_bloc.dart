import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:pickle_app/core/error/failures.dart';
import 'package:pickle_app/features/auth/domain/entities/user_entity.dart';
import 'package:pickle_app/features/auth/domain/usecases/sign_in_usecase.dart';
import 'package:pickle_app/features/auth/domain/usecases/sign_up_usecase.dart';
import 'package:pickle_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:pickle_app/features/auth/presentation/bloc/auth_event.dart';
import 'package:pickle_app/features/auth/presentation/bloc/auth_state.dart';
import 'package:get_it/get_it.dart';

typedef AuthStream = Stream<AuthState>;

@injectable
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final SignInWithEmailAndPasswordUseCase signInWithEmailAndPasswordUseCase =
      GetIt.instance<SignInWithEmailAndPasswordUseCase>();
  final SignUpWithEmailAndPasswordUseCase signUpWithEmailAndPasswordUseCase =
      GetIt.instance<SignUpWithEmailAndPasswordUseCase>();
  final AuthRepository authRepository = GetIt.instance<AuthRepository>();

  AuthBloc() : super(const AuthState()) {
    on<AuthCheckRequested>(_onAuthCheckRequested);
    on<SignInRequested>(_onSignInRequested);
    on<SignUpRequested>(_onSignUpRequested);
    // on<SignInWithGoogleRequested>(_onSignInWithGoogleRequested);
    // on<SignInWithAppleRequested>(_onSignInWithAppleRequested);
    on<SignOutRequested>(_onSignOutRequested);
    on<SendPasswordResetEmailRequested>(_onSendPasswordResetEmailRequested);
    on<AuthStatusChanged>(_onAuthStatusChanged);
    on<AuthErrorOccurred>(_onAuthErrorOccurred);
  }

  Future<void> _onAuthCheckRequested(
    AuthCheckRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(status: AuthStatus.loading));

    final result = await authRepository.getCurrentUser();

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: AuthStatus.unauthenticated,
          error: failure.toString(),
        ),
      ),
      (user) => emit(
        state.copyWith(
          status: user != null
              ? AuthStatus.authenticated
              : AuthStatus.unauthenticated,
          user: user,
        ),
      ),
    );
  }

  Future<void> _onSignInRequested(
    SignInRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(status: AuthStatus.loading));

    final result = await signInWithEmailAndPasswordUseCase(
      SignInParams(email: event.email, password: event.password),
    );

    _handleAuthResult(result, emit);
  }

  Future<void> _onSignUpRequested(
    SignUpRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(status: AuthStatus.loading));

    final result = await signUpWithEmailAndPasswordUseCase(
      SignUpParams(
        email: event.email,
        password: event.password,
        name: event.name,
      ),
    );

    result.fold(
      (failure) => emit(
        state.copyWith(status: AuthStatus.failure, error: failure.toString()),
      ),
      (user) => emit(
        state.copyWith(status: AuthStatus.registrationSuccess, user: user),
      ),
    );
  }

  // Future<void> _onSignInWithGoogleRequested(
  //   SignInWithGoogleRequested event,
  //   Emitter<AuthState> emit,
  // ) async {
  //   emit(state.copyWith(status: AuthStatus.loading));

  //   final result = await authRepository.signInWithGoogle();

  //   _handleAuthResult(result, emit);
  // }

  // Future<void> _onSignInWithAppleRequested(
  //   SignInWithAppleRequested event,
  //   Emitter<AuthState> emit,
  // ) async {
  //   emit(state.copyWith(status: AuthStatus.loading));

  //   final result = await authRepository.signInWithApple();

  //   _handleAuthResult(result, emit);
  // }

  Future<void> _onSignOutRequested(
    SignOutRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(status: AuthStatus.loading));

    final result = await authRepository.signOut();

    result.fold(
      (failure) => emit(
        state.copyWith(status: AuthStatus.failure, error: failure.toString()),
      ),
      (_) => emit(const AuthState(status: AuthStatus.unauthenticated)),
    );
  }

  Future<void> _onSendPasswordResetEmailRequested(
    SendPasswordResetEmailRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(status: AuthStatus.loading));

    final result = await authRepository.sendPasswordResetEmail(event.email);

    result.fold(
      (failure) => emit(
        state.copyWith(status: AuthStatus.failure, error: failure.toString()),
      ),
      (_) => emit(
        state.copyWith(
          status: AuthStatus.unauthenticated,
          error: 'Password reset email sent',
        ),
      ),
    );
  }

  void _onAuthStatusChanged(AuthStatusChanged event, Emitter<AuthState> emit) {
    emit(
      state.copyWith(
        status: event.isAuthenticated
            ? AuthStatus.authenticated
            : AuthStatus.unauthenticated,
        isFirstTimeUser: event.isFirstTimeUser,
      ),
    );
  }

  void _onAuthErrorOccurred(AuthErrorOccurred event, Emitter<AuthState> emit) {
    emit(state.copyWith(status: AuthStatus.failure, error: event.error));
  }

  void _handleAuthResult(
    Either<Failure, UserEntity> result,
    Emitter<AuthState> emit,
  ) {
    result.fold(
      (failure) {
        emit(
          state.copyWith(
            status: AuthStatus.failure,
            error: _mapFailureToMessage(failure),
          ),
        );
      },
      (user) {
        emit(
          state.copyWith(
            status: AuthStatus.authenticated,
            user: user,
            error: null, // Clear any previous errors
          ),
        );
      },
    );
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return 'Server error: ${failure.message}';
      case CacheFailure:
        return 'Cache error: ${failure.message}';
      case NetworkFailure:
        return 'Network error: ${failure.message}';
      case ValidationFailure:
        return 'Validation error: ${failure.message}';
      default:
        return 'Unexpected error: ${failure.message}';
    }
  }
}
