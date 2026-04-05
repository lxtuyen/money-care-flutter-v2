import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:money_care/core/constants/colors.dart';
import 'package:money_care/core/controllers/app_controller.dart';
import 'package:money_care/core/services/exam_period_notification_service.dart';
import 'package:money_care/core/utils/helper/date_picker_helper.dart';
import 'package:money_care/core/utils/helper/helper_functions.dart';
import 'package:money_care/features/finance_mode/domain/entities/finance_mode_entity.dart';
import 'package:money_care/features/finance_mode/presentation/controllers/finance_mode_controller.dart';
import 'package:money_care/features/fund/presentation/controllers/fund_controller.dart';
import 'package:money_care/features/transaction/data/models/transaction_model.dart';
import 'package:money_care/features/transaction/domain/entities/category_entity.dart';
import 'package:money_care/features/transaction/domain/entities/transaction_entity.dart';
import 'package:money_care/features/transaction/presentation/controllers/scan_receipt_controller.dart';
import 'package:money_care/features/transaction/presentation/controllers/transaction_controller.dart';
import 'package:money_care/features/transaction/presentation/controllers/user_category_controller.dart';
import 'package:money_care/core/presentation/widgets/text_field/app_currency_form_field.dart';

class TransactionFormController extends GetxController {
  final TransactionController transactionController =
      Get.find<TransactionController>();
  final FundController fundController =
      Get.find<FundController>();
  final ScanReceiptController scanReceiptController =
      Get.find<ScanReceiptController>();
  final AppController appController = Get.find<AppController>();

  final formKey = GlobalKey<FormState>();
  final amountController = TextEditingController();
  final categoryController = TextEditingController();
  final noteController = TextEditingController();

  final Rxn<DateTime> selectedDate = Rxn<DateTime>();
  final RxnInt selectedCategoryId = RxnInt();

  /// Keeps the full selected category so we can check [CategoryEntity.isEssential]
  /// when validating SURVIVAL mode (Req 5.10).
  CategoryEntity? selectedCategory;

  bool showCategory = true;
  String transactionType = 'expense';
  TransactionEntity? initialItem;

  void init(bool isCategoryVisible, TransactionEntity? item, [String type = 'expense']) {
    showCategory = isCategoryVisible;
    transactionType = type;
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
                title: const Text(
                  'Chá»¥p hoÃ¡ Ä‘Æ¡n',
                ),
                onTap: () => Navigator.pop(context, ImageSource.camera),
              ),
              ListTile(
                leading: const Icon(Icons.photo_library_outlined),
                title: const Text(
                  'Chá»n tá»« thÆ° viá»‡n',
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
        final fundCategories =
            fundController.currentFund.value?.categories ?? [];
        final userCategoryController = Get.find<UserCategoryController>();
        final categories = fundCategories.isNotEmpty
            ? fundCategories
            : userCategoryController.categories;

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
    final fundId = fundController.currentFundId > 0
        ? fundController.currentFundId
        : null;
    return TransactionCreateDto(
      amount: int.tryParse(rawValue) ?? 0,
      type: transactionType,
      note: noteController.text.trim(),
      categoryId: selectedCategoryId.value,
      transactionDate: selectedDate.value,
      userId: appController.userId.value,
      fundId: fundId,
    );
  }

  void setCategory(CategoryEntity category) {
    selectedCategoryId.value = category.id;
    categoryController.text = category.name;
    selectedCategory = category;
  }

  Future<void> submit() async {
    if (!formKey.currentState!.validate()) return;

    // Req 5.10: In SURVIVAL mode, warn before saving a Non_Essential transaction.
    if (showCategory && await _shouldWarnSurvivalMode()) {
      _showSurvivalWarningDialog();
      return;
    }

    // Req 9.4: In exam period, remind before saving an entertainment transaction.
    if (showCategory && _shouldRemindExamPeriod()) {
      _showExamPeriodReminderDialog();
      return;
    }

    if (initialItem == null) {
      await createTransaction();
    } else {
      await updateTransaction();
    }
  }

  /// Returns true when the current finance mode is SURVIVAL and the selected
  /// category is non-essential (Req 5.10).
  Future<bool> _shouldWarnSurvivalMode() async {
    try {
      final financeModeController = Get.find<FinanceModeController>();
      if (financeModeController.currentMode.value != FinanceMode.survival) {
        return false;
      }
      // Use the stored full entity; fall back to essential if unknown.
      return selectedCategory != null && !selectedCategory!.isEssential;
    } catch (_) {
      return false;
    }
  }

  /// Show the SURVIVAL mode confirmation dialog (Req 5.10).
  void _showSurvivalWarningDialog() {
    Get.dialog(
      AlertDialog(
        title: const Text('Cáº£nh bÃ¡o chi tiÃªu'),
        content: const Text(
          'Khoáº£n nÃ y khÃ´ng thiáº¿t yáº¿u â€” báº¡n cÃ³ cháº¯c muá»‘n chi khÃ´ng?',
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Huá»·'),
          ),
          TextButton(
            onPressed: () async {
              Get.back();
              if (initialItem == null) {
                await createTransaction();
              } else {
                await updateTransaction();
              }
            },
            child: const Text('Váº«n chi'),
          ),
        ],
      ),
    );
  }

