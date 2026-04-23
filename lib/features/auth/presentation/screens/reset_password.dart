import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:money_care/core/constants/colors.dart';
import 'package:money_care/core/constants/route_path.dart';
import 'package:money_care/core/constants/text_string.dart';
import 'package:money_care/app/widgets/button/primary_button.dart';
import 'package:money_care/app/widgets/text_field/app_text_form_field.dart';
import 'package:money_care/features/auth/presentation/controllers/reset_password_controller.dart';
import 'package:money_care/features/auth/presentation/widgets/auth_header.dart';
import 'package:money_care/features/auth/presentation/widgets/auth_redirect_text.dart';

class ResetPasswordScreen extends GetView<ResetPasswordController> {
  const ResetPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 480),
            child: Form(
              key: controller.formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const AuthHeader(
                    title: AppTexts.resetPasswordTitle,
                    subtitle: AppTexts.resetPasswordDescription,
                  ),
                  const SizedBox(height: 20),
                  Obx(() {
                    return AppTextFormField(
                      controller: controller.passwordController,
                      label: AppTexts.passwordLabel,
                      icon: Icons.lock_outline_rounded,
                      suffixIcon: IconButton(
                        icon: Icon(
                          controller.isPasswordObscure.value
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: AppColors.text4,
                        ),
                        onPressed: controller.togglePasswordVisibility,
                      ),
                      keyboardType: TextInputType.visiblePassword,
                      obscureText: controller.isPasswordObscure.value,
                      textInputAction: TextInputAction.next,
                      validator: controller.validatePassword,
                    );
                  }),
                  const SizedBox(height: 10),
                  Obx(() {
                    return AppTextFormField(
                      controller: controller.confirmPasswordController,
                      label: AppTexts.confirmPasswordLabel,
                      icon: Icons.lock_outline_rounded,
                      suffixIcon: IconButton(
                        icon: Icon(
                          controller.isPasswordObscure.value
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: AppColors.text4,
                        ),
                        onPressed: controller.togglePasswordVisibility,
                      ),
                      obscureText: controller.isPasswordObscure.value,
                      keyboardType: TextInputType.visiblePassword,
                      textInputAction: TextInputAction.done,
                      validator: controller.validateConfirmPassword,
                    );
                  }),
                  const SizedBox(height: 20),
                  Obx(() {
                    return PrimaryButton(
                      label: AppTexts.confirmButton,
                      onPressed: controller.submitResetPassword,
                      isLoading: controller.isLoading.value,
                    );
                  }),
                  const Spacer(),
                  AuthRedirectText(
                    leadingText: AppTexts.rememberPassword,
                    actionText: AppTexts.login,
                    leadingColor: AppColors.text4,
                    onTap: () {
                      Get.toNamed(RoutePath.login);
                    },
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
