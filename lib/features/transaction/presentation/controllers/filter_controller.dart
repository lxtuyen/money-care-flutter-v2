import 'package:get/get.dart';

class FilterController extends GetxController {
  static const String defaultDateLabel = 'Tháng này';

  var categoryId = RxnInt();
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

  void updateDateRange(DateTime? start, DateTime? end, {String? label}) {
    startDate.value = start;
    endDate.value = end;
    if (label != null) {
      dateLabel.value = label;
    }
  }

  void updateKeyword(String value) => keyword.value = value;

  bool get hasKeyword => keyword.value.trim().isNotEmpty;
  bool get hasCategory => categoryId.value != null;
  bool get hasDateFilter =>
      dateLabel.value != defaultDateLabel ||
      !_isCurrentMonthRange(startDate.value, endDate.value);
  bool get hasActiveFilters => hasKeyword || hasCategory || hasDateFilter;
  int get activeFilterCount =>
      (hasKeyword ? 1 : 0) + (hasCategory ? 1 : 0) + (hasDateFilter ? 1 : 0);

  void clearAll() {
    categoryId.value = null;
    keyword.value = '';
    _setDefaultMonthRange();
  }

  void _setDefaultMonthRange() {
    final now = DateTime.now();
    startDate.value = DateTime(now.year, now.month, 1);
    endDate.value = DateTime(now.year, now.month + 1, 0);
    dateLabel.value = defaultDateLabel;
  }

  bool _isCurrentMonthRange(DateTime? start, DateTime? end) {
    if (start == null || end == null) return false;

    final now = DateTime.now();
    final monthStart = DateTime(now.year, now.month, 1);
    final monthEnd = DateTime(now.year, now.month + 1, 0);

    return start.year == monthStart.year &&
        start.month == monthStart.month &&
        start.day == monthStart.day &&
        end.year == monthEnd.year &&
        end.month == monthEnd.month &&
        end.day == monthEnd.day;
  }
}

final filterController = FilterController();
