import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:money_care/app/widgets/layout/app_header.dart';
import 'package:money_care/core/theme/app_theme_colors.dart';
import 'package:money_care/features/wallet/presentation/controllers/wallet_controller.dart';
import 'package:money_care/features/wallet/domain/entities/wallet_entity.dart';
import 'package:money_care/features/transaction/presentation/controllers/user_category_controller.dart';
import 'package:money_care/core/utils/helper/helper_functions.dart';
import 'package:money_care/core/constants/colors.dart';
import 'package:money_care/app/widgets/button/primary_button.dart';
import 'package:money_care/app/widgets/text_field/app_currency_form_field.dart';
import 'package:money_care/features/couple/presentation/controllers/couple_controller.dart';

class WalletTransferScreen extends StatefulWidget {
  const WalletTransferScreen({super.key});

  @override
  State<WalletTransferScreen> createState() => _WalletTransferScreenState();
}

class _WalletTransferScreenState extends State<WalletTransferScreen> {
  final controller = Get.find<WalletController>();
  final amountController = TextEditingController();
  final noteController = TextEditingController();

  int? fromWalletId;
  int? toWalletId;
  bool lockToWallet = false;
  bool coupleMode = false;

  List<WalletEntity> get availableWallets {
    final List<WalletEntity> list = [...controller.wallets];
    if (Get.isRegistered<CoupleController>()) {
      final coupleController = Get.find<CoupleController>();
      for (final sw in coupleController.sharedWallets) {
        if (!list.any((w) => w.id == sw.id)) {
          list.add(sw);
        }
      }
    }
    return list;
  }

  List<WalletEntity> get destinationWallets {
    if (!coupleMode) return availableWallets;
    if (!Get.isRegistered<CoupleController>()) return availableWallets;
    final coupleController = Get.find<CoupleController>();
    final sharedIds = coupleController.sharedWallets.map((w) => w.id).toSet();
    return availableWallets.where((w) => sharedIds.contains(w.id)).toList();
  }

