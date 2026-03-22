import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:money_care/core/storage/local_storage.dart';
import 'package:money_care/features/auth/domain/entities/user_entity.dart';
import 'package:money_care/features/auth/domain/usecases/connect_gmail_usecase.dart';
import 'package:money_care/features/auth/domain/usecases/forgot_password_usecase.dart';
import 'package:money_care/features/auth/domain/usecases/google_signin_usecase.dart';
import 'package:money_care/features/auth/domain/usecases/login_usecase.dart';
import 'package:money_care/features/auth/domain/usecases/logout_usecase.dart';
import 'package:money_care/features/auth/domain/usecases/register_usecase.dart';

class AuthController extends GetxController {
  final LoginUseCase loginUseCase;
  final GoogleSignInUseCase googleSignInUseCase;
  final RegisterUseCase registerUseCase;
  final LogoutUseCase logoutUseCase;
  final ConnectGmailUseCase connectGmailUseCase;
  final ForgotPasswordUseCase forgotPasswordUseCase;
  final VerifyOtpUseCase verifyOtpUseCase;
  final ResetPasswordUseCase resetPasswordUseCase;
  final LocalStorage storage;

  AuthController({
    required this.loginUseCase,
    required this.googleSignInUseCase,
    required this.registerUseCase,
    required this.logoutUseCase,
    required this.connectGmailUseCase,
    required this.forgotPasswordUseCase,
    required this.verifyOtpUseCase,
    required this.resetPasswordUseCase,
    required this.storage,
  });

  var user = Rxn<UserEntity>();
  var isLoading = false.obs;
  var isGoogleLogin = false.obs;

  Future<void> login(String email, String password) async {
    try {
      isLoading.value = true;
      final entity = await loginUseCase(email, password);
      isGoogleLogin.value = false;
      user.value = entity;
    } finally {
      isLoading.value = false;
    }
  }

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

  Future<String> register(
    String email,
    String password,
    String firstName,
    String lastName,
  ) async {
    try {
      isLoading.value = true;
      return await registerUseCase(
        email: email,
        password: password,
        firstName: firstName,
        lastName: lastName,
      );
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

  Future<void> connectGmail() async {
    try {
      isLoading.value = true;
      await connectGmailUseCase();
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

  UserEntity? getUserInfo() => user.value;
}
