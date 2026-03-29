import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:money_care/core/constants/route_path.dart';
import 'package:money_care/core/utils/helper/helper_functions.dart';
import 'package:money_care/core/utils/validators/validation.dart';
import 'package:money_care/features/auth/presentation/controllers/auth_controller.dart';

class ResetPasswordController extends GetxController {
  final AuthController authController;

  ResetPasswordController({required this.authController});

  final formKey = GlobalKey<FormState>();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final isPasswordObscure = true.obs;
  RxBool get isLoading => authController.isLoading;

  String? validatePassword(String? value) => AppValidator.validatePassword(value);

  String? validateConfirmPassword(String? value) =>
      AppValidator.validateConfirmPassword(passwordController.text, value);

  void togglePasswordVisibility() {
    isPasswordObscure.toggle();
  }

  Future<void> submitResetPassword() async {
    final formState = formKey.currentState;
    if (formState == null || !formState.validate()) {
      return;
    }

    final result = await authController.resetPassword(passwordController.text);
    result.match((failure) => AppHelperFunction.showSnackBar(failure.message), (
      message,
    ) {
      Get.offAllNamed(RoutePath.login);
      AppHelperFunction.showSnackBar(message);
    });
  }

  @override
  void onClose() {
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
}
