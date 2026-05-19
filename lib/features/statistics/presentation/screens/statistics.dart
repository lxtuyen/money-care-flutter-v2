import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:money_care/app/controllers/app_controller.dart';
import 'package:money_care/app/controllers/saving_goal_controller.dart';
import 'package:money_care/app/controllers/statistics_controller.dart';
import 'package:money_care/app/controllers/transaction_controller.dart';
import 'package:money_care/app/controllers/user_controller.dart';
import 'package:money_care/app/widgets/layout/app_header.dart';
import 'package:money_care/app/widgets/texts/section_heading.dart';
import 'package:money_care/core/constants/colors.dart';
import 'package:money_care/core/utils/helper/helper_functions.dart';
import 'package:money_care/core/theme/app_theme_colors.dart';

import 'package:money_care/features/statistics/presentation/widgets/savings_bar_chart.dart';
import 'package:money_care/features/statistics/presentation/widgets/saving_goal_summary_card.dart';
import 'package:money_care/features/statistics/presentation/widgets/statistics_overview_card.dart';
import 'package:money_care/features/statistics/presentation/widgets/monthly_budget_card.dart';
import 'package:money_care/features/statistics/presentation/widgets/transaction_type_summary_toggle.dart';
import 'package:money_care/features/transaction/domain/entities/transaction_entity.dart';
import 'package:money_care/features/transaction/presentation/controllers/filter_controller.dart';
import 'package:money_care/features/transaction/presentation/controllers/user_category_controller.dart';
import 'package:money_care/features/transaction/data/models/transaction_filter_dto.dart';
import 'package:money_care/features/spending_plan/presentation/controllers/spending_plan_controller.dart';
import 'package:money_care/features/spending_plan/domain/entities/spending_plan_entity.dart';

class StatisticsScreen extends StatefulWidget {
  const StatisticsScreen({super.key});

