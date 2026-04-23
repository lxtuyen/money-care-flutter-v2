import 'package:flutter/material.dart';
import 'package:money_care/app/controllers/statistics_controller.dart';
import 'package:money_care/features/transaction/data/models/transaction_model.dart';
import 'package:get/get.dart';
import 'package:money_care/app/controllers/saving_goal_controller.dart';
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

  final SavingGoalController savingGoalController =
      Get.find<SavingGoalController>();

  var transactionByfilter = Rxn<TransactionByTypeEntity>();
  var recentTransactions = Rxn<TransactionByTypeEntity>();

  var isLoading = false.obs;
  var isRecentLoading = false.obs;
  var errorMessage = RxnString();

  final RxInt transactionChangedCount = 0.obs;

  final now = DateTime.now();
  late DateTime monthStartDate = DateTime(now.year, now.month, 1);
  late DateTime monthEndDate = DateTime(now.year, now.month + 1, 0);

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

    ever(savingGoalController.goalId, (int id) {
      final userId = Get.find<AppController>().userId.value;
      if (userId != null) {
        recentTransactions.value = null;
        transactionByfilter.value = null;

        final goal = savingGoalController.currentGoal.value;
        if (goal != null && goal.startDate != null && goal.endDate != null) {
          Get.find<FilterController>().setGoalRange(
            goal.startDate!,
            goal.endDate!,
            goal.name,
          );
        } else {
          Get.find<FilterController>().clearAll();
        }
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
    final currentGoal = savingGoalController.currentGoal.value;

    final rawStart = currentGoal?.startDate;
    final rawEnd = currentGoal?.endDate;
    final clampedStart = rawStart != null ? _clampToGoalStart(rawStart) : null;
    final clampedEnd = rawEnd != null ? _clampToGoalEnd(rawEnd) : null;

    final recentFilterDto = TransactionFilterDto(
      goalId: _currentGoalIdOrNull,
      startDate: clampedStart?.toIso8601String(),
      endDate: clampedEnd?.toIso8601String(),
      limit: 5,
    );

    isRecentLoading.value = true;
    try {
      final recentRes = await filterTransactionsUseCase(
        userId,
        recentFilterDto,
      );
      recentTransactions.value = recentRes;
    } catch (e) {
    } finally {
      isRecentLoading.value = false;
    }

    await applyFilters(userId);

    transactionChangedCount.value++;
  }

  Future<void> applyFilters(int userId) async {
    final filterController = Get.find<FilterController>();

    final rawStart = filterController.startDate.value;
    final rawEnd = filterController.endDate.value;

    final clampedStart = rawStart != null ? _clampToGoalStart(rawStart) : null;
    final clampedEnd = rawEnd != null ? _clampToGoalEnd(rawEnd) : null;

    final dto = TransactionFilterDto(
      categoryId: filterController.categoryId.value,
      goalId: _currentGoalIdOrNull,
      startDate: clampedStart?.toIso8601String(),
      endDate: clampedEnd?.toIso8601String(),
    );

    await filterTransactions(userId, dto);
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

  int? get _currentGoalIdOrNull => savingGoalController.goalId.value > 0
      ? savingGoalController.goalId.value
      : null;

  DateTime _clampToGoalRange(
    DateTime date,
    DateTime? goalStart,
    DateTime? goalEnd, {
    required bool isStart,
  }) {
    if (goalStart == null || goalEnd == null) return date;

    if (isStart) {
      return date.isBefore(goalStart) ? goalStart : date;
    } else {
      return date.isAfter(goalEnd) ? goalEnd : date;
    }
  }
}
