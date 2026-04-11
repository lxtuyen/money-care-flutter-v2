import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:money_care/app/controllers/app_controller.dart';
import 'package:money_care/app/widgets/text_field/app_currency_form_field.dart';
import 'package:money_care/core/utils/helper/date_picker_helper.dart';
import 'package:money_care/core/utils/helper/helper_functions.dart';
import 'package:money_care/core/utils/validators/validation.dart';
import 'package:money_care/app/controllers/fund_controller.dart';
import 'package:money_care/features/transaction/data/models/transaction_model.dart';
import 'package:money_care/features/transaction/domain/entities/category_entity.dart';
import 'package:money_care/app/controllers/transaction_controller.dart';
import 'package:money_care/features/transaction/domain/usecases/scan_receipt_usecases.dart';

class PhotoTransactionController extends GetxController {
  final TransactionController transactionController =
      Get.find<TransactionController>();
  final FundController fundController =
      Get.find<FundController>();
  final AppController appController = Get.find<AppController>();
  final ScanReceiptUseCase? scanReceiptUseCase;

  PhotoTransactionController({this.scanReceiptUseCase});

  final ImagePicker picker = ImagePicker();

  final formKey = GlobalKey<FormState>();
  final amountController = TextEditingController();
  final categoryController = TextEditingController();
  final noteController = TextEditingController();

  final Rxn<DateTime> selectedDate = Rxn<DateTime>(DateTime.now());
  final RxnInt selectedCategoryId = RxnInt();
  final RxnString selectedImagePath = RxnString();
  final RxString transactionType = 'expense'.obs;
  final RxBool isPickingImage = false.obs;
  final RxBool isScanning = false.obs;

  bool get isExpense => transactionType.value == 'expense';

  @override
  void onInit() {
    super.onInit();
    reset();
  }

  void reset() {
    amountController.clear();
    categoryController.clear();
    noteController.clear();
    selectedDate.value = DateTime.now();
    selectedCategoryId.value = null;
    selectedImagePath.value = null;
    transactionType.value = 'expense';
    isScanning.value = false;
  }

  void setTransactionType(String type) {
    transactionType.value = type;
    if (!isExpense) {
      selectedCategoryId.value = null;
      categoryController.clear();
    }
  }

  Future<void> scanWithAI() async {
    final path = selectedImagePath.value;
    if (path == null || scanReceiptUseCase == null) return;

    isScanning.value = true;
    try {
      final result = await scanReceiptUseCase!(XFile(path));
      
      amountController.text = AppCurrencyFormField.format(result.totalAmount.toString());
      
      if (result.merchantName != null && result.merchantName!.isNotEmpty) {
        noteController.text = result.merchantName!;
      }

      final parsedDate = DateTime.tryParse(result.date);
      if (parsedDate != null) {
        selectedDate.value = parsedDate;
      }

      if (result.categoryName != null) {
        final currentFund = fundController.currentFund.value;
        if (currentFund != null) {
          final cat = currentFund.categories.firstWhereOrNull(
            (c) => c.name.toLowerCase().contains(result.categoryName!.toLowerCase()) ||
                   result.categoryName!.toLowerCase().contains(c.name.toLowerCase())
          );
          if (cat != null) {
            setCategory(cat);
          }
        }
      }
      
      AppHelperFunction.showSuccessSnackBar('Ã„ÂÃƒÂ£ trÃƒÂ­ch xuÃ¡ÂºÂ¥t thÃƒÂ´ng tin tÃ¡Â»Â« hÃƒÂ³a Ã„â€˜Ã†Â¡n!');
    } catch (e) {
      AppHelperFunction.showErrorSnackBar('LÃ¡Â»â€”i quÃƒÂ©t hÃƒÂ³a Ã„â€˜Ã†Â¡n: $e');
    } finally {
      isScanning.value = false;
    }
  }

