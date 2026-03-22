import 'package:money_care/features/auth/domain/entities/user_entity.dart';

abstract class AuthRepository {
  Future<UserEntity> login(String email, String password);
  Future<UserEntity> loginWithGoogle();
  Future<String> register({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
  });
  Future<String> forgotPassword(String email);
  Future<String> verifyOtp(String email, String otp);
  Future<String> resetPassword(String email, String newPassword);
  Future<void> connectGmail();
  Future<void> logout();
}
