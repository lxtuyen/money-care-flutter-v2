import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:money_care/core/theme/app_theme_colors.dart';
import 'package:money_care/core/utils/helper/helper_functions.dart';
import 'package:money_care/features/auth/presentation/controllers/auth_controller.dart';
import 'package:money_care/features/couple/presentation/controllers/couple_controller.dart';
import 'package:money_care/features/transaction/domain/entities/transaction_entity.dart';
import 'package:money_care/features/transaction/presentation/controllers/user_category_controller.dart';
import 'package:money_care/features/wallet/domain/entities/wallet_entity.dart';

class CouplePhotoTransactionDetailController extends GetxController {
  final List<TransactionEntity> photoTransactions;
  final CoupleController coupleController;
  final RxInt currentIndex = 0.obs;
  
  PageController? pageController;

  CouplePhotoTransactionDetailController({
    required this.photoTransactions,
    required int initialIndex,
    required this.coupleController,
  }) {
    currentIndex.value = initialIndex;
  }

  TransactionEntity get currentTransaction => photoTransactions[currentIndex.value];

  // State Variables
  final RxDouble amount = 0.0.obs;
  final RxString note = ''.obs;
  final Rx<DateTime> selectedDate = DateTime.now().obs;
  final Rxn<CategoryEntity> selectedCategory = Rxn<CategoryEntity>();
  final Rxn<WalletEntity> selectedWallet = Rxn<WalletEntity>();
  final RxnInt selectedPayerId = RxnInt();
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    _loadInitialValues();
  }

  void setCurrentIndex(int index) {
    currentIndex.value = index;
    _loadInitialValues();
  }

  void resetChanges() {
    _loadInitialValues();
  }

  void _loadInitialValues() {
    final transaction = currentTransaction;
    amount.value = transaction.amount.toDouble();
    note.value = transaction.note ?? '';
    selectedDate.value = transaction.transactionDate ?? DateTime.now();
    selectedCategory.value = transaction.category;
    selectedPayerId.value = transaction.payerId;

    // Resolve initial wallet
    if (transaction.walletId != null) {
      selectedWallet.value = coupleController.sharedWallets
          .firstWhereOrNull((w) => w.id == transaction.walletId);
    } else {
      selectedWallet.value = null;
    }

    // Load categories if they are empty
    final categoryController = Get.find<UserCategoryController>();
    final authController = Get.find<AuthController>();
    final currentUserId = authController.user.value?.id;

    if (categoryController.categories.isEmpty && currentUserId != null) {
      categoryController.loadCategories(currentUserId);
    }
  }

  bool get hasChanges {
    final transaction = currentTransaction;
    final originalAmount = transaction.amount.toDouble();
    final originalNote = transaction.note ?? '';
    final originalDate = transaction.transactionDate ?? DateTime.now();
    final originalCategoryId = transaction.category?.id;
    final originalWalletId = transaction.walletId;
    final originalPayerId = transaction.payerId;

    return amount.value != originalAmount ||
        note.value != originalNote ||
        selectedDate.value.year != originalDate.year ||
        selectedDate.value.month != originalDate.month ||
        selectedDate.value.day != originalDate.day ||
        selectedDate.value.hour != originalDate.hour ||
        selectedDate.value.minute != originalDate.minute ||
        selectedCategory.value?.id != originalCategoryId ||
        selectedWallet.value?.id != originalWalletId ||
        selectedPayerId.value != originalPayerId;
  }

  Future<bool> saveChanges({bool closeScreen = true}) async {
    if (amount.value <= 0) {
      AppHelperFunction.showErrorSnackBar('Số tiền phải lớn hơn 0');
      return false;
    }
    if (selectedCategory.value == null) {
      AppHelperFunction.showErrorSnackBar('Vui lòng chọn danh mục');
      return false;
    }
    if (selectedWallet.value == null) {
      AppHelperFunction.showErrorSnackBar('Vui lòng chọn ví liên kết');
      return false;
    }
    if (selectedPayerId.value == null) {
      AppHelperFunction.showErrorSnackBar('Vui lòng chọn người thanh toán');
      return false;
    }

    isLoading.value = true;
    try {
      final transaction = currentTransaction;
      
      // Determine splitMethod dynamically (if paid from a shared wallet, it should not be split)
      final isSharedWallet = coupleController.sharedWallets
          .any((w) => w.id == selectedWallet.value?.id);
      final splitMethod = isSharedWallet ? 'none' : 'equal';

      // Re-map splits if present (only for personal wallet transactions)
      List<Map<String, dynamic>>? splits;
      if (!isSharedWallet && transaction.splits != null && transaction.splits!.isNotEmpty) {
        splits = transaction.splits!
            .map((s) => {
                  'userId': s.userId,
                  'amount': s.amount,
                  'percent': s.percent,
                })
            .toList();
      }

      await coupleController.editSharedTransaction(
        id: transaction.id!,
        amount: amount.value.toInt(),
        type: transaction.type,
        note: note.value,
        walletId: selectedWallet.value!.id,
        categoryId: selectedCategory.value!.id!,
        payerId: selectedPayerId.value!,
        date: selectedDate.value,
        splitMethod: splitMethod,
        splits: splits,
        pictureUrl: transaction.pictureUrl,
      );

      // Update the local list transaction object so it matches saved state
      photoTransactions[currentIndex.value] = TransactionEntity(
        id: transaction.id,
        amount: amount.value.toInt(),
        type: transaction.type,
        note: note.value,
        walletId: selectedWallet.value?.id,
        walletName: selectedWallet.value?.name,
        payerId: selectedPayerId.value,
        payerName: coupleController.couple.value?.members.firstWhereOrNull((m) => m.userId == selectedPayerId.value)?.fullName,
        transactionDate: selectedDate.value,
        pictureUrl: transaction.pictureUrl,
        category: selectedCategory.value,
        splits: isSharedWallet ? null : transaction.splits,
        splitMethod: splitMethod,
      );

      if (closeScreen) {
        Get.back();
      }
      return true;
    } catch (e) {
      AppHelperFunction.showErrorSnackBar('Có lỗi xảy ra: $e');
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteTransaction() async {
    isLoading.value = true;
    try {
      final idToDelete = currentTransaction.id!;
      final prevIndex = currentIndex.value;
      await coupleController.deleteSharedTransaction(idToDelete);
      
      photoTransactions.removeAt(prevIndex);
      if (photoTransactions.isEmpty) {
        Get.back(); // Return from details view
      } else {
        int nextIndex = prevIndex;
        if (nextIndex >= photoTransactions.length) {
          nextIndex = photoTransactions.length - 1;
        }
        currentIndex.value = nextIndex;
        _loadInitialValues();
        pageController?.jumpToPage(nextIndex);
      }
    } catch (e) {
      AppHelperFunction.showErrorSnackBar('Có lỗi xảy ra: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> selectDateTime(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate.value,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.dark(
              primary: Theme.of(context).primaryColor,
              surface: const Color(0xFF1E1E1E),
              onSurface: Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      if (!context.mounted) return;
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(selectedDate.value),
        builder: (context, child) {
          return Theme(
            data: Theme.of(context).copyWith(
              colorScheme: ColorScheme.dark(
                primary: Theme.of(context).primaryColor,
                surface: const Color(0xFF1E1E1E),
                onSurface: Colors.white,
              ),
            ),
            child: child!,
          );
        },
      );

      if (pickedTime != null) {
        selectedDate.value = DateTime(
          picked.year,
          picked.month,
          picked.day,
          pickedTime.hour,
          pickedTime.minute,
        );
      } else {
        selectedDate.value = picked;
      }
    }
  }

  void showAmountSheet() {
    final colors = AppThemeColors.of(Get.context!);
    final controller = TextEditingController(
      text: amount.value > 0
          ? AppHelperFunction.formatCurrency(amount.value.toInt().toString())
          : '',
    );
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: colors.dialogBackground,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Nhập số tiền',
              style: TextStyle(
                  color: colors.textPrimary,
                  fontSize: 16,
                  fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: controller,
              keyboardType: TextInputType.number,
              autofocus: true,
              style: TextStyle(
                  color: colors.textPrimary,
                  fontSize: 24,
                  fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                _AmountInputFormatter(),
              ],
              decoration: InputDecoration(
                hintText: '0đ',
                hintStyle: TextStyle(color: colors.textHint),
                suffixText: 'VND',
                suffixStyle:
                    TextStyle(color: colors.textSecondary, fontSize: 16),
                enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: colors.borderSecondary)),
                focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                        color: Theme.of(Get.context!).primaryColor)),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                final raw =
                    AppHelperFunction.unformatCurrency(controller.text.trim());
                final amt = double.tryParse(raw) ?? 0.0;
                amount.value = amt;
                Get.back();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(Get.context!).primaryColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text('Xác nhận',
                  style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }

  void showNoteSheet() {
    final colors = AppThemeColors.of(Get.context!);
    final controller = TextEditingController(text: note.value);
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: colors.dialogBackground,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Thêm ghi chú',
              style: TextStyle(
                  color: colors.textPrimary,
                  fontSize: 16,
                  fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: controller,
              textCapitalization: TextCapitalization.sentences,
              autofocus: true,
              style: TextStyle(color: colors.textPrimary, fontSize: 16),
              decoration: InputDecoration(
                hintText: 'Nhập nội dung ghi chú...',
                hintStyle: TextStyle(color: colors.textHint),
                enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: colors.borderSecondary)),
                focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                        color: Theme.of(Get.context!).primaryColor)),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                note.value = controller.text.trim();
                Get.back();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(Get.context!).primaryColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text('Xác nhận',
                  style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }

  void showCategorySelector() {
    final colors = AppThemeColors.of(Get.context!);
    final categoryController = Get.find<UserCategoryController>();

    Get.bottomSheet(
      Container(
        constraints: BoxConstraints(maxHeight: Get.height * 0.6),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: colors.dialogBackground,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Chọn danh mục',
              style: TextStyle(
                  color: colors.textPrimary,
                  fontSize: 16,
                  fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Obx(() {
                if (categoryController.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }

                final expenseCats = categoryController.categories
                    .where((c) => c.type == 'expense')
                    .toList();

                if (expenseCats.isEmpty) {
                  return Center(
                    child: Text(
                      'Không có danh mục nào',
                      style:
                          TextStyle(color: colors.textSecondary, fontSize: 14),
                    ),
                  );
                }

                return GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: 0.85,
                  ),
                  itemCount: expenseCats.length,
                  itemBuilder: (context, index) {
                    final cat = expenseCats[index];
                    final isSelected = selectedCategory.value?.id == cat.id;
                    return InkWell(
                      onTap: () {
                        selectedCategory.value = cat;
                        Get.back();
                      },
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        decoration: BoxDecoration(
                          color: isSelected
                              ? Theme.of(context)
                                  .primaryColor
                                  .withValues(alpha: 0.2)
                              : colors.surfaceBackground,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isSelected
                                ? Theme.of(context).primaryColor
                                : colors.borderSecondary,
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(cat.icon,
                                style: const TextStyle(fontSize: 24)),
                            const SizedBox(height: 8),
                            Text(
                              cat.name,
                              textAlign: TextAlign.center,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  color: colors.textPrimary, fontSize: 11),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  void showWalletSelector() {
    final colors = AppThemeColors.of(Get.context!);
    final savingWalletIds = coupleController.savingGoals
        .map((g) => g.walletId)
        .whereType<int>()
        .toSet();
    final nonSavingWallets = coupleController.sharedWallets
        .where((w) => w.savingGoals.isEmpty && !savingWalletIds.contains(w.id))
        .toList();

    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: colors.dialogBackground,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Chọn ví liên kết',
              style: TextStyle(
                  color: colors.textPrimary,
                  fontSize: 16,
                  fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            if (nonSavingWallets.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Text(
                  'Không có ví chi tiêu chung hợp lệ',
                  style: TextStyle(color: colors.textSecondary, fontSize: 14),
                  textAlign: TextAlign.center,
                ),
              )
            else
              ...nonSavingWallets.map((w) {
                final isSelected = selectedWallet.value?.id == w.id;
                return ListTile(
                  onTap: () {
                    selectedWallet.value = w;
                    Get.back();
                  },
                  leading: Icon(
                    Icons.account_balance_wallet_outlined,
                    color: isSelected
                        ? Theme.of(Get.context!).primaryColor
                        : colors.textSecondary,
                  ),
                  title:
                      Text(w.name, style: TextStyle(color: colors.textPrimary)),
                  trailing: isSelected
                      ? Icon(Icons.check_circle,
                          color: Theme.of(Get.context!).primaryColor)
                      : null,
                );
              }),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }

  void showPayerSelector() {
    final colors = AppThemeColors.of(Get.context!);
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: colors.dialogBackground,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Chọn người thanh toán',
              style: TextStyle(
                  color: colors.textPrimary,
                  fontSize: 16,
                  fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ...(coupleController.couple.value?.members ?? []).map((m) {
              final isSelected = selectedPayerId.value == m.userId;
              return ListTile(
                onTap: () {
                  selectedPayerId.value = m.userId;
                  Get.back();
                },
                leading: CircleAvatar(
                  backgroundColor: isSelected
                      ? Theme.of(Get.context!).primaryColor
                      : colors.surfaceBackground,
                  radius: 18,
                  child: Text(
                    m.initials,
                    style: TextStyle(
                      color: isSelected ? Colors.white : colors.textSecondary,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
                title: Text(m.fullName,
                    style: TextStyle(color: colors.textPrimary)),
                trailing: isSelected
                    ? Icon(Icons.check_circle,
                        color: Theme.of(Get.context!).primaryColor)
                    : null,
              );
            }),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }
}

class _AmountInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final rawValue = AppHelperFunction.unformatCurrency(newValue.text);
    final formattedValue = AppHelperFunction.formatCurrency(rawValue);

    return TextEditingValue(
      text: formattedValue,
      selection: TextSelection.collapsed(offset: formattedValue.length),
      composing: TextRange.empty,
    );
  }
}
