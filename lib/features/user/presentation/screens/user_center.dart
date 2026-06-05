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
                    UserMenuItem(
                      icon: Icons.person_outline,
                      title: 'profile.info'.tr,
                      onTap: () => Get.toNamed(RoutePath.profile),
                    ),

                    UserMenuItem(
                      icon: Icons.track_changes_outlined,
                      title: 'profile.savingGoals'.tr,
                      onTap: () => Get.toNamed(RoutePath.savingGoalManagement),
                    ),

                    UserMenuItem(
                      icon: Icons.fact_check_outlined,
                      title: 'Kế hoạch chi tiêu',
                      onTap: () => Get.toNamed(RoutePath.spendingPlanList),
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
                      icon: Icons.analytics_outlined,
                      title: 'profile.personalFinanceProfile'.tr,
                      onTap: () => Get.toNamed(RoutePath.personalFinanceProfile),
                    ),
                    UserMenuItem(
                      icon: Icons.assessment_outlined,
                      title: 'profile.modelEvaluation'.tr,
                      onTap: () => Get.toNamed(RoutePath.modelEvaluation),
                    ),

                    UserMenuItem(
                      icon: Icons.exit_to_app,
                      title: 'auth.logout'.tr,
                      onTap: () async {
                        await authController.logout();
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
