import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:money_care/core/constants/route_path.dart';
import 'package:money_care/core/utils/Helper/helper_functions.dart';
import 'package:money_care/core/utils/validatiors/validation.dart';
import 'package:money_care/features/auth/domain/usecases/register_usecase.dart';

class RegisterController extends GetxController {
  final RegisterUseCase registerUseCase;

  RegisterController({required this.registerUseCase});

  final isLoading = false.obs;
  final registerFormKey = GlobalKey<FormState>();
  final registerFirstNameController = TextEditingController();
  final registerLastNameController = TextEditingController();
  final registerEmailController = TextEditingController();
  final registerPasswordController = TextEditingController();
  final registerConfirmPasswordController = TextEditingController();
  final isRegisterPasswordObscure = true.obs;

  String? validateRegisterFirstName(String? value) =>
      AppValidator.validateFirstName(value);

  String? validateRegisterLastName(String? value) =>
      AppValidator.validateLastName(value);

  String? validateRegisterEmail(String? value) =>
      AppValidator.validateEmail(value);

  String? validateRegisterPassword(String? value) =>
      AppValidator.validatePassword(value);

  String? validateRegisterConfirmPassword(String? value) =>
      AppValidator.validateConfirmPassword(
        registerPasswordController.text,
        value,
      );

  void toggleRegisterPasswordVisibility() {
    isRegisterPasswordObscure.toggle();
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

  Future<void> submitRegister() async {
    final formState = registerFormKey.currentState;
    if (formState == null || !formState.validate()) {
      return;
    }

    try {
      final message = await register(
        registerEmailController.text.trim(),
        registerPasswordController.text,
        registerFirstNameController.text.trim(),
        registerLastNameController.text.trim(),
      );

      Get.offAllNamed(RoutePath.login);
      AppHelperFunction.showSnackBar(message);
    } catch (e) {
      AppHelperFunction.showSnackBar(e.toString());
    }
  }

  @override
  void onClose() {
    registerFirstNameController.dispose();
    registerLastNameController.dispose();
    registerEmailController.dispose();
    registerPasswordController.dispose();
    registerConfirmPasswordController.dispose();
    super.onClose();
  }
}
