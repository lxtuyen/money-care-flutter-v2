import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:money_care/core/constants/colors.dart';
import 'package:money_care/app/controllers/app_controller.dart';
import 'package:money_care/core/utils/helper/date_picker_helper.dart';
import 'package:money_care/core/utils/helper/helper_functions.dart';
import 'package:money_care/features/finance_mode/domain/entities/finance_mode_entity.dart';
import 'package:money_care/features/finance_mode/presentation/controllers/finance_mode_controller.dart';
import 'package:money_care/app/controllers/fund_controller.dart';
import 'package:money_care/features/transaction/data/models/transaction_model.dart';
import 'package:money_care/features/transaction/domain/entities/category_entity.dart';
import 'package:money_care/features/transaction/domain/entities/transaction_entity.dart';
import 'package:money_care/features/transaction/presentation/controllers/scan_receipt_controller.dart';
import 'package:money_care/app/controllers/transaction_controller.dart';
import 'package:money_care/features/transaction/presentation/controllers/user_category_controller.dart';
import 'package:money_care/app/widgets/text_field/app_currency_form_field.dart';

class TransactionFormController extends GetxController {
  final TransactionController transactionController =
      Get.find<TransactionController>();
  final FundController fundController = Get.find<FundController>();
  final ScanReceiptController scanReceiptController =
      Get.find<ScanReceiptController>();
  final AppController appController = Get.find<AppController>();

  final formKey = GlobalKey<FormState>();
  final amountController = TextEditingController();
  final categoryController = TextEditingController();
  final noteController = TextEditingController();

  final Rxn<DateTime> selectedDate = Rxn<DateTime>();
  final RxnInt selectedCategoryId = RxnInt();

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
                title: const Text('Chup hoa don'),
                onTap: () => Navigator.pop(context, ImageSource.camera),
              ),
              ListTile(
                leading: const Icon(Icons.photo_library_outlined),
                title: const Text('Chon tu thu vien'),
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
    if (data == null) return;

    amountController.text = data.totalAmount.toString();
    selectedDate.value = DateTime.parse(data.date);

    if (showCategory) {
      final fundCategories = fundController.currentFund.value?.categories ?? [];
      final userCategoryController = Get.find<UserCategoryController>();
      final categories = fundCategories.isNotEmpty
          ? fundCategories
          : userCategoryController.categories;

      final matched = categories.firstWhere(
        (c) =>
            c.name.toLowerCase().trim() ==
            data.categoryName.toLowerCase().trim(),
        orElse: () => CategoryEntity(id: -1, name: '', icon: 'default.png'),
      );

      if (matched.id != -1) {
        selectedCategoryId.value = matched.id;
        categoryController.text = matched.name;
      }
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
    );
  }

  void setCategory(CategoryEntity category) {
    selectedCategoryId.value = category.id;
    categoryController.text = category.name;
    selectedCategory = category;
  }

  Future<void> submit() async {
    if (!formKey.currentState!.validate()) return;

    if (showCategory && await _shouldWarnSurvivalMode()) {
      _showSurvivalWarningDialog();
      return;
    }

    if (initialItem == null) {
      await createTransaction();
    } else {
      await updateTransaction();
    }
  }

  Future<bool> _shouldWarnSurvivalMode() async {
    try {
      final financeModeController = Get.find<FinanceModeController>();
      if (financeModeController.currentMode.value != FinanceMode.survival) {
        return false;
      }
      return selectedCategory != null && !selectedCategory!.isEssential;
    } catch (_) {
      return false;
    }
  }

  void _showSurvivalWarningDialog() {
    Get.dialog(
      AlertDialog(
        title: const Text('Canh bao chi tieu'),
        content: const Text(
          'Khoan nay khong thiet yeu - ban chac muon chi khong?',
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Huy')),
          TextButton(
            onPressed: () async {
              Get.back();
              if (initialItem == null) {
                await createTransaction();
              } else {
                await updateTransaction();
              }
            },
            child: const Text('Van chi'),
          ),
        ],
      ),
    );
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

  void _showModeSuggestionDialog(
    FinanceMode suggestedMode,
    FinanceModeController financeModeController,
  ) {
    final modeName = suggestedMode == FinanceMode.saving
        ? 'TIET KIEM'
        : 'SINH TON';
    Get.dialog(
      AlertDialog(
        title: const Text('Goi y che do tai chinh'),
        content: Text(
          'Chi tieu dang cao. Ban muon chuyen sang che do $modeName khong?',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Get.back();
              financeModeController.declineSuggestion();
            },
            child: const Text('Khong, cam on'),
          ),
          TextButton(
            onPressed: () {
              Get.back();
              financeModeController.switchMode(suggestedMode);
            },
            child: const Text('Chuyen ngay'),
          ),
        ],
      ),
    );
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
