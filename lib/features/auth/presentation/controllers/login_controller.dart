import 'package:flutter/material.dart';
import 'package:fpdart/fpdart.dart';
import 'package:get/get.dart';
import 'package:money_care/core/constants/route_path.dart';
import 'package:money_care/core/errors/failure.dart';
import 'package:money_care/core/utils/helper/helper_functions.dart';
import 'package:money_care/core/utils/validators/validation.dart';
import 'package:money_care/features/auth/domain/entities/user_entity.dart';
import 'package:money_care/features/auth/domain/usecases/login_usecase.dart';
import 'package:money_care/features/auth/presentation/controllers/auth_controller.dart';

class LoginController extends GetxController {
  final LoginUseCase loginUseCase;
  final AuthController authController;

  LoginController({
    required this.loginUseCase,
    required this.authController,
  });

  final isLoading = false.obs;
  final loginFormKey = GlobalKey<FormState>();
  final loginEmailController = TextEditingController();
  final loginPasswordController = TextEditingController();
  final isLoginPasswordObscure = true.obs;

  String? validateLoginEmail(String? value) => AppValidator.validateEmail(value);

  String? validateLoginPassword(String? value) =>
      AppValidator.validatePassword(value);

  void toggleLoginPasswordVisibility() {
    isLoginPasswordObscure.toggle();
  }

  Future<Either<Failure, UserEntity>> login(
    String email,
    String password,
  ) async {
    try {
      isLoading.value = true;
      final result = await loginUseCase(email, password);
      result.match((_) => authController.isGoogleLogin.value = false, (entity) {
        authController.isGoogleLogin.value = false;
        authController.user.value = entity;
      });
      return result;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> submitLogin() async {
    final formState = loginFormKey.currentState;
    if (formState == null || !formState.validate()) {
      return;
    }

    final result = await login(
      loginEmailController.text.trim(),
      loginPasswordController.text.trim(),
    );

    result.match((failure) => AppHelperFunction.showSnackBar(failure.message), (
      currentUser,
    ) {
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
        return;
      }

      AppHelperFunction.showSnackBar('ÄÄƒng nháº­p tháº¥t báº¡i');
    });
  }

  @override
  void onClose() {
    loginEmailController.dispose();
    loginPasswordController.dispose();
    super.onClose();
  }
}
