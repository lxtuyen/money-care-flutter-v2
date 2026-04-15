import 'package:fl_chart/fl_chart.dart';
import 'package:get/get.dart';
import 'package:money_care/app/controllers/fund_controller.dart';
import 'package:money_care/features/transaction/data/models/transaction_model.dart';
import 'package:money_care/app/controllers/app_controller.dart';
import 'package:money_care/features/transaction/domain/entities/ai_insight_entity.dart';
import 'package:money_care/features/transaction/domain/entities/entities.dart';
import 'package:money_care/features/transaction/domain/usecases/usecases.dart';
import 'package:money_care/app/controllers/transaction_controller.dart';

class StatisticsController extends GetxController {
  final GetTotalByTypeUseCase getTotalByTypeUseCase;
  final GetTotalByCateUseCase getTotalByCateUseCase;
  final GetTotalByDateEntityUseCase getTotalByDateEntityUseCase;
  final GetStatisticsSummaryUseCase getStatisticsSummaryUseCase;
  final GetFinancialInsightsUseCase getFinancialInsightsUseCase;

  FundController get fundController => Get.find<FundController>();

  var totalByType = Rxn<TotalByTypeEntity>();
  RxList<TotalByCategoryEntity> totalByCate = <TotalByCategoryEntity>[].obs;
  RxList<TotalByCategoryEntity> expenseCategories = <TotalByCategoryEntity>[].obs;
  RxList<TotalByCategoryEntity> incomeCategories = <TotalByCategoryEntity>[].obs;

  var totalByDate = Rxn<TotalsByDateEntity>();
  var totalByDateLstMonth = Rxn<TotalsByDateEntity>();
  var statisticsSummary = Rxn<StatisticsSummaryEntity>();
  var aiInsight = Rxn<AiInsightEntity>();

  // Processed data for charts
  RxList<FlSpot> chartSpots = <FlSpot>[].obs;
  RxList<String> chartLabels = <String>[].obs;
  var isSilentLoading = false.obs;

  double get totalBudget => expenseCategories.fold(0.0, (sum, cat) => sum + cat.limit);

  double get utilizationPercentage {
    if (totalBudget <= 0) return 0.0;
    final spent = totalByType.value?.expenseTotal.toDouble() ?? 0.0;
    return spent / totalBudget;
  }

  final RxString selectedType = 'chi'.obs;

