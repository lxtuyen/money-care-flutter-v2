import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:money_care/core/constants/route_path.dart';
import 'package:money_care/core/utils/Helper/helper_functions.dart';
import 'package:money_care/core/utils/validatiors/validation.dart';
import 'package:money_care/features/auth/presentation/controllers/auth_controller.dart';

class ForgotPasswordController extends GetxController {
  final AuthController authController;

  ForgotPasswordController({required this.authController});

  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  RxBool get isLoading => authController.isLoading;

  String? validateEmail(String? value) => AppValidator.validateEmail(value);

  Future<void> submitForgotPassword() async {
    final formState = formKey.currentState;
    if (formState == null || !formState.validate()) {
      return;
    }

    try {
      final message = await authController.forgotPassword(
        emailController.text.trim(),
      );
      Get.offAllNamed(RoutePath.otp);
      AppHelperFunction.showSnackBar(message);
    } catch (e) {
      AppHelperFunction.showSnackBar(e.toString());
    }
  }

  @override
  void onClose() {
    emailController.dispose();
    super.onClose();
  }
}
