import 'package:get/get.dart';

class FilterController extends GetxController {
  static const String defaultDateLabel = 'Tháng này';

  var categoryId = RxnInt();
  var walletId = RxnInt();
  var startDate = Rxn<DateTime>();
  var endDate = Rxn<DateTime>();
  var keyword = ''.obs;
  var dateLabel = defaultDateLabel.obs;
  var isManualDateFilter = false.obs;

  @override
  void onInit() {
    super.onInit();
    _setDefaultMonthRange();
  }

  void updateCategory(int? id) => categoryId.value = id;

  void updateWallet(int? id) => walletId.value = id;

  void updateDateRange(DateTime? start, DateTime? end, {String? label, bool isManual = false}) {
    startDate.value = start;
    endDate.value = end;
    if (label != null) {
      dateLabel.value = label;
    }
    isManualDateFilter.value = isManual;
  }

  void updateKeyword(String value) => keyword.value = value;

  bool get hasKeyword => keyword.value.trim().isNotEmpty;
  bool get hasCategory => categoryId.value != null;
  bool get hasWallet => walletId.value != null;
  bool get hasDateFilter => isManualDateFilter.value;
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
    isManualDateFilter.value = false;
  }

}

final filterController = FilterController();
