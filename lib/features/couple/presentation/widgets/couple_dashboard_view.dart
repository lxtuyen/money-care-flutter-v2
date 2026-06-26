import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:money_care/app/widgets/states/app_empty_state.dart';
import 'package:money_care/app/widgets/texts/section_heading.dart';
import 'package:money_care/features/wallet/presentation/widgets/wallet_card.dart';
import 'package:money_care/core/utils/helper/helper_functions.dart';
import 'package:money_care/core/constants/route_path.dart';
import 'package:money_care/features/couple/presentation/controllers/couple_controller.dart';
import 'package:money_care/features/statistics/presentation/widgets/statistics_time_navigator.dart';
import 'package:money_care/app/controllers/statistics_controller.dart';
import 'package:money_care/features/couple/presentation/widgets/couple_spending_alerts_section.dart';
import 'package:money_care/features/couple/presentation/widgets/couple_profile_insights_card.dart';
import 'package:money_care/features/couple/presentation/widgets/couple_spending_forecast_section.dart';
import 'package:money_care/core/constants/colors.dart';

class CoupleDashboardView extends StatelessWidget {
  final CoupleController controller;

  const CoupleDashboardView({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.primaryColor;

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Streak Badge
          Obx(() {
            final couple = controller.couple.value;
            if (couple == null || !couple.isActive) {
              return const SizedBox.shrink();
            }
            final streak = couple.currentStreak;

            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('🔥', style: TextStyle(fontSize: 18)),
                  const SizedBox(width: 8),
                  Text(
                    '$streak ngày liên tiếp',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: AppColors.text1,
                    ),
                  ),
                ],
              ),
            );
          }),

          // Month Selector Header
          Obx(
            () {
              final month = controller.selectedMonth.value;
              final now = DateTime.now();
              final statisticsController = Get.find<StatisticsController>();
              final first = statisticsController.firstTransactionDate.value;

              return StatisticsTimeNavigator(
                focusedMonth: month,
                onPrevious: () {
                  controller.changeMonth(
                    DateTime(month.year, month.month - 1),
                  );
                },
                onNext: () {
                  controller.changeMonth(
                    DateTime(month.year, month.month + 1),
                  );
                },
                canGoNext:
                    !(month.year == now.year && month.month == now.month),
                canGoPrevious: first == null ||
                    !(month.year == first.year && month.month == first.month),
                onTap: () async {
                  final DateTime? picked = await showDatePicker(
                    context: context,
                    initialDate: month,
                    firstDate: DateTime(2020),
                    lastDate: DateTime(2030),
                    initialDatePickerMode: DatePickerMode.year,
                  );
                  if (picked != null) {
                    controller.changeMonth(picked);
                  }
                },
              );
            },
          ),
          const SizedBox(height: 16),
          // Total Balance Card
          Card(
            elevation: 0,
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: BorderSide(color: AppColors.primary),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  Text(
                    'Tổng Số Dư Ví Chung',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Obx(
                    () => Text(
                      AppHelperFunction.formatAmount(
                        controller.totalBalance.value,
                      ),
                      style: theme.textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: primaryColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Income & Expense Summary Widgets
          Row(
            children: [
              Expanded(
                child: Card(
                  elevation: 0,
                  color: Colors.green.withValues(alpha: 0.05),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                    side: const BorderSide(color: Colors.green, width: 0.5),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          children: [
                            Icon(
                              Icons.arrow_downward_rounded,
                              color: Colors.green,
                              size: 16,
                            ),
                            SizedBox(width: 4),
                            Text(
                              'Thu nhập chung',
                              style: TextStyle(
                                color: Colors.green,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Obx(
                          () => Text(
                            AppHelperFunction.formatAmount(
                              controller.totalIncome.value,
                            ),
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.green,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Card(
                  elevation: 0,
                  color: Colors.red.withValues(alpha: 0.05),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                    side: const BorderSide(color: Colors.red, width: 0.5),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          children: [
                            Icon(
                              Icons.arrow_upward_rounded,
                              color: Colors.red,
                              size: 16,
                            ),
                            SizedBox(width: 4),
                            Text(
                              'Chi tiêu chung',
                              style: TextStyle(color: Colors.red, fontSize: 12),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Obx(
                          () => Text(
                            AppHelperFunction.formatAmount(
                              controller.totalExpense.value,
                            ),
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.red,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Shared Wallets Header
          AppSectionHeading(
            title: 'Ví Chung',
            buttonTitle: 'Xem thêm',
            onPressed: () {
              Get.toNamed(
                RoutePath.wallets,
                arguments: {'coupleId': controller.couple.value?.id},
              );
            },
          ),
          const SizedBox(height: 8),

          // Shared Wallets List
          Obx(() {
            if (controller.sharedWallets.isEmpty) {
              return const AppEmptyState(
                message: 'Chưa có ví chung nào. Hãy tạo một ví mới!',
              );
            }
            return Column(
              children: controller.sharedWallets.map((wallet) {
                return WalletCard(wallet: wallet, marginBottom: 12);
              }).toList(),
            );
          }),
/*
          // AI Couple Profile Insights
          Obx(() {
            final profile = controller.coupleReport.value?.coupleProfile;
            if (profile == null || profile.activeMonths == 0) {
              return const SizedBox.shrink();
            }
            return Padding(
              padding: const EdgeInsets.only(top: 16),
              child: Card(
                elevation: 0,
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: BorderSide(
                    color: Colors.purple.withValues(alpha: 0.2),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: CoupleProfileInsightsCard(profile: profile),
                ),
              ),
            );
          }),

          // AI Couple Spending Forecast
          Obx(() {
            final forecast = controller.coupleReport.value?.coupleForecast;
            if (forecast == null || forecast.confidence == 0) {
              return const SizedBox.shrink();
            }
            return Padding(
              padding: const EdgeInsets.only(top: 16),
              child: Card(
                elevation: 0,
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: BorderSide(
                    color: Colors.blue.withValues(alpha: 0.2),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: CoupleSpendingForecastSection(forecast: forecast),
                ),
              ),
            );
          }),*/

          CoupleSpendingAlertsSection(controller: controller),
        ],
      ),
    );
  }
}
