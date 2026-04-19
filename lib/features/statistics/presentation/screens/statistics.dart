import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:money_care/app/controllers/app_controller.dart';
import 'package:money_care/app/controllers/saving_goal_controller.dart';
import 'package:money_care/app/controllers/statistics_controller.dart';
import 'package:money_care/app/controllers/transaction_controller.dart';
import 'package:money_care/app/controllers/user_controller.dart';
import 'package:money_care/app/widgets/layout/app_header.dart';
import 'package:money_care/app/widgets/texts/section_heading.dart';
import 'package:money_care/core/constants/colors.dart';
import 'package:money_care/core/constants/text_string.dart';
import 'package:money_care/core/utils/helper/helper_functions.dart';
import 'package:money_care/features/chatbot/presentation/screens/chatbot.dart';

import 'package:money_care/features/statistics/presentation/widgets/savings_bar_chart.dart';
import 'package:money_care/features/statistics/presentation/widgets/saving_goal_summary_card.dart';
import 'package:money_care/features/statistics/presentation/widgets/statistics_overview_card.dart';
import 'package:money_care/features/statistics/presentation/widgets/transaction_type_summary_toggle.dart';
import 'package:money_care/features/transaction/domain/entities/transaction_entity.dart';
import 'package:money_care/features/transaction/presentation/controllers/filter_controller.dart';
import 'package:money_care/features/transaction/presentation/controllers/user_category_controller.dart';

class StatisticsScreen extends StatefulWidget {
  const StatisticsScreen({super.key});

  @override
  State<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> {
  final AppController appController = Get.find<AppController>();
  final TransactionController transactionController = Get.find<TransactionController>();
  final StatisticsController statisticsController = Get.find<StatisticsController>();
  final SavingGoalController savingGoalController = Get.find<SavingGoalController>();
  final UserCategoryController userCategoryController = Get.find<UserCategoryController>();
  final FilterController filterController = Get.find<FilterController>();
  final UserController userController = Get.find<UserController>();

  @override
  void initState() {
    super.initState();
    initData();
  }

  Future<void> initData() async {
    final userId = await appController.getCurrentUserId();
    if (userId == null) return;
    await statisticsController.refreshStatisticsData(userId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundPrimary,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppHeader(
                title: 'Thu - Chi',

                child: Obx(() {
                  final data = statisticsController.totalByType.value;
                  final selectedType = statisticsController.selectedType.value;

                  return Stack(
                    children: [
                      TransactionTypeSummaryToggle(
                        selected: selectedType,
                        onSelected: (value) => statisticsController.changeType(value),
                        spendText: data?.expenseTotal ?? 0,
                        incomeText: data?.incomeTotal ?? 0,
                      ),
                      if (statisticsController.isSilentLoading.value || statisticsController.isLoading.value)
                        Positioned(
                          top: 0,
                          left: 0,
                          right: 0,
                          child: LinearProgressIndicator(
                            backgroundColor: Colors.transparent,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              AppColors.primary.withOpacity(0.5),
                            ),
                            minHeight: 2,
                          ),
                        ),
                    ],
                  );
                }),
              ),

              const SizedBox(height: 12),
              
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Obx(() => GestureDetector(
                      onTap: () => statisticsController.togglePeriodType(),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 4,
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.menu, size: 14, color: AppColors.primary),
                            const SizedBox(width: 6),
                            Text(
                              statisticsController.periodType.value,
                              style: const TextStyle(
                                color: AppColors.primary,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )),
                  ],
                ),
              ),

              const SizedBox(height: 8),

              Obx(() => _buildTimeNavigator()),

              const SizedBox(height: 20),

