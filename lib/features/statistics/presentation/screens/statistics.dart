import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:money_care/app/controllers/app_controller.dart';
import 'package:money_care/app/controllers/saving_goal_controller.dart';
import 'package:money_care/app/controllers/statistics_controller.dart';
import 'package:money_care/app/controllers/transaction_controller.dart';
import 'package:money_care/app/controllers/user_controller.dart';
import 'package:money_care/app/widgets/layout/app_header.dart';
import 'package:money_care/app/widgets/texts/section_heading.dart';
import 'package:money_care/app/widgets/states/app_empty_state.dart';
import 'package:money_care/core/constants/colors.dart';
import 'package:money_care/core/constants/route_path.dart';
import 'package:money_care/core/utils/helper/helper_functions.dart';

import 'package:money_care/features/statistics/presentation/widgets/savings_bar_chart.dart';
import 'package:money_care/features/statistics/presentation/widgets/saving_goal_summary_card.dart';
import 'package:money_care/features/statistics/presentation/widgets/statistics_overview_card.dart';
import 'package:money_care/features/statistics/presentation/widgets/transaction_type_summary_toggle.dart';
import 'package:money_care/features/statistics/presentation/widgets/estimated_expense_budget_group_card.dart';
import 'package:money_care/features/statistics/presentation/models/goal_plan_impact.dart';
import 'package:money_care/features/saving_goal/domain/entities/saving_goal_entity.dart';
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
                              AppColors.primary.withValues(alpha: 0.5),
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
                                color: Colors.black.withValues(alpha: 0.1),
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

                    double dailyEstimatedTotal = 0;
                    double weeklyEstimatedTotal = 0;
                    double monthlyEstimatedTotal = 0;

                    for (var expense in activePlan.estimatedExpenses) {
                      final type = expense.frequencyType.toLowerCase();
                      final val = expense.frequencyValue;
                      final baseAmt = expense.amount;
                      final totalAmt = baseAmt * val;

                      if (type == 'daily') {
                        dailyEstimatedTotal += totalAmt;
                      } else if (type == 'weekly') {
                        weeklyEstimatedTotal += totalAmt;
                      } else if (type == 'monthly') {
                        monthlyEstimatedTotal += totalAmt;
                      }
                    }

                    if (isDaily) {
                      limitLineY = dailyEstimatedTotal;
                      if (limitLineY > 0) {
                        limitLineLabel =
                            'Hạn mức ngày: ${AppHelperFunction.formatCompactNumber(limitLineY)}';
                      }
                    } else {
                      limitLineY =
                          dailyEstimatedTotal +
                          (weeklyEstimatedTotal / 7.0) +
                          (monthlyEstimatedTotal / 30.0);
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
              const SizedBox(height: 10),
              Obx(() {
                if (statisticsController.selectedType.value != 'chi') {
                  return const SizedBox.shrink();
                }
                final stats = spendingPlanController.statsSummary.value;
                if (stats == null) return const SizedBox.shrink();
                final groupedExpenses =
                    EstimatedExpenseBudgetGroupCard.groupExpenses(
                      stats.estimatedExpenses,
                    );
                final planImpact = _buildGoalPlanImpact(stats, groupedExpenses);

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: AppSectionHeading(
                        title: 'Theo dõi ngân sách',
                        showActionButton: stats.estimatedExpenses.length > 5,
                        onPressed: () {
                          Get.toNamed(
                            RoutePath.spendingPlanDetail,
                            arguments: stats.planId,
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 10),
                    _buildBudgetTrackingSection(
                      context,
                      stats,
                      groupedExpenses,
                      planImpact,
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
                final planImpact = _buildGoalPlanImpact(
                  spendingPlanController.statsSummary.value,
                  EstimatedExpenseBudgetGroupCard.groupExpenses(
                    spendingPlanController
                            .statsSummary
                            .value
                            ?.estimatedExpenses ??
                        const [],
                  ),
                );
                final insightSnapshot = _buildGoalPlanInsightSnapshot(
                  planImpact,
                  fund,
                );
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
                      planImpact: planImpact,
                      insightSnapshot: insightSnapshot,
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
                    color: AppColors.primary.withValues(alpha: 0.08),
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
                color: AppColors.primary.withValues(alpha: 0.08),
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
          border: Border.all(color: color.withValues(alpha: 0.3)),
          borderRadius: BorderRadius.circular(16),
          color: color.withValues(alpha: 0.05),
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
    Get.back();
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
    Map<String, List<EstimatedExpenseEntity>> groupedExpenses,
    GoalPlanImpact? planImpact,
  ) {
    final selMonth = statisticsController.selectedMonth.value;
    final daysInMonth = DateTime(selMonth.year, selMonth.month + 1, 0).day;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (stats.estimatedExpenses.isEmpty)
            const AppEmptyState(
              message: 'Chưa có khoản theo dõi ngân sách nào.',
            )
          else ...[
            ...groupedExpenses.entries.map((entry) {
              return EstimatedExpenseBudgetGroupCard(
                categoryName: entry.key,
                daysInMonth: daysInMonth,
                expenses: entry.value,
                goalImpact: _categoryImpactFor(planImpact, entry.key),
              );
            }),
          ],
        ],
      ),
    );
  }

  GoalPlanImpact? _buildGoalPlanImpact(
    SpendingPlanStatsEntity? stats,
    Map<String, List<EstimatedExpenseEntity>> groupedExpenses,
  ) {
    final goal = savingGoalController.currentGoal.value;
    if (goal == null || goal.isCompleted || stats == null) return null;
    return GoalPlanImpact.build(
      goal: goal,
      stats: stats,
      report: savingGoalController.goalReport.value,
      selectedMonth: statisticsController.selectedMonth.value,
      groupedExpenses: groupedExpenses,
    );
  }

  BudgetCategoryGoalImpact? _categoryImpactFor(
    GoalPlanImpact? impact,
    String categoryName,
  ) {
    if (impact == null) return null;
    return impact.categories.firstWhereOrNull(
      (item) => item.name == categoryName,
    );
  }

  GoalPlanInsightSnapshot? _buildGoalPlanInsightSnapshot(
    GoalPlanImpact? impact,
    SavingGoalEntity fund,
  ) {
    final userId = appController.userId.value;
    if (impact == null || userId == null) return null;
    return impact.toInsightSnapshot(
      userId: userId,
      goal: fund,
      report: savingGoalController.goalReport.value,
    );
  }
}
