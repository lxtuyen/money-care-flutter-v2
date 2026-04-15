import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:money_care/core/constants/route_path.dart';
import 'package:money_care/app/widgets/layout/app_header.dart';
import 'package:money_care/features/auth/presentation/controllers/auth_controller.dart';
import 'package:money_care/app/controllers/statistics_controller.dart';
import 'package:money_care/app/controllers/fund_controller.dart';
import 'package:money_care/app/controllers/user_controller.dart';
import 'package:money_care/core/constants/colors.dart';
import 'package:money_care/core/constants/text_string.dart';
import 'package:money_care/app/controllers/app_controller.dart';
import 'package:money_care/features/user/presentation/widgets/user_menu_item.dart';
import 'package:money_care/features/user/presentation/widgets/savings_goals.dart';

class UserCenterScreen extends StatefulWidget {
  const UserCenterScreen({super.key});

  @override
  State<UserCenterScreen> createState() => _UserCenterScreenState();
}

class _UserCenterScreenState extends State<UserCenterScreen> {
  final AppController appController = Get.find<AppController>();
  final AuthController authController = Get.find<AuthController>();
  final UserController userController = Get.find<UserController>();
  final StatisticsController statisticsController = Get.find<StatisticsController>();
  final FundController fundController = Get.find<FundController>();

  @override
  void initState() {
    super.initState();
    initData();
  }

  Future<void> initData() async {
    await appController.getCurrentUserId();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const AppHeader(
                title: AppTexts.profileTitle,
                height: 140,
              ),

              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Obx(() {
                      final currentFund = fundController.currentFund.value;
                      if (currentFund == null) return const SizedBox.shrink();

                      final data = statisticsController.totalByType.value;

                      return Column(
                        children: [
                          if (statisticsController.isLoading.value)
                            const SizedBox(
                              height: 120,
                              child: Center(child: CircularProgressIndicator()),
                            )
                          else if (data == null)
                            const SavingsGoals(currentSaving: 0, targetSaving: 0)
                          else
                            SavingsGoals(
                              currentSaving: data.currentSaving.toDouble(),
                              targetSaving: data.targetSaving.toDouble(),
                            ),
                          const SizedBox(height: 20),
                        ],
                      );
                    }),

                    UserMenuItem(
                      icon: Icons.person_outline,
                      title: AppTexts.profile,
                      onTap: () => Get.toNamed(RoutePath.profile),
                    ),

                    UserMenuItem(
                      icon: Icons.category_outlined,
                      title: AppTexts.funds,
                      onTap: () => Get.toNamed(RoutePath.selectFund),
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