  /// Returns true when currently in an exam period and the selected category
  /// is "Giáº£i trÃ­" (entertainment / non-essential) (Req 9.4).
  bool _shouldRemindExamPeriod() {
    try {
      final examController = Get.find<ExamPeriodController>();
      if (!examController.isInExamPeriod.value) return false;
      // Trigger for non-essential (entertainment) categories
      return selectedCategory != null && !selectedCategory!.isEssential;
    } catch (_) {
      return false;
    }
  }

  /// Show the exam period reminder dialog (Req 9.4).
  void _showExamPeriodReminderDialog() {
    Get.dialog(
      AlertDialog(
        title: const Text('Nháº¯c nhá»Ÿ mÃ¹a thi'),
        content: const Text(
          'Äang mÃ¹a thi Ä‘Ã³ â€” Æ°u tiÃªn há»c trÆ°á»›c nhÃ©!',
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Äá»ƒ sau'),
          ),
          TextButton(
            onPressed: () async {
              Get.back();
              if (initialItem == null) {
                await createTransaction();
              } else {
                await updateTransaction();
              }
            },
            child: const Text('Váº«n chi'),
          ),
        ],
      ),
    );
  }

  Future<void> createTransaction() async {
    final userId = await appController.getCurrentUserId();
    if (userId == null) {
      AppHelperFunction.showErrorSnackBar('KhÃ´ng thá»ƒ xÃ¡c Ä‘á»‹nh ngÆ°á»i dÃ¹ng. Vui lÃ²ng Ä‘Äƒng nháº­p láº¡i.');
      return;
    }
    try {
      final dto = buildTransactionDto();
      await transactionController.createTransaction(dto);
      Get.back();
      AppHelperFunction.showSuccessSnackBar(
        'Táº¡o giao dá»‹ch thÃ nh cÃ´ng',
      );
      // Budget and goal-fund suggestions are disabled until their controllers are restored.
    } catch (e) {
      AppHelperFunction.showErrorSnackBar(e.toString());
    }
  }

  void _showModeSuggestionDialog(
    FinanceMode suggestedMode,
    FinanceModeController financeModeController,
  ) {
    final modeName = suggestedMode == FinanceMode.saving ? 'TIáº¾T KIá»†M' : 'SINH Tá»’N';
    Get.dialog(
      AlertDialog(
        title: const Text('Gá»£i Ã½ cháº¿ Ä‘á»™ tÃ i chÃ­nh'),
        content: Text(
          'Chi tiÃªu cá»§a báº¡n Ä‘ang tÄƒng cao. Báº¡n cÃ³ muá»‘n chuyá»ƒn sang cháº¿ Ä‘á»™ $modeName khÃ´ng?',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Get.back();
              financeModeController.declineSuggestion();
            },
            child: const Text('KhÃ´ng, cáº£m Æ¡n'),
          ),
          TextButton(
            onPressed: () {
              Get.back();
              financeModeController.switchMode(suggestedMode);
            },
            child: const Text('Chuyá»ƒn ngay'),
          ),
        ],
      ),
    );
  }

  Future<void> updateTransaction() async {
    final userId = await appController.getCurrentUserId();
    if (userId == null) {
      AppHelperFunction.showErrorSnackBar('KhÃ´ng thá»ƒ xÃ¡c Ä‘á»‹nh ngÆ°á»i dÃ¹ng. Vui lÃ²ng Ä‘Äƒng nháº­p láº¡i.');
      return;
    }
    try {
      final dto = buildTransactionDto();
      await transactionController.updateTransaction(dto, initialItem!.id!);
      Get.back();
      AppHelperFunction.showSuccessSnackBar(
        'Cáº­p nháº­t giao dá»‹ch thÃ nh cÃ´ng',
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

