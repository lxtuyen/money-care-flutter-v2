import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:money_care/app/controllers/app_controller.dart';
import 'package:money_care/app/controllers/saving_goal_controller.dart';
import 'package:money_care/app/controllers/transaction_controller.dart';
import 'package:money_care/core/utils/helper/date_picker_helper.dart';
import 'package:money_care/core/utils/helper/helper_functions.dart';
import 'package:money_care/features/transaction/data/models/transaction_model.dart';
import 'package:money_care/features/transaction/domain/entities/transaction_entity.dart';
import 'package:money_care/features/transaction/presentation/controllers/user_category_controller.dart';
import 'package:money_care/features/wallet/presentation/controllers/wallet_controller.dart';

class TransactionFormController extends GetxController {
  final TransactionController transactionController =
      Get.find<TransactionController>();
  final SavingGoalController savingGoalController =
      Get.find<SavingGoalController>();
  final WalletController walletController = Get.find<WalletController>();
  final AppController appController = Get.find<AppController>();

  final formKey = GlobalKey<FormState>();
  final amountController = TextEditingController();
  final categoryController = TextEditingController();
  final subCategoryController = TextEditingController();
  final walletNameController = TextEditingController();
  final noteController = TextEditingController();

  final Rxn<DateTime> selectedDate = Rxn<DateTime>();
  final RxnInt selectedCategoryId = RxnInt();
  final RxnInt selectedSubCategoryId = RxnInt();
  final RxnInt selectedWalletId = RxnInt();
  final Rxn<CategoryEntity> _selectedCategory = Rxn<CategoryEntity>();
  CategoryEntity? get selectedCategory => _selectedCategory.value;
  set selectedCategory(CategoryEntity? value) =>
      _selectedCategory.value = value;

  final RxString _transactionType = 'expense'.obs;
  String get transactionType => _transactionType.value;
  set transactionType(String value) => _transactionType.value = value;

  TransactionEntity? initialItem;

  void _clearFormState() {
    amountController.clear();
    categoryController.clear();
    subCategoryController.clear();
    walletNameController.clear();
    noteController.clear();
    selectedDate.value = null;
    selectedCategoryId.value = null;
    selectedSubCategoryId.value = null;
    selectedWalletId.value = null;
    selectedCategory = null;
  }

  void changeTransactionType(String type) {
    transactionType = type;
    selectedCategoryId.value = null;
    selectedSubCategoryId.value = null;
    selectedCategory = null;
    categoryController.clear();
    subCategoryController.clear();
  }

  void init(TransactionEntity? item, [String type = 'expense']) {
    _clearFormState();
    transactionType = type;
    initialItem = item;

    if (item != null) {
      selectedDate.value = item.transactionDate ?? DateTime.now();
      amountController.text = item.amount.toString();
      categoryController.text = item.category?.name ?? '';
      noteController.text = item.note ?? '';
      selectedCategoryId.value = item.category?.id;
      selectedSubCategoryId.value = item.subCategory?.id;
      subCategoryController.text = item.subCategory?.name ?? '';
      selectedCategory = _findLoadedCategory(item);
      selectedWalletId.value = item.walletId;
      walletNameController.text = item.walletName ?? '';
    } else {
      selectedDate.value = DateTime.now();
      // Ưu tiên chọn ví thường (không phải saving wallet) làm default
      final nonSavingWallet = walletController.wallets.firstWhereOrNull(
        (w) => w.savingGoals.isEmpty,
      );
      final defaultWallet =
          nonSavingWallet ?? walletController.selectedWallet.value;
      if (defaultWallet != null) {
        selectedWalletId.value = defaultWallet.id;
        walletNameController.text = defaultWallet.name;
      }
    }
  }

  CategoryEntity? _findLoadedCategory(TransactionEntity item) {
    if (!Get.isRegistered<UserCategoryController>()) {
      return item.category;
    }

    final categories = Get.find<UserCategoryController>().categories;
    return categories.firstWhereOrNull(
          (category) =>
              (item.category?.id != null && category.id == item.category!.id) ||
              category.name == item.category?.name,
        ) ??
        item.category;
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
    final date = selectedDate.value ?? DateTime.now();
    final normalizedDate = DateTime(
      date.year,
      date.month,
      date.day,
      12,
      0,
      0,
    ).toUtc();

    return TransactionCreateDto(
      amount: int.tryParse(rawValue) ?? 0,
      type: transactionType,
      note: noteController.text.trim(),
      categoryId: selectedCategoryId.value,
      subCategoryId: selectedSubCategoryId.value,
      transactionDate: normalizedDate,
      userId: appController.userId.value,
      walletId: selectedWalletId.value,
    );
  }

  void setCategory(CategoryEntity category) {
    selectedCategoryId.value = category.id;
    categoryController.text = category.name;
    selectedCategory = category;
    selectedSubCategoryId.value = null;
    subCategoryController.clear();
  }

  void setSubCategory(SubCategoryEntity? subCategory) {
    if (subCategory == null) {
      selectedSubCategoryId.value = null;
      subCategoryController.clear();
    } else {
      selectedSubCategoryId.value = subCategory.id;
      subCategoryController.text = subCategory.name;
    }
  }

  void setWallet(int id, String name) {
    selectedWalletId.value = id;
    walletNameController.text = name;
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
      AppHelperFunction.showErrorSnackBar('Khong the xac dinh nguoi dung.');
      return;
    }
    try {
      final dto = buildTransactionDto();
      await transactionController.createTransaction(dto);
      Get.back();
      AppHelperFunction.showSuccessSnackBar('Tạo giao dịch thành công');
    } catch (e) {
      AppHelperFunction.showErrorSnackBar(e.toString());
    }
  }

  Future<void> updateTransaction() async {
    final userId = await appController.getCurrentUserId();
    if (userId == null) {
      AppHelperFunction.showErrorSnackBar('Khong the xac dinh nguoi dung.');
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
    subCategoryController.dispose();
    walletNameController.dispose();
    noteController.dispose();
    super.onClose();
  }
}
