import 'package:get/get.dart';

class FilterController extends GetxController {
  static const String defaultDateLabel = 'Tháng này';

  var categoryId = RxnInt();
  var walletId = RxnInt();
  var startDate = Rxn<DateTime>();
  var endDate = Rxn<DateTime>();
  var keyword = ''.obs;
  var dateLabel = defaultDateLabel.obs;

  @override
  void onInit() {
    super.onInit();
    _setDefaultMonthRange();
  }

  void updateCategory(int? id) => categoryId.value = id;

  void updateWallet(int? id) => walletId.value = id;

  void updateDateRange(DateTime? start, DateTime? end, {String? label}) {
    startDate.value = start;
    endDate.value = end;
    if (label != null) {
      dateLabel.value = label;
    }
  }

  void setGoalRange(DateTime start, DateTime end, String goalName) {
    startDate.value = start;
    endDate.value = end;
    dateLabel.value = 'Mục tiêu: $goalName';
  }

  void updateKeyword(String value) => keyword.value = value;

  bool get hasKeyword => keyword.value.trim().isNotEmpty;
  bool get hasCategory => categoryId.value != null;
  bool get hasWallet => walletId.value != null;
  bool get hasDateFilter =>
      dateLabel.value != defaultDateLabel ||
      !_isCurrentMonthRange(startDate.value, endDate.value);
  bool get hasActiveFilters =>
      hasKeyword || hasCategory || hasWallet || hasDateFilter;
  int get activeFilterCount =>
      (hasKeyword ? 1 : 0) +
      (hasCategory ? 1 : 0) +
      (hasWallet ? 1 : 0) +
      (hasDateFilter ? 1 : 0);

  void clearAll() {
    categoryId.value = null;
    walletId.value = null;
    keyword.value = '';
    _setDefaultMonthRange();
  }

  void _setDefaultMonthRange() {
    startDate.value = null;
    endDate.value = null;
    dateLabel.value = defaultDateLabel;
  }

  bool _isCurrentMonthRange(DateTime? start, DateTime? end) {
    if (start == null && end == null) return true;
    if (start == null || end == null) return false;

    final now = DateTime.now();
    final monthStart = DateTime(now.year, now.month, 1);
    final nextMonthStart = DateTime(now.year, now.month + 1, 1);

    // Check if start is first day of current month
    final isStartMatch =
        start.year == monthStart.year &&
        start.month == monthStart.month &&
        start.day == 1;

    // Check if end is within the current month (same month and year)
    final isEndMatch = end.year == now.year && end.month == now.month;

    return isStartMatch && isEndMatch;
  }
}

final filterController = FilterController();
