import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:money_care/app/controllers/saving_goal_controller.dart';
import 'package:money_care/features/transaction/data/models/transaction_model.dart';
import 'package:money_care/app/controllers/app_controller.dart';

import 'package:money_care/features/transaction/domain/entities/entities.dart';
import 'package:money_care/features/transaction/domain/usecases/usecases.dart';
import 'package:money_care/core/services/widget_service.dart';
import 'package:money_care/core/constants/route_path.dart';
import 'package:money_care/app/controllers/transaction_controller.dart';

class StatisticsController extends GetxController {
  final GetTotalByTypeUseCase getTotalByTypeUseCase;
  final GetTotalByCateUseCase getTotalByCateUseCase;
  final GetTotalByDateEntityUseCase getTotalByDateEntityUseCase;
  final GetStatisticsSummaryUseCase getStatisticsSummaryUseCase;

  SavingGoalController get savingGoalController =>
      Get.find<SavingGoalController>();

  var totalByType = Rxn<TotalByTypeEntity>();
  var globalTotalByType = Rxn<TotalByTypeEntity>();
  var previousTotalByType = Rxn<TotalByTypeEntity>();
  RxList<TotalByCategoryEntity> totalByCate = <TotalByCategoryEntity>[].obs;
  RxList<TotalByCategoryEntity> expenseCategories =
      <TotalByCategoryEntity>[].obs;
  RxList<TotalByCategoryEntity> incomeCategories =
      <TotalByCategoryEntity>[].obs;

  var totalByDate = Rxn<TotalsByDateEntity>();
  var totalByDateLstMonth = Rxn<TotalsByDateEntity>();
  var statisticsSummary = Rxn<StatisticsSummaryEntity>();

  RxList<FlSpot> chartSpots = <FlSpot>[].obs;
  RxList<String> chartLabels = <String>[].obs;
  var isSilentLoading = false.obs;

  double get totalBudget =>
      expenseCategories.fold(0.0, (sum, cat) => sum + cat.limit);

  double get utilizationPercentage {
    if (totalBudget <= 0) return 0.0;
    final spent = totalByType.value?.expenseTotal.toDouble() ?? 0.0;
    return spent / totalBudget;
  }

  final RxString selectedType = 'chi'.obs;

  final RxString periodType = 'hàng tháng'.obs;
  final Rx<DateTime> selectedMonth = DateTime(
    DateTime.now().year,
    DateTime.now().month,
    1,
  ).obs;
  final Rx<DateTime> selectedDay = DateTime(
    DateTime.now().year,
    DateTime.now().month,
    DateTime.now().day,
  ).obs;

  DateTime get monthStartDate =>
      _getCycleDate(selectedMonth.value, 0);
  DateTime get monthEndDate =>
      _getCycleDate(selectedMonth.value, 0, isEnd: true);

  DateTime _clampDayToMonth(int year, int month, int day) {
    int lastDay = DateTime(year, month + 1, 0).day;
    return DateTime(year, month, day > lastDay ? lastDay : day);
  }

  DateTime _getCycleDate(DateTime baseMonth, int offsetMonths,
      {bool isEnd = false}) {
    final appController = Get.find<AppController>();
    final startDay = appController.startDayOfMonth.value;

    int year = baseMonth.year;
    int month = baseMonth.month + offsetMonths;

    if (isEnd) {
      DateTime nextCycleStart = _clampDayToMonth(year, month + 1, startDay);
      return nextCycleStart.subtract(const Duration(seconds: 1));
    }

    return _clampDayToMonth(year, month, startDay);
  }

  DateTime get currentStartDate {
    return periodType.value == 'hàng tháng'
        ? monthStartDate
        : selectedDay.value;
  }

  DateTime get currentEndDate {
    return periodType.value == 'hàng tháng'
        ? DateTime(
            monthEndDate.year,
            monthEndDate.month,
            monthEndDate.day,
            23,
            59,
            59,
          )
        : DateTime(
            selectedDay.value.year,
            selectedDay.value.month,
            selectedDay.value.day,
            23,
            59,
            59,
          );
  }

