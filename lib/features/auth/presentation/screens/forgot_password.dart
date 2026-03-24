import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:money_care/core/constants/colors.dart';
import 'package:money_care/core/constants/route_path.dart';
import 'package:money_care/core/constants/text_string.dart';
import 'package:money_care/core/presentation/widgets/button/primary_button.dart';
import 'package:money_care/core/presentation/widgets/text_field/app_text_form_field.dart';
import 'package:money_care/features/auth/presentation/controllers/forgot_password_controller.dart';
import 'package:money_care/features/auth/presentation/widgets/auth_header.dart';
import 'package:money_care/features/auth/presentation/widgets/auth_redirect_text.dart';

class ForgotPasswordScreen extends GetView<ForgotPasswordController> {
  const ForgotPasswordScreen({super.key});

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
                    title: AppTexts.forgotPasswordTitle,
                    subtitle: AppTexts.forgotPasswordDescription,
                    subtitleColor: AppColors.text4,
                  ),
                  const SizedBox(height: 20),
                  AppTextFormField(
                    controller: controller.emailController,
                    label: AppTexts.emailLabel,
                    icon: Icons.alternate_email_rounded,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.done,
                    validator: controller.validateEmail,
                  ),
                  const SizedBox(height: 20),
                  Obx(() {
                    return PrimaryButton(
                      label: AppTexts.getOtp,
                      onPressed: controller.submitForgotPassword,
                      isLoading: controller.isLoading.value,
                    );
                  }),
                  const Spacer(),
                  AuthRedirectText(
                    leadingText: AppTexts.rememberPassword,
                    actionText: AppTexts.login,
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