  final RxString periodType = 'hàng tháng'.obs; // 'hàng tháng' or 'hàng ngày'
  final Rx<DateTime> selectedMonth = DateTime(DateTime.now().year, DateTime.now().month, 1).obs;
  final Rx<DateTime> selectedDay = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day).obs;

  DateTime get monthStartDate => DateTime(selectedMonth.value.year, selectedMonth.value.month, 1);
  DateTime get monthEndDate => DateTime(selectedMonth.value.year, selectedMonth.value.month + 1, 0);

  DateTime get currentStartDate => periodType.value == 'hàng tháng' ? monthStartDate : selectedDay.value;
  DateTime get currentEndDate => periodType.value == 'hàng tháng' ? monthEndDate : selectedDay.value;

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
    required this.getFinancialInsightsUseCase,
  });

  @override
  void onInit() {
    super.onInit();
    final appController = Get.find<AppController>();
    
    // Lắng nghe sự thay đổi của userId để tải lại dữ liệu
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

    // Lắng nghe thay đổi thời gian
    everAll([selectedMonth, selectedDay, periodType, selectedType], (_) {
      final id = appController.userId.value;
      if (id != null) refreshStatisticsData(id);
    });
  }

  void _clearData() {
    totalByType.value = null;
    totalByCate.clear();
    expenseCategories.clear();
    incomeCategories.clear();
    totalByDate.value = null;
    totalByDateLstMonth.value = null;
    statisticsSummary.value = null;
    aiInsight.value = null;
  }

  Future<void> getTotalByType(int userId,
      {DateTime? startDate, DateTime? endDate}) async {
    isLoading.value = true;
    try {
      final dto =
          _createTotalsDto(startDate ?? monthStartDate, endDate ?? monthEndDate);
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
      final dto = _createTotalsDto(monthStartDate, monthEndDate);
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
        fundId: _currentFundIdOrNull,
        startDate: startDate.toIso8601String(),
        endDate: endDate.toIso8601String(),
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

  Future<void> _loadTotalByType(int userId,
      {DateTime? startDate, DateTime? endDate}) async {
    try {
      final dto = _createTotalsDto(
          startDate ?? monthStartDate, endDate ?? monthEndDate);
      totalByType.value = await getTotalByTypeUseCase(userId, dto);
    } catch (e) {
      totalByType.value = null;
      rethrow;
    }
  }

  Future<void> _loadTotalByCate(int userId) async {
    try {
      final dto = _createTotalsDto(monthStartDate, monthEndDate);
      final list = await getTotalByCateUseCase(userId, dto);
      totalByCate.assignAll(list);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> _loadMonthlyCategories(int userId) async {
    try {
      final expenseDto = TransactionTotalsDto(
        fundId: _currentFundIdOrNull,
        startDate: monthStartDate.toIso8601String(),
        endDate: monthEndDate.toIso8601String(),
        type: 'expense',
      );
      final incomeDto = TransactionTotalsDto(
        fundId: _currentFundIdOrNull,
        startDate: monthStartDate.toIso8601String(),
        endDate: monthEndDate.toIso8601String(),
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

  bool _isRefreshing = false;

  Future<void> refreshStatisticsData(int userId) async {
    if (_isRefreshing) return;
    
    _isRefreshing = true;
    // Only show full loading if it's the first time or if data is null
    if (totalByDate.value == null) {
      isLoading.value = true;
    } else {
      isSilentLoading.value = true;
    }

    try {
      final dtoRange = _createTotalsDto(currentStartDate, currentEndDate);

      if (periodType.value == 'hàng tháng') {
        await Future.wait([
          _loadTotalByType(userId, startDate: currentStartDate, endDate: currentEndDate),
          _loadTotalByCate(userId),
          _loadMonthlyCategories(userId),
          _loadTotalByDate(userId, dtoRange),
          _loadStatisticsSummary(userId),
          _loadFinancialInsights(userId),
        ]);
        _processMonthlyData();
      } else {
        // Daily Hourly View
        await Future.wait([
          _loadTotalByType(userId, startDate: currentStartDate, endDate: currentEndDate),
          _loadTotalByCate(userId),
          _loadDailyHourlyData(userId),
          _loadStatisticsSummary(userId),
          _loadFinancialInsights(userId),
        ]);
      }
      errorMessage.value = null;
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
      isSilentLoading.value = false;
      _isRefreshing = false;
    }
  }

  Future<void> _loadDailyHourlyData(int userId) async {
    try {
      final filterDto = TransactionFilterDto(
        startDate: currentStartDate.toIso8601String(),
        endDate: currentEndDate.toIso8601String(),
        fundId: _currentFundIdOrNull,
      );

      final result = await Get.find<TransactionController>().filterTransactionsUseCase(userId, filterDto);
      
      final transactions = selectedType.value == 'chi' ? result.expenseTransactions : result.incomeTransactions;
      
      // Initialize with 24 hours
      final List<double> hourlyTotals = List.filled(24, 0.0);
      for (var t in transactions) {
        final hour = t.transactionDate?.hour ?? 0;
        hourlyTotals[hour] += t.amount.toDouble();
      }

      chartSpots.assignAll(
        hourlyTotals.asMap().entries.map((e) => FlSpot(e.key.toDouble(), e.value)).toList()
      );
      
      chartLabels.assignAll(
        List.generate(24, (i) => i % 4 == 0 ? "${i.toString().padLeft(2, '0')}:00" : "")
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
      for (var d in data) d.date.day: d.total.toDouble(),
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
      selectedMonth.value = DateTime(selectedMonth.value.year, selectedMonth.value.month + 1, 1);
    } else {
      selectedDay.value = selectedDay.value.add(const Duration(days: 1));
    }
  }

  void previousPeriod() {
    if (periodType.value == 'hàng tháng') {
      selectedMonth.value = DateTime(selectedMonth.value.year, selectedMonth.value.month - 1, 1);
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
      final dto = _createTotalsDto(monthStartDate, monthEndDate);
      statisticsSummary.value = await getStatisticsSummaryUseCase(userId, dto);
    } catch (e) {
      statisticsSummary.value = null;
    }
  }

  Future<void> _loadFinancialInsights(int userId) async {
    try {
      aiInsight.value = await getFinancialInsightsUseCase(
        userId,
        fundId: _currentFundIdOrNull,
        period: 'last_30_days',
      );
    } catch (e) {
      aiInsight.value = null;
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

  int? get _currentFundIdOrNull =>
      fundController.currentFundId > 0 ? fundController.currentFundId : null;

  TransactionTotalsDto _createTotalsDto(DateTime start, DateTime end) {
    final backendType = selectedType.value == 'chi' ? 'expense' : 'income';
    return TransactionTotalsDto(
      fundId: _currentFundIdOrNull,
      startDate: start.toIso8601String(),
      endDate: end.toIso8601String(),
      type: backendType,
    );
  }

  DateTime get lastMonthToday {
    int month = now.month - 1;
    int year = month == 0 ? now.year - 1 : now.year;
    month = month == 0 ? 12 : month;
    final lastDayOfPreviousMonth = DateTime(year, month + 1, 0).day;
    final day =
        now.day > lastDayOfPreviousMonth ? lastDayOfPreviousMonth : now.day;
    return DateTime(year, month, day);
  }

  DateTime get lastMonth7DaysStart =>
      lastMonthToday.subtract(const Duration(days: 6));

  double calculateDailyAverage(List<TotalByDateEntity> list, DateTime endDate) {
    final Map<String, int> map = {
      for (var d in list)
        "${d.date.year}-${d.date.month}-${d.date.day}": d.total,
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

  List<FlSpot> convertToSpots7Days(List<TotalByDateEntity> data, DateTime endDate) {
    final Map<String, double> map = {
      for (var d in data)
        "${d.date.year}-${d.date.month}-${d.date.day}": d.total.toDouble(),
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

}
