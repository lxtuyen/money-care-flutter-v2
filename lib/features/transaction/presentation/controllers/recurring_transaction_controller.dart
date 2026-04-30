import 'package:get/get.dart';
import 'package:money_care/app/controllers/app_controller.dart';
import 'package:money_care/core/utils/helper/helper_functions.dart';
import 'package:money_care/features/transaction/data/models/recurring_transaction_model.dart';
import 'package:money_care/features/transaction/domain/usecases/recurring_transaction_usecases.dart';

class RecurringTransactionController extends GetxController {
  final GetRecurringTransactionsUseCase getRecurringTransactionsUseCase;
  final CreateRecurringTransactionUseCase createRecurringTransactionUseCase;
  final DeleteRecurringTransactionUseCase deleteRecurringTransactionUseCase;

  RecurringTransactionController({
    required this.getRecurringTransactionsUseCase,
    required this.createRecurringTransactionUseCase,
    required this.deleteRecurringTransactionUseCase,
  });

  var recurringTransactions = <RecurringTransactionModel>[].obs;
  var isLoading = false.obs;
  var errorMessage = RxnString();

  @override
  void onInit() {
    super.onInit();
    final userId = Get.find<AppController>().userId.value;
    if (userId != null) {
      loadRecurringTransactions(userId);
    }
  }

  Future<void> loadRecurringTransactions(int userId) async {
    isLoading.value = true;
    try {
      final list = await getRecurringTransactionsUseCase(userId);
      recurringTransactions.assignAll(list);
      errorMessage.value = null;
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> createRecurringTransaction(CreateRecurringTransactionDto dto) async {
    isLoading.value = true;
    try {
      await createRecurringTransactionUseCase(dto);
      await loadRecurringTransactions(dto.userId);
      errorMessage.value = null;
      Get.back();
      AppHelperFunction.showSuccessSnackBar('Tạo giao dịch thành công');
    } catch (e) {
      AppHelperFunction.showErrorSnackBar(e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteRecurringTransaction(int id) async {
    isLoading.value = true;
    try {
      final success = await deleteRecurringTransactionUseCase(id);
      if (success) {
        recurringTransactions.removeWhere((element) => element.id == id);
      }
      errorMessage.value = null;
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }
}
