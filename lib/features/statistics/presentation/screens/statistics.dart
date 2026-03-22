import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:money_care/features/transaction/presentation/controllers/filter_controller.dart';
import 'package:money_care/features/saving_fund/presentation/controllers/saving_fund_controller.dart';
import 'package:money_care/features/transaction/presentation/controllers/transaction_controller.dart';
import 'package:money_care/features/user/presentation/controllers/user_controller.dart';
import 'package:money_care/core/constants/text_string.dart';
import 'package:money_care/core/utils/Helper/helper_functions.dart';
import 'package:money_care/core/storage/local_storage.dart';
import 'package:money_care/features/transaction/domain/entities/transaction_entity.dart';
import 'package:money_care/features/auth/data/models/user_model.dart';
import 'package:money_care/features/statistics/presentation/widgets/chart/chart_card.dart';
import 'package:money_care/features/statistics/presentation/widgets/description/description_total.dart';
import 'package:money_care/features/statistics/presentation/widgets/chart/savings_line_chart.dart';
import 'package:money_care/features/statistics/presentation/widgets/statistical.dart';
import 'package:money_care/features/statistics/presentation/widgets/statistics_header.dart';
import 'package:money_care/core/presentation/widgets/texts/section_heading.dart';

class StatisticsScreen extends StatefulWidget {
  const StatisticsScreen({super.key});

