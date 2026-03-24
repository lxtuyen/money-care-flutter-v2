import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:money_care/core/constants/route_path.dart';
import 'package:money_care/core/storage/local_storage.dart';
import 'package:money_care/features/auth/domain/entities/user_entity.dart';
import 'package:money_care/features/auth/domain/usecases/forgot_password_usecase.dart';
import 'package:money_care/features/auth/domain/usecases/google_signin_usecase.dart';
import 'package:money_care/features/auth/domain/usecases/logout_usecase.dart';

class AuthController extends GetxController {
  final GoogleSignInUseCase googleSignInUseCase;
  final LogoutUseCase logoutUseCase;
  final ForgotPasswordUseCase forgotPasswordUseCase;
  final VerifyOtpUseCase verifyOtpUseCase;
  final ResetPasswordUseCase resetPasswordUseCase;
  final LocalStorage storage;

  AuthController({
    required this.googleSignInUseCase,
    required this.logoutUseCase,
    required this.forgotPasswordUseCase,
    required this.verifyOtpUseCase,
    required this.resetPasswordUseCase,
    required this.storage,
  });

  final user = Rxn<UserEntity>();
  final isLoading = false.obs;
  final isGoogleLogin = false.obs;

  Future<UserEntity> loginWithGoogle() async {
    try {
      isLoading.value = true;
      final entity = await googleSignInUseCase();
      isGoogleLogin.value = true;
      user.value = entity;
      return entity;
    } finally {
      isLoading.value = false;
    }
  }

  Future<String> forgotPassword(String email) async {
    try {
      isLoading.value = true;
      final res = await forgotPasswordUseCase(email);
      await storage.writeString('user_email', email);
      return res;
    } finally {
      isLoading.value = false;
    }
  }

  Future<String> verifyOtp(String otp) async {
    try {
      isLoading.value = true;
      final email = storage.readString('user_email');
      return await verifyOtpUseCase(email!, otp);
    } finally {
      isLoading.value = false;
    }
  }

  Future<String> resetPassword(String newPassword) async {
    try {
      isLoading.value = true;
      final email = storage.readString('user_email');
      final res = await resetPasswordUseCase(email!, newPassword);
      await storage.remove('user_email');
      return res;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> logout() async {
    if (isGoogleLogin.value) {
      await GoogleSignIn().signOut();
    }
    isGoogleLogin.value = false;
    user.value = null;
    await logoutUseCase();
  }

  Future<void> loginWithGoogleAndNavigate() async {
    final currentUser = await loginWithGoogle();
    if (currentUser.role == 'user') {
      Get.offAllNamed(
        currentUser.savingFund != null
            ? RoutePath.main
            : RoutePath.onboardingWelcome,
      );
      return;
    }
    if (currentUser.role == 'admin') {
      Get.offAllNamed(RoutePath.adminHome);
    }
  }

  UserEntity? getUserInfo() => user.value;
}
