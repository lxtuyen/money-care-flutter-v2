import 'package:get/get.dart';

class FilterController extends GetxController {
  var categoryId = RxnInt();
  var startDate = Rxn<DateTime>();
  var endDate = Rxn<DateTime>();
  var keyword = ''.obs;

  @override
  void onInit() {
    super.onInit();
    final now = DateTime.now();
    startDate.value = DateTime(now.year, now.month, 1);
    endDate.value = DateTime(now.year, now.month + 1, 0);
  }

  void updateCategory(int? id) => categoryId.value = id;

  void updateDateRange(DateTime? start, DateTime? end) {
    startDate.value = start;
    endDate.value = end;
  }

  void updateKeyword(String value) => keyword.value = value;

  void clearAll() {
    categoryId.value = null;
    keyword.value = '';
    final now = DateTime.now();
    startDate.value = DateTime(now.year, now.month, 1);
    endDate.value = DateTime(now.year, now.month + 1, 0);
  }
}

final filterController = FilterController();
