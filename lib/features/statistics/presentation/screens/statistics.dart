import 'package:money_care/app/widgets/layout/app_header.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:money_care/features/transaction/presentation/controllers/filter_controller.dart';
import 'package:money_care/app/controllers/fund_controller.dart';
import 'package:money_care/app/controllers/transaction_controller.dart';
import 'package:money_care/features/transaction/presentation/controllers/user_category_controller.dart';
import 'package:money_care/app/controllers/statistics_controller.dart';
import 'package:money_care/app/controllers/user_controller.dart';
import 'package:money_care/core/constants/text_string.dart';
import 'package:money_care/core/utils/helper/helper_functions.dart';
import 'package:money_care/app/controllers/app_controller.dart';
import 'package:money_care/features/transaction/domain/entities/transaction_entity.dart';
import 'package:money_care/features/statistics/presentation/widgets/chart/chart_card.dart';
import 'package:money_care/features/statistics/presentation/widgets/description/statistics_highlights.dart';
import 'package:money_care/features/statistics/presentation/widgets/chart/savings_bar_chart.dart';
import 'package:money_care/features/statistics/presentation/widgets/statistics_overview_card.dart';
import 'package:money_care/features/statistics/presentation/widgets/transaction_type_summary_toggle.dart';
import 'package:money_care/features/statistics/presentation/widgets/fund_summary_card.dart';
import 'package:money_care/app/widgets/texts/section_heading.dart';

class StatisticsScreen extends StatefulWidget {
  const StatisticsScreen({super.key});

