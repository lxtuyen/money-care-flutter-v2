import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:money_care/core/constants/colors.dart';
import 'package:money_care/core/constants/route_path.dart';
import 'package:money_care/core/constants/text_string.dart';
import 'package:money_care/app/widgets/button/primary_button.dart';
import 'package:money_care/app/widgets/text_field/app_text_form_field.dart';
import 'package:money_care/features/auth/presentation/controllers/register_controller.dart';
import 'package:money_care/features/auth/presentation/widgets/auth_header.dart';
import 'package:money_care/features/auth/presentation/widgets/auth_redirect_text.dart';

class RegisterScreen extends GetView<RegisterController> {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 480),
                child: Form(
                  key: controller.registerFormKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const AuthHeader(
                        title: AppTexts.signup,
                        subtitle: AppTexts.registerSubtitle,
                        topSpacing: 35,
                      ),
                      const SizedBox(height: 15),

                      Row(
                        children: [
                          Expanded(
                            child: AppTextFormField(
                              controller: controller.registerFirstNameController,
                              label: AppTexts.firstName,
                              icon: Icons.person_outline_rounded,
                              keyboardType: TextInputType.name,
                              textInputAction: TextInputAction.next,
                              validator: controller.validateRegisterFirstName,
                            ),
                          ),
                          const SizedBox(width: 10),

                          Expanded(
                            child: AppTextFormField(
                              controller: controller.registerLastNameController,
                              label: AppTexts.lastName,
                              icon: Icons.person_rounded,
                              keyboardType: TextInputType.name,
                              textInputAction: TextInputAction.next,
                              validator: controller.validateRegisterLastName,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 10),

                      AppTextFormField(
                        controller: controller.registerEmailController,
                        label: AppTexts.emailLabel,
                        icon: Icons.alternate_email_rounded,
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                        validator: controller.validateRegisterEmail,
                      ),

                      const SizedBox(height: 10),

                      Obx(() {
                        return AppTextFormField(
                          controller: controller.registerPasswordController,
                          label: AppTexts.passwordLabel,
                          icon: Icons.lock_outline_rounded,
                          suffixIcon: IconButton(
                            icon: Icon(
                              controller.isRegisterPasswordObscure.value
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              color: AppColors.text4,
                            ),
                            onPressed: controller.toggleRegisterPasswordVisibility,
                          ),
                          keyboardType: TextInputType.visiblePassword,
                          obscureText: controller.isRegisterPasswordObscure.value,
                          textInputAction: TextInputAction.next,
                          validator: controller.validateRegisterPassword,
                        );
                      }),

                      const SizedBox(height: 10),

                      Obx(() {
                        return AppTextFormField(
                          controller: controller.registerConfirmPasswordController,
                          label: AppTexts.confirmPasswordLabel,
                          icon: Icons.lock_outline_rounded,
                          suffixIcon: IconButton(
                            icon: Icon(
                              controller.isRegisterPasswordObscure.value
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              color: AppColors.text4,
                            ),
                            onPressed: controller.toggleRegisterPasswordVisibility,
                          ),
                          obscureText: controller.isRegisterPasswordObscure.value,
                          keyboardType: TextInputType.visiblePassword,
                          textInputAction: TextInputAction.done,
                          validator: controller.validateRegisterConfirmPassword,
                        );
                      }),
                      const SizedBox(height: 10),

                      Obx(() {
                        return PrimaryButton(
                          label: AppTexts.signup,
                          onPressed: controller.submitRegister,
                          isLoading: controller.isLoading.value,
                        );
                      }),
                      const SizedBox(height: 30),
                      AuthRedirectText(
                        leadingText: AppTexts.alreadyHaveAccount,
                        actionText: AppTexts.login,
                        onTap: () {
                          Get.toNamed(RoutePath.login);
                        },
                      ),
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
