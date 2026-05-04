import 'package:get/get.dart';
import 'package:money_care/features/wallet/domain/entities/wallet_entity.dart';
import 'package:money_care/features/wallet/domain/repositories/wallet_repository.dart';
import 'package:money_care/app/controllers/app_controller.dart';
import 'package:money_care/core/utils/helper/helper_functions.dart';

class WalletController extends GetxController {
  final WalletRepository repository;

  WalletController({required this.repository});

  var wallets = <WalletEntity>[].obs;
  var totalAssets = 0.0.obs;
  var isLoading = false.obs;
  var selectedWallet = Rxn<WalletEntity>();

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
    } catch (e) {} finally {
      isLoading.value = false;
    }
  }

  Future<void> createWallet(String name, double balance, {String? icon, String? color}) async {
    isLoading.value = true;
    try {
      await repository.create({
        'name': name,
        'balance': balance,
        'icon': icon,
        'color': color,
      });
      await refreshWallets();
      wallets.refresh();
      AppHelperFunction.showSuccessSnackBar('Đã tạo $name thành công');
    } catch (e) {
      AppHelperFunction.showErrorSnackBar('Không thể tạo ví: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> autoCreateNextWallet() async {
    final nextNumber = wallets.length + 1;
    final name = "Ví $nextNumber";
    await createWallet(name, 0.0, icon: "💰", color: "#4CAF50");
  }

  Future<void> updateWallet(int id, String name, {String? icon, String? color, bool? isActive, bool? isPrimary}) async {
    isLoading.value = true;
    try {
      await repository.update(id, {
        'name': name,
        if (icon != null) 'icon': icon,
        if (color != null) 'color': color,
        if (isActive != null) 'is_active': isActive,
        if (isPrimary != null) 'is_primary': isPrimary,
      });
      await refreshWallets();
      AppHelperFunction.showSuccessSnackBar('Cập nhật ví thành công');
    } catch (e) {
      AppHelperFunction.showErrorSnackBar('Cập nhật thất bại: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteWallet(int id) async {
    isLoading.value = true;
    try {
      await repository.delete(id);
      await refreshWallets();
      AppHelperFunction.showSuccessSnackBar('Đã xóa ví thành công');
    } catch (e) {
      AppHelperFunction.showErrorSnackBar('Xóa ví thất bại: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> transfer(int fromId, int toId, double amount, {double fee = 0, String? note, int? categoryId}) async {
    isLoading.value = true;
    try {
      await repository.transfer({
        'fromWalletId': fromId,
        'toWalletId': toId,
        'amount': amount,
        'fee': fee,
        if (note != null) 'note': note,
        if (categoryId != null) 'categoryId': categoryId,
      });
      await refreshWallets();
    } catch (e) {
      rethrow;
    } finally {
      isLoading.value = false;
    }
  }
}
