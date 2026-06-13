import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:money_care/core/constants/route_path.dart';
import 'package:money_care/core/constants/colors.dart';
import 'package:money_care/core/constants/icon_string.dart';
import 'package:money_care/core/constants/sizes.dart';
import 'package:money_care/features/home/presentation/widgets/widgets.dart';
import 'package:money_care/features/home/presentation/controllers/home_controller.dart';
import 'package:money_care/app/widgets/icon/circular_icon.dart';
import 'package:money_care/app/widgets/texts/section_heading.dart';
import 'package:money_care/features/gamification/presentation/widgets/streak_badge_widget.dart';
import 'package:money_care/features/gamification/presentation/controllers/gamification_controller.dart';
import 'package:money_care/features/spending_plan/presentation/controllers/spending_plan_controller.dart';
import 'package:money_care/core/utils/helper/helper_functions.dart';
import 'package:money_care/features/transaction/domain/entities/transaction_entity.dart';

class HomeScreen extends GetView<HomeController> {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSizes.md),
        child: Column(
          children: [
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Obx(() {
                        final profile =
                            controller.userController.userProfile.value;
                        final String greeting = AppHelperFunction.getGreeting();

                        if (controller.userController.isLoading.value) {
                          return const SizedBox(
                            height: 48,
                            child: Center(
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),
                          );
                        }

                        return Row(
                          children: [
                            Container(
                              width: 44,
                              height: 44,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: LinearGradient(
                                  colors: [
                                    AppColors.primary,
                                    AppColors.primary.withValues(alpha: 0.7),
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.primary.withValues(
                                      alpha: 0.2,
                                    ),
                                    blurRadius: 8,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Center(
                                child: profile?.avatar != null
                                    ? ClipRRect(
                                        borderRadius: BorderRadius.circular(22),
                                        child: Image.network(
                                          profile!.avatar!,
                                          width: 44,
                                          height: 44,
                                          fit: BoxFit.cover,
                                        ),
                                      )
                                    : Text(
                                        (profile?.firstName?.isNotEmpty == true)
                                            ? profile!.firstName![0]
                                                  .toUpperCase()
                                            : "U",
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18,
                                        ),
                                      ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    greeting,
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: AppColors.text4,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  Text(
                                    profile?.fullName ?? 'common.user'.tr,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 16,
                                      color: AppColors.text1,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        );
                      }),
                    ),

                    Row(
                      children: [
                        CircularIcon(
                          iconPath: AppIcons.search,
                          backgroundColor: const Color(0XFFF5FAFE),
                          height: 38,
                          width: 38,
                          onTap: () {
                            showGeneralDialog(
                              context: context,
                              barrierDismissible: true,
                              barrierLabel: '',
                              transitionDuration: const Duration(
                                milliseconds: 200,
                              ),
                              pageBuilder: (context, anim1, anim2) {
                                return Align(
                                  alignment: Alignment.topCenter,
                                  child: Material(
                                    color: Colors.transparent,
                                    child: Container(
                                      margin: const EdgeInsets.only(top: 80),
                                      width:
                                          MediaQuery.of(context).size.width *
                                          0.9,
                                      child: Obx(() {
                                        final recent = controller
                                            .transactionController
                                            .recentTransactions
                                            .value;
                                        final List<TransactionEntity>
                                        transactions =
                                            [
                                              ...(recent?.expenseTransactions ??
                                                  []),
                                              ...(recent?.incomeTransactions ??
                                                  []),
                                            ]..sort(
                                              (a, b) =>
                                                  (b.transactionDate ??
                                                          DateTime.now())
                                                      .compareTo(
                                                        a.transactionDate ??
                                                            DateTime.now(),
                                                      ),
                                            );

                                        if (controller
                                            .transactionController
                                            .isRecentLoading
                                            .value) {
                                          return const SizedBox(
                                            height: 120,
                                            child: Center(
                                              child:
                                                  CircularProgressIndicator(),
                                            ),
                                          );
                                        }

                                        return TransactionSearchAnchor(
                                          listData: transactions,
                                        );
                                      }),
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        ),
                        const SizedBox(width: 12),
                        Stack(
                          clipBehavior: Clip.none,
                          children: [
                            CircularIcon(
                              onTap: () => Get.toNamed(RoutePath.notification),
                              iconPath: AppIcons.notification,
                              backgroundColor: const Color(0XFFF5FAFE),
                              height: 38,
                              width: 38,
                            ),
                            Positioned(
                              right: 2,
                              top: 2,
                              child: Container(
                                width: 8,
                                height: 8,
                                decoration: BoxDecoration(
                                  color: Colors.red,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.white,
                                    width: 1.5,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),

            _buildQuickStatus(),
            _buildSpendingSummary(),
            _buildRecentTransactions(),
            _buildSpendingOverview(),
            _buildMonthlySpending(),
            _buildMonthlyIncome(),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickStatus() {
    return Column(
      children: [
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          child: Row(
            children: [
              const StreakBadgeWidget(),
              Obx(() {
                final showStreak =
                    Get.find<GamificationController>().currentStreak.value > 0;
                final showForecast =
                    Get.find<SpendingPlanController>().activePlan.value !=
                        null &&
                    Get.find<SpendingPlanController>().statsSummary.value !=
                        null;
                if (showStreak && showForecast) {
                  return const SizedBox(width: 8);
                }
                return const SizedBox.shrink();
              }),
            ],
          ),
        ),
        const SizedBox(height: AppSizes.defaultSpace),
      ],
    );
  }

  Widget _buildSpendingSummary() {
    return Column(
      children: [
        Obx(() {
          final totals =
              controller.statisticsController.globalTotalByType.value;
          final isVisible = controller.appController.isBalanceVisible.value;

          if (controller.statisticsController.isLoading.value && totals == null) {
            return const SizedBox(
              height: 120,
              child: Center(child: CircularProgressIndicator()),
            );
          }

          if (totals == null) {
            return SpendingSummary(
              incomeTotal: 0,
              expenseTotal: 0,
              totalBalance: controller.walletController.totalAssets.value
                  .toInt(),
              isBalanceVisible: isVisible,
              onToggleVisibility: () =>
                  controller.appController.toggleBalanceVisibility(),
            );
          }

          return SpendingSummary(
            incomeTotal: totals.incomeTotal,
            expenseTotal: totals.expenseTotal,
            totalBalance: controller.walletController.totalAssets.value.toInt(),
            isBalanceVisible: isVisible,
            onToggleVisibility: () =>
                controller.appController.toggleBalanceVisibility(),
          );
        }),
        const SizedBox(height: AppSizes.defaultSpace),
      ],
    );
  }

  Widget _buildRecentTransactions() {
    return Column(
      children: [
        AppSectionHeading(
          title: 'home.recentTransactions'.tr,
          showActionButton: false,
        ),
        Obx(() {
          final transactions =
              controller.transactionController.recentTransactions.value;
          if (controller.transactionController.isRecentLoading.value) {
            return const SizedBox(
              height: 120,
              child: Center(child: CircularProgressIndicator()),
            );
          }

          if (transactions == null) {
            return const TransactionSection(
              incomeTransactions: [],
              expenseTransactions: [],
            );
          }

          return TransactionSection(
            incomeTransactions: transactions.incomeTransactions,
            expenseTransactions: transactions.expenseTransactions,
          );
        }),
        const SizedBox(height: AppSizes.defaultSpace),
      ],
    );
  }

  Widget _buildSpendingOverview() {
    return Column(
      children: [
        AppSectionHeading(title: 'home.overview'.tr, showActionButton: false),
        const SizedBox(height: AppSizes.spaceBtwItems),
        Obx(() {
          final totalsData = controller.statisticsController.totalByDate.value;

          if (controller.statisticsController.isLoading.value && totalsData == null) {
            return const SizedBox(
              height: 120,
              child: Center(child: CircularProgressIndicator()),
            );
          }

          if (totalsData == null || totalsData.expense.isEmpty) {
            return SpendingOverviewCard(
              startDate: controller.statisticsController.weekStartDate,
              endDate: controller.statisticsController.weekEndDate,
              totals: [],
              amountSpent: 0,
              isBalanceVisible: controller.appController.isBalanceVisible.value,
            );
          }

          final totals = totalsData.expense;
          double totalSpent = totals.fold(0, (sum, t) => sum + t.total);

          return SpendingOverviewCard(
            startDate: controller.statisticsController.weekStartDate,
            endDate: controller.statisticsController.weekEndDate,
            totals: totals,
            amountSpent: totalSpent,
            isBalanceVisible: controller.appController.isBalanceVisible.value,
          );
        }),
        const SizedBox(height: AppSizes.defaultSpace),
      ],
    );
  }

  Widget _buildMonthlySpending() {
    return Obx(() {
      final categories = controller.statisticsController.expenseCategories
          .where((c) => c.total > 0)
          .toList();

      if (controller.statisticsController.isLoading.value && categories.isEmpty) {
        return const SizedBox(
          height: 124,
          child: Center(child: CircularProgressIndicator()),
        );
      }

      if (categories.isEmpty) {
        return const SizedBox.shrink();
      }

      String sectionTitle = 'home.monthlySpending'.tr;

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppSectionHeading(title: sectionTitle, showActionButton: false),
          const SizedBox(height: AppSizes.spaceBtwItems),
          ...categories.map((TotalByCategoryEntity category) {
            return CategoryOverviewCard(
              title: category.categoryName,
              spent: category.total,
              iconPath: category.categoryIcon,
              isIncome: false,
            );
          }),
          const SizedBox(height: AppSizes.defaultSpace),
        ],
      );
    });
  }

  Widget _buildMonthlyIncome() {
    return Obx(() {
      final categories = controller.statisticsController.incomeCategories
          .where((c) => c.total > 0)
          .toList();

      if (controller.statisticsController.isLoading.value && categories.isEmpty) {
        return const SizedBox(
          height: 124,
          child: Center(child: CircularProgressIndicator()),
        );
      }

      if (categories.isEmpty) {
        return const SizedBox.shrink();
      }

      return Column(
        children: [
          AppSectionHeading(
            title: 'home.monthlyIncome'.tr,
            showActionButton: false,
          ),
          const SizedBox(height: AppSizes.spaceBtwItems),
          ...categories.map((TotalByCategoryEntity category) {
            return CategoryOverviewCard(
              title: category.categoryName,
              spent: category.total,
              iconPath: category.categoryIcon,
              isIncome: true,
            );
          }),
          const SizedBox(height: AppSizes.defaultSpace),
        ],
      );
    });
  }
}
