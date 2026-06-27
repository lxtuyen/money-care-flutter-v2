import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:get/get.dart';
import 'package:money_care/app/controllers/saving_goal_controller.dart';
import 'package:money_care/features/transaction/data/models/transaction_model.dart';
import 'package:money_care/app/controllers/app_controller.dart';

import 'package:money_care/features/transaction/domain/entities/entities.dart';
import 'package:money_care/features/transaction/domain/usecases/usecases.dart';
import 'package:money_care/core/services/widget_service.dart';
import 'package:money_care/app/controllers/transaction_controller.dart';
import 'package:money_care/features/spending_plan/presentation/controllers/spending_plan_controller.dart';
import 'package:money_care/features/spending_plan/domain/entities/spending_plan_entity.dart';
import 'package:money_care/features/statistics/data/models/analytics_model.dart';
import 'package:money_care/features/statistics/domain/usecases/get_financial_analytics_usecase.dart';
import 'package:money_care/features/ai_feedback/data/models/ai_feedback_dto.dart';
import 'package:money_care/features/ai_feedback/domain/usecases/send_ai_feedback_usecase.dart';
import 'package:money_care/core/utils/helper/helper_functions.dart';
import 'package:money_care/features/habit_commitments/domain/entities/habit_commitment_entity.dart';
import 'package:money_care/features/habit_commitments/domain/repositories/habit_commitment_repository.dart';

class StatisticsController extends GetxController {
  final GetTotalByTypeUseCase getTotalByTypeUseCase;
  final GetTotalByCateUseCase getTotalByCateUseCase;
  final GetTotalByDateEntityUseCase getTotalByDateEntityUseCase;
  final GetStatisticsSummaryUseCase getStatisticsSummaryUseCase;
  final GetFirstTransactionDateUseCase getFirstTransactionDateUseCase;
  final GetFinancialAnalyticsUseCase getFinancialAnalyticsUseCase;
  final SendAiFeedbackUseCase sendAiFeedbackUseCase;

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

  final analyticsData = Rxn<AnalyticsModel>();
  final isLoadingAnalytics = false.obs;
  final analyticsError = ''.obs;
  final submittedFeedbackIds = <String>{}.obs;
  final sendingFeedbackIds = <String>{}.obs;
  final habitCommitments = <HabitCommitmentEntity>[].obs;

  final firstTransactionDate = Rxn<DateTime>();

  RxList<FlSpot> chartSpots = <FlSpot>[].obs;
  RxList<String> chartLabels = <String>[].obs;
  var isSilentLoading = false.obs;

  double get totalBudget => totalLimit;

  double get utilizationPercentage {
    final total = totalLimit;
    if (total <= 0) return 0.0;
    final totalExpense = (totalByType.value?.expenseTotal ?? 0).toDouble();
    final spent = (totalExpense - savingSpent).clamp(0.0, double.infinity);
    return (spent / total).clamp(0.0, 1.0);
  }

  SpendingPlanController get _spendingPlanController => Get.find<SpendingPlanController>();

  bool get hasSpendingPlanStats => _spendingPlanController.statsSummary.value != null;
  SpendingPlanStatsEntity? get spendingPlanStats => _spendingPlanController.statsSummary.value;

  int get daysInMonth => DateTime(selectedMonth.value.year, selectedMonth.value.month + 1, 0).day;

  bool get isCurrentMonth {
    final now = DateTime.now();
    return selectedMonth.value.year == now.year && selectedMonth.value.month == now.month;
  }

  bool get canGoNextMonth {
    if (periodType.value != 'hàng tháng') return true;
    final now = DateTime.now();
    return !(selectedMonth.value.year == now.year &&
        selectedMonth.value.month == now.month);
  }

  bool get canGoPreviousMonth {
    if (periodType.value != 'hàng tháng') return true;
    final first = firstTransactionDate.value;
    if (first == null) return true;
    return !(selectedMonth.value.year == first.year &&
        selectedMonth.value.month == first.month);
  }

  List<BudgetExceedPredictionModel> get exceedPredictions =>
      analyticsData.value?.aiBudgeting?.budgetExceedPredictions ?? const [];

  Map<String, BudgetExceedPredictionModel> get predictionMap => {
        for (final p in exceedPredictions) p.categoryName.toLowerCase(): p,
      };

  int get anomalyCount => analyticsData.value?.anomalies.length ?? 0;
  List<AnomalyModel> get anomalies => analyticsData.value?.anomalies ?? const [];

  Map<String, List<EstimatedExpenseEntity>> get groupedExpenses {
    final stats = spendingPlanStats;
    if (stats == null) return const {};
    final groups = <String, List<EstimatedExpenseEntity>>{};
    for (final expense in stats.estimatedExpenses) {
      final category = expense.category?.trim();
      final key = category != null && category.isNotEmpty
          ? category
          : expense.displayName;
      groups.putIfAbsent(key, () => []).add(expense);
    }
    return groups;
  }

