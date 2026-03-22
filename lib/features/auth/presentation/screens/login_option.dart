import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:money_care/core/constants/route_path.dart';
import 'package:money_care/features/auth/presentation/controllers/auth_controller.dart';
import 'package:money_care/core/constants/image_string.dart';
import 'package:money_care/core/constants/colors.dart';
import 'package:money_care/core/constants/text_string.dart';
import 'package:money_care/core/presentation/widgets/image/circular_image.dart';

class LoginOptionScreen extends StatelessWidget {
  const LoginOptionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthController authController = Get.find<AuthController>();

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

                const SizedBox(height: 40),

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
                const SizedBox(height: 30),

                ElevatedButton(
                  onPressed: () async {
                    final user = await authController.loginWithGoogle();
                    if (user.role == 'user') {
                      Get.offAllNamed(
                        user.savingFund != null
                            ? RoutePath.main
                            : RoutePath.onboardingWelcome,
                      );
                      return;
                    }

                    if (user.role == 'admin') {
                      Get.offAllNamed(RoutePath.adminHome);
                      return;
                    }
                  },
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
                ),

                const SizedBox(height: 16),

                ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.facebook,
                    color: Colors.white,
                    size: 22,
                  ),
                  label: const Text(
                    AppTexts.loginWithFacebook,
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(50),
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      AppTexts.alreadyHaveAccount,
                      style: TextStyle(fontSize: 14, color: AppColors.text1),
                    ),
                    GestureDetector(
                      onTap: () => Get.toNamed(RoutePath.login),
                      child: const Text(
                        AppTexts.login,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
