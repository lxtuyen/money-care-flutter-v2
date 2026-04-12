import 'package:money_care/app/controllers/statistics_controller.dart';
import 'package:money_care/features/transaction/data/models/transaction_model.dart';
import 'package:get/get.dart';
import 'package:money_care/app/controllers/fund_controller.dart';
import 'package:money_care/features/transaction/domain/entities/transaction_entity.dart';
import 'package:money_care/features/transaction/domain/usecases/usecases.dart';
import 'package:money_care/features/gamification/presentation/controllers/gamification_controller.dart';
import 'package:money_care/app/controllers/app_controller.dart';
import 'package:money_care/features/transaction/presentation/controllers/filter_controller.dart';

class TransactionController extends GetxController {
  final FilterTransactionsUseCase filterTransactionsUseCase;
  final CreateTransactionUseCase createTransactionUseCase;
  final UpdateTransactionUseCase updateTransactionUseCase;
  final DeleteTransactionUseCase deleteTransactionUseCase;

  final FundController fundController = Get.find<FundController>();

  var transactionByfilter = Rxn<TransactionByTypeEntity>();

  var isLoading = false.obs;
  var errorMessage = RxnString();

  final RxInt transactionChangedCount = 0.obs;

  final now = DateTime.now();
  late DateTime monthStartDate = DateTime(now.year, now.month, 1);
  late DateTime monthEndDate = DateTime(now.year, now.month + 1, 0);
  DateTime get weekStartDate => now.subtract(const Duration(days: 6));
  DateTime get weekEndDate => now;

  TransactionFilterDto? _lastFilter;

  TransactionController({
    required this.filterTransactionsUseCase,
    required this.createTransactionUseCase,
    required this.updateTransactionUseCase,
    required this.deleteTransactionUseCase,
  });

  @override
  void onInit() {
    super.onInit();
    
    ever(fundController.fundId, (int id) {
      final userId = Get.find<AppController>().userId.value;
      if (userId != null && id > 0) {
        refreshAllData(userId);
      }
    });

    ever(Get.find<AppController>().userId, (int? userId) {
      if (userId != null) {
        refreshAllData(userId);
      }
    });
  }

  Future<void> createTransaction(TransactionCreateDto dto) async {
    isLoading.value = true;
    try {
      await createTransactionUseCase(dto);
      await refreshAllData(dto.userId!);
      
      if (Get.isRegistered<GamificationController>()) {
        Future.delayed(const Duration(milliseconds: 300), () {
          Get.find<GamificationController>().recordDailyTransaction();
        });
      }
      
      errorMessage.value = null;
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
      transactionByfilter.value = await filterTransactionsUseCase(userId, dto);
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
    final filterDto = _lastFilter ?? TransactionFilterDto(
      fundId: _currentFundIdOrNull,
      startDate: weekStartDate.toIso8601String(),
      endDate: weekEndDate.toIso8601String(),
    );

    await filterTransactions(userId, filterDto);

    if (Get.isRegistered<StatisticsController>()) {
      await Get.find<StatisticsController>().refreshStatisticsData(userId);
    }

    transactionChangedCount.value++;
  }

  Future<void> applyFilters(int userId) async {
    final filterController = Get.find<FilterController>();
    
    final dto = TransactionFilterDto(
      categoryId: filterController.categoryId.value,
      fundId: _currentFundIdOrNull,
      startDate: filterController.startDate.value?.toIso8601String(),
      endDate: filterController.endDate.value?.toIso8601String(),
    );

    await filterTransactions(userId, dto);
    
    if (Get.isRegistered<StatisticsController>()) {
      await Get.find<StatisticsController>().getTotalByType(
        userId,
        startDate: filterController.startDate.value,
        endDate: filterController.endDate.value,
      );
    }
  }

  int? get _currentFundIdOrNull =>
      fundController.currentFundId > 0 ? fundController.currentFundId : null;
}