  static const _savingCategoryName = 'Tiết kiệm';

  Map<String, List<EstimatedExpenseEntity>> get filteredExpenses {
    return Map.fromEntries(
      groupedExpenses.entries.where(
        (e) => e.key.toLowerCase() != _savingCategoryName.toLowerCase(),
      ),
    );
  }

  Map<String, double> get categorySpentMap => {
        for (final c in totalByCate) c.categoryName.toLowerCase(): c.total.toDouble(),
      };

  double get savingBudget {
    double total = 0;
    for (final entry in groupedExpenses.entries) {
      if (entry.key.toLowerCase() == _savingCategoryName.toLowerCase()) {
        for (final e in entry.value) {
          final limit = e.monthlyLimit > 0
              ? e.monthlyLimit
              : _monthlyizedAmount(e, daysInMonth);
          total += limit;
        }
        break;
      }
    }
    return total;
  }

  double get savingSpent {
    double spent = 0;
    for (final goal in savingGoalController.activeGoals) {
      final report = savingGoalController.goalReports[goal.id];
      if (report != null) {
        final start = currentStartDate;
        final end = currentEndDate;
        for (final tx in report.transactions) {
          final txDate = tx.transactionDate;
          if (txDate != null &&
              txDate.isAfter(start.subtract(const Duration(seconds: 1))) &&
              txDate.isBefore(end.add(const Duration(seconds: 1)))) {
            if (tx.type == 'income' || tx.type == 'thu') {
              spent += tx.amount;
            } else if (tx.type == 'expense' || tx.type == 'chi') {
              spent -= tx.amount;
            }
          }
        }
      }
    }
    return spent;
  }

  double get totalLimit {
    double limit = 0;
    for (final entry in filteredExpenses.entries) {
      for (final e in entry.value) {
        final lim = e.monthlyLimit > 0
            ? e.monthlyLimit
            : _monthlyizedAmount(e, daysInMonth);
        limit += lim;
      }
    }
    return limit;
  }

  double get totalForecast {
    double forecast = 0;
    final pMap = predictionMap;
    for (final entry in filteredExpenses.entries) {
      final pred = pMap[entry.key.toLowerCase()];
      if (pred != null) {
        forecast += pred.totalForecast;
      }
    }
    return forecast;
  }

  double get totalFixedForecast {
    final forecasting = analyticsData.value?.currentMonthProjection;
    if (forecasting == null) return 0.0;
    double total = 0.0;
    for (final cf in forecasting.categoryForecasts) {
      total += cf.fixedAmount ?? 0.0;
    }
    return total;
  }

  double get totalFlexibleForecast {
    final forecast = totalForecast;
    final fixed = totalFixedForecast;
    if (forecast <= 0 || fixed <= 0) return forecast;
    return (forecast - fixed).clamp(0.0, double.infinity);
  }

  double get totalSpentExcludingSavings {
    final totalExpense = (totalByType.value?.expenseTotal ?? 0).toDouble();
    return (totalExpense - savingSpent).clamp(0.0, double.infinity);
  }

  double get forecastedSaving {
    final stats = spendingPlanStats;
    if (stats == null) return 0.0;
    final plannedIncome = stats.totalAmount;
    final forecast = totalForecast;
    return forecast > 0
        ? plannedIncome - forecast
        : plannedIncome - totalSpentExcludingSavings;
  }

  double get totalHabitSavings {
    if (habitCommitments.isEmpty) return 0.0;
    return habitCommitments.fold<double>(
      0.0,
      (sum, c) => sum + c.potentialSavings,
    );
  }

  double _monthlyizedAmount(EstimatedExpenseEntity expense, int daysInMonth) {
    final v = expense.frequencyValue <= 0 ? 1 : expense.frequencyValue;
    switch (expense.frequencyType.toLowerCase()) {
      case 'daily':
        return expense.amount * v * daysInMonth;
      case 'weekly':
        return expense.amount * v * (daysInMonth / 7);
      default:
        return expense.amount * v;
    }
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

  DateTime get monthStartDate => _getCycleDate(selectedMonth.value, 0);
  DateTime get monthEndDate =>
      _getCycleDate(selectedMonth.value, 0, isEnd: true);

  DateTime _clampDayToMonth(int year, int month, int day) {
    int lastDay = DateTime(year, month + 1, 0).day;
    return DateTime(year, month, day > lastDay ? lastDay : day);
  }

  DateTime _getCycleDate(
    DateTime baseMonth,
    int offsetMonths, {
    bool isEnd = false,
  }) {
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
    required this.getFirstTransactionDateUseCase,
    required this.getFinancialAnalyticsUseCase,
    required this.sendAiFeedbackUseCase,
  });

