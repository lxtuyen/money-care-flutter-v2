import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:money_care/core/constants/route_path.dart';
import 'package:money_care/core/presentation/widgets/layout/app_header.dart';
import 'package:money_care/features/auth/presentation/controllers/auth_controller.dart';
import 'package:money_care/features/statistics/presentation/controllers/statistics_controller.dart';
import 'package:money_care/features/saving_fund/presentation/controllers/saving_fund_controller.dart';
import 'package:money_care/features/user/presentation/controllers/user_controller.dart';
import 'package:money_care/core/constants/colors.dart';
import 'package:money_care/core/constants/text_string.dart';
import 'package:money_care/core/controllers/app_controller.dart';
import 'package:money_care/features/user/presentation/widgets/menu_item.dart';
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
  final SavingFundController fundController = Get.find<SavingFundController>();


  @override
  void initState() {
    super.initState();
    initData();
  }

  Future<void> initData() async {
    final userId = await appController.getCurrentUserId();

    if (userId == null) return;

    final currentFund = fundController.currentFund.value;
    await statisticsController.getTotalByType(
      userId,
      startDate: currentFund?.start_date,
      endDate: currentFund?.end_date,
    );
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
                      final data = statisticsController.totalByType.value;

                      if (statisticsController.isLoading.value) {
                        return const SizedBox(
                          height: 120,
                          child: Center(child: CircularProgressIndicator()),
                        );
                      }

                      if (data == null) {
                        return SavingsGoals(currentSaving: 0, targetSaving: 0);
                      }

                      return SavingsGoals(
                        currentSaving: data.currentSaving.toDouble(),
                        targetSaving: data.targetSaving.toDouble(),
                      );
                    }),

                    const SizedBox(height: 20),

                    BuildMenuItem(
                      icon: Icons.person_outline,
                      title: AppTexts.profile,
                      onTap: () => Get.toNamed(RoutePath.profile),
                    ),

                    BuildMenuItem(
                      icon: Icons.category_outlined,
                      title: AppTexts.savingFunds,
                      onTap: () => Get.toNamed(RoutePath.selectSavingFund),
                    ),

                    BuildMenuItem(
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
