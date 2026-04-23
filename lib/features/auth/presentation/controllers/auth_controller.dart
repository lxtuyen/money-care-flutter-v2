import 'package:fpdart/fpdart.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:money_care/core/constants/route_path.dart';
import 'package:money_care/core/errors/failure.dart';
import 'package:money_care/core/storage/local_storage.dart';
import 'package:money_care/features/auth/domain/entities/user_entity.dart';
import 'package:money_care/features/auth/domain/usecases/forgot_password_usecase.dart';
import 'package:money_care/features/auth/domain/usecases/google_signin_usecase.dart';
import 'package:money_care/features/auth/domain/usecases/get_cached_user_usecase.dart';
import 'package:money_care/features/auth/domain/usecases/logout_usecase.dart';
import 'package:money_care/app/services/notification_service.dart';
import 'package:money_care/app/controllers/app_controller.dart';

class AuthController extends GetxController {
  final GoogleSignIn _googleSignIn = GoogleSignIn.instance;
  final GoogleSignInUseCase googleSignInUseCase;
  final LogoutUseCase logoutUseCase;
  final ForgotPasswordUseCase forgotPasswordUseCase;
  final VerifyOtpUseCase verifyOtpUseCase;
  final ResetPasswordUseCase resetPasswordUseCase;
  final GetCachedUserUseCase getCachedUserUseCase;
  final LocalStorage storage;

  AuthController({
    required this.googleSignInUseCase,
    required this.logoutUseCase,
    required this.forgotPasswordUseCase,
    required this.verifyOtpUseCase,
    required this.resetPasswordUseCase,
    required this.getCachedUserUseCase,
    required this.storage,
  });

  final user = Rxn<UserEntity>();
  final isLoading = false.obs;
  final isGoogleLogin = false.obs;

  @override
  void onInit() {
    super.onInit();
    initialize();
  }

  void initialize() {
    final cachedUser = getCachedUserUseCase();
    if (cachedUser != null) {
      user.value = cachedUser;
      try {
        Get.find<NotificationService>().syncToken();
      } catch (e) {
        print('NotificationService syncToken on restart error: $e');
      }
    }

    ever(user, (UserEntity? currentUser) {
      if (currentUser != null) {
        try {
          Get.find<AppController>().setUserId(currentUser.id);
          Get.find<NotificationService>().syncToken();
        } catch (e) {
          print('AuthController error during user sync: $e');
        }
      }
    });
  }

  Future<Either<Failure, UserEntity>> loginWithGoogle() async {
    try {
      isLoading.value = true;
      final result = await googleSignInUseCase();
      result.match((_) => isGoogleLogin.value = false, (entity) {
        isGoogleLogin.value = true;
        user.value = entity;
      });
      return result;
    } finally {
      isLoading.value = false;
    }
  }

  Future<Either<Failure, String>> forgotPassword(String email) async {
    try {
      isLoading.value = true;
      final result = await forgotPasswordUseCase(email);
      if (result.isRight()) {
        await storage.writeString('user_email', email);
      }
      return result;
    } finally {
      isLoading.value = false;
    }
  }

  Future<Either<Failure, String>> verifyOtp(String otp) async {
    try {
      isLoading.value = true;
      final email = storage.readString('user_email');
      if (email == null || email.isEmpty) {
        return const Left(
          ServerFailure('Khong tim thay email de xac thuc OTP'),
        );
      }
      return await verifyOtpUseCase(email, otp);
    } finally {
      isLoading.value = false;
    }
  }

  Future<Either<Failure, String>> resetPassword(String newPassword) async {
    try {
      isLoading.value = true;
      final email = storage.readString('user_email');
      if (email == null || email.isEmpty) {
        return const Left(
          ServerFailure('Khong tim thay email de dat lai mat khau'),
        );
      }
      final result = await resetPasswordUseCase(email, newPassword);
      if (result.isRight()) {
        await storage.remove('user_email');
      }
      return result;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> logout() async {
    try {
      await Get.find<NotificationService>().removeTokenFromServer();
    } catch (e) {
      print('NotificationService error: $e');
    }

    if (isGoogleLogin.value) {
      await _googleSignIn.signOut();
    }
    isGoogleLogin.value = false;
    user.value = null;
    try {
      Get.find<AppController>().clearUser();
    } catch (_) {}
    await logoutUseCase();
  }

  Future<void> loginWithGoogleAndNavigate() async {
    final result = await loginWithGoogle();
    result.match((_) {}, (currentUser) {
      try {
        Get.find<AppController>().setUserId(currentUser.id);

        if (currentUser.role == 'user') {
          final destination = currentUser.hasCategories
              ? RoutePath.main
              : RoutePath.onboardingWelcome;
          Get.offAllNamed(destination);
          return;
        }
        if (currentUser.role == 'admin') {
          Get.offAllNamed(RoutePath.adminHome);
        }
      } catch (_) {}
    });
  }

  UserEntity? getUserInfo() => user.value;
}
