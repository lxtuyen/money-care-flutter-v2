import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:money_care/core/constants/route_path.dart';
import 'package:money_care/app/widgets/layout/app_header.dart';
import 'package:money_care/features/auth/presentation/controllers/auth_controller.dart';
import 'package:money_care/core/constants/colors.dart';
import 'package:money_care/core/constants/text_string.dart';
import 'package:money_care/features/user/presentation/widgets/user_menu_item.dart';
import 'package:money_care/app/controllers/app_controller.dart';
import 'package:money_care/core/theme/app_theme_colors.dart';

class UserCenterScreen extends StatefulWidget {
  const UserCenterScreen({super.key});

  @override
  State<UserCenterScreen> createState() => _UserCenterScreenState();
}

class _UserCenterScreenState extends State<UserCenterScreen> {
  final AuthController authController = Get.find<AuthController>();
  final AppController appController = Get.find<AppController>();

  @override
  Widget build(BuildContext context) {
    final themeColors = AppThemeColors.of(context);

    return Scaffold(
      backgroundColor: themeColors.cardBackground,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const AppHeader(title: AppTexts.profileTitle, height: 140),

              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Dark mode toggle
                    Obx(() => Container(
                      margin: const EdgeInsets.only(bottom: 4),
                      decoration: BoxDecoration(
                        color: themeColors.surfaceBackground,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: ListTile(
                        leading: Icon(
                          appController.isDarkMode.value
                              ? Icons.dark_mode_rounded
                              : Icons.light_mode_rounded,
                          color: AppColors.primary,
                        ),
                        title: Text(
                          'Chế độ tối',
                          style: TextStyle(fontSize: 16, color: themeColors.textPrimary),
                        ),
                        trailing: Switch.adaptive(
                          value: appController.isDarkMode.value,
                          onChanged: (_) => appController.toggleDarkMode(),
                          activeColor: AppColors.primary,
                        ),
                      ),
                    )),
                    const Divider(height: 1, thickness: 0.5),

                    UserMenuItem(
                      icon: Icons.person_outline,
                      title: AppTexts.profile,
                      onTap: () => Get.toNamed(RoutePath.profile),
                    ),

                    UserMenuItem(
                      icon: Icons.track_changes_outlined,
                      title: AppTexts.funds,
                      onTap: () => Get.toNamed(RoutePath.selectSavingGoal),
                    ),

                    UserMenuItem(
                      icon: Icons.timer_off_outlined,
                      title: "Mục tiêu đã hết hạn",
                      onTap: () => Get.toNamed(RoutePath.expiredSavingGoals),
                    ),

                    UserMenuItem(
                      icon: Icons.category_rounded,
                      title: "Quản lý danh mục",
                      onTap: () => Get.toNamed(RoutePath.categoryManagement),
                    ),

                    UserMenuItem(
                      icon: Icons.exit_to_app,
                      title: AppTexts.logout,
                      onTap: () {
                        authController.logout();
                        Get.offAllNamed(RoutePath.loginOption);
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
