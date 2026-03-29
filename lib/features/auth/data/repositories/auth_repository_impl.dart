import 'package:fpdart/fpdart.dart';
import 'package:get/get.dart';
import 'package:money_care/core/controllers/app_controller.dart';
import 'package:money_care/core/errors/exceptions.dart';
import 'package:money_care/core/errors/failure.dart';
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
  Future<Either<Failure, UserEntity>> login(String email, String password) async {
    try {
      final model = await remoteDatasource.login(email, password);
      await localDatasource.cacheUser(model);
      _syncUserId(model.id);
      return Right(model.toEntity());
    } catch (e) {
      return Left(_mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> loginWithGoogle() async {
    try {
      final model = await remoteDatasource.loginWithGoogle();
      await localDatasource.cacheUser(model);
      _syncUserId(model.id);
      return Right(model.toEntity());
    } catch (e) {
      return Left(_mapExceptionToFailure(e));
    }
  }

  void _syncUserId(int id) {
    try {
      Get.find<AppController>().userId.value = id;
    } catch (_) {}
  }

  @override
  Future<Either<Failure, String>> register({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
  }) async {
    try {
      final message = await remoteDatasource.register(
        email: email,
        password: password,
        firstName: firstName,
        lastName: lastName,
      );
      return Right(message);
    } catch (e) {
      return Left(_mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, String>> forgotPassword(String email) async {
    try {
      final message = await remoteDatasource.forgotPassword(email);
      return Right(message);
    } catch (e) {
      return Left(_mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, String>> verifyOtp(String email, String otp) async {
    try {
      final message = await remoteDatasource.verifyOtp(email, otp);
      return Right(message);
    } catch (e) {
      return Left(_mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, String>> resetPassword(
    String email,
    String newPassword,
  ) async {
    try {
      final message = await remoteDatasource.resetPassword(email, newPassword);
      return Right(message);
    } catch (e) {
      return Left(_mapExceptionToFailure(e));
    }
  }

  @override
  Future<void> logout() async {
    await localDatasource.clearCache();
  }

  @override
  UserEntity? getCachedUser() {
    final model = localDatasource.getCachedUser();
    return model?.toEntity();
  }

  Failure _mapExceptionToFailure(Object error) {
    if (error is UnauthorizedException) {
      return UnauthorizedFailure(error.message);
    }
    if (error is NetworkException) {
      return NetworkFailure(error.message);
    }
    if (error is ServerException) {
      return ServerFailure(error.message);
    }
    return ServerFailure(error.toString());
  }
}