  @override
  void initState() {
    super.initState();

    // Support pre-filling from route arguments (e.g. from goal achievement hint)
    final args = Get.arguments;
    final int? argFrom =
        args is Map ? (args['fromWalletId'] as num?)?.toInt() : null;
    final int? argTo =
        args is Map ? (args['toWalletId'] as num?)?.toInt() : null;
    final double? argAmount =
        args is Map ? (args['amount'] as num?)?.toDouble() : null;
    lockToWallet =
        args is Map ? (args['lockToWallet'] as bool?) == true : false;
    coupleMode =
        args is Map ? (args['coupleMode'] as bool?) == true : false;

    if (argAmount != null && argAmount > 0) {
      amountController.text = argAmount.toStringAsFixed(0);
    }

    final walletsList = availableWallets;
    if (walletsList.isNotEmpty) {
      if (argTo != null &&
          walletsList.any((w) => w.id == argTo)) {
        toWalletId = argTo;
      }

      if (argFrom != null &&
          walletsList.any((w) => w.id == argFrom)) {
        fromWalletId = argFrom;
      }

      // Fallback: auto-select source wallet if not provided via args
      if (fromWalletId == null) {
        final positiveWallets = walletsList
            .where((w) => w.balance > 0 && w.id != toWalletId)
            .toList();
        if (positiveWallets.isNotEmpty) {
          // Pick the wallet with the highest balance
          positiveWallets.sort((a, b) => b.balance.compareTo(a.balance));
          fromWalletId = positiveWallets.first.id;
        }
      }
      if (toWalletId == null) {
        final destWallets = destinationWallets;
        if (destWallets.isNotEmpty) {
          final candidate = destWallets
              .firstWhereOrNull((w) => w.id != fromWalletId);
          toWalletId = candidate?.id ?? destWallets.first.id;
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppThemeColors.of(context);

    return Scaffold(
      backgroundColor: colors.surfaceBackground,
      body: SafeArea(
        child: Column(
          children: [
            AppHeader(title: "Chuyển tiền", showBackButton: true, height: 140),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildWalletSelector(
                      "Từ ví",
                      fromWalletId,
                      (v) => setState(() => fromWalletId = v),
                      isSource: true,
                      icon: Icons.upload_rounded,
                    ),
                    const SizedBox(height: 16),
                    _buildWalletSelector(
                      "Đến ví",
                      toWalletId,
                      (v) => setState(() => toWalletId = v),
                      icon: Icons.download_rounded,
                      locked: lockToWallet,
                    ),
                    const SizedBox(height: 24),
                    AppCurrencyFormField(
                      controller: amountController,
                      label: "Số tiền chuyển",
                      hintText: "0",
                      icon: Icons.swap_horiz_rounded,
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: noteController,
                      maxLines: 3,
                      style: TextStyle(color: colors.textPrimary, fontSize: 15),
                      decoration: InputDecoration(
                        labelText: "Ghi chú",
                        alignLabelWithHint: true,
                        prefixIcon: Padding(
                          padding: const EdgeInsets.only(bottom: 40),
                          child: Icon(
                            Icons.description_rounded,
                            color: AppColors.primary,
                            size: 22,
                          ),
                        ),
                        filled: true,
                        fillColor: AppColors.backgroundSecondary,
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(18),
                          borderSide: const BorderSide(
                            color: AppColors.borderSecondary,
                            width: 1.2,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(18),
                          borderSide: const BorderSide(
                            color: AppColors.primary,
                            width: 1.8,
                          ),
                        ),
                        contentPadding: const EdgeInsets.all(18),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
              child: Obx(
                () => PrimaryButton(
                  label: "Thực hiện chuyển tiền",
                  isLoading: controller.isLoading.value,
                  onPressed: _handleTransfer,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWalletSelector(
    String label,
    int? selectedId,
    Function(int?) onChanged, {
    bool isSource = false,
    required IconData icon,
    bool locked = false,
  }) {
    final colors = AppThemeColors.of(context);
    final selectedWallet = availableWallets
        .where((w) => w.id == selectedId)
        .firstOrNull;

    return InkWell(
      onTap: locked
          ? null
          : () => _showWalletPicker(label, selectedId, onChanged, isSource),
      borderRadius: BorderRadius.circular(18),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
        decoration: BoxDecoration(
          color: locked
              ? AppColors.backgroundSecondary.withValues(alpha: 0.7)
              : AppColors.backgroundSecondary,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: AppColors.borderSecondary, width: 1.2),
        ),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: Icon(icon, color: AppColors.primary, size: 22),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      label,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: AppColors.text3,
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 2),
                    if (selectedWallet != null)
                      Builder(builder: (_) {
                        final isShared = Get.isRegistered<CoupleController>() &&
                            Get.find<CoupleController>()
                                .sharedWallets
                                .any((sw) => sw.id == selectedWallet.id);
                        final prefix = isShared ? "👥 [Chung] " : "💰 ";
                        return Text(
                          "$prefix${selectedWallet.name}",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: colors.textPrimary,
                          ),
                        );
                      })
                    else
                      Text(
                        "Chọn ví...",
                        style: TextStyle(color: colors.textHint, fontSize: 15),
                      ),
                  ],
                ),
              ),
            ),
            if (selectedWallet != null)
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: Text(
                  AppHelperFunction.formatAmount(selectedWallet.balance),
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: selectedWallet.balance < 0
                        ? AppColors.expense
                        : AppColors.income,
                  ),
                ),
              ),
            if (locked)
              const Padding(
                padding: EdgeInsets.only(right: 12),
                child: Icon(
                  Icons.lock_rounded,
                  color: AppColors.text3,
                  size: 18,
                ),
              )
            else ...[
              const Icon(
                Icons.keyboard_arrow_down_rounded,
                color: AppColors.text3,
              ),
              const SizedBox(width: 12),
            ],
          ],
        ),
      ),
    );
  }