  DateTime _clampToGoalStart(DateTime date) {
    final goal = savingGoalController.currentGoal.value;
    if (goal == null || goal.startDate == null) return date;
    if (date.isBefore(goal.startDate!)) return goal.startDate!;
    return date;
  }

  DateTime _clampToGoalEnd(DateTime date) {
    final goal = savingGoalController.currentGoal.value;
    if (goal == null || goal.endDate == null) return date;
    if (date.isAfter(goal.endDate!)) return goal.endDate!;
    return date;
  }

  DateTime get previousStartDate {
    if (periodType.value == 'hàng tháng') {
      return _getCycleDate(selectedMonth.value, -1);
    } else {
      return selectedDay.value.subtract(const Duration(days: 1));
    }
  }

  DateTime get previousEndDate {
    if (periodType.value == 'hàng tháng') {
      return _getCycleDate(selectedMonth.value, -1, isEnd: true);
    } else {
      final prev = selectedDay.value.subtract(const Duration(days: 1));
      return DateTime(prev.year, prev.month, prev.day, 23, 59, 59);
    }
  }

  var isLoading = false.obs;
  var errorMessage = RxnString();

  final now = DateTime.now();
  DateTime get weekStartDate => now.subtract(const Duration(days: 6));
  DateTime get weekEndDate => now;

  StatisticsController({
    required this.getTotalByTypeUseCase,
    required this.getTotalByCateUseCase,
    required this.getTotalByDateEntityUseCase,
    required this.getStatisticsSummaryUseCase,
  });

  @override
  void onInit() {
    super.onInit();
    final appController = Get.find<AppController>();
    ever(appController.startDayOfMonth, (_) {
      final id = appController.userId.value;
      if (id != null) {
        refreshStatisticsData(id);
      }
    });

    ever(appController.userId, (int? id) {
      if (id != null) {
        refreshStatisticsData(id);
      } else {
        _clearData();
      }
    });

    final currentId = appController.userId.value;
    if (currentId != null) {
      refreshStatisticsData(currentId);
    }

    everAll(
      [
        selectedMonth,
        selectedDay,
        periodType,
        selectedType,
        savingGoalController.goalId,
      ],
      (_) {
        final id = appController.userId.value;
        if (id != null) refreshStatisticsData(id);
      },
    );
  }

  void _clearData() {
    totalByType.value = null;
    globalTotalByType.value = null;
    previousTotalByType.value = null;
    totalByCate.clear();
    expenseCategories.clear();
    incomeCategories.clear();
    totalByDate.value = null;
    totalByDateLstMonth.value = null;
    statisticsSummary.value = null;
  }

  Future<void> _loadGlobalTotalByType(int userId) async {
    try {
      final dto = TransactionTotalsDto(
        startDate: currentStartDate.toUtc().toIso8601String(),
        endDate: currentEndDate.toUtc().toIso8601String(),
      );

      globalTotalByType.value = await getTotalByTypeUseCase(userId, dto);
    } catch (e) {
      debugPrint('Error loading global totals: $e');
    }
  }

  Future<void> _loadPreviousTotalByType(int userId) async {
    try {
      final dto = TransactionTotalsDto(
        startDate: previousStartDate.toUtc().toIso8601String(),
        endDate: previousEndDate.toUtc().toIso8601String(),
      );
      previousTotalByType.value = await getTotalByTypeUseCase(userId, dto);
    } catch (e) {
      previousTotalByType.value = null;
      debugPrint('Error loading previous totals: $e');
    }
  }