  @override
  State<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> {

  List<String> generateLast7DaysLabels() {
    final List<String> labels = [];
    final now = DateTime.now();
    final formatter = DateFormat('dd');

    for (int i = 6; i >= 0; i--) {
      final date = now.subtract(Duration(days: i));
      labels.add(formatter.format(date));
    }
    return labels;
  }

  final now = DateTime.now();
  late DateTime monthStartDate = DateTime(now.year, now.month, 1);

  final AppController appController = Get.find<AppController>();
  final TransactionController transactionController =
      Get.find<TransactionController>();
  final StatisticsController statisticsController =
      Get.find<StatisticsController>();
  final FundController fundController =
      Get.find<FundController>();
  final UserCategoryController userCategoryController =
      Get.find<UserCategoryController>();
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
    // Load fund report nếu user có quỹ
    final fundId = fundController.fundId.value;
    if (fundId > 0) {
      fundController.loadFundReport(fundId);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Obx(() => AppHeader(
                    title: statisticsController.selectedType.value == 'chi'
                        ? "Thống kê chi"
                        : "Thống kê thu",
                    child: Builder(builder: (context) {
                      final data = statisticsController.totalByType.value;

                      if (statisticsController.isLoading.value) {
                        return const SizedBox(
                          height: 120,
                          child: Center(child: CircularProgressIndicator()),
                        );
                      }

                      return TransactionTypeSummaryToggle(
                        selected: statisticsController.selectedType.value,
                        onSelected: (value) =>
                            statisticsController.changeType(value),
                        spendText: data?.expenseTotal ?? 0,
                        incomeText: data?.incomeTotal ?? 0,
                      );
                    }),
                  )),

              const SizedBox(height: 25),

              Obx(() => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: AppSectionHeading(
                  title: statisticsController.selectedType.value == 'chi'
                      ? "Tổng chi tiêu theo tháng"
                      : "Tổng thu nhập theo tháng",
                  showActionButton: false,
                ),
              )),
              const SizedBox(height: 10),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Obx(() {
                  if (statisticsController.isLoading.value) {
                    return const SizedBox(
                      height: 120,
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }

                  final totalsLstMonth =
                      statisticsController.totalByDateLstMonth.value;
                  final totalsThisMonth =
                      statisticsController.totalByDate.value;

                  if (totalsLstMonth == null || totalsThisMonth == null) {
                    return const SizedBox(
                      height: 120,
                      child: Center(
                        child: Text(
                          'Không có dữ liệu thống kê',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ),
                    );
                  }

                  final lstMonthData =
                      statisticsController.getDataBySelected(totalsLstMonth);
                  final thisMonthData =
                      statisticsController.getDataBySelected(totalsThisMonth);

                  final lastMonthSpots = statisticsController.convertToSpots7Days(
                    lstMonthData,
                    statisticsController.lastMonthToday,
                  );
                  final thisMonthSpots = statisticsController.convertToSpots7Days(
                    thisMonthData,
                    now,
                  );

                  return SavingsBarChart(
                    xLabels: generateLast7DaysLabels(),
                    thisMonthSpots: thisMonthSpots,
                    lastMonthSpots: lastMonthSpots,
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
              const SizedBox(height: 10),
              Obx(() {
                final data = statisticsController.totalByType.value;
                final categories = statisticsController.totalByCate;
                final isExpense = statisticsController.selectedType.value == 'chi';

                if (statisticsController.isLoading.value) {
                  return const SizedBox(
                    height: 120,
                    child: Center(child: CircularProgressIndicator()),
                  );
                }

                // Lọc các danh mục có chi tiêu/thu nhập thực tế
                final List<CategoryEntity> updatedCategories = categories
                    .where((c) => c.total > 0)
                    .toList()
                    .asMap()
                    .entries
                    .map((entry) {
                      final index = entry.key;
                      final item = entry.value;
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
                  startDate: AppHelperFunction.getFormattedDate(monthStartDate),
                  endDate: AppHelperFunction.getFormattedDate(now),
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
                final categories = statisticsController.totalByCate;
                final isExpense = statisticsController.selectedType.value == 'chi';
                final hasFund = statisticsController.fundController.currentFund.value != null;

                if (!isExpense || !hasFund) return const SizedBox.shrink();

                if (statisticsController.isLoading.value) {
                  return const SizedBox(
                    height: 120,
                    child: Center(child: CircularProgressIndicator()),
                  );
                }

                final filtered = categories.where((c) => c.limit > 0 || c.total > 0).toList();
                filtered.sort((a, b) {
                  double percentA = a.limit > 0 ? a.total / a.limit : (a.total > 0 ? 10.0 : 0.0);
                  double percentB = b.limit > 0 ? b.total / b.limit : (b.total > 0 ? 10.0 : 0.0);
                  return percentB.compareTo(percentA);
                });

                if (filtered.isEmpty) return const SizedBox.shrink();

                return Align(
                  alignment: Alignment.centerLeft,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    child: Row(
                      children: [
                        ...filtered.map(
                          (item) => Padding(
                            padding: const EdgeInsets.only(right: 12),
                            child: ChartCard(
                              title: item.categoryName,
                              amount: item.total,
                              limit: item.limit,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),

              const SizedBox(height: 25),

              Obx(() {
                final fund = fundController.currentFund.value;
                if (fund == null) return const SizedBox.shrink();
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: AppSectionHeading(
                        title: 'Thống kê quỹ tiết kiệm',
                        showActionButton: false,
                      ),
                    ),
                    const SizedBox(height: 10),
                    FundSummaryCard(
                      fund: fund,
                      report: fundController.fundReport.value,
                      isLoading: fundController.isLoadingReport.value,
                    ),
                    const SizedBox(height: 25),
                  ],
                );
              }),

              Obx(() {
                final lstMonth = statisticsController.totalByDateLstMonth.value;
                final thisMonth = statisticsController.totalByDate.value;
                final totalByType = statisticsController.totalByType.value;

                if (statisticsController.isLoading.value) {
                  return const SizedBox(
                    height: 120,
                    child: Center(child: CircularProgressIndicator()),
                  );
                }

                if (lstMonth == null ||
                    thisMonth == null ||
                    totalByType == null) {
                  return const SizedBox(
                    height: 120,
                    child: Center(child: Text('Không có dữ liệu')),
                  );
                }

                final summary = statisticsController.statisticsSummary.value;

                if (summary == null) {
                   return const SizedBox(
                    height: 120,
                    child: Center(child: Text('Đang tải dữ liệu...')),
                  );
                }

                return StatisticsHighlights(
                  dailyAverage: summary.dailyAverage,
                  dailyAverageChange: summary.dailyAverageChange.toInt().toString(),
                  monthlyBalanceChange: summary.dailyIncomeChange.toInt().toString(),
                  monthlyBalance: summary.monthlyBalance,
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
