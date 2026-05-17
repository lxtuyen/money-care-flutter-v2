import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:money_care/core/constants/route_path.dart';
import 'package:money_care/app/widgets/layout/app_header.dart';
import 'package:money_care/features/auth/presentation/controllers/auth_controller.dart';
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
              AppHeader(title: 'profile.title'.tr, height: 140),

              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /*
                    Obx(() => ListTile(
                      leading: Icon(
                        appController.isDarkMode.value
                            ? Icons.dark_mode_rounded
                            : Icons.light_mode_rounded,
                        color: AppColors.primary,
                      ),
                      title: Text(
                        'profile.darkMode'.tr,
                        style: TextStyle(fontSize: 16, color: themeColors.textPrimary),
                      ),
                      trailing: Switch.adaptive(
                        value: appController.isDarkMode.value,
                        onChanged: (_) => appController.toggleDarkMode(),
                        activeColor: AppColors.primary,
                      ),
                    )),
                    const Divider(height: 1, thickness: 0.5),

                    Obx(() => ListTile(
                      leading: const Icon(
                        Icons.language_rounded,
                        color: AppColors.primary,
                      ),
                      title: Text(
                        'profile.language'.tr,
                        style: TextStyle(fontSize: 16, color: themeColors.textPrimary),
                      ),
                      trailing: GestureDetector(
                        onTap: () => appController.toggleLocale(),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: AppColors.primary.withOpacity(0.3),
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                appController.currentLocale.value == 'vi_VN' ? '🇻🇳' : '🇺🇸',
                                style: const TextStyle(fontSize: 16),
                              ),
                              const SizedBox(width: 6),
                              Text(
                                appController.currentLocale.value == 'vi_VN'
                                    ? 'VI'
                                    : 'EN',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.primary,
                                ),
                              ),
                              const SizedBox(width: 4),
                              Icon(
                                Icons.swap_horiz_rounded,
                                size: 16,
                                color: AppColors.primary,
                              ),
                            ],
                          ),
                        ),
                      ),
                    )),
                    const Divider(height: 1, thickness: 0.5),
                    */
                    UserMenuItem(
                      icon: Icons.person_outline,
                      title: 'profile.info'.tr,
                      onTap: () => Get.toNamed(RoutePath.profile),
                    ),

                    UserMenuItem(
                      icon: Icons.track_changes_outlined,
                      title: 'profile.savingGoals'.tr,
                      onTap: () => Get.toNamed(RoutePath.selectSavingGoal),
                    ),

                    UserMenuItem(
                      icon: Icons.fact_check_outlined,
                      title: 'Kế hoạch chi tiêu',
                      onTap: () => Get.toNamed(RoutePath.spendingPlanList),
                    ),

                    UserMenuItem(
                      icon: Icons.timer_off_outlined,
                      title: 'profile.expiredGoals'.tr,
                      onTap: () => Get.toNamed(RoutePath.expiredSavingGoals),
                    ),

                    UserMenuItem(
                      icon: Icons.category_rounded,
                      title: 'profile.categoryManagement'.tr,
                      onTap: () => Get.toNamed(RoutePath.categoryManagement),
                    ),
                    UserMenuItem(
                      icon: Icons.account_balance_wallet_outlined,
                      title: 'Ví của tôi',
                      onTap: () => Get.toNamed(RoutePath.wallets),
                    ),

                    UserMenuItem(
                      icon: Icons.exit_to_app,
                      title: 'auth.logout'.tr,
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
