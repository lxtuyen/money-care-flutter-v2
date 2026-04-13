import 'package:get/get.dart';
import 'package:money_care/core/network/api_client.dart';
import 'package:money_care/core/storage/local_storage.dart';
import 'package:money_care/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:money_care/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:money_care/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:money_care/features/auth/domain/repositories/auth_repository.dart';
import 'package:money_care/features/auth/domain/usecases/forgot_password_usecase.dart';
import 'package:money_care/features/auth/domain/usecases/get_cached_user_usecase.dart';
import 'package:money_care/features/auth/domain/usecases/google_signin_usecase.dart';
import 'package:money_care/features/auth/domain/usecases/login_usecase.dart';
import 'package:money_care/features/auth/domain/usecases/logout_usecase.dart';
import 'package:money_care/features/auth/domain/usecases/register_usecase.dart';
import 'package:money_care/features/auth/presentation/controllers/auth_controller.dart';
import 'package:money_care/features/auth/presentation/controllers/forgot_password_controller.dart';
import 'package:money_care/features/auth/presentation/controllers/login_controller.dart';
import 'package:money_care/features/auth/presentation/controllers/login_option_controller.dart';
import 'package:money_care/features/auth/presentation/controllers/otp_controller.dart';
import 'package:money_care/features/auth/presentation/controllers/register_controller.dart';
import 'package:money_care/features/auth/presentation/controllers/reset_password_controller.dart';

class AuthBinding extends Bindings {
  @override
  void dependencies() {
    final apiClient = Get.find<ApiClient>();
    final localStorage = Get.find<LocalStorage>();
    final remoteDatasource = AuthRemoteDatasourceImpl(api: apiClient);
    final localDatasource = AuthLocalDatasourceImpl(storage: localStorage);

    final repository = AuthRepositoryImpl(
      remoteDatasource: remoteDatasource,
      localDatasource: localDatasource,
    );

    Get.lazyPut<AuthRepository>(() => repository);

    Get.lazyPut(() => GetCachedUserUseCase(Get.find<AuthRepository>()));
    Get.lazyPut(() => GoogleSignInUseCase(Get.find<AuthRepository>()));
    Get.lazyPut(() => LogoutUseCase(Get.find<AuthRepository>()));
    Get.lazyPut(() => ForgotPasswordUseCase(Get.find<AuthRepository>()));
    Get.lazyPut(() => VerifyOtpUseCase(Get.find<AuthRepository>()));
    Get.lazyPut(() => ResetPasswordUseCase(Get.find<AuthRepository>()));

    Get.put<AuthController>(
      AuthController(
        googleSignInUseCase: Get.find<GoogleSignInUseCase>(),
        logoutUseCase: Get.find<LogoutUseCase>(),
        forgotPasswordUseCase: Get.find<ForgotPasswordUseCase>(),
        verifyOtpUseCase: Get.find<VerifyOtpUseCase>(),
        resetPasswordUseCase: Get.find<ResetPasswordUseCase>(),
        getCachedUserUseCase: Get.find<GetCachedUserUseCase>(),
        storage: localStorage,
      ),
      permanent: true,
    );

    Get.lazyPut<LoginController>(
      () => LoginController(
        loginUseCase: LoginUseCase(repository),
        authController: Get.find<AuthController>(),
      ),
      fenix: true,
    );

    Get.lazyPut<RegisterController>(
      () => RegisterController(
        registerUseCase: RegisterUseCase(repository),
      ),
      fenix: true,
    );

    Get.lazyPut<ForgotPasswordController>(
      () => ForgotPasswordController(
        authController: Get.find<AuthController>(),
      ),
      fenix: true,
    );

    Get.lazyPut<ResetPasswordController>(
      () => ResetPasswordController(
        authController: Get.find<AuthController>(),
      ),
      fenix: true,
    );

    Get.lazyPut<OtpController>(
      () => OtpController(
        authController: Get.find<AuthController>(),
      ),
      fenix: true,
    );

    Get.lazyPut<LoginOptionController>(
      () => LoginOptionController(
        authController: Get.find<AuthController>(),
      ),
      fenix: true,
    );
  }
}