  Future<void> getTotalByType(
    int userId, {
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    isLoading.value = true;
    try {
      final dto = _createTotalsDto(
        startDate ?? currentStartDate,
        endDate ?? currentEndDate,
      );
      totalByType.value = await getTotalByTypeUseCase(userId, dto);
      errorMessage.value = null;
    } catch (e) {
      totalByType.value = null;
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> getTotalByCate(int userId) async {
    isLoading.value = true;
    try {
      final dto = _createTotalsDto(currentStartDate, currentEndDate);
      final list = await getTotalByCateUseCase(userId, dto);
      totalByCate.assignAll(list);
      errorMessage.value = null;
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> getTotalByDateEntity(
    int userId,
    TransactionTotalsDto dto,
  ) async {
    isLoading.value = true;
    try {
      totalByDate.value = await getTotalByDateEntityUseCase(userId, dto);
      errorMessage.value = null;
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> getTotalByDateEntityLstMonth(int userId) async {
    try {
      final dto = _createTotalsDto(lastMonth7DaysStart, lastMonthToday);
      totalByDateLstMonth.value = await getTotalByDateEntityUseCase(
        userId,
        dto,
      );
      errorMessage.value = null;
    } catch (e) {
      errorMessage.value = e.toString();
    }
  }

  Future<void> loadStatisticsData(
    int userId,
    DateTime startDate,
    DateTime endDate,
  ) async {
    isLoading.value = true;
    try {
      final totalsDto = TransactionTotalsDto(
        startDate: startDate.toUtc().toIso8601String(),
        endDate: endDate.toUtc().toIso8601String(),
      );

      await Future.wait([
        _loadTotalByType(userId),
        _loadTotalByCate(userId),
        _loadMonthlyCategories(userId),
        _loadTotalByDate(userId, totalsDto),
      ]);

      errorMessage.value = null;
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _loadTotalByType(
    int userId, {
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      final dto = _createTotalsDto(
        startDate ?? currentStartDate,
        endDate ?? currentEndDate,
      );
      totalByType.value = await getTotalByTypeUseCase(userId, dto);
    } catch (e) {
      totalByType.value = null;
      rethrow;
    }
  }

  Future<void> _loadTotalByCate(
    int userId, {
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      final dto = _createTotalsDto(
        startDate ?? currentStartDate,
        endDate ?? currentEndDate,
      );
      final list = await getTotalByCateUseCase(userId, dto);
      totalByCate.assignAll(list);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> _loadMonthlyCategories(int userId) async {
    try {
      final expenseDto = TransactionTotalsDto(
        startDate: currentStartDate.toUtc().toIso8601String(),
        endDate: currentEndDate.toUtc().toIso8601String(),
        type: 'expense',
      );
      final incomeDto = TransactionTotalsDto(
        startDate: currentStartDate.toUtc().toIso8601String(),
        endDate: currentEndDate.toUtc().toIso8601String(),
        type: 'income',
      );

      final results = await Future.wait([
        getTotalByCateUseCase(userId, expenseDto),
        getTotalByCateUseCase(userId, incomeDto),
      ]);

      expenseCategories.assignAll(results[0]);
      incomeCategories.assignAll(results[1]);
    } catch (e) {
      print("Error loading monthly categories: $e");
    }
  }

  Future<void> _loadTotalByDate(int userId, TransactionTotalsDto dto) async {
    try {
      totalByDate.value = await getTotalByDateEntityUseCase(userId, dto);
    } catch (e) {
      rethrow;
    }
  }

  int _refreshCounter = 0;

  Future<void> refreshStatisticsData(int userId, {bool skipMainTotals = false}) async {
    final int currentRefresh = ++_refreshCounter;

    if (totalByDate.value == null) {
      isLoading.value = true;
    } else {
      isSilentLoading.value = true;
    }

    try {
      final dtoRange = _createTotalsDto(currentStartDate, currentEndDate);

      if (periodType.value == 'hàng tháng') {
        final List<Future> futures = [];
        
        if (!skipMainTotals) {
          futures.addAll([
            _loadTotalByType(
              userId,
              startDate: currentStartDate,
              endDate: currentEndDate,
            ),
            _loadGlobalTotalByType(userId),
            _loadTotalByCate(
              userId,
              startDate: currentStartDate,
              endDate: currentEndDate,
            ),
            _loadMonthlyCategories(userId),
            _loadTotalByDate(userId, dtoRange),
          ]);
        }

        futures.addAll([
          _loadPreviousTotalByType(userId),
          _loadStatisticsSummary(userId),
        ]);

        final activeGoalId = savingGoalController.goalId.value;
        if (activeGoalId > 0) {
          futures.add(
            savingGoalController.loadGoalReport(activeGoalId),
          );
        }

        await Future.wait(futures);
        if (currentRefresh == _refreshCounter) {
          _processMonthlyData();
          _updateWidgetData();
        }
      } else {
        final List<Future> futures = [];
        
        if (!skipMainTotals) {
          futures.addAll([
            _loadTotalByType(
              userId,
              startDate: currentStartDate,
              endDate: currentEndDate,
            ),
            _loadGlobalTotalByType(userId),
            _loadTotalByCate(
              userId,
              startDate: currentStartDate,
              endDate: currentEndDate,
            ),
            _loadDailyHourlyData(userId),
          ]);
        }

        futures.addAll([
          _loadPreviousTotalByType(userId),
          _loadStatisticsSummary(userId),
        ]);

        final activeGoalId = savingGoalController.goalId.value;
        if (activeGoalId > 0) {
          futures.add(
            savingGoalController.loadGoalReport(activeGoalId),
          );
        }

        await Future.wait(futures);
      }

      if (currentRefresh == _refreshCounter) {
        errorMessage.value = null;
      }
    } catch (e) {
      if (currentRefresh == _refreshCounter) {
        errorMessage.value = e.toString();
      }
    } finally {
      if (currentRefresh == _refreshCounter) {
        isLoading.value = false;
        isSilentLoading.value = false;
      }
    }
  }

  Future<void> _loadDailyHourlyData(int userId) async {
    try {
      final filterDto = TransactionFilterDto(
        startDate: currentStartDate.toUtc().toIso8601String(),
        endDate: currentEndDate.toUtc().toIso8601String(),
      );

      final result = await Get.find<TransactionController>()
          .filterTransactionsUseCase(userId, filterDto);

      final transactions = selectedType.value == 'chi'
          ? result.expenseTransactions
          : result.incomeTransactions;

      final List<double> hourlyTotals = List.filled(24, 0.0);
      for (var t in transactions) {
        final hour = t.transactionDate?.toLocal().hour ?? 0;
        hourlyTotals[hour] += t.amount.toDouble();
      }

      chartSpots.assignAll(
        hourlyTotals
            .asMap()
            .entries
            .map((e) => FlSpot(e.key.toDouble(), e.value))
            .toList(),
      );

      chartLabels.assignAll(
        List.generate(
          24,
          (i) => i % 4 == 0 ? "${i.toString().padLeft(2, '0')}:00" : "",
        ),
      );
    } catch (e) {
      print("Error loading hourly data: $e");
    }
  }

  void _processMonthlyData() {
    final totals = totalByDate.value;
    if (totals == null) return;

    final data = selectedType.value == 'chi' ? totals.expense : totals.income;
    final Map<int, double> dayMap = {
      for (var d in data) d.date.toLocal().day: d.total.toDouble(),
    };

    final lastDay = monthEndDate.day;
    final List<FlSpot> spots = [];
    final List<String> labels = [];

    for (int i = 1; i <= lastDay; i++) {
      spots.add(FlSpot((i - 1).toDouble(), dayMap[i] ?? 0.0));
      if (i == 1 || i == lastDay || (i - 1) % 2 == 0) {
        labels.add(i.toString());
      } else {
        labels.add("");
      }
    }

    chartSpots.assignAll(spots);
    chartLabels.assignAll(labels);
  }

  void nextPeriod() {
    if (periodType.value == 'hàng tháng') {
      selectedMonth.value = DateTime(
        selectedMonth.value.year,
        selectedMonth.value.month + 1,
        1,
      );
    } else {
      selectedDay.value = selectedDay.value.add(const Duration(days: 1));
    }
  }

  void previousPeriod() {
    if (periodType.value == 'hàng tháng') {
      selectedMonth.value = DateTime(
        selectedMonth.value.year,
        selectedMonth.value.month - 1,
        1,
      );
    } else {
      selectedDay.value = selectedDay.value.subtract(const Duration(days: 1));
    }
  }

  void togglePeriodType() {
    if (periodType.value == 'hàng tháng') {
      periodType.value = 'hàng ngày';
    } else {
      periodType.value = 'hàng tháng';
    }
  }

  Future<void> _loadStatisticsSummary(int userId) async {
    try {
      final dto = _createTotalsDto(currentStartDate, currentEndDate);
      statisticsSummary.value = await getStatisticsSummaryUseCase(userId, dto);
    } catch (e) {
      statisticsSummary.value = null;
    }
  }

  void changeType(String type) async {
    selectedType.value = type;
    final appController = Get.find<AppController>();
    final userId = await appController.getCurrentUserId();
    if (userId != null) {
      _loadTotalByCate(userId);
    }
  }

  TransactionTotalsDto _createTotalsDto(DateTime start, DateTime end) {
    final backendType = selectedType.value == 'chi' ? 'expense' : 'income';
    final now = DateTime.now();

    // Check if it is the current month range (standard 1st to end of month)
    final isCurrentMonth = start.year == now.year &&
        start.month == now.month &&
        start.day == 1 &&
        end.year == now.year &&
        end.month == now.month;

    return TransactionTotalsDto(
      startDate: isCurrentMonth ? null : start.toUtc().toIso8601String(),
      endDate: isCurrentMonth ? null : end.toUtc().toIso8601String(),
      type: backendType,
    );
  }

  DateTime get lastMonthToday {
    int month = now.month - 1;
    int year = month == 0 ? now.year - 1 : now.year;
    month = month == 0 ? 12 : month;
    final lastDayOfPreviousMonth = DateTime(year, month + 1, 0).day;
    final day = now.day > lastDayOfPreviousMonth
        ? lastDayOfPreviousMonth
        : now.day;
    return DateTime(year, month, day);
  }

  DateTime get lastMonth7DaysStart =>
      lastMonthToday.subtract(const Duration(days: 6));

  double calculateDailyAverage(List<TotalByDateEntity> list, DateTime endDate) {
    final Map<String, int> map = {
      for (var d in list)
        "${d.date.toLocal().year}-${d.date.toLocal().month}-${d.date.toLocal().day}": d.total,
    };

    if (list.isEmpty) return 0;

    final start = endDate.subtract(const Duration(days: 6));
    double sum = 0;

    for (int i = 0; i < 7; i++) {
      final d = start.add(Duration(days: i));
      final key = "${d.year}-${d.month}-${d.day}";
      sum += map[key] ?? 0;
    }

    return sum / 7;
  }

  double calculatePercentageChange(double current, double previous) {
    if (previous == 0) return 0;
    return ((current - previous) / previous) * 100;
  }

  List<TotalByDateEntity> getDataBySelected(TotalsByDateEntity totals) {
    if (selectedType.value == 'chi') {
      return totals.expense;
    } else if (selectedType.value == 'thu') {
      return totals.income;
    } else {
      return [];
    }
  }

  List<FlSpot> convertToSpots7Days(
    List<TotalByDateEntity> data,
    DateTime endDate,
  ) {
    final Map<String, double> map = {
      for (var d in data)
        "${d.date.toLocal().year}-${d.date.toLocal().month}-${d.date.toLocal().day}": d.total.toDouble(),
    };

    final List<FlSpot> spots = [];
    final start = endDate.subtract(const Duration(days: 6));

    for (int i = 0; i < 7; i++) {
      final date = start.add(Duration(days: i));
      final key = "${date.year}-${date.month}-${date.day}";
      final val = map[key] ?? 0.0;
      spots.add(FlSpot(i.toDouble(), val));
    }
    return spots;
  }

  void _updateWidgetData() {
    final totals = globalTotalByType.value;
    if (totals == null) return;

    final appController = Get.find<AppController>();
    final bool isVisible = appController.isWidgetBalanceVisible.value;

    final income = totals.incomeTotal.toDouble();
    final expense = totals.expenseTotal.toDouble();
    final balance = income - expense;

    // Remaining budget calculation
    final spent = totals.expenseTotal.toDouble();
    final remaining = totalBudget > 0 ? (totalBudget - spent) : 0.0;

    WidgetService.updateHomeWidget(
      balance: isVisible ? balance : null,
      monthlyExpense: isVisible ? expense : null,
      remainingBudget: isVisible ? remaining : null,
    );
  }

  void updateStatsFromTransactions(TransactionByTypeEntity data) {
    final income = data.incomeTransactions;
    final expense = data.expenseTransactions;

    // 1. Update Total By Type
    double incomeTotal = income.fold(0.0, (sum, t) => sum + t.amount);
    double expenseTotal = expense.fold(0.0, (sum, t) => sum + t.amount);

    globalTotalByType.value = TotalByTypeEntity(
      incomeTotal: incomeTotal.toInt(),
      expenseTotal: expenseTotal.toInt(),
      currentSaving: (incomeTotal - expenseTotal).toInt(),
    );
    totalByType.value = globalTotalByType.value;

    // 2. Update Total By Date (for Chart)
    final Map<DateTime, double> incomeByDay = {};
    final Map<DateTime, double> expenseByDay = {};

    for (var t in income) {
      final date = _stripTime(t.transactionDate ?? DateTime.now());
      incomeByDay[date] = (incomeByDay[date] ?? 0.0) + t.amount;
    }
    for (var t in expense) {
      final date = _stripTime(t.transactionDate ?? DateTime.now());
      expenseByDay[date] = (expenseByDay[date] ?? 0.0) + t.amount;
    }

    final List<TotalByDateEntity> incomeList = incomeByDay.entries
        .map((e) => TotalByDateEntity(date: e.key, total: e.value.toInt()))
        .toList();
    final List<TotalByDateEntity> expenseList = expenseByDay.entries
        .map((e) => TotalByDateEntity(date: e.key, total: e.value.toInt()))
        .toList();

    totalByDate.value = TotalsByDateEntity(
      income: incomeList,
      expense: expenseList,
    );

    // 3. Update Categories
    final Map<int, TotalByCategoryEntity> expCatMap = {};
    final Map<int, TotalByCategoryEntity> incCatMap = {};

    final targetGoal = savingGoalController.currentGoal.value?.target ?? 0;

    for (var t in expense) {
      if (t.category == null || t.category!.id == null) continue;
      final int id = t.category!.id!;
      final existing = expCatMap[id];
      if (existing == null) {
        expCatMap[id] = TotalByCategoryEntity(
          categoryId: id,
          categoryName: t.category!.name,
          categoryIcon: t.category!.icon ?? '',
          total: t.amount.toInt(),
          percentage: t.category!.percentage.toDouble(),
          limit: (t.category!.percentage * targetGoal) / 100,
          isEssential: t.category!.isEssential,
        );
      } else {
        expCatMap[id] = TotalByCategoryEntity(
          categoryId: id,
          categoryName: existing.categoryName,
          categoryIcon: existing.categoryIcon,
          total: existing.total + t.amount.toInt(),
          percentage: existing.percentage,
          limit: existing.limit,
          isEssential: existing.isEssential,
        );
      }
    }

    for (var t in income) {
      if (t.category == null || t.category!.id == null) continue;
      final int id = t.category!.id!;
      final existing = incCatMap[id];
      if (existing == null) {
        incCatMap[id] = TotalByCategoryEntity(
          categoryId: id,
          categoryName: t.category!.name,
          categoryIcon: t.category!.icon ?? '',
          total: t.amount.toInt(),
          percentage: t.category!.percentage.toDouble(),
          limit: 0,
          isEssential: t.category!.isEssential,
        );
      } else {
        incCatMap[id] = TotalByCategoryEntity(
          categoryId: id,
          categoryName: existing.categoryName,
          categoryIcon: existing.categoryIcon,
          total: existing.total + t.amount.toInt(),
          percentage: existing.percentage,
          limit: existing.limit,
          isEssential: existing.isEssential,
        );
      }
    }

    expenseCategories.assignAll(expCatMap.values.toList());
    incomeCategories.assignAll(incCatMap.values.toList());

    _processMonthlyData();
    _updateWidgetData();
  }

  DateTime _stripTime(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }
}
