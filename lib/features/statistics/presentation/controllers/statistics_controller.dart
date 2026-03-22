import 'package:get/get.dart';
import 'package:money_care/features/saving_fund/presentation/controllers/saving_fund_controller.dart';
import 'package:money_care/features/transaction/data/models/transaction_model.dart';
import 'package:money_care/features/transaction/domain/entities/transaction_entity.dart';
import 'package:money_care/features/transaction/domain/usecases/usecases.dart';

class StatisticsController extends GetxController {
  final GetTotalByTypeUseCase getTotalByTypeUseCase;
  final GetTotalByCateUseCase getTotalByCateUseCase;
  final GetTotalByDateEntityUseCase getTotalByDateEntityUseCase;

  final SavingFundController fundController = Get.find<SavingFundController>();

  var totalByType = Rxn<TotalByTypeEntity>();
  RxList<TotalByCategoryEntity> totalByCate = <TotalByCategoryEntity>[].obs;

  var totalByDate = Rxn<TotalsByDateEntity>();
  var totalByDateLstMonth = Rxn<TotalsByDateEntity>();

  var isLoading = false.obs;
  var errorMessage = RxnString();

  final now = DateTime.now();
  late DateTime monthStartDate = DateTime(now.year, now.month, 1);
  late DateTime monthEndDate = DateTime(now.year, now.month + 1, 0);
  DateTime get weekStartDate => now.subtract(const Duration(days: 6));
  DateTime get weekEndDate => now;

  StatisticsController({
    required this.getTotalByTypeUseCase,
    required this.getTotalByCateUseCase,
    required this.getTotalByDateEntityUseCase,
  });

  Future<void> getTotalByType(int userId) async {
    isLoading.value = true;
    try {
      final dto = _createTotalsDto(monthStartDate, monthEndDate);
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
    isLoading.value = true;
    try {
      final dto = _createTotalsDto(lastMonth7DaysStart, lastMonthToday);
      totalByDateLstMonth.value = await getTotalByDateEntityUseCase(
        userId,
        dto,
      );
      errorMessage.value = null;
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
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
        _loadTotalByDate(userId, totalsDto),
      ]);

      errorMessage.value = null;
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _loadTotalByType(int userId) async {
    try {
      final dto = _createTotalsDto(monthStartDate, monthEndDate);
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

  Future<void> _loadTotalByDate(int userId, TransactionTotalsDto dto) async {
    try {
      totalByDate.value = await getTotalByDateEntityUseCase(userId, dto);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> refreshStatisticsData(int userId) async {
    final dtoWeek = _createTotalsDto(weekStartDate, weekEndDate);

    await Future.wait([
      getTotalByType(userId),
      getTotalByCate(userId),
      getTotalByDateEntity(userId, dtoWeek),
      getTotalByDateEntityLstMonth(userId),
    ]);
  }

  int? get _currentFundIdOrNull =>
      fundController.currentFundId > 0 ? fundController.currentFundId : null;

  TransactionTotalsDto _createTotalsDto(DateTime start, DateTime end) {
    return TransactionTotalsDto(
      fundId: _currentFundIdOrNull,
      startDate: start.toIso8601String(),
      endDate: end.toIso8601String(),
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

  double get dailyAverage =>
      calculateDailyAverage(totalByDate.value?.expense ?? [], now);

  double get lastWeekDailyAverage => calculateDailyAverage(
    totalByDateLstMonth.value?.expense ?? [],
    lastMonthToday,
  );

  double get dailyAverageChange =>
      calculatePercentageChange(dailyAverage, lastWeekDailyAverage);

  double get dailyIncomeAverage =>
      calculateDailyAverage(totalByDate.value?.income ?? [], now);

  double get lastWeekDailyIncomeAverage => calculateDailyAverage(
    totalByDateLstMonth.value?.income ?? [],
    lastMonthToday,
  );

  double get dailyIncomeChange =>
      calculatePercentageChange(dailyIncomeAverage, lastWeekDailyIncomeAverage);
}
