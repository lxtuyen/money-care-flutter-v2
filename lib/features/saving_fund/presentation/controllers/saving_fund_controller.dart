import 'package:money_care/features/saving_fund/data/models/models.dart';
import 'package:get/get.dart';
import 'package:money_care/features/saving_fund/domain/entities/saving_fund_entity.dart';
import 'package:money_care/features/saving_fund/domain/usecases/usecases.dart';
import 'package:money_care/core/storage/local_storage.dart';
import 'package:money_care/features/auth/data/models/user_model.dart';
import 'package:money_care/features/transaction/domain/entities/category_entity.dart';
import 'package:flutter/material.dart';

class SavingFundController extends GetxController {
  final CreateSavingFundUseCase createSavingFundUseCase;
  final GetSavingFundsByUserUseCase getSavingFundsByUserUseCase;
  final GetSavingFundUseCase getSavingFundUseCase;
  final UpdateSavingFundUseCase updateSavingFundUseCase;
  final DeleteSavingFundUseCase deleteSavingFundUseCase;
  final SelectSavingFundUseCase selectSavingFundUseCase;

  SavingFundController({
    required this.createSavingFundUseCase,
    required this.getSavingFundsByUserUseCase,
    required this.getSavingFundUseCase,
    required this.updateSavingFundUseCase,
    required this.deleteSavingFundUseCase,
    required this.selectSavingFundUseCase,
  });

  RxList<SavingFundEntity> savingFunds = <SavingFundEntity>[].obs;
  Rxn<SavingFundEntity> currentFund = Rxn<SavingFundEntity>();
  RxBool isLoadingFunds = false.obs;
  RxBool isLoadingCurrent = false.obs;
  RxString? errorMessage = RxString('');
  var fundId = 0.obs;

  Rxn<int> currentUserId = Rxn<int>();
  RxInt selectedFundIndex = 0.obs;

  RxList<CategoryEntity> categories = <CategoryEntity>[].obs;
  Rxn<int> userId = Rxn<int>();
  late final Rx<int> totalPercentage = Rx<int>(0);

  Rxn<double> targetAmount = Rxn<double>();
  Rxn<DateTime> startDate = Rxn<DateTime>();
  Rxn<DateTime> endDate = Rxn<DateTime>();

  @override
  void onInit() {
    super.onInit();
    ever(fundId, (_) {
      if (fundId.value > 0) {
        loadFundById();
      }
    });
    ever(categories, (_) {
      _updateTotalPercentage();
    });
  }

  void initializeCategoryDefaults() {
    categories.clear();
    categories.addAll([
      CategoryEntity(icon: 'charity_icon', name: 'Ăn uống', percentage: 0),
      CategoryEntity(icon: 'pleasure_icon', name: 'Mua sắm', percentage: 0),
      CategoryEntity(icon: 'savings_icon', name: 'Di chuyển', percentage: 0),
      CategoryEntity(icon: 'essential_icon', name: 'Hóa đơn', percentage: 0),
      CategoryEntity(icon: 'education_icon', name: 'Giáo dục', percentage: 0),
      CategoryEntity(icon: 'freedom_icon', name: 'Khác', percentage: 0),
    ]);
    categories.refresh();
  }

  Future<void> initializeUserInfo() async {
    try {
      final userInfoJson = LocalStorage().getUserInfo();
      if (userInfoJson == null) return;

      final user = UserModel.fromJson(userInfoJson, '');
      userId.value = user.id;
    } catch (e) {
      errorMessage?.value = e.toString();
    }
  }

  void updateCategoryPercentage(int index, int newPercentage) {
    if (index < 0 || index >= categories.length) return;

    final category = categories[index];
    final updatedCategory = CategoryEntity(
      id: category.id,
      name: category.name,
      percentage: newPercentage,
      icon: category.icon,
      color: category.color,
    );

    categories[index] = updatedCategory;
    categories.refresh();
  }

  bool validatePercentages() {
    return totalPercentage.value == 100;
  }

  void _updateTotalPercentage() {
    final sum = categories.fold<int>(0, (sum, cat) => sum + cat.percentage);
    totalPercentage.value = sum;
  }

  void updateFundId(int id) {
    fundId.value = id;
  }

  Future<void> loadFunds(int userId) async {
    try {
      isLoadingFunds.value = true;
      final result = await getSavingFundsByUserUseCase(userId);
      result.fold(
        (failure) {
          _showError(failure.message);
        },
        (list) {
          savingFunds.assignAll(list);
        },
      );
    } catch (e) {
      _showError('Failed to load funds: $e');
    } finally {
      isLoadingFunds.value = false;
    }
  }

