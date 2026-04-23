import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:money_care/core/constants/route_path.dart';
import 'package:money_care/app/widgets/layout/app_header.dart';
import 'package:money_care/features/auth/presentation/controllers/auth_controller.dart';
import 'package:money_care/core/constants/colors.dart';
import 'package:money_care/core/constants/text_string.dart';
import 'package:money_care/features/user/presentation/widgets/user_menu_item.dart';

class UserCenterScreen extends StatefulWidget {
  const UserCenterScreen({super.key});

  @override
  State<UserCenterScreen> createState() => _UserCenterScreenState();
}

class _UserCenterScreenState extends State<UserCenterScreen> {
  final AuthController authController = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
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
