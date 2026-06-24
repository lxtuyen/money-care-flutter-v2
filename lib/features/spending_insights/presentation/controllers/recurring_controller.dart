import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:money_care/core/utils/helper/helper_functions.dart';
import 'package:money_care/features/spending_insights/domain/entities/recurring_transaction_entity.dart';
import 'package:money_care/features/spending_insights/domain/repositories/spending_insights_repository.dart';

class RecurringController extends GetxController {
  final SpendingInsightsRepository repository;

  RecurringController({required this.repository});

  // Detected items (from AI)
  final isLoading = false.obs;
  final isRefreshing = false.obs; // force refresh — giữ data cũ, chỉ hiện indicator nhỏ
  final hasError = false.obs;
  final errorMessage = ''.obs;
  final result = Rxn<RecurringDetectResult>();
  final lastScannedAt = Rxn<String>();

  // Confirmed items (from DB)
  final isLoadingConfirmed = false.obs;
  final confirmedItems = <RecurringTransactionEntity>[].obs;

  List<RecurringTransactionEntity> get recurringItems =>
      result.value?.recurringItems ?? [];

  double get totalMonthlyRecurring =>
      result.value?.totalMonthlyRecurring ?? 0.0;

  double get confirmedMonthlyTotal =>
      confirmedItems.fold(0.0, (sum, item) => sum + item.monthlyEstimate);

  int get itemCount => recurringItems.length;

  /// Top 3 khoản lớn nhất (cho summary card trong Statistics).
  List<RecurringTransactionEntity> get topItems {
    final sorted = [...recurringItems]
      ..sort((a, b) => b.monthlyEstimate.compareTo(a.monthlyEstimate));
    return sorted.take(3).toList();
  }

  /// Nhóm recurring items theo danh mục (cho pie chart).
  Map<String, double> get categoryBreakdown {
    final map = <String, double>{};
    for (final item in recurringItems) {
      final key = item.categoryName;
      map[key] = (map[key] ?? 0) + item.monthlyEstimate;
    }
    return map;
  }

  Future<void> fetchRecurring({int months = 6, bool forceRefresh = false}) async {
    // Nếu forceRefresh và đã có data → dùng isRefreshing thay vì isLoading
    final hasExistingData = result.value != null;
    if (forceRefresh && hasExistingData) {
      isRefreshing.value = true;
    } else {
      isLoading.value = true;
    }
    hasError.value = false;
    errorMessage.value = '';

    try {
      final data = await repository.getRecurringTransactions(
        months: months,
        forceRefresh: forceRefresh,
      );
      result.value = data;
      lastScannedAt.value = data.lastScannedAt;
    } catch (e) {
      // Chỉ hiện error state nếu chưa có data (lần đầu load)
      if (!hasExistingData) {
        hasError.value = true;
        errorMessage.value = e.toString();
      }
      debugPrint('RecurringController error: $e');
    } finally {
      isLoading.value = false;
      isRefreshing.value = false;
    }
  }

  Future<void> fetchConfirmed() async {
    isLoadingConfirmed.value = true;
    try {
      final items = await repository.getConfirmedRecurring();
      debugPrint('[RecurringController] fetchConfirmed: ${items.length} items');
      for (final item in items) {
        debugPrint('[RecurringController] confirmed: ${item.description} (${item.recurringId})');
      }
      confirmedItems.value = items;
    } catch (e, stack) {
      debugPrint('RecurringController fetchConfirmed error: $e\n$stack');
    } finally {
      isLoadingConfirmed.value = false;
    }
  }

  Future<void> confirmItem(RecurringTransactionEntity item) async {
    try {
      await repository.confirmRecurring(item);

      // Optimistic UI: move from detected → confirmed
      final current = result.value;
      if (current != null) {
        final updated = current.recurringItems
            .where((i) => i.recurringId != item.recurringId)
            .toList();
        result.value = RecurringDetectResult(
          recurringItems: updated,
          totalMonthlyRecurring:
              updated.fold(0.0, (s, i) => s + i.monthlyEstimate),
          scanMonths: current.scanMonths,
          transactionCount: current.transactionCount,
          lastScannedAt: current.lastScannedAt,
        );
      }
      confirmedItems.add(item);
    } catch (e) {
      AppHelperFunction.showErrorSnackBar('Không thể xác nhận: $e');
    }
  }

  Future<void> dismissItem(RecurringTransactionEntity item) async {
    try {
      await repository.dismissRecurring(item.recurringId);

      // Optimistic UI: remove from detected
      final current = result.value;
      if (current != null) {
        final updated = current.recurringItems
            .where((i) => i.recurringId != item.recurringId)
            .toList();
        result.value = RecurringDetectResult(
          recurringItems: updated,
          totalMonthlyRecurring:
              updated.fold(0.0, (s, i) => s + i.monthlyEstimate),
          scanMonths: current.scanMonths,
          transactionCount: current.transactionCount,
          lastScannedAt: current.lastScannedAt,
        );
      }
    } catch (e) {
      AppHelperFunction.showErrorSnackBar('Không thể bỏ qua: $e');
    }
  }

  Future<void> refreshData() => Future.wait([
        fetchRecurring(),
        fetchConfirmed(),
      ]);

  Future<void> updateConfirmed(
    RecurringTransactionEntity item,
    Map<String, dynamic> updates,
  ) async {
    if (item.confirmedId == null) return;
    try {
      await repository.updateConfirmedRecurring(item.confirmedId!, updates);
      // Reload from server to get updated data
      await fetchConfirmed();
    } catch (e) {
      AppHelperFunction.showErrorSnackBar('Không thể cập nhật: $e');
    }
  }

  Future<void> deleteConfirmed(RecurringTransactionEntity item) async {
    if (item.confirmedId == null) return;
    try {
      await repository.deleteConfirmedRecurring(item.confirmedId!);
      // Optimistic UI: remove from list
      confirmedItems.removeWhere((i) => i.confirmedId == item.confirmedId);
    } catch (e) {
      AppHelperFunction.showErrorSnackBar('Không thể xóa: $e');
    }
  }
}
