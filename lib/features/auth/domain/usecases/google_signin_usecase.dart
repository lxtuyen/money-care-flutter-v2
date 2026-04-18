import 'package:fpdart/fpdart.dart';
import 'package:money_care/core/errors/failure.dart';
import 'package:money_care/features/auth/domain/entities/user_entity.dart';
import 'package:money_care/features/auth/domain/repositories/auth_repository.dart';

class GoogleSignInUseCase {
  final AuthRepository repository;
  GoogleSignInUseCase(this.repository);

  Future<Either<Failure, UserEntity>> call() {
    return repository.loginWithGoogle();
  }
}