              Obx(() {
                String title = "";
                if (statisticsController.periodType.value == 'hàng tháng') {
                  title = statisticsController.selectedType.value == 'chi'
                      ? "Chi tiêu theo tháng"
                      : "Thu nhập theo tháng";
                } else {
                  title = statisticsController.selectedType.value == 'chi'
                      ? "Chi tiêu theo ngày"
                      : "Thu nhập theo ngày";
                }
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: AppSectionHeading(
                    title: title,
                    showActionButton: false,
                  ),
                );
              }),

               Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Obx(() {
                  final spots = statisticsController.chartSpots;
                  final labels = statisticsController.chartLabels;

                  if (spots.isEmpty && statisticsController.isLoading.value) {
                    return const SizedBox(
                      height: 220,
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }

                  return SavingsBarChart(
                      key: ValueKey("${statisticsController.periodType.value}_${statisticsController.currentStartDate}"),
                      thisMonthSpots: spots,
                      xLabels: labels,
                    );
                }),
              ),

              const SizedBox(height: 25),

              Obx(() => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: AppSectionHeading(
                  title: statisticsController.selectedType.value == 'chi'
                      ? AppTexts.limitOverview
                      : "Tổng quan thu nhập",
                  showActionButton: false,
                ),
              )),
               Obx(() {
                final data = statisticsController.totalByType.value;
                final categories = statisticsController.totalByCate;

                final List<CategoryEntity> updatedCategories = categories
                    .where((TotalByCategoryEntity c) => c.total > 0)
                    .toList()
                    .asMap()
                    .entries
                    .map<CategoryEntity>((entry) {
                      final index = entry.key;
                      final TotalByCategoryEntity item = entry.value;
                      return CategoryEntity(
                        id: 0,
                        name: item.categoryName,
                        percentage: item.spendingPercentage.toInt(),
                        icon: item.categoryIcon,
                        color: AppHelperFunction.getChartColorByIndex(index),
                      );
                    })
                    .toList();

                return StatisticsOverviewCard(
                    key: ValueKey(statisticsController.currentStartDate),
                    startDate: AppHelperFunction.getFormattedDate(statisticsController.currentStartDate),
                    endDate: AppHelperFunction.getFormattedDate(statisticsController.currentEndDate),
                    totalAmount: AppHelperFunction.formatAmount(
                      (data?.expenseTotal ?? 0).toDouble(),
                      'VND',
                    ),
                    incomeAmount: AppHelperFunction.formatAmount(
                      (data?.incomeTotal ?? 0).toDouble(),
                      'VND',
                    ),
                    categories: updatedCategories,
                  );
              }),

              const SizedBox(height: 25),

              Obx(() {
                final fund = savingGoalController.currentGoal.value;
                if (fund == null) return const SizedBox.shrink();
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: AppSectionHeading(
                        title: 'Thống kê mục tiêu tiết kiệm',
                        showActionButton: false,
                      ),
                    ),
                    const SizedBox(height: 10),
                    SavingGoalSummaryCard(
                      fund: fund,
                      report: savingGoalController.goalReport.value,
                      isLoading: savingGoalController.isLoadingReport.value,
                    ),
                    const SizedBox(height: 25),
                  ],
                );
              }),
              const SizedBox(height: 25),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTimeNavigator() {
    String label = "";
    if (statisticsController.periodType.value == 'hàng tháng') {
      label = DateFormat('yyyy/MM').format(statisticsController.selectedMonth.value);
    } else {
      label = DateFormat('yyyy/MM/dd').format(statisticsController.selectedDay.value);
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          _buildNavButton(
            icon: Icons.chevron_left_rounded,
            onTap: () => statisticsController.previousPeriod(),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Container(
              height: 48,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: AppColors.primary, width: 1.5),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.08),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (statisticsController.periodType.value == 'hàng ngày')
                    Container(
                      width: 8,
                      height: 8,
                      margin: const EdgeInsets.only(right: 8),
                      decoration: const BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                      ),
                    ),
                  Text(
                    label,
                    style: const TextStyle(
                      color: AppColors.primary,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 12),
          _buildNavButton(
            icon: Icons.chevron_right_rounded,
            onTap: () => statisticsController.nextPeriod(),
          ),
        ],
      ),
    );
  }

  Widget _buildNavButton({required IconData icon, required VoidCallback onTap}) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.primary, width: 1.5),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withOpacity(0.08),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Icon(icon, color: AppColors.primary, size: 28),
        ),
      ),
    );
  }
}
