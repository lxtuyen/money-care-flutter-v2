import 'package:money_care/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:money_care/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:money_care/features/auth/domain/entities/user_entity.dart';
import 'package:money_care/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDatasource remoteDatasource;
  final AuthLocalDatasource localDatasource;

  AuthRepositoryImpl({
    required this.remoteDatasource,
    required this.localDatasource,
  });

  @override
  Future<UserEntity> login(String email, String password) async {
    final model = await remoteDatasource.login(email, password);
    await localDatasource.cacheUser(model);
    return model.toEntity();
  }

  @override
  Future<UserEntity> loginWithGoogle() async {
    final model = await remoteDatasource.loginWithGoogle();
    await localDatasource.cacheUser(model);
    return model.toEntity();
  }

  @override
  Future<String> register({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
  }) {
    return remoteDatasource.register(
      email: email,
      password: password,
      firstName: firstName,
      lastName: lastName,
    );
  }

  @override
  Future<String> forgotPassword(String email) {
    return remoteDatasource.forgotPassword(email);
  }

  @override
  Future<String> verifyOtp(String email, String otp) {
    return remoteDatasource.verifyOtp(email, otp);
  }

  @override
  Future<String> resetPassword(String email, String newPassword) {
    return remoteDatasource.resetPassword(email, newPassword);
  }

  @override
  Future<void> connectGmail() {
    return remoteDatasource.connectGmail();
  }

  @override
  Future<void> logout() async {
    await localDatasource.clearCache();
  }
}