  @override
  State<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> {
  final AppController appController = Get.find<AppController>();
  final TransactionController transactionController =
      Get.find<TransactionController>();
  final StatisticsController statisticsController =
      Get.find<StatisticsController>();
  final SavingGoalController savingGoalController =
      Get.find<SavingGoalController>();
  final UserCategoryController userCategoryController =
      Get.find<UserCategoryController>();
  final FilterController filterController = Get.find<FilterController>();
  final UserController userController = Get.find<UserController>();
  final SpendingPlanController spendingPlanController =
      Get.find<SpendingPlanController>();

  @override
  void initState() {
    super.initState();
    initData();
  }

  Future<void> initData() async {
    final userId = await appController.getCurrentUserId();
    if (userId == null) return;
    await Future.wait([
      statisticsController.refreshStatisticsData(userId),
      spendingPlanController.loadStatsSummary(loadActiveIfMissing: true),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppHeader(
                title: 'statistics.title'.tr,
                actions: [
                  IconButton(
                    onPressed: () => _showExportDialog(),
                    icon: const Icon(
                      Icons.file_download_outlined,
                      color: Colors.white,
                    ),
                  ),
                ],
                child: Obx(() {
                  final data = statisticsController.totalByType.value;
                  final selectedType = statisticsController.selectedType.value;

                  return Stack(
                    children: [
                      TransactionTypeSummaryToggle(
                        selected: selectedType,
                        onSelected: (value) =>
                            statisticsController.changeType(value),
                        spendText: data?.expenseTotal ?? 0,
                        incomeText: data?.incomeTotal ?? 0,
                      ),
                      if (statisticsController.isSilentLoading.value ||
                          statisticsController.isLoading.value)
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
                    Obx(
                      () => GestureDetector(
                        onTap: () => statisticsController.togglePeriodType(),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
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
                              const Icon(
                                Icons.menu,
                                size: 14,
                                color: AppColors.primary,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                (statisticsController.periodType.value ==
                                        'hàng tháng'
                                    ? 'statistics.monthly'.tr
                                    : 'statistics.daily'.tr),
                                style: const TextStyle(
                                  color: AppColors.primary,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
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
                      ? "statistics.monthlyExpense".tr
                      : "statistics.monthlyIncome".tr;
                } else {
                  title = statisticsController.selectedType.value == 'chi'
                      ? "statistics.dailyExpense".tr
                      : "statistics.dailyIncome".tr;
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

                  double? limitLineY;
                  String? limitLineLabel;
                  if (statisticsController.selectedType.value == 'chi' &&
                      spendingPlanController.activePlan.value != null) {
                    final activePlan = spendingPlanController.activePlan.value!;
                    final isDaily =
                        statisticsController.periodType.value != 'hàng tháng';

                    double dailyFixedTotal = 0;
                    double weeklyFixedTotal = 0;
                    double monthlyFixedTotal = 0;

                    for (var expense in activePlan.fixedExpenses) {
                      final type = expense.frequencyType.toLowerCase();
                      final val = expense.frequencyValue;
                      final baseAmt = expense.amount;
                      final totalAmt = baseAmt * val;

                      if (type == 'daily') {
                        dailyFixedTotal += totalAmt;
                      } else if (type == 'weekly') {
                        weeklyFixedTotal += totalAmt;
                      } else if (type == 'monthly') {
                        monthlyFixedTotal += totalAmt;
                      }
                    }

                    if (isDaily) {
                      limitLineY = dailyFixedTotal;
                      if (limitLineY > 0) {
                        limitLineLabel =
                            'Hạn mức ngày: ${AppHelperFunction.formatCompactNumber(limitLineY)}';
                      }
                    } else {
                      limitLineY =
                          dailyFixedTotal +
                          (weeklyFixedTotal / 7.0) +
                          (monthlyFixedTotal / 30.0);
                      if (limitLineY > 0) {
                        limitLineLabel =
                            'Định mức ngày: ${AppHelperFunction.formatCompactNumber(limitLineY)}';
                      }
                    }
                  }

                  return SavingsBarChart(
                    key: ValueKey(
                      "${statisticsController.periodType.value}_${statisticsController.currentStartDate}",
                    ),
                    thisMonthSpots: spots,
                    xLabels: labels,
                    limitLineY: limitLineY,
                    limitLineLabel: limitLineLabel,
                  );
                }),
              ),

              const SizedBox(height: 25),

              // Tạm ẩn so sánh với kỳ trước theo yêu cầu của người dùng
              const SizedBox.shrink(),

              Obx(
                () => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: AppSectionHeading(
                    title: statisticsController.selectedType.value == 'chi'
                        ? 'statistics.limitOverview'.tr
                        : "statistics.incomeOverview".tr,
                    showActionButton: false,
                  ),
                ),
              ),
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
                        spendingPercentage: item.spendingPercentage,
                        icon: item.categoryIcon,
                        color: AppHelperFunction.getChartColorByIndex(index),
                      );
                    })
                    .toList();

                return StatisticsOverviewCard(
                  key: ValueKey(statisticsController.currentStartDate),
                  startDate: AppHelperFunction.getFormattedDate(
                    statisticsController.currentStartDate,
                    format: 'dd/MM',
                  ),
                  endDate: AppHelperFunction.getFormattedDate(
                    statisticsController.currentEndDate,
                    format: 'dd/MM',
                  ),
                  totalAmount: AppHelperFunction.formatAmount(
                    (data?.expenseTotal ?? 0).toDouble(),
                  ),
                  incomeAmount: AppHelperFunction.formatAmount(
                    (data?.incomeTotal ?? 0).toDouble(),
                  ),
                  categories: updatedCategories,
                );
              }),

              Obx(() {
                if (statisticsController.selectedType.value != 'chi') {
                  return const SizedBox.shrink();
                }
                final stats = spendingPlanController.statsSummary.value;
                if (stats == null) return const SizedBox.shrink();

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: AppSectionHeading(
                        title: 'Theo dõi ngân sách',
                        showActionButton: false,
                      ),
                    ),
                    const SizedBox(height: 10),
                    _buildBudgetTrackingSection(context, stats),
                    const SizedBox(height: 25),
                  ],
                );
              }),

              Obx(() {
                if (statisticsController.periodType.value != 'hàng tháng') {
                  return const SizedBox.shrink();
                }
                if (statisticsController.selectedType.value != 'chi') {
                  return const SizedBox.shrink();
                }

                final budget = statisticsController.totalBudget;
                if (budget <= 0) return const SizedBox.shrink();

                final spent =
                    statisticsController.totalByType.value?.expenseTotal
                        .toDouble() ??
                    0.0;
                final now = DateTime.now();
                final sel = statisticsController.selectedMonth.value;
                final lastDay = DateTime(sel.year, sel.month + 1, 0).day;
                final isCurrentMonth =
                    sel.year == now.year && sel.month == now.month;
                final daysRemaining = isCurrentMonth
                    ? (lastDay - now.day + 1)
                    : lastDay;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: AppSectionHeading(
                        title: 'budget.monthlyTitle'.tr,
                        showActionButton: false,
                      ),
                    ),
                    const SizedBox(height: 10),
                    MonthlyBudgetCard(
                      totalBudget: budget,
                      totalSpent: spent,
                      daysRemaining: daysRemaining,
                      totalDays: lastDay,
                      categories: statisticsController.expenseCategories,
                    ),
                    const SizedBox(height: 25),
                  ],
                );
              }),

              Obx(() {
                final fund = savingGoalController.currentGoal.value;
                if (fund == null || fund.isCompleted) {
                  return const SizedBox.shrink();
                }
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: AppSectionHeading(
                        title: 'statistics.goalStats'.tr,
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
      label = AppHelperFunction.getFormattedDate(
        statisticsController.selectedMonth.value,
        format: 'yyyy/MM',
      );
    } else {
      label = AppHelperFunction.getFormattedDate(
        statisticsController.selectedDay.value,
        format: 'yyyy/MM/dd',
      );
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

  Widget _buildNavButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
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

  void _showExportDialog() {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'statistics.exportTitle'.tr,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.text1,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'statistics.exportEmailNote'.tr.replaceAll(
                '@email',
                userController.user.value?.email ?? '...',
              ),
              style: const TextStyle(color: AppColors.text3),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: _buildExportOption(
                    icon: Icons.picture_as_pdf_rounded,
                    label: 'PDF',
                    color: Colors.red,
                    onTap: () => _handleExport('pdf'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildExportOption(
                    icon: Icons.table_chart_rounded,
                    label: 'CSV',
                    color: Colors.green,
                    onTap: () => _handleExport('csv'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildExportOption({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20),
        decoration: BoxDecoration(
          border: Border.all(color: color.withOpacity(0.3)),
          borderRadius: BorderRadius.circular(16),
          color: color.withOpacity(0.05),
        ),
        child: Column(
          children: [
            Icon(icon, size: 32, color: color),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(fontWeight: FontWeight.bold, color: color),
            ),
          ],
        ),
      ),
    );
  }

  void _handleExport(String format) async {
    Get.back(); // Close bottom sheet
    final userId = appController.userId.value;
    if (userId == null) return;

    final filterDto = TransactionFilterDto(
      startDate: statisticsController.currentStartDate.toIso8601String(),
      endDate: statisticsController.currentEndDate.toIso8601String(),
    );

    await Get.find<TransactionController>().exportReport(
      userId,
      filterDto,
      format,
    );
  }

  Widget _buildBudgetTrackingSection(
    BuildContext context,
    SpendingPlanStatsEntity stats,
  ) {
    final themeColors = AppThemeColors.of(context);
    final selMonth = statisticsController.selectedMonth.value;
    final daysInMonth = DateTime(selMonth.year, selMonth.month + 1, 0).day;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (stats.fixedExpenses.isEmpty)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: themeColors.cardBackground,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Center(
                child: Text(
                  'Chưa có khoản theo dõi ngân sách nào.',
                  style: TextStyle(
                    color: themeColors.textSecondary,
                    fontSize: 13,
                  ),
                ),
              ),
            )
          else
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: themeColors.cardBackground,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.02),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ...stats.fixedExpenses.map((expense) {
                    final isBudget = expense.trackingType == 'budget';
                    double plannedTotal = isBudget
                        ? (expense.monthlyLimit > 0
                              ? expense.monthlyLimit
                              : expense.amount)
                        : expense.amount * expense.frequencyValue;
                    if (!isBudget &&
                        expense.frequencyType.toLowerCase() == 'daily') {
                      plannedTotal *= daysInMonth;
                    } else if (!isBudget &&
                        expense.frequencyType.toLowerCase() == 'weekly') {
                      plannedTotal *= (daysInMonth / 7.0);
                    }

                    final actualPaid = expense.spentThisMonth;
                    final progress = plannedTotal <= 0
                        ? 0.0
                        : (actualPaid / plannedTotal).clamp(0.0, 1.0);

                    final isLast = expense == stats.fixedExpenses.last;

                    final catName =
                        expense.subCategory ?? expense.category ?? expense.name;
                    final category = userCategoryController.categories
                        .firstWhereOrNull(
                          (item) =>
                              item.name.toLowerCase() == catName.toLowerCase(),
                        );
                    final subCategory = category?.subCategories
                        .firstWhereOrNull(
                          (sub) =>
                              sub.name.toLowerCase() == catName.toLowerCase(),
                        );
                    final catIcon = subCategory?.icon ?? category?.icon ?? '🧾';

                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 38,
                                height: 38,
                                decoration: BoxDecoration(
                                  color: AppColors.expense.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  catIcon,
                                  style: const TextStyle(fontSize: 18),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      expense.name,
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: themeColors.textPrimary,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      isBudget
                                          ? 'Ngân sách dùng dần'
                                          : 'Hóa đơn cố định',
                                      style: TextStyle(
                                        fontSize: 11,
                                        color: themeColors.textSecondary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              // Cost comparisons
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    AppHelperFunction.formatAmount(actualPaid),
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: themeColors.textPrimary,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    'Kế hoạch: ${AppHelperFunction.formatAmount(plannedTotal)}',
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: themeColors.textSecondary,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(999),
                            child: LinearProgressIndicator(
                              value: progress,
                              minHeight: 7,
                              backgroundColor: themeColors.textSecondary
                                  .withOpacity(0.12),
                              valueColor: AlwaysStoppedAnimation<Color>(
                                actualPaid > plannedTotal
                                    ? Colors.red
                                    : isBudget
                                    ? AppColors.primary
                                    : Colors.green,
                              ),
                            ),
                          ),
                          if (isBudget && expense.dailyLimit != null) ...[
                            const SizedBox(height: 6),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                expense.dailyOverAmount > 0
                                    ? 'Hôm nay: ${AppHelperFunction.formatAmount(expense.todaySpent)} / ${AppHelperFunction.formatAmount(expense.dailyLimit!)} - vượt ${AppHelperFunction.formatAmount(expense.dailyOverAmount)}'
                                    : 'Hôm nay: ${AppHelperFunction.formatAmount(expense.todaySpent)} / ${AppHelperFunction.formatAmount(expense.dailyLimit!)}',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: expense.dailyOverAmount > 0
                                      ? FontWeight.w700
                                      : FontWeight.w500,
                                  color: expense.dailyOverAmount > 0
                                      ? Colors.red
                                      : themeColors.textSecondary,
                                ),
                              ),
                            ),
                          ],
                          if (!isLast) ...[
                            const SizedBox(height: 8),
                            Divider(
                              color: Colors.grey.withOpacity(0.15),
                              height: 1,
                            ),
                          ],
                        ],
                      ),
                    );
                  }),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
