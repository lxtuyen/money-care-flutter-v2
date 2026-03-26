import 'package:fpdart/fpdart.dart';
import 'package:money_care/core/errors/failure.dart';
import 'package:money_care/features/auth/domain/repositories/auth_repository.dart';

class ForgotPasswordUseCase {
  final AuthRepository repository;
  ForgotPasswordUseCase(this.repository);

  Future<Either<Failure, String>> call(String email) {
    return repository.forgotPassword(email);
  }
}

class VerifyOtpUseCase {
  final AuthRepository repository;
  VerifyOtpUseCase(this.repository);

  Future<Either<Failure, String>> call(String email, String otp) {
    return repository.verifyOtp(email, otp);
  }
}

class ResetPasswordUseCase {
  final AuthRepository repository;
  ResetPasswordUseCase(this.repository);

  Future<Either<Failure, String>> call(String email, String newPassword) {
    return repository.resetPassword(email, newPassword);
  }
}
