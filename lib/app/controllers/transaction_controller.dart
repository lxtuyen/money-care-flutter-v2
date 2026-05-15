import 'package:money_care/features/transaction/data/models/transaction_model.dart';
import 'package:get/get.dart';
import 'package:money_care/core/utils/helper/helper_functions.dart';
import 'package:money_care/app/controllers/saving_goal_controller.dart';
import 'package:money_care/features/transaction/domain/entities/transaction_entity.dart';
import 'package:money_care/features/transaction/domain/usecases/usecases.dart';
import 'package:money_care/features/gamification/presentation/controllers/gamification_controller.dart';
import 'package:money_care/app/controllers/app_controller.dart';
import 'package:money_care/features/transaction/presentation/controllers/filter_controller.dart';
import 'package:money_care/features/wallet/presentation/controllers/wallet_controller.dart';
import 'package:money_care/app/controllers/statistics_controller.dart';

class TransactionController extends GetxController {
  final FilterTransactionsUseCase filterTransactionsUseCase;
  final CreateTransactionUseCase createTransactionUseCase;
  final UpdateTransactionUseCase updateTransactionUseCase;
  final DeleteTransactionUseCase deleteTransactionUseCase;
  final ExportReportUseCase exportReportUseCase;

  final SavingGoalController savingGoalController =
      Get.find<SavingGoalController>();

  var transactionByfilter = Rxn<TransactionByTypeEntity>();
  var recentTransactions = Rxn<TransactionByTypeEntity>();

  var isLoading = false.obs;
  var isRecentLoading = false.obs;
  var errorMessage = RxnString();

  final RxInt transactionChangedCount = 0.obs;

  List<TransactionEntity> get allTransactions {
    final data = transactionByfilter.value;
    if (data == null) return [];
    return [...data.incomeTransactions, ...data.expenseTransactions];
  }

  final now = DateTime.now();
  late DateTime monthStartDate = DateTime(now.year, now.month, 1);
  late DateTime monthEndDate = DateTime(now.year, now.month + 1, 0);

  TransactionFilterDto? _lastFilter;

  TransactionController({
    required this.filterTransactionsUseCase,
    required this.createTransactionUseCase,
    required this.updateTransactionUseCase,
    required this.deleteTransactionUseCase,
    required this.exportReportUseCase,
  });

  @override
  void onInit() {
    super.onInit();

    ever(savingGoalController.goalId, (int id) {
      final userId = Get.find<AppController>().userId.value;
      if (userId != null) {
        recentTransactions.value = null;
        transactionByfilter.value = null;
        refreshAllData(userId);
      }
    });

    ever(Get.find<AppController>().userId, (int? userId) {
      if (userId != null) {
        refreshAllData(userId);
      }
    });
  }

  Future<TransactionEntity> createTransaction(TransactionCreateDto dto) async {
    isLoading.value = true;
    try {
      final transaction = await createTransactionUseCase(dto);
      await refreshAllData(dto.userId!);

      if (Get.isRegistered<GamificationController>()) {
        Future.delayed(const Duration(milliseconds: 300), () {
          Get.find<GamificationController>().recordDailyTransaction();
        });
      }

      errorMessage.value = null;
      return transaction;
    } catch (e) {
      errorMessage.value = e.toString();
      rethrow;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateTransaction(TransactionCreateDto dto, int id) async {
    isLoading.value = true;
    try {
      await updateTransactionUseCase(dto, id);
      await refreshAllData(dto.userId!);
      errorMessage.value = null;
    } catch (e) {
      errorMessage.value = e.toString();
      rethrow;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteTransaction(int id, int userId) async {
    isLoading.value = true;
    try {
      await deleteTransactionUseCase(id);
      await refreshAllData(userId);
      errorMessage.value = null;
    } catch (e) {
      errorMessage.value = e.toString();
      rethrow;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> filterTransactions(int userId, TransactionFilterDto dto) async {
    isLoading.value = true;
    _lastFilter = dto;
    try {
      final result = await filterTransactionsUseCase(userId, dto);
      transactionByfilter.value = result;

      // REUSE: Derive recent transactions from the filtered result (top 5)
      final allIncome = result.incomeTransactions;
      final allExpense = result.expenseTransactions;

      // Sort both by date DESC
      final sortedIncome = [...allIncome]..sort((a, b) =>
          (b.transactionDate ?? DateTime.now())
              .compareTo(a.transactionDate ?? DateTime.now()));
      final sortedExpense = [...allExpense]..sort((a, b) =>
          (b.transactionDate ?? DateTime.now())
              .compareTo(a.transactionDate ?? DateTime.now()));

      recentTransactions.value = TransactionByTypeEntity(
        incomeTransactions: sortedIncome.take(5).toList(),
        expenseTransactions: sortedExpense.take(5).toList(),
      );

      // REUSE: Update statistics locally from this list
      if (Get.isRegistered<StatisticsController>()) {
        Get.find<StatisticsController>().updateStatsFromTransactions(result);
      }

      errorMessage.value = null;
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadTransactionScreenData(
    int userId,
    TransactionFilterDto filterDto,
  ) async {
    await filterTransactions(userId, filterDto);
  }
  Future<void> refreshAllData(int userId) async {
    await applyFilters(userId);

    if (Get.isRegistered<WalletController>()) {
      Get.find<WalletController>().refreshWallets();
    }
    if (Get.isRegistered<StatisticsController>()) {
      Get.find<StatisticsController>().refreshStatisticsData(userId, skipMainTotals: true);
    }
    final activeGoalId = savingGoalController.goalId.value;
    if (activeGoalId > 0) {
      savingGoalController.loadGoalReport(activeGoalId);
    }

    transactionChangedCount.value++;
  }

  Future<void> applyFilters(int userId) async {
    final filterController = Get.find<FilterController>();

    final rawStart = filterController.startDate.value;
    final rawEnd = filterController.endDate.value;

    final dto = TransactionFilterDto(
      categoryId: filterController.categoryId.value,
      walletId: filterController.walletId.value,
      startDate: rawStart != null
          ? _getStartOfDay(rawStart).toUtc().toIso8601String()
          : null,
      endDate: rawEnd != null
          ? _getEndOfDay(rawEnd).toUtc().toIso8601String()
          : null,
    );

    await filterTransactions(userId, dto);
  }

  DateTime _getStartOfDay(DateTime date) {
    return DateTime(date.year, date.month, date.day, 0, 0, 0);
  }

  DateTime _getEndOfDay(DateTime date) {
    return DateTime(date.year, date.month, date.day, 23, 59, 59, 999);
  }

  Future<void> exportReport(int userId, TransactionFilterDto dto, String format) async {
    isLoading.value = true;
    try {
      final success = await exportReportUseCase(userId, dto, format);
      if (success) {
        AppHelperFunction.showSuccessSnackBar(
          'Báo cáo đã được gửi về email của bạn!',
        );
      } else {
        throw Exception('Export failed');
      }
    } catch (e) {
      AppHelperFunction.showErrorSnackBar(
        'Không thể xuất báo cáo: $e',
      );
    } finally {
      isLoading.value = false;
    }
  }
}
