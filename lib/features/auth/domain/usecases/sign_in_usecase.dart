import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:pickle_app/core/error/failures.dart';
import 'package:pickle_app/core/usecases/usecase.dart';
import 'package:pickle_app/features/auth/domain/entities/user_entity.dart';
import 'package:pickle_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:injectable/injectable.dart';

@Injectable()
class SignInWithEmailAndPasswordUseCase
    extends UseCase<UserEntity, SignInParams> {
  final AuthRepository repository;

  SignInWithEmailAndPasswordUseCase(this.repository);

  @override
  Future<Either<Failure, UserEntity>> call(SignInParams params) async {
    return await repository.signInWithEmailAndPassword(
      email: params.email,
      password: params.password,
    );
  }
}

class SignInParams extends Equatable {
  final String email;
  final String password;

  const SignInParams({required this.email, required this.password});

  @override
  List<Object?> get props => [email, password];
}
