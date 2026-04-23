import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:money_care/core/constants/colors.dart';
import 'package:money_care/core/constants/route_path.dart';
import 'package:money_care/core/constants/text_string.dart';
import 'package:money_care/app/widgets/button/primary_button.dart';
import 'package:money_care/app/widgets/text_field/app_text_form_field.dart';
import 'package:money_care/features/auth/presentation/controllers/login_controller.dart';
import 'package:money_care/features/auth/presentation/widgets/auth_header.dart';
import 'package:money_care/features/auth/presentation/widgets/auth_redirect_text.dart';

class LoginScreen extends GetView<LoginController> {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 480),
                child: Form(
                  key: controller.loginFormKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const AuthHeader(
                        title: AppTexts.login,
                        subtitle: AppTexts.loginSubtitle,
                        subtitleColor: AppColors.text1,
                      ),
                      const SizedBox(height: 10),
                      AppTextFormField(
                        controller: controller.loginEmailController,
                        label: AppTexts.emailLabel,
                        icon: Icons.alternate_email_rounded,
                        keyboardType: TextInputType.emailAddress,
                        validator: controller.validateLoginEmail,
                        textInputAction: TextInputAction.next,
                      ),
                      const SizedBox(height: 10),
                      Obx(() {
                        return AppTextFormField(
                          controller: controller.loginPasswordController,
                          label: AppTexts.passwordLabel,
                          icon: Icons.lock_outline_rounded,
                          suffixIcon: IconButton(
                            icon: Icon(
                              controller.isLoginPasswordObscure.value
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              color: AppColors.text4,
                            ),
                            onPressed: controller.toggleLoginPasswordVisibility,
                          ),
                          keyboardType: TextInputType.visiblePassword,
                          obscureText: controller.isLoginPasswordObscure.value,
                          validator: controller.validateLoginPassword,
                          textInputAction: TextInputAction.done,
                        );
                      }),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {
                            Get.toNamed(RoutePath.forgotPassword);
                          },
                          child: const Text(
                            AppTexts.forgotPassword,
                            style: TextStyle(
                              color: AppColors.text3,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                      Obx(() {
                        return PrimaryButton(
                          label: AppTexts.login,
                          onPressed: controller.submitLogin,
                          isLoading: controller.isLoading.value,
                        );
                      }),
                      const SizedBox(height: 30),
                      AuthRedirectText(
                        leadingText: AppTexts.noAccount,
                        actionText: AppTexts.signup,
                        onTap: () {
                          Get.toNamed(RoutePath.register);
                        },
                      ),
                      const SizedBox(height: 10),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
