import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:money_care/app/controllers/app_controller.dart';
import 'package:money_care/core/utils/helper/date_picker_helper.dart';
import 'package:money_care/core/utils/helper/helper_functions.dart';
import 'package:money_care/app/controllers/saving_goal_controller.dart';
import 'package:money_care/features/transaction/data/models/recurring_transaction_model.dart';
import 'package:money_care/features/transaction/data/models/transaction_model.dart';
import 'package:money_care/features/transaction/domain/entities/transaction_entity.dart';
import 'package:money_care/features/transaction/presentation/controllers/scan_receipt_controller.dart';
import 'package:money_care/app/controllers/transaction_controller.dart';
import 'package:money_care/features/wallet/presentation/controllers/wallet_controller.dart';

class TransactionFormController extends GetxController {
  final TransactionController transactionController =
      Get.find<TransactionController>();
  final SavingGoalController savingGoalController =
      Get.find<SavingGoalController>();
  final ScanReceiptController scanReceiptController =
      Get.find<ScanReceiptController>();
  final WalletController walletController = Get.find<WalletController>();
  final AppController appController = Get.find<AppController>();

  final formKey = GlobalKey<FormState>();
  final amountController = TextEditingController();
  final categoryController = TextEditingController();
  final noteController = TextEditingController();

  final Rxn<DateTime> selectedDate = Rxn<DateTime>();
  final RxnInt selectedCategoryId = RxnInt();
  final RxnInt selectedWalletId = RxnInt();

  CategoryEntity? selectedCategory;

  bool showCategory = true;
  String transactionType = 'expense';
  TransactionEntity? initialItem;

  void init(
    bool isCategoryVisible,
    TransactionEntity? item, [
    String type = 'expense',
  ]) {
    showCategory = isCategoryVisible;
    transactionType = type;
    initialItem = item;

    if (item != null) {
      selectedDate.value = item.transactionDate ?? DateTime.now();
      amountController.text = item.amount.toString();
      categoryController.text = item.category?.name ?? '';
      noteController.text = item.note ?? '';
      selectedCategoryId.value = item.category?.id;
    } else {
      selectedDate.value = DateTime.now();
      if (walletController.selectedWallet.value != null) {
        selectedWalletId.value = walletController.selectedWallet.value!.id;
      }
    }
  }

  Future<void> selectDate(BuildContext context) async {
    final DateTime? picked = await showStyledDatePicker(
      context: context,
      initialDate: selectedDate.value ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2050),
    );
    if (picked != null && picked != selectedDate.value) {
      selectedDate.value = picked;
    }
  }

  TransactionCreateDto buildTransactionDto() {
    final rawValue = AppHelperFunction.unformatCurrency(amountController.text);
    return TransactionCreateDto(
      amount: int.tryParse(rawValue) ?? 0,
      type: transactionType,
      note: noteController.text.trim(),
      categoryId: selectedCategoryId.value,
      transactionDate: selectedDate.value,
      userId: appController.userId.value,
      walletId: selectedWalletId.value,
    );
  }

  CreateRecurringTransactionDto buildRecurringTransactionDto(String frequency) {
    final userId = appController.userId.value;
    if (userId == null) {
      throw Exception('Không tìm thấy người dùng. Vui lòng đăng nhập lại.');
    }

    final rawValue = AppHelperFunction.unformatCurrency(amountController.text);
    return CreateRecurringTransactionDto(
      amount: double.tryParse(rawValue) ?? 0,
      type: transactionType,
      frequency: frequency,
      startDate: selectedDate.value ?? DateTime.now(),
      note: noteController.text.trim(),
      userId: userId,
      categoryId: selectedCategoryId.value,
    );
  }

  void setCategory(CategoryEntity category) {
    selectedCategoryId.value = category.id;
    categoryController.text = category.name;
    selectedCategory = category;
  }

  Future<void> submit() async {
    if (!formKey.currentState!.validate()) return;
    if (initialItem == null) {
      await createTransaction();
    } else {
      await updateTransaction();
    }
  }

  Future<void> createTransaction() async {
    final userId = await appController.getCurrentUserId();
    if (userId == null) {
      AppHelperFunction.showErrorSnackBar(
        'Khong the xac dinh nguoi dung. Vui long dang nhap lai.',
      );
      return;
    }
    try {
      final dto = buildTransactionDto();
      await transactionController.createTransaction(dto);
      Get.back();
      AppHelperFunction.showSuccessSnackBar('Tao giao dich thanh cong');
    } catch (e) {
      AppHelperFunction.showErrorSnackBar(e.toString());
    }
  }

  Future<void> updateTransaction() async {
    final userId = await appController.getCurrentUserId();
    if (userId == null) {
      AppHelperFunction.showErrorSnackBar(
        'Khong the xac dinh nguoi dung. Vui long dang nhap lai.',
      );
      return;
    }
    try {
      final dto = buildTransactionDto();
      await transactionController.updateTransaction(dto, initialItem!.id!);
      Get.back();
      AppHelperFunction.showSuccessSnackBar('Cap nhat giao dich thanh cong');
    } catch (e) {
      AppHelperFunction.showErrorSnackBar(e.toString());
    }
  }

  @override
  void onClose() {
    amountController.dispose();
    categoryController.dispose();
    noteController.dispose();
    super.onClose();
  }
}
