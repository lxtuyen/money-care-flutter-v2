import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:money_care/core/constants/colors.dart';
import 'package:money_care/core/constants/image_string.dart';
import 'package:money_care/core/constants/route_path.dart';
import 'package:money_care/core/constants/text_string.dart';
import 'package:money_care/app/widgets/button/primary_button.dart';
import 'package:money_care/app/widgets/image/circular_image.dart';
import 'package:money_care/features/auth/presentation/controllers/login_option_controller.dart';
import 'package:money_care/features/auth/presentation/widgets/auth_redirect_text.dart';

class LoginOptionScreen extends GetView<LoginOptionController> {
  const LoginOptionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 480),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircularImages(image: AppImages.logo, height: 100, width: 100),
                const Text(
                  AppTexts.login,
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: AppColors.text1,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  AppTexts.loginDescription,
                  style: TextStyle(fontSize: 15, color: AppColors.text3),
                ),
                const SizedBox(height: 20),
                Obx(() {
                  if (controller.isLoading.value) {
                    return PrimaryButton(
                      label: AppTexts.loginWithGoogle,
                      onPressed: controller.loginWithGoogleAndNavigate,
                      isLoading: true,
                    );
                  }

                  return ElevatedButton(
                    onPressed: controller.loginWithGoogleAndNavigate,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: AppColors.text1,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: const BorderSide(color: AppColors.borderPrimary),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      elevation: 1,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularImages(
                          image: AppImages.google,
                          width: 40,
                          height: 40,
                        ),
                        const SizedBox(width: 16),
                        const Text(
                          AppTexts.loginWithGoogle,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  );
                }),
                const SizedBox(height: 20),
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
    );
  }
}
