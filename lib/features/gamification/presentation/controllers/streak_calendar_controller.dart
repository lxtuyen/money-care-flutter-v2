import 'package:get/get.dart';
import 'package:money_care/app/controllers/app_controller.dart';
import 'package:money_care/app/controllers/transaction_controller.dart';
import 'package:money_care/features/transaction/data/models/transaction_model.dart';
import 'package:money_care/features/transaction/domain/entities/transaction_entity.dart';
import 'package:money_care/core/utils/helper/helper_functions.dart';

class StreakCalendarController extends GetxController {
  final TransactionController _txController = Get.find<TransactionController>();
  final AppController _appController = Get.find<AppController>();

  final Rx<DateTime> focusedMonth = DateTime.now().obs;
  final RxBool isLoading = false.obs;
  final RxMap<int, int> dailyNet = <int, int>{}.obs;
  final RxSet<int> daysWithTx = <int>{}.obs;

  @override
  void onInit() {
    super.onInit();
    loadMonthData();
  }

  Future<void> loadMonthData() async {
    isLoading.value = true;
    final userId = await _appController.getCurrentUserId();
    if (userId == null) {
      isLoading.value = false;
      return;
    }

    final firstDay = DateTime(focusedMonth.value.year, focusedMonth.value.month, 1);
    final lastDay = DateTime(focusedMonth.value.year, focusedMonth.value.month + 1, 0, 23, 59, 59);

    try {
      final data = await _txController.filterTransactionsUseCase(
        userId,
        TransactionFilterDto(
          startDate: firstDay.toIso8601String(),
          endDate: lastDay.toIso8601String(),
        ),
      );

      final Map<int, int> net = {};
      final Set<int> days = {};

      void process(List<TransactionEntity> txs, int multiplier) {
        for (final tx in txs) {
          final d = tx.transactionDate;
          if (d == null) continue;
          if (d.year != focusedMonth.value.year || d.month != focusedMonth.value.month) {
            continue;
          }
          days.add(d.day);
          net[d.day] = (net[d.day] ?? 0) + (tx.amount * multiplier);
        }
      }

      process(data.incomeTransactions, 1);
      process(data.expenseTransactions, -1);

      dailyNet.assignAll(net);
      daysWithTx.assignAll(days);
    } catch (e) {
      print('[STREAK_CALENDAR] Error: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void prevMonth() {
    focusedMonth.value = DateTime(focusedMonth.value.year, focusedMonth.value.month - 1, 1);
    loadMonthData();
  }

  void nextMonth() {
    focusedMonth.value = DateTime(focusedMonth.value.year, focusedMonth.value.month + 1, 1);
    loadMonthData();
  }

  bool isToday(int dayNum) {
    final today = DateTime.now();
    return focusedMonth.value.year == today.year &&
        focusedMonth.value.month == today.month &&
        dayNum == today.day;
  }
}
