import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:money_care/features/wallet/data/models/transfer_dto.dart';
import 'package:money_care/features/wallet/data/models/update_wallet_dto.dart';
import 'package:money_care/features/wallet/domain/entities/wallet_entity.dart';
import 'package:money_care/features/wallet/domain/repositories/wallet_repository.dart';
import 'package:money_care/app/controllers/app_controller.dart';
import 'package:money_care/app/controllers/saving_goal_controller.dart';
import 'package:money_care/core/utils/helper/helper_functions.dart';
import 'package:money_care/features/transaction/domain/entities/transaction_entity.dart';
import 'package:money_care/features/transaction/data/models/transaction_filter_dto.dart';
import 'package:money_care/app/controllers/transaction_controller.dart';

class WalletController extends GetxController {
  final WalletRepository repository;

  WalletController({required this.repository});

  var wallets = <WalletEntity>[].obs;
  var totalAssets = 0.0.obs;
  var isLoading = false.obs;
  var selectedWallet = Rxn<WalletEntity>();

  final RxList<TransactionEntity> walletTransactions =
      <TransactionEntity>[].obs;
  final RxBool isLoadingTransactions = false.obs;

  @override
  void onInit() {
    super.onInit();
    final appController = Get.find<AppController>();
    ever(appController.userId, (int? userId) {
      if (userId != null) {
        refreshWallets();
      } else {
        wallets.clear();
        totalAssets.value = 0.0;
      }
    });

    if (appController.userId.value != null) {
      refreshWallets();
    }
  }

  Future<void> refreshWallets() async {
    isLoading.value = true;
    try {
      final list = await repository.findAll();
      wallets.assignAll(list);

      final total = await repository.getTotalAssets();
      totalAssets.value = total;

      if (wallets.isNotEmpty && selectedWallet.value == null) {
        selectedWallet.value = wallets.first;
      }
    } catch (e) {
      debugPrint('Error refreshing wallets: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> createWallet() async {
    isLoading.value = true;
    try {
      await repository.create({});
      await refreshWallets();
      wallets.refresh();
      AppHelperFunction.showSuccessSnackBar('Tạo ví thành công');
    } catch (e) {
      AppHelperFunction.showErrorSnackBar('Không thể tạo ví: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateWallet(int id, String name, {bool? isActive}) async {
    isLoading.value = true;
    try {
      await repository.update(
        id,
        UpdateWalletDto(name: name, isActive: isActive),
      );
      await refreshWallets();
      AppHelperFunction.showSuccessSnackBar('Cập nhật ví thành công');
    } catch (e) {
      AppHelperFunction.showErrorSnackBar('Cập nhật thất bại: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> deleteWallet(
    int id, {
    bool showSuccessMessage = true,
    bool ignoreBalanceCheck = false,
  }) async {
    final wallet = wallets.firstWhereOrNull((item) => item.id == id);
    if (!ignoreBalanceCheck && wallet != null && wallet.balance != 0) {
      AppHelperFunction.showWarningSnackBar('Không thể xóa ví đang có số dư');
      return false;
    }

    isLoading.value = true;
    try {
      await repository.delete(id);
      await refreshWallets();
      return true;
    } catch (e) {
      AppHelperFunction.showErrorSnackBar('Xóa ví thất bại: $e');
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> transfer(
    int fromId,
    int toId,
    double amount, {
    String? note,
    int? categoryId,
  }) async {
    isLoading.value = true;
    try {
      await repository.transfer(
        TransferDto(
          fromWalletId: fromId,
          toWalletId: toId,
          amount: amount,
          note: note,
          categoryId: categoryId,
        ),
      );
      final appController = Get.find<AppController>();
      final userId = appController.userId.value;
      if (userId != null && Get.isRegistered<TransactionController>()) {
        await Get.find<TransactionController>().refreshAllData(userId);
      } else {
        await refreshWallets();
        if (userId != null) {
          if (Get.isRegistered<SavingGoalController>()) {
            final savingGoalController = Get.find<SavingGoalController>();
            await savingGoalController.loadGoals(userId);
            if (savingGoalController.goalId.value > 0) {
              await savingGoalController.loadGoalById();
            }
          }
        }
      }
    } catch (e) {
      rethrow;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchWalletTransactions(int walletId) async {
    isLoadingTransactions.value = true;
    try {
      final filter = TransactionFilterDto(
        walletId: walletId,
        limit: 50,
        includeTransfer: 'true',
      );
      final appController = Get.find<AppController>();
      final userId = appController.userId.value;
      if (userId != null) {
        final transactionController = Get.find<TransactionController>();
        final result = await transactionController.filterTransactionsUseCase(
          userId,
          filter,
        );
        final all = [
          ...result.expenseTransactions,
          ...result.incomeTransactions,
        ];
        all.sort(
          (a, b) => (b.transactionDate ?? DateTime.now()).compareTo(
            a.transactionDate ?? DateTime.now(),
          ),
        );
        walletTransactions.assignAll(all);
      }
    } catch (e) {
      debugPrint('Error fetching wallet transactions: $e');
    } finally {
      isLoadingTransactions.value = false;
    }
  }
}