  Future<void> loadUserAndFunds() async {
    try {
      isLoadingFunds.value = true;
      Map<String, dynamic> userInfoJson = LocalStorage().getUserInfo()!;
      UserModel user = UserModel.fromJson(userInfoJson, '');
      await loadFunds(user.id);

      currentUserId.value = user.id;
      selectedFundIndex.value = savingFunds.indexWhere(
        (f) => f.id == fundId.value,
      );
      if (selectedFundIndex.value == -1) selectedFundIndex.value = 0;
    } catch (e) {
      _showError('Failed to load user and funds: $e');
    } finally {
      isLoadingFunds.value = false;
    }
  }

  void updateSelectedFundIndex(int index) {
    selectedFundIndex.value = index;
  }

  Future<void> loadFundById() async {
    try {
      isLoadingCurrent.value = true;
      final result = await getSavingFundUseCase(fundId.value);
      result.fold(
        (failure) {
          _showError(failure.message);
        },
        (fund) {
          currentFund.value = fund;
        },
      );
    } catch (e) {
      _showError('Failed to load fund: $e');
    } finally {
      isLoadingCurrent.value = false;
    }
  }

  Future<void> selectSavingFund(int userId, int id) async {
    try {
      isLoadingCurrent.value = true;

      final result = await selectSavingFundUseCase(userId, id);
      result.fold(
        (failure) {
          _showError(failure.message);
        },
        (selected) {
          fundId.value = id;
          currentFund.value = selected;
          loadFunds(userId);
        },
      );
    } catch (e) {
      _showError('Failed to select fund: $e');
    } finally {
      isLoadingCurrent.value = false;
    }
  }

  Future<void> createFund(SavingFundDto dto) async {
    try {
      isLoadingFunds.value = true;
      final result = await createSavingFundUseCase(dto);
      result.fold(
        (failure) {
          _showError(failure.message);
        },
        (fund) {
          savingFunds.add(fund);
          savingFunds.refresh();
          categories.clear();
          userId.value = null;
          totalPercentage.value = 0;
          targetAmount.value = null;
          startDate.value = null;
          endDate.value = null;
          Get.snackbar(
            'Thành công',
            'Tạo quỹ tiết kiệm thành công',
            snackPosition: SnackPosition.BOTTOM,
            duration: Duration(seconds: 2),
          );
        },
      );
    } catch (e) {
      _showError('Failed to create fund: $e');
    } finally {
      isLoadingFunds.value = false;
    }
  }

  Future<void> updateFund(SavingFundDto dto) async {
    try {
      isLoadingFunds.value = true;
      final result = await updateSavingFundUseCase(dto);
      result.fold(
        (failure) {
          _showError(failure.message);
        },
        (updated) {
          final index = savingFunds.indexWhere((f) => f.id == dto.id);
          if (index != -1) {
            savingFunds[index] = updated;
            savingFunds.refresh();
          }

          if (currentFund.value?.id == dto.id) {
            currentFund.value = updated;
          }
          Get.snackbar(
            'Thành công',
            'Cập nhật quỹ tiết kiệm thành công',
            snackPosition: SnackPosition.BOTTOM,
            duration: Duration(seconds: 2),
          );
        },
      );
    } catch (e) {
      _showError('Failed to update fund: $e');
    } finally {
      isLoadingFunds.value = false;
    }
  }

  Future<void> deleteFund(int id) async {
    try {
      isLoadingFunds.value = true;
      final result = await deleteSavingFundUseCase(id);
      result.fold(
        (failure) {
          _showError(failure.message);
        },
        (_) {
          savingFunds.removeWhere((f) => f.id == id);
          savingFunds.refresh();

          if (currentFund.value?.id == id) {
            currentFund.value = null;
            fundId.value = 0;
          }
          Get.snackbar(
            'Thành công',
            'Xóa quỹ tiết kiệm thành công',
            snackPosition: SnackPosition.BOTTOM,
            duration: Duration(seconds: 2),
          );
        },
      );
    } catch (e) {
      _showError('Failed to delete fund: $e');
    } finally {
      isLoadingFunds.value = false;
    }
  }

  void _showError(String message) {
    errorMessage?.value = message;
    Get.snackbar(
      'Lỗi',
      message,
      snackPosition: SnackPosition.BOTTOM,
      duration: Duration(seconds: 3),
      backgroundColor: Colors.red.withOpacity(0.8),
      colorText: Colors.white,
      icon: Icon(Icons.error, color: Colors.white),
      margin: EdgeInsets.all(10),
      borderRadius: 8,
    );
  }

  int get currentFundId => fundId.value;

  SavingFundEntity? get selectedFund => currentFund.value;
}
