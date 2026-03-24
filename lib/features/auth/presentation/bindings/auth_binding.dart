import 'package:get/get.dart';
import 'package:money_care/core/network/api_client.dart';
import 'package:money_care/core/storage/local_storage.dart';
import 'package:money_care/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:money_care/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:money_care/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:money_care/features/auth/domain/usecases/forgot_password_usecase.dart';
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
  final ApiClient apiClient;
  final LocalStorage localStorage;

  AuthBinding({required this.apiClient, required this.localStorage});

  @override
  void dependencies() {
    final remoteDatasource = AuthRemoteDatasourceImpl(api: apiClient);
    final localDatasource = AuthLocalDatasourceImpl(storage: localStorage);

    final repository = AuthRepositoryImpl(
      remoteDatasource: remoteDatasource,
      localDatasource: localDatasource,
    );

    Get.lazyPut<AuthController>(
      () => AuthController(
        googleSignInUseCase: GoogleSignInUseCase(repository),
        logoutUseCase: LogoutUseCase(repository),
        forgotPasswordUseCase: ForgotPasswordUseCase(repository),
        verifyOtpUseCase: VerifyOtpUseCase(repository),
        resetPasswordUseCase: ResetPasswordUseCase(repository),
        storage: localStorage,
      ),
      fenix: true,
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
