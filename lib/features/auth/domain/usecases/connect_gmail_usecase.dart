import 'package:fpdart/fpdart.dart';
import 'package:money_care/core/errors/failure.dart';
import 'package:money_care/features/auth/domain/entities/user_entity.dart';

abstract class AuthRepository {
  Future<Either<Failure, UserEntity>> login(String email, String password);
  Future<Either<Failure, UserEntity>> loginWithGoogle();
  Future<Either<Failure, String>> register({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
  });
  Future<Either<Failure, String>> forgotPassword(String email);
  Future<Either<Failure, String>> verifyOtp(String email, String otp);
  Future<Either<Failure, String>> resetPassword(
    String email,
    String newPassword,
  );
  Future<void> logout();
  UserEntity? getCachedUser();
}