  @override
  State<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> {
  String selected = 'chi';

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

  late int userId;

  final TransactionController transactionController =
      Get.find<TransactionController>();
  final SavingFundController savingFundController =
      Get.find<SavingFundController>();
  final FilterController filterController = Get.find<FilterController>();
  final UserController userController = Get.find<UserController>();

  @override
  void initState() {
    super.initState();
    initUserInfo();
  }

  Future<void> initUserInfo() async {
    Map<String, dynamic> userInfoJson = LocalStorage().getUserInfo()!;
    UserModel user = UserModel.fromJson(userInfoJson, '');
    setState(() {
      userId = user.id;
    });
    loadData();
  }

  Future<void> loadData() async {
    transactionController.getTotalByDateEntityLstMonth(userId);
  }

  @override
  Widget build(BuildContext context) {
    final List<Color> fixedColors = [
      Colors.blue,
      Colors.red,
      Colors.green,
      Colors.orange,
      Colors.purple,
      Colors.teal,
      Colors.brown,
    ];
    List<FlSpot> convertToSpots7Days(List<TotalByDateEntity> data, DateTime endDate) {
      final Map<String, int> map = {
        for (var d in data)
          "${d.date.year}-${d.date.month}-${d.date.day}": d.total,
      };

      final List<FlSpot> spots = [];
      final start = endDate.subtract(const Duration(days: 6));

      for (int i = 0; i < 7; i++) {
        final d = start.add(Duration(days: i));
        final key = "${d.year}-${d.month}-${d.day}";
        final total = map[key] ?? 0.0;
        //spots.add(FlSpot(i.toDouble(), total));
      }

      return spots;
    }

    List<TotalByDateEntity> getDataBySelected(TotalsByDateEntity totals, String selected) {
      if (selected == 'chi') {
        return totals.expense;
      } else if (selected == 'thu') {
        return totals.income;
      } else {
        return [];
      }
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 195,
                decoration: const BoxDecoration(
                  color: kIsWeb ? Colors.white : Color(0xFF0B84FF),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(40),
                    bottomRight: Radius.circular(40),
                  ),
                ),
                child: Obx(() {
                  final data = transactionController.totalByType.value;

                  if (transactionController.isLoading.value) {
                    return const SizedBox(
                      height: 120,
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }

                  if (data == null) {
                    return StatisticsHeader(
                      selected: selected,
                      onSelected: (value) => setState(() => selected = value),
                      title: "Thá»‘ng kÃª",
                      spendText: 0,
                      incomeText: 0,
                    );
                  }

                  return StatisticsHeader(
                    selected: selected,
                    onSelected: (value) => setState(() => selected = value),
                    title: "Thá»‘ng kÃª",
                    spendText: data.expenseTotal,
                    incomeText: data.incomeTotal,
                  );
                }),
              ),

              const SizedBox(height: 25),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: AppSectionHeading(
                  title: "Tá»•ng chi tiÃªu theo thÃ¡ng",
                  showActionButton: false,
                ),
              ),
              const SizedBox(height: 10),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Obx(() {
                  if (transactionController.isLoading.value) {
                    return const SizedBox(
                      height: 120,
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }

                  final totalsLstMonth =
                      transactionController.totalByDateLstMonth.value;
                  final totalsThisMonth =
                      transactionController.totalByDate.value;

                  if (totalsLstMonth == null || totalsThisMonth == null) {
                    return const SizedBox(
                      height: 120,
                      child: Center(child: Text('KhÃ´ng cÃ³ dá»¯ liá»‡u')),
                    );
                  }

                  final lstMonthData = getDataBySelected(
                    totalsLstMonth,
                    selected,
                  );
                  final thisMonthData = getDataBySelected(
                    totalsThisMonth,
                    selected,
                  );

                  final lastMonthSpots = convertToSpots7Days(
                    lstMonthData,
                    transactionController.lastMonthToday,
                  );
                  final thisMonthSpots = convertToSpots7Days(
                    thisMonthData,
                    now,
                  );

                  return SavingsLineChart(
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
                final data = transactionController.totalByType.value;
                final currentFund = savingFundController.currentFund.value;

                if (transactionController.isLoading.value) {
                  return const SizedBox(
                    height: 120,
                    child: Center(child: CircularProgressIndicator()),
                  );
                }

                if (data == null || currentFund == null) {
                  return StatisticalWidgets(
                    startDate: AppHelperFunction.getFormattedDate(
                      monthStartDate,
                    ),
                    endDate: AppHelperFunction.getFormattedDate(now),
                    totalAmount: "0",
                    categories: [],
                  );
                }

                for (int i = 0; i < currentFund.categories.length; i++) {
                  /*currentFund.categories[i].color =
                      fixedColors[i % fixedColors.length];*/
                }

                return StatisticalWidgets(
                  startDate: AppHelperFunction.getFormattedDate(monthStartDate),
                  endDate: AppHelperFunction.getFormattedDate(now),
                  totalAmount: AppHelperFunction.formatAmount(
                    data.expenseTotal.toDouble(),
                    'VND',
                  ),
                  categories: currentFund.categories,
                );
              }),

              const SizedBox(height: 25),
              Obx(() {
                final categories = transactionController.totalByCate;

                if (transactionController.isLoading.value) {
                  return const SizedBox(
                    height: 120,
                    child: Center(child: CircularProgressIndicator()),
                  );
                }

                if (categories.isEmpty) {
                  return const SizedBox(
                    height: 120,
                    child: Center(child: Text('KhÃ´ng cÃ³ dá»¯ liá»‡u')),
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
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          const SizedBox(width: 12),
                          ...categories.map(
                            (item) => Padding(
                              padding: const EdgeInsets.only(right: 12),
                              child: ChartCard(
                                title: item.categoryName,
                                amount: item.total,
                                limit:
                                    ((item.percentage) *
                                        (userController
                                                .userProfile
                                                .value
                                                ?.monthlyIncome ??
                                            0)) /
                                    100,
                                percent: item.percentage.toStringAsFixed(1),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }),

              const SizedBox(height: 25),

              Obx(() {
                final lstMonth =
                    transactionController.totalByDateLstMonth.value;
                final thisMonth = transactionController.totalByDate.value;
                final totalByType = transactionController.totalByType.value;

                if (transactionController.isLoading.value) {
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
                    child: Center(child: Text('KhÃ´ng cÃ³ dá»¯ liá»‡u')),
                  );
                }

                return DescriptionTotal(
                  dailyAverage: transactionController.dailyAverage,
                  dailyAverageChange:
                      transactionController.dailyAverageChange
                          .toInt()
                          .toString(),
                  monthlyBalanceChange:
                      transactionController.dailyIncomeChange.toString(),
                  monthlyBalance:
                      (totalByType.incomeTotal - totalByType.expenseTotal)
                          .toDouble(),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