  Future<void> loadFinancialAnalytics() async {
    isLoadingAnalytics.value = true;
    analyticsError.value = '';
    try {
      final targetDate = currentStartDate;
      final result = await getFinancialAnalyticsUseCase(
        targetMonth: targetDate.month,
        targetYear: targetDate.year,
      );
      result.fold(
        (failure) {
          analyticsData.value = null;
          analyticsError.value = failure.message;
        },
        (data) {
          analyticsData.value = data;
        },
      );
    } catch (e) {
      analyticsError.value = e.toString();
    } finally {
      isLoadingAnalytics.value = false;
    }
  }

  Future<void> _loadHabitCommitments() async {
    try {
      if (!Get.isRegistered<HabitCommitmentRepository>()) return;
      final repo = Get.find<HabitCommitmentRepository>();
      final month = currentStartDate.month;
      final year = currentStartDate.year;
      final data = await repo.getProgress(month: month, year: year);
      habitCommitments.assignAll(data);
    } catch (e) {
      debugPrint('Error loading habit commitments: $e');
    }
  }

  Future<void> sendBudgetRecommendationFeedback(
    AiBudgetRecommendationItemModel item,
    String action, {
    double? finalLimitAmount,
  }) async {
    if (submittedFeedbackIds.contains(item.recommendationId) ||
        sendingFeedbackIds.contains(item.recommendationId)) {
      return;
    }

    sendingFeedbackIds.add(item.recommendationId);
    try {
      await sendAiFeedbackUseCase(
        AiFeedbackDto(
          recommendationType: 'budget',
          recommendationId: item.recommendationId,
          sourceModel: 'personalized_budget_optimizer',
          sourceModelVersion: 'v2',
          userAction: action,
          sourcePayload: {
            'categoryName': item.categoryName,
            'currentLimitAmount': item.currentLimitAmount,
            'recommendedLimitAmount': item.recommendedLimitAmount,
            'predictedSpendAmount': item.predictedSpendAmount,
            'spentAmount': item.spentAmount,
            'confidence': item.confidence,
            'reason': item.reason,
            'actionType': item.actionType,
            'riskBefore': item.riskBefore,
            'riskAfter': item.riskAfter,
            'elasticity': item.elasticity,
            'reasonCodes': item.reasonCodes,
          },
          modifiedPayload: finalLimitAmount == null
              ? null
              : {'finalLimitAmount': finalLimitAmount},
          contextPayload: {'screen': 'statistics', 'riskLevel': item.riskLevel},
        ),
      );
      submittedFeedbackIds.add(item.recommendationId);
      AppHelperFunction.showSuccessSnackBar('Da ghi nhan phan hoi AI');
    } catch (e) {
      AppHelperFunction.showErrorSnackBar('Khong the gui phan hoi AI: $e');
    } finally {
      sendingFeedbackIds.remove(item.recommendationId);
    }
  }



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
        _loadFirstTransactionDate(id);
      } else {
        _clearData();
      }
    });

    final currentId = appController.userId.value;
    if (currentId != null) {
      refreshStatisticsData(currentId);
      _loadFirstTransactionDate(currentId);
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

  Future<void> _loadFirstTransactionDate(int userId) async {
    try {
      firstTransactionDate.value =
          await getFirstTransactionDateUseCase(userId);
    } catch (e) {
      debugPrint('Error loading first transaction date: $e');
    }
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
      debugPrint('Error loading global total by type: $e');
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
      debugPrint("Error loading monthly categories: $e");
    }
  }

  Future<void> _loadTotalByDate(int userId, TransactionTotalsDto dto) async {
    try {
      totalByDate.value = await getTotalByDateEntityUseCase(userId, dto);
    } catch (e) {
      rethrow;
    }
  }

  @override
  void onClose() {
    _refreshTimer?.cancel();
    _changeMonthDebounce?.cancel();
    super.onClose();
  }

  int _refreshCounter = 0;
  Timer? _refreshTimer;
  Completer<void>? _refreshCompleter;

  Future<void> refreshStatisticsData(
    int userId, {
    bool skipMainTotals = false,
  }) async {
    _refreshTimer?.cancel();

    if (totalByDate.value == null) {
      isLoading.value = true;
    } else {
      isSilentLoading.value = true;
    }

    if (_refreshCompleter == null || _refreshCompleter!.isCompleted) {
      _refreshCompleter = Completer<void>();
    }

    final currentCompleter = _refreshCompleter!;

    _refreshTimer = Timer(const Duration(milliseconds: 50), () async {
      try {
        await _executeRefreshStatisticsData(userId, skipMainTotals: skipMainTotals);
        if (!currentCompleter.isCompleted) {
          currentCompleter.complete();
        }
      } catch (e) {
        if (!currentCompleter.isCompleted) {
          currentCompleter.completeError(e);
        }
      }
    });

    return currentCompleter.future;
  }

  Future<void> _executeRefreshStatisticsData(
    int userId, {
    bool skipMainTotals = false,
  }) async {
    final int currentRefresh = ++_refreshCounter;

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
            _loadTotalByDate(userId, dtoRange),
          ]);
        }

        futures.addAll([
          _loadMonthlyCategories(userId),
          _loadPreviousTotalByType(userId),
          _loadStatisticsSummary(userId),
          if (Get.isRegistered<SpendingPlanController>())
            Get.find<SpendingPlanController>().loadStatsSummary(
              month: currentStartDate.month,
              year: currentStartDate.year,
            ),
        ]);

        final activeGoalId = savingGoalController.goalId.value;
        if (activeGoalId > 0) {
          futures.addAll([
            savingGoalController.loadGoalReport(activeGoalId),
            savingGoalController.loadGoalPrediction(activeGoalId),
          ]);
        }

        // Run AI forecasting in background asynchronously to prevent blocking the main UI loading state
        loadFinancialAnalytics();
        _loadHabitCommitments();

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
          if (Get.isRegistered<SpendingPlanController>())
            Get.find<SpendingPlanController>().loadStatsSummary(
              month: currentStartDate.month,
              year: currentStartDate.year,
            ),
        ]);

        final activeGoalId = savingGoalController.goalId.value;
        if (activeGoalId > 0) {
          futures.addAll([
            savingGoalController.loadGoalReport(activeGoalId),
            savingGoalController.loadGoalPrediction(activeGoalId),
          ]);
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
      debugPrint("Error loading hourly data: $e");
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
      if (!canGoNextMonth) return;
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
      if (!canGoPreviousMonth) return;
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

  // ── Month sync cho đồng bộ giữa các màn hình ────────

  Timer? _changeMonthDebounce;

  /// Chuyển tháng có debounce để tránh lag khi user bấm nhanh.
  /// Dùng bởi các màn hình cần chuyển tháng (Lịch sử GD, etc.).
  void changeMonth(DateTime newMonth) {
    selectedMonth.value = DateTime(newMonth.year, newMonth.month, 1);
  }

  int getSelectedDayForMonth(DateTime month) {
    final today = DateTime.now();
    return (month.year == today.year && month.month == today.month)
        ? today.day
        : 1;
  }


  /// Trả về date range (start, end) cho 1 tháng + label.
  ({DateTime start, DateTime end, String label}) getMonthDateRange(
    DateTime month,
  ) {
    return (
      start: DateTime(month.year, month.month, 1),
      end: DateTime(month.year, month.month + 1, 0),
      label: '${month.year}/${month.month.toString().padLeft(2, '0')}',
    );
  }

  Future<void> _loadStatisticsSummary(int userId) async {
    try {
      statisticsSummary.value = await getStatisticsSummaryUseCase(userId);
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

    return TransactionTotalsDto(
      startDate: start.toUtc().toIso8601String(),
      endDate: end.toUtc().toIso8601String(),
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
        "${d.date.toLocal().year}-${d.date.toLocal().month}-${d.date.toLocal().day}":
            d.total,
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
        "${d.date.toLocal().year}-${d.date.toLocal().month}-${d.date.toLocal().day}":
            d.total.toDouble(),
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

    WidgetService.updateHomeWidget(
      balance: isVisible ? balance : null,
      monthlyExpense: isVisible ? expense : null,
      remainingBudget: null,
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

    for (var t in expense) {
      if (t.category == null || t.category!.id == null) continue;
      final int id = t.category!.id!;
      final existing = expCatMap[id];
      if (existing == null) {
        expCatMap[id] = TotalByCategoryEntity(
          categoryId: id,
          categoryName: t.category!.name,
          categoryIcon: t.category!.icon,
          total: t.amount.toInt(),
          spendingPercentage: 0,
          isEssential: t.category!.isEssential,
        );
      } else {
        expCatMap[id] = TotalByCategoryEntity(
          categoryId: id,
          categoryName: existing.categoryName,
          categoryIcon: existing.categoryIcon,
          total: existing.total + t.amount.toInt(),
          spendingPercentage: existing.spendingPercentage,
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
          categoryIcon: t.category!.icon,
          total: t.amount.toInt(),
          spendingPercentage: 0,
          isEssential: t.category!.isEssential,
        );
      } else {
        incCatMap[id] = TotalByCategoryEntity(
          categoryId: id,
          categoryName: existing.categoryName,
          categoryIcon: existing.categoryIcon,
          total: existing.total + t.amount.toInt(),
          spendingPercentage: existing.spendingPercentage,
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
