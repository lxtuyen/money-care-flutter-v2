import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:money_care/app/controllers/app_controller.dart';
import 'package:money_care/app/controllers/transaction_controller.dart';
import 'package:money_care/app/widgets/layout/app_header.dart';
import 'package:money_care/app/widgets/button/app_action_button.dart';
import 'package:money_care/core/constants/colors.dart';
import 'package:money_care/core/theme/app_theme_colors.dart';
import 'package:money_care/core/utils/helper/helper_functions.dart';
import 'package:money_care/features/wallet/domain/entities/wallet_entity.dart';
import 'package:money_care/features/wallet/presentation/controllers/wallet_controller.dart';
import 'package:money_care/features/home/presentation/widgets/transaction/transaction_item.dart';
import 'package:money_care/features/transaction/domain/entities/transaction_entity.dart';
import 'package:money_care/features/transaction/data/models/transaction_filter_dto.dart';
import 'package:money_care/app/widgets/dialog/app_confirm_dialog.dart';
import 'package:money_care/app/widgets/states/app_empty_state.dart';

class WalletDetailScreen extends StatefulWidget {
  const WalletDetailScreen({super.key});

  @override
  State<WalletDetailScreen> createState() => _WalletDetailScreenState();
}

class _WalletDetailScreenState extends State<WalletDetailScreen> {
  final walletController = Get.find<WalletController>();
  final transactionController = Get.find<TransactionController>();
  
  late WalletEntity wallet;
  final RxList<TransactionEntity> walletTransactions = <TransactionEntity>[].obs;
  final RxBool isLoadingTransactions = false.obs;

  @override
  void initState() {
    super.initState();
    wallet = Get.arguments as WalletEntity;
    _fetchTransactions();
  }

  Future<void> _fetchTransactions() async {
    isLoadingTransactions.value = true;
    try {
      final filter = TransactionFilterDto(
        walletId: wallet.id,
        limit: 50,
        includeTransfer: 'true',
      );
      final userId = Get.find<AppController>().userId.value;
      if (userId != null) {
        final result = await transactionController.filterTransactionsUseCase(userId, filter);
        final all = [...result.expenseTransactions, ...result.incomeTransactions];
        all.sort((a, b) => (b.transactionDate ?? DateTime.now()).compareTo(a.transactionDate ?? DateTime.now()));
        walletTransactions.assignAll(all);
      }
    } catch (e) {
      debugPrint('Error fetching wallet transactions: $e');
    } finally {
      isLoadingTransactions.value = false;
    }
  }

  void _showEditDialog() {
    final nameController = TextEditingController(text: wallet.name);
    final colors = AppThemeColors.of(context);

    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          decoration: BoxDecoration(
            color: colors.cardBackground,
            borderRadius: BorderRadius.circular(28),
          ),
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Chỉnh sửa ví",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: colors.textPrimary,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                "Tên ví",
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: colors.textSecondary,
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: nameController,
                autofocus: true,
                style: TextStyle(color: colors.textPrimary, fontWeight: FontWeight.w500),
                decoration: InputDecoration(
                  hintText: "Nhập tên ví...",
                  filled: true,
                  fillColor: colors.surfaceBackground,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text("Hủy", style: TextStyle(color: colors.textSecondary)),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton(
                    onPressed: () async {
                      final name = nameController.text.trim();
                      if (name.isNotEmpty) {
                        await walletController.updateWallet(wallet.id, name);
                        setState(() {
                          wallet = walletController.wallets.firstWhere((w) => w.id == wallet.id);
                        });
                        if (!context.mounted) return;
                        Navigator.pop(context);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text("Lưu"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _confirmDelete() {
    AppConfirmDialog.show(
      title: "Xác nhận xóa",
      message: "Bạn có chắc chắn muốn xóa ví '${wallet.name}' không? Các giao dịch liên quan sẽ bị ảnh hưởng.",
      confirmText: "Xóa",
      cancelText: "Hủy",
      onConfirm: () async {
        await walletController.deleteWallet(wallet.id);
        Get.back();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppThemeColors.of(context);
    
    return Scaffold(
      backgroundColor: colors.surfaceBackground,
      body: Column(
        children: [
          AppHeader(
            title: wallet.name,
            showBackButton: true,
            height: 180,
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                AppHelperFunction.formatAmount(wallet.balance),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 36,
                  fontWeight: FontWeight.w900,
                  letterSpacing: -0.5,
                ),
              ),
            ),
          ),
          
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
            child: Row(
              children: [
                Expanded(
                  child: AppActionButton(
                    onTap: _showEditDialog,
                    icon: Icons.edit_outlined,
                    label: "Chỉnh sửa",
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: AppActionButton(
                    onTap: _confirmDelete,
                    icon: Icons.delete_outline_rounded,
                    label: "Xóa ví",
                    color: Colors.redAccent,
                  ),
                ),
              ],
            ),
          ),
          
          Expanded(
            child: Obx(() {
              if (isLoadingTransactions.value) {
                return const Center(child: CircularProgressIndicator());
              }
              
              if (walletTransactions.isEmpty) {
                return const AppEmptyState(
                  message: "Chưa có giao dịch nào cho ví này",
                );
              }
              
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
                    child: Text(
                      "Giao dịch gần đây",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: colors.textPrimary,
                      ),
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                      itemCount: walletTransactions.length,
                      itemBuilder: (context, index) {
                        final tx = walletTransactions[index];
                        return TransactionItem(
                          item: tx,
                          onTap: () {
                          },
                        );
                      },
                    ),
                  ),
                ],
              );
            }),
          ),
        ],
      ),
    );
  }
}

