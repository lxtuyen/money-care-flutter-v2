import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:money_care/app/controllers/app_controller.dart';
import 'package:money_care/app/controllers/saving_goal_controller.dart';
import 'package:money_care/app/controllers/transaction_controller.dart';
import 'package:money_care/core/utils/helper/date_picker_helper.dart';
import 'package:money_care/core/utils/helper/helper_functions.dart';
import 'package:money_care/features/couple/presentation/controllers/couple_controller.dart';
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
  final payerNameController = TextEditingController();
  final splitMethodNameController = TextEditingController();

  // Couple-specific Fields
  final isShared = false.obs;
  final isSharedEditable = true.obs;
  final selectedPayerId = RxnInt();
  final splitMethod = 'none'.obs;

  final splitPctMeController = TextEditingController();
  final splitPctPartnerController = TextEditingController();
  final splitAmtMeController = TextEditingController();
  final splitAmtPartnerController = TextEditingController();

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
    
    isShared.value = false;
    isSharedEditable.value = true;
    selectedPayerId.value = null;
    splitMethod.value = 'none';
    splitPctMeController.clear();
    splitPctPartnerController.clear();
    splitAmtMeController.clear();
    splitAmtPartnerController.clear();
    payerNameController.clear();
    splitMethodNameController.clear();
  }

  void changeTransactionType(String type) {
    transactionType = type;
    selectedCategoryId.value = null;
    selectedSubCategoryId.value = null;
    selectedCategory = null;
    categoryController.clear();
    subCategoryController.clear();
    
    if (type == 'income') {
      splitMethod.value = 'none';
    }
  }

  void init(TransactionEntity? item, [String type = 'expense']) {
    _clearFormState();
    transactionType = type;
    initialItem = item;

    final hasActiveCouple = Get.isRegistered<CoupleController>() &&
        Get.find<CoupleController>().couple.value?.isActive == true;

    final args = Get.arguments as Map<String, dynamic>?;
    final isSharedArg = args?['isShared'] == true;

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

      // Load shared transaction state
      isShared.value = item.coupleId != null;
      isSharedEditable.value = false; // Lock Chung/Riêng selection for existing transactions

      if (item.coupleId != null) {
        selectedPayerId.value = item.payerId;
        splitMethod.value = item.splitMethod ?? 'none';

        // Set Payer label
        if (hasActiveCouple) {
          final coupleController = Get.find<CoupleController>();
          final coupleData = coupleController.couple.value;
          if (coupleData != null) {
            final payer = coupleData.members.firstWhereOrNull((m) => m.userId == item.payerId);
            if (payer != null) {
              payerNameController.text = payer.userId == appController.userId.value
                  ? '${payer.fullName} (Bạn)'
                  : payer.fullName;
            }
          }
        }

        // Set Split Method label
        switch (splitMethod.value) {
          case 'none':
            splitMethodNameController.text = 'Không chia';
            break;
          case 'equal':
            splitMethodNameController.text = 'Chia đều (50/50)';
            break;
          case 'percentage':
            splitMethodNameController.text = 'Chia theo phần trăm (%)';
            break;
          case 'fixed':
            splitMethodNameController.text = 'Chia theo số tiền cố định';
            break;
        }

        final userId = appController.userId.value ?? 0;
        if (item.splits != null && item.splits!.isNotEmpty) {
          final splitMe = item.splits!.firstWhereOrNull((s) => s.userId == userId);
          final splitPartner = item.splits!.firstWhereOrNull((s) => s.userId != userId);

          if (splitMe != null) {
            if (splitMe.percent != null) {
              splitPctMeController.text = splitMe.percent!.toStringAsFixed(0);
            }
            splitAmtMeController.text = splitMe.amount.toStringAsFixed(0);
          }
          if (splitPartner != null) {
            if (splitPartner.percent != null) {
              splitPctPartnerController.text = splitPartner.percent!.toStringAsFixed(0);
            }
            splitAmtPartnerController.text = splitPartner.amount.toStringAsFixed(0);
          }
        }
      }
    } else {
      selectedDate.value = DateTime.now();
      isSharedEditable.value = true;

      if (isSharedArg && hasActiveCouple) {
        isShared.value = true;
        // Default to first shared wallet
        if (Get.isRegistered<CoupleController>()) {
          final coupleController = Get.find<CoupleController>();
          if (coupleController.sharedWallets.isNotEmpty) {
            final defaultSharedWallet = coupleController.sharedWallets.first;
            selectedWalletId.value = defaultSharedWallet.id;
            walletNameController.text = defaultSharedWallet.name;
          }

          // Default payer to me
          final currentUserId = appController.userId.value;
          selectedPayerId.value = currentUserId;
          final coupleData = coupleController.couple.value;
          if (coupleData != null && currentUserId != null) {
            final me = coupleData.me(currentUserId);
            if (me != null) {
              payerNameController.text = '${me.fullName} (Bạn)';
            }
          }
        }
        splitMethod.value = 'none';
        splitMethodNameController.text = 'Không chia';
      } else {
        // Default to personal wallet
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

      // If couple is active, default payer to me
      if (hasActiveCouple && !isSharedArg) {
        final currentUserId = appController.userId.value;
        selectedPayerId.value = currentUserId;
        final coupleController = Get.find<CoupleController>();
        final coupleData = coupleController.couple.value;
        if (coupleData != null && currentUserId != null) {
          final me = coupleData.me(currentUserId);
          if (me != null) {
            payerNameController.text = '${me.fullName} (Bạn)';
          }
        }
      }
    }
  }

  void toggleShared(bool val) {
    if (!isSharedEditable.value) return;
    isShared.value = val;

    // Reset selected wallet based on shared status
    selectedWalletId.value = null;
    walletNameController.clear();

    if (val) {
      // Switch to first shared wallet
      if (Get.isRegistered<CoupleController>()) {
        final coupleController = Get.find<CoupleController>();
        if (coupleController.sharedWallets.isNotEmpty) {
          final defaultSharedWallet = coupleController.sharedWallets.first;
          selectedWalletId.value = defaultSharedWallet.id;
          walletNameController.text = defaultSharedWallet.name;
        }
        
        // Default payer to me
        final currentUserId = appController.userId.value;
        selectedPayerId.value = currentUserId;
        final coupleData = coupleController.couple.value;
        if (coupleData != null && currentUserId != null) {
          final me = coupleData.me(currentUserId);
          if (me != null) {
            payerNameController.text = '${me.fullName} (Bạn)';
          }
        }
      }
      splitMethod.value = 'none';
      splitMethodNameController.text = 'Không chia';
    } else {
      // Switch back to personal wallet
      final nonSavingWallet = walletController.wallets.firstWhereOrNull(
        (w) => w.savingGoals.isEmpty,
      );
      final defaultWallet =
          nonSavingWallet ?? walletController.selectedWallet.value;
      if (defaultWallet != null) {
        selectedWalletId.value = defaultWallet.id;
        walletNameController.text = defaultWallet.name;
      }
      splitMethod.value = 'none';
      splitPctMeController.clear();
      splitPctPartnerController.clear();
      splitAmtMeController.clear();
      splitAmtPartnerController.clear();
      payerNameController.clear();
      splitMethodNameController.clear();
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

  void setPayer(int id, String name) {
    selectedPayerId.value = id;
    payerNameController.text = name;
  }

  void setSplitMethod(String method, String label) {
    splitMethod.value = method;
    splitMethodNameController.text = label;
  }

  List<Map<String, dynamic>>? buildSplitsPayload(int currentUserId, int? partnerUserId) {
    if (transactionType != 'expense' || splitMethod.value == 'none') {
      return null;
    }

    if (partnerUserId == null) return null;

    final rawValue = AppHelperFunction.unformatCurrency(amountController.text);
    final amount = double.tryParse(rawValue) ?? 0.0;

    if (splitMethod.value == 'equal') {
      return [
        {'userId': currentUserId, 'percent': 50},
        {'userId': partnerUserId, 'percent': 50},
      ];
    } else if (splitMethod.value == 'percentage') {
      final pctMe = double.tryParse(splitPctMeController.text.trim()) ?? 0.0;
      final pctPartner = double.tryParse(splitPctPartnerController.text.trim()) ?? 0.0;
      if (pctMe + pctPartner != 100) {
        throw 'Tổng phần trăm phải bằng 100%';
      }
      return [
        {'userId': currentUserId, 'percent': pctMe},
        {'userId': partnerUserId, 'percent': pctPartner},
      ];
    } else if (splitMethod.value == 'fixed') {
      final amtMe = double.tryParse(splitAmtMeController.text.trim()) ?? 0.0;
      final amtPartner = double.tryParse(splitAmtPartnerController.text.trim()) ?? 0.0;
      if (amtMe + amtPartner != amount) {
        throw 'Tổng số tiền chia phải bằng số tiền giao dịch (${AppHelperFunction.formatAmount(amount)})';
      }
      return [
        {'userId': currentUserId, 'amount': amtMe},
        {'userId': partnerUserId, 'amount': amtPartner},
      ];
    }
    return null;
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

      if (isShared.value) {
        final coupleController = Get.find<CoupleController>();
        final coupleId = coupleController.couple.value?.id;
        final partnerUserId = coupleController.couple.value?.partner(userId)?.userId;

        List<Map<String, dynamic>>? splitsPayload;
        try {
          splitsPayload = buildSplitsPayload(userId, partnerUserId);
        } catch (e) {
          AppHelperFunction.showErrorSnackBar(e.toString());
          return;
        }

        await transactionController.createTransaction(
          dto,
          coupleId: coupleId,
          payerId: selectedPayerId.value ?? userId,
          splitMethod: splitMethod.value,
          splits: splitsPayload,
        );
      } else {
        await transactionController.createTransaction(dto);
      }
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

      if (isShared.value) {
        final coupleController = Get.find<CoupleController>();
        final coupleId = coupleController.couple.value?.id;
        final partnerUserId = coupleController.couple.value?.partner(userId)?.userId;

        List<Map<String, dynamic>>? splitsPayload;
        try {
          splitsPayload = buildSplitsPayload(userId, partnerUserId);
        } catch (e) {
          AppHelperFunction.showErrorSnackBar(e.toString());
          return;
        }

        await transactionController.updateTransaction(
          dto,
          initialItem!.id!,
          coupleId: coupleId,
          payerId: selectedPayerId.value ?? userId,
          splitMethod: splitMethod.value,
          splits: splitsPayload,
        );
      } else {
        await transactionController.updateTransaction(dto, initialItem!.id!);
      }
      Get.back();
      AppHelperFunction.showSuccessSnackBar('Cập nhật giao dịch thành công');
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
    splitPctMeController.dispose();
    splitPctPartnerController.dispose();
    splitAmtMeController.dispose();
    splitAmtPartnerController.dispose();
    payerNameController.dispose();
    splitMethodNameController.dispose();
    super.onClose();
  }
}
