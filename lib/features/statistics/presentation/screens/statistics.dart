import 'package:money_care/core/presentation/widgets/layout/app_header.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:money_care/features/transaction/presentation/controllers/filter_controller.dart';
import 'package:money_care/features/saving_fund/presentation/controllers/saving_fund_controller.dart';
import 'package:money_care/features/transaction/presentation/controllers/transaction_controller.dart';
import 'package:money_care/features/statistics/presentation/controllers/statistics_controller.dart';
import 'package:money_care/features/user/presentation/controllers/user_controller.dart';
import 'package:money_care/core/constants/text_string.dart';
import 'package:money_care/core/utils/helper/helper_functions.dart';
import 'package:money_care/core/controllers/app_controller.dart';
import 'package:money_care/features/transaction/domain/entities/transaction_entity.dart';
import 'package:money_care/features/statistics/presentation/widgets/chart/chart_card.dart';
import 'package:money_care/features/statistics/presentation/widgets/description/statistics_highlights.dart';
import 'package:money_care/features/statistics/presentation/widgets/chart/savings_bar_chart.dart';
import 'package:money_care/features/statistics/presentation/widgets/statistics_overview_card.dart';
import 'package:money_care/features/statistics/presentation/widgets/transaction_type_summary_toggle.dart';
import 'package:money_care/core/presentation/widgets/texts/section_heading.dart';

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
  final SavingFundController savingFundController =
      Get.find<SavingFundController>();
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

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: AppSectionHeading(
                  title: "Tổng chi tiêu theo tháng",
                  showActionButton: false,
                ),
              ),
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

              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: AppSectionHeading(
                  title: AppTexts.limitOverview,
                  showActionButton: false,
                ),
              ),
              const SizedBox(height: 10),
              Obx(() {
                final data = statisticsController.totalByType.value;
                final currentFund = savingFundController.currentFund.value;

                if (statisticsController.isLoading.value) {
                  return const SizedBox(
                    height: 120,
                    child: Center(child: CircularProgressIndicator()),
                  );
                }

                if (data == null || currentFund == null) {
                  return StatisticsOverviewCard(
                    startDate: AppHelperFunction.getFormattedDate(
                      monthStartDate,
                    ),
                    endDate: AppHelperFunction.getFormattedDate(now),
                    totalAmount: "0",
                    categories: const [],
                  );
                }

                final List<CategoryEntity> updatedCategories = currentFund.categories.asMap().entries.map((entry) {
                  final index = entry.key;
                  final category = entry.value;
                  return CategoryEntity(
                    id: category.id,
                    name: category.name,
                    percentage: category.percentage,
                    icon: category.icon,
                    color: AppHelperFunction.getChartColorByIndex(index),
                  );
                }).toList();

                return StatisticsOverviewCard(
                  startDate: AppHelperFunction.getFormattedDate(monthStartDate),
                  endDate: AppHelperFunction.getFormattedDate(now),
                  totalAmount: AppHelperFunction.formatAmount(
                    data.expenseTotal.toDouble(),
                    'VND',
                  ),
                  categories: updatedCategories,
                );
              }),

              const SizedBox(height: 25),
              Obx(() {
                final categories = statisticsController.totalByCate;

                if (statisticsController.isLoading.value) {
                  return const SizedBox(
                    height: 120,
                    child: Center(child: CircularProgressIndicator()),
                  );
                }

                if (categories.isEmpty) {
                  return const SizedBox(
                    height: 120,
                    child: Center(
                      child: Text(
                        'Chưa có dữ liệu danh mục',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                  );
                }

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
                        const SizedBox(width: 12),
                        ...categories.map(
                          (item) => Padding(
                            padding: const EdgeInsets.only(right: 12),
                            child: ChartCard(
                              title: item.categoryName,
                              amount: item.total,
                              limit: item.limit,
                              percent: item.percentage.toStringAsFixed(1),
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
