import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:money_care/core/controllers/app_controller.dart';
import 'package:money_care/core/utils/helper/helper_functions.dart';
import 'package:money_care/features/saving_fund/presentation/controllers/saving_fund_controller.dart';
import 'package:money_care/features/transaction/data/models/transaction_model.dart';
import 'package:money_care/features/transaction/domain/entities/transaction_entity.dart';
import 'package:money_care/features/transaction/presentation/controllers/scan_receipt_controller.dart';
import 'package:money_care/features/transaction/presentation/controllers/transaction_controller.dart';
import 'package:money_care/core/presentation/widgets/text_field/app_currency_form_field.dart';

class TransactionFormController extends GetxController {
  final TransactionController transactionController =
      Get.find<TransactionController>();
  final SavingFundController savingFundController =
      Get.find<SavingFundController>();
  final ScanReceiptController scanReceiptController =
      Get.find<ScanReceiptController>();
  final AppController appController = Get.find<AppController>();

  final formKey = GlobalKey<FormState>();
  final amountController = TextEditingController();
  final categoryController = TextEditingController();
  final noteController = TextEditingController();

  final Rxn<DateTime> selectedDate = Rxn<DateTime>();
  final RxnInt selectedCategoryId = RxnInt();

  bool showCategory = true;
  TransactionEntity? initialItem;

  void init(bool isCategoryVisible, TransactionEntity? item) {
    showCategory = isCategoryVisible;
    initialItem = item;

    if (item != null) {
      selectedDate.value = item.transactionDate ?? DateTime.now();
      amountController.text = item.amount.toString();
      categoryController.text = item.category?.name ?? "";
      noteController.text = item.note ?? "";
      selectedCategoryId.value = item.category?.id;
    } else {
      selectedDate.value = DateTime.now();
    }
  }

  Future<void> selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate.value,
      firstDate: DateTime(2000),
      lastDate: DateTime(2050),
    );
    if (picked != null && picked != selectedDate.value) {
      selectedDate.value = picked;
    }
  }

  Future<void> openScanOptions(BuildContext context) async {
    if (scanReceiptController.isScanning.value) return;

    final source = await showModalBottomSheet<ImageSource>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.photo_camera_outlined),
                title: const Text(
                  'Chụp hoá đơn',
                ),
                onTap: () => Navigator.pop(context, ImageSource.camera),
              ),
              ListTile(
                leading: const Icon(Icons.photo_library_outlined),
                title: const Text(
                  'Chọn từ thư viện',
                ),
                onTap: () => Navigator.pop(context, ImageSource.gallery),
              ),
            ],
          ),
        );
      },
    );

    if (source == null) return;
    await scanBill(source);
  }

  Future<void> scanBill(ImageSource source) async {
    final data = await scanReceiptController.scan(source);
    if (data != null) {
      amountController.text = data.totalAmount.toString();
      selectedDate.value = DateTime.parse(data.date);
      if (showCategory) {
        final categories =
            savingFundController.currentFund.value?.categories ?? [];

        final matched = categories.firstWhere(
          (c) =>
              c.name.toLowerCase().trim() ==
              data.categoryName.toLowerCase().trim(),
          orElse: () => CategoryEntity(id: -1, name: "", icon: "default.png"),
        );

        if (matched.id != -1) {
          selectedCategoryId.value = matched.id;
          categoryController.text = matched.name;
        }
      }
    }
  }

  TransactionCreateDto buildTransactionDto() {
    final rawValue = AppCurrencyFormField.unformat(amountController.text);
    return TransactionCreateDto(
      amount: int.tryParse(rawValue) ?? 0,
      type: showCategory ? "expense" : "income",
      note: noteController.text.trim(),
      categoryId: selectedCategoryId.value,
      transactionDate: selectedDate.value,
      userId: appController.userId.value ?? 0,
    );
  }

  void setCategory(CategoryEntity category) {
    selectedCategoryId.value = category.id;
    categoryController.text = category.name;
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
    try {
      final dto = buildTransactionDto();
      await transactionController.createTransaction(dto);
      Get.back();
      AppHelperFunction.showSuccessSnackBar(
        'Tạo giao dịch thành công',
      );
    } catch (e) {
      AppHelperFunction.showErrorSnackBar(e.toString());
    }
  }

  Future<void> updateTransaction() async {
    try {
      final dto = buildTransactionDto();
      await transactionController.updateTransaction(dto, initialItem!.id!);
      Get.back();
      AppHelperFunction.showSuccessSnackBar(
        'Cập nhật giao dịch thành công',
      );
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
