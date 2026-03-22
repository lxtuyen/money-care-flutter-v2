import 'package:money_care/features/transaction/data/models/transaction_model.dart';
import 'package:get/get.dart';
import 'package:money_care/features/saving_fund/presentation/controllers/saving_fund_controller.dart';
import 'package:money_care/features/transaction/domain/entities/transaction_entity.dart';
import 'package:money_care/features/transaction/domain/usecases/usecases.dart';

class TransactionController extends GetxController {
  final FilterTransactionsUseCase filterTransactionsUseCase;
  final GetTotalByTypeUseCase getTotalByTypeUseCase;
  final GetTotalByCateUseCase getTotalByCateUseCase;
  final GetTotalByDateEntityUseCase getTotalByDateEntityUseCase;
  final CreateTransactionUseCase createTransactionUseCase;
  final UpdateTransactionUseCase updateTransactionUseCase;
  final DeleteTransactionUseCase deleteTransactionUseCase;

  final SavingFundController fundController = Get.find<SavingFundController>();

  var totalByType = Rxn<TotalByTypeEntity>();
  var transactionByfilter = Rxn<TransactionByTypeEntity>();
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

  TransactionController({
    required this.filterTransactionsUseCase,
    required this.getTotalByTypeUseCase,
    required this.getTotalByCateUseCase,
    required this.getTotalByDateEntityUseCase,
    required this.createTransactionUseCase,
    required this.updateTransactionUseCase,
    required this.deleteTransactionUseCase,
  });

  Future<void> createTransaction(TransactionCreateDto dto) async {
    try {
      await createTransactionUseCase(dto);
      await refreshAllData(dto.userId!);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateTransaction(TransactionCreateDto dto, int id) async {
    try {
      await updateTransactionUseCase(dto, id);
      await refreshAllData(dto.userId!);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteTransaction(int id, int userId) async {
    try {
      await deleteTransactionUseCase(id);
      await refreshAllData(userId);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> filterTransactions(int userId, TransactionFilterDto dto) async {
    isLoading.value = true;
    try {
      transactionByfilter.value = await filterTransactionsUseCase(userId, dto);
      errorMessage.value = null;
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

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

  Future<void> getTotalByDateEntity(int userId, TransactionTotalsDto dto) async {
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
      totalByDateLstMonth.value = await getTotalByDateEntityUseCase(userId, dto);
      errorMessage.value = null;
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> refreshAllData(int userId) async {
    final dtoWeek = _createTotalsDto(weekStartDate, weekEndDate);
    final filterDto = TransactionFilterDto(
      fundId: fundController.currentFundId > 0
          ? fundController.currentFundId
          : null,
      startDate: weekStartDate.toIso8601String(),
      endDate: weekEndDate.toIso8601String(),
    );

    await getTotalByType(userId);
    await getTotalByCate(userId);
    await getTotalByDateEntity(userId, dtoWeek);
    await getTotalByDateEntityLstMonth(userId);
    await filterTransactions(userId, filterDto);
  }

  TransactionTotalsDto _createTotalsDto(DateTime start, DateTime end) {
    return TransactionTotalsDto(
      fundId: fundController.currentFundId > 0
          ? fundController.currentFundId
          : null,
      startDate: start.toIso8601String(),
      endDate: end.toIso8601String(),
    );
  }

  DateTime get lastMonthToday {
    int month = now.month - 1;
    int year = month == 0 ? now.year - 1 : now.year;
    month = month == 0 ? 12 : month;
    final lastDayOfPreviousMonth = DateTime(year, month + 1, 0).day;
    final day = now.day > lastDayOfPreviousMonth ? lastDayOfPreviousMonth : now.day;
    return DateTime(year, month, day);
  }

  DateTime get lastMonth7DaysStart =>
      lastMonthToday.subtract(const Duration(days: 6));

  double calculateDailyAverage(List<TotalByDateEntity> list, DateTime endDate) {
    final Map<String, int> map = {
      for (var d in list) "${d.date.year}-${d.date.month}-${d.date.day}": d.total,
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

  double calculateMonthTotal(List<TotalByDateEntity> list) {
    return list.fold(0, (prev, element) => prev + element.total);
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