  void _showWalletPicker(
    String title,
    int? selectedId,
    Function(int?) onChanged,
    bool isSource,
  ) {
    final colors = AppThemeColors.of(context);
    var walletsList = isSource ? availableWallets : destinationWallets;
    // When destination wallet is locked, exclude it from source picker
    if (isSource && lockToWallet && toWalletId != null) {
      walletsList = walletsList.where((w) => w.id != toWalletId).toList();
    }

    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.symmetric(vertical: 24),
        decoration: BoxDecoration(
          color: colors.cardBackground,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: colors.textPrimary,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Flexible(
              child: ListView.separated(
                shrinkWrap: true,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: walletsList.length,
                separatorBuilder: (_, _) => const SizedBox(height: 8),
                itemBuilder: (context, index) {
                  final wallet = walletsList[index];
                  final bool isDisabled = isSource && wallet.balance <= 0;
                  final bool isSelected = wallet.id == selectedId;

                  return InkWell(
                    onTap: isDisabled
                        ? null
                        : () {
                            onChanged(wallet.id);
                            Get.back();
                          },
                    borderRadius: BorderRadius.circular(16),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppColors.primary.withValues(alpha: 0.05)
                            : (isDisabled
                                  ? colors.surfaceBackground.withValues(
                                      alpha: 0.5,
                                    )
                                  : Colors.transparent),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: isSelected
                              ? AppColors.primary.withValues(alpha: 0.3)
                              : Colors.transparent,
                          width: 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              color:
                                  (isDisabled
                                          ? colors.textMuted
                                          : AppColors.primary)
                                      .withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Center(
                              child: Text('💰', style: TextStyle(fontSize: 22)),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  Get.isRegistered<CoupleController>() &&
                                          Get.find<CoupleController>()
                                              .sharedWallets
                                              .any((sw) => sw.id == wallet.id)
                                      ? "👥 [Chung] ${wallet.name}"
                                      : "👤 [Cá nhân] ${wallet.name}",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: isDisabled
                                        ? colors.textMuted
                                        : colors.textPrimary,
                                  ),
                                ),
                                if (isDisabled)
                                  Text(
                                    "Số dư không khả dụng",
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: AppColors.expense.withValues(
                                        alpha: 0.7,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                AppHelperFunction.formatAmount(wallet.balance),
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                  color: isDisabled
                                      ? colors.textMuted
                                      : (wallet.balance < 0
                                            ? AppColors.expense
                                            : AppColors.income),
                                  decoration: isDisabled
                                      ? TextDecoration.lineThrough
                                      : null,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
      isScrollControlled: true,
    );
  }

  void _handleTransfer() async {
    if (fromWalletId == null || toWalletId == null) {
      AppHelperFunction.showErrorSnackBar("Vui lòng chọn cả ví gửi và ví nhận");
      return;
    }

    if (fromWalletId == toWalletId) {
      AppHelperFunction.showErrorSnackBar(
        "Ví gửi và ví nhận không được trùng nhau",
      );
      return;
    }

    final amount =
        double.tryParse(
          AppHelperFunction.unformatCurrency(amountController.text),
        ) ??
        0;

    if (amount <= 0) {
      AppHelperFunction.showErrorSnackBar("Số tiền chuyển phải lớn hơn 0");
      return;
    }

    final fromWallet = availableWallets.firstWhere(
      (w) => w.id == fromWalletId,
    );
    if (fromWallet.balance <= 0) {
      AppHelperFunction.showErrorSnackBar(
        "Ví '${fromWallet.name}' không có số dư để thực hiện chuyển tiền",
      );
      return;
    }

    if (fromWallet.balance < amount) {
      AppHelperFunction.showErrorSnackBar(
        "Số dư ví không đủ để thực hiện chuyển khoản",
      );
      return;
    }

    try {
      final categoryController = Get.find<UserCategoryController>();
      final categoryId = await categoryController.getOrCreateTransferCategory();

      await controller.transfer(
        fromWalletId!,
        toWalletId!,
        amount,
        note: noteController.text.trim(),
        categoryId: categoryId,
      );
      if (Get.isRegistered<CoupleController>()) {
        final coupleController = Get.find<CoupleController>();
        await coupleController.fetchSharedWallets();
        await coupleController.fetchSavingGoals();
      }
      Get.back();
      AppHelperFunction.showSuccessSnackBar("Chuyển tiền thành công");
    } catch (e) {
      AppHelperFunction.showErrorSnackBar(e.toString());
    }
  }
}