  Future<void> selectDate(BuildContext context) async {
    final DateTime? picked = await showStyledDatePicker(
      context: context,
      initialDate: selectedDate.value ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2050),
    );
    if (picked != null) {
      selectedDate.value = picked;
    }
  }

  Future<void> openImageOptions(BuildContext context) async {
    if (isPickingImage.value) return;

    final source = await showModalBottomSheet<ImageSource>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 12),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.black12,
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
              const SizedBox(height: 16),
              ListTile(
                leading: const Icon(Icons.photo_camera_outlined),
                title: const Text('ChÃ¡Â»Â¥p Ã¡ÂºÂ£nh'),
                onTap: () => Navigator.pop(context, ImageSource.camera),
              ),
              ListTile(
                leading: const Icon(Icons.photo_library_outlined),
                title: const Text('ChÃ¡Â»Ân tÃ¡Â»Â« thÃ†Â° viÃ¡Â»â€¡n'),
                onTap: () => Navigator.pop(context, ImageSource.gallery),
              ),
              if (selectedImagePath.value != null)
                ListTile(
                  leading: const Icon(
                    Icons.delete_outline,
                    color: Colors.redAccent,
                  ),
                  title: const Text('GÃ¡Â»Â¡ Ã¡ÂºÂ£nh hiÃ¡Â»â€¡n tÃ¡ÂºÂ¡i'),
                  onTap: () {
                    Navigator.pop(context);
                    removeImage();
                  },
                ),
              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );

    if (source == null) return;
    await pickImage(source);
  }

  Future<void> pickImage(ImageSource source) async {
    if (isPickingImage.value) return;

    isPickingImage.value = true;
    try {
      final image = await picker.pickImage(source: source, imageQuality: 85);
      if (image != null) {
        selectedImagePath.value = image.path;
      }
    } catch (e) {
      AppHelperFunction.showErrorSnackBar('KhÃƒÂ´ng thÃ¡Â»Æ’ chÃ¡Â»Ân Ã¡ÂºÂ£nh: $e');
    } finally {
      isPickingImage.value = false;
    }
  }

  void removeImage() {
    selectedImagePath.value = null;
  }

  void setCategory(CategoryEntity category) {
    selectedCategoryId.value = category.id;
    categoryController.text = category.name;
  }

  TransactionCreateDto buildTransactionDto() {
    final rawValue = AppCurrencyFormField.unformat(amountController.text);
    return TransactionCreateDto(
      amount: int.tryParse(rawValue) ?? 0,
      type: transactionType.value,
      note: noteController.text.trim(),
      pictureUrl: selectedImagePath.value,
      categoryId: isExpense ? selectedCategoryId.value : null,
      transactionDate: selectedDate.value,
      userId: appController.userId.value,
    );
  }

  Future<void> submit() async {
    if (!formKey.currentState!.validate()) return;

    final dateError = AppValidator.validateTransactionDate(selectedDate.value);
    if (dateError != null) {
      AppHelperFunction.showErrorSnackBar(dateError);
      return;
    }

    if (selectedImagePath.value == null || selectedImagePath.value!.isEmpty) {
      AppHelperFunction.showErrorSnackBar(
        'Vui lÃƒÂ²ng chÃ¡Â»Â¥p hoÃ¡ÂºÂ·c chÃ¡Â»Ân Ã¡ÂºÂ£nh cho bÃ¡ÂºÂ£n ghi.',
      );
      return;
    }

    final userId = await appController.getCurrentUserId();
    if (userId == null) {
      AppHelperFunction.showErrorSnackBar(
        'KhÃƒÂ´ng thÃ¡Â»Æ’ xÃƒÂ¡c Ã„â€˜Ã¡Â»â€¹nh ngÃ†Â°Ã¡Â»Âi dÃƒÂ¹ng. Vui lÃƒÂ²ng Ã„â€˜Ã„Æ’ng nhÃ¡ÂºÂ­p lÃ¡ÂºÂ¡i.',
      );
      return;
    }

    try {
      final dto = buildTransactionDto();
      await transactionController.createTransaction(dto);
      Get.back();
      AppHelperFunction.showSuccessSnackBar('TÃ¡ÂºÂ¡o bÃ¡ÂºÂ£n ghi kÃƒÂ¨m Ã¡ÂºÂ£nh thÃƒÂ nh cÃƒÂ´ng');
      reset();
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



