import 'package:get/get.dart';
import 'package:money_care/core/constants/route_path.dart';
import 'package:money_care/core/controllers/app_controller.dart';
import 'package:money_care/core/errors/failure.dart';
import 'package:money_care/core/storage/local_storage.dart';
import 'package:money_care/core/utils/helper/helper_functions.dart';
import 'package:money_care/features/auth/data/models/user_model.dart';
import 'package:money_care/features/saving_fund/data/models/models.dart';
import 'package:money_care/features/saving_fund/domain/entities/saving_fund_entity.dart';
import 'package:money_care/features/saving_fund/domain/usecases/usecases.dart';
import 'package:money_care/features/auth/presentation/controllers/auth_controller.dart';
import 'package:money_care/features/user/presentation/controllers/user_controller.dart';

class SavingFundController extends GetxController {
  final GetSavingFundsByUserUseCase getSavingFundsByUserUseCase;
  final GetSavingFundUseCase getSavingFundUseCase;
  final UpdateSavingFundUseCase updateSavingFundUseCase;
  final DeleteSavingFundUseCase deleteSavingFundUseCase;
  final SelectSavingFundUseCase selectSavingFundUseCase;
  final AppController appController = Get.find<AppController>();
  final UserController userController = Get.find<UserController>();

  SavingFundController({
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
  RxInt selectedFundIndex = 0.obs;

  @override
  void onInit() {
    super.onInit();
    final authController = Get.find<AuthController>();
    ever(authController.user, (user) {
      if (user != null && user.savingFund != null) {
        currentFund.value = user.savingFund;
        fundId.value = user.savingFund!.id;
      }
    });

    if (authController.user.value?.savingFund != null) {
      currentFund.value = authController.user.value!.savingFund;
      fundId.value = authController.user.value!.savingFund!.id;
      loadFundById();
    }

    ever(fundId, (_) {
      if (fundId.value > 0) {
        loadFundById();
      }
    });
  }

  void updateFundId(int id) {
    fundId.value = id;
  }

  Future<void> loadFunds(int userId) async {
    isLoadingFunds.value = true;
    final result = await getSavingFundsByUserUseCase(userId);
    result.fold(_handleFailure, (list) {
      savingFunds.assignAll(list);
    });
    isLoadingFunds.value = false;
  }

  Future<void> loadUserAndFunds() async {
    isLoadingFunds.value = true;

    final userInfoJson = LocalStorage().getUserInfo();
    if (userInfoJson == null) {
      _showError('Không thể xác định người dùng hiện tại');
      isLoadingFunds.value = false;
      return;
    }

    try {
      final user = UserModel.fromJson(userInfoJson, '');
      final result = await getSavingFundsByUserUseCase(user.id);
      result.fold(_handleFailure, (list) {
        savingFunds.assignAll(list);
        selectedFundIndex.value = savingFunds.indexWhere(
          (f) => f.id == fundId.value,
        );
        if (selectedFundIndex.value == -1) {
          selectedFundIndex.value = 0;
        }
      });
    } catch (_) {
      _showError('Không thể xác định người dùng hiện tại');
    } finally {
      isLoadingFunds.value = false;
    }
  }

  Future<void> initializeSelectSavingFund() async {
    await loadUserAndFunds();
  }

  void updateSelectedFundIndex(int index) {
    selectedFundIndex.value = index;
  }

  void goToCreateSavingFund() {
    Get.toNamed(RoutePath.createSavingFund);
  }

  Future<void> loadFundById() async {
    isLoadingCurrent.value = true;
    final result = await getSavingFundUseCase(fundId.value);
    result.fold(_handleFailure, (fund) {
      currentFund.value = fund;
    });
    isLoadingCurrent.value = false;
  }

  Future<bool> selectSavingFund(int userId, int id) async {
    isLoadingCurrent.value = true;
    final result = await selectSavingFundUseCase(userId, id);
    final isSuccess = result.fold(
      (failure) {
        _handleFailure(failure);
        return false;
      },
      (selected) {
        fundId.value = id;
        currentFund.value = selected;
        loadFunds(userId);
        return true;
      },
    );
    isLoadingCurrent.value = false;
    return isSuccess;
  }

  Future<void> confirmSelectedFund() async {
    if (savingFunds.isEmpty) return;

    final selectedFund = savingFunds[selectedFundIndex.value];
    final currentUserId = appController.userId.value ?? 0;

    final isSuccess = await selectSavingFund(currentUserId, selectedFund.id);
    if (!isSuccess) {
      return;
    }

    Get.toNamed(RoutePath.main);
  }

  Future<bool> updateFund(SavingFundDto dto) async {
    isLoadingFunds.value = true;
    final result = await updateSavingFundUseCase(dto);
    final isSuccess = result.fold(
      (failure) {
        _handleFailure(failure);
        return false;
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
        AppHelperFunction.showSuccessSnackBar(
          'Cập nhật quỹ tiết kiệm thành công',
        );
        return true;
      },
    );
    isLoadingFunds.value = false;
    return isSuccess;
  }

  Future<bool> deleteFund(int id) async {
    isLoadingFunds.value = true;
    final result = await deleteSavingFundUseCase(id);
    final isSuccess = result.fold(
      (failure) {
        _handleFailure(failure);
        return false;
      },
      (_) {
        savingFunds.removeWhere((f) => f.id == id);
        savingFunds.refresh();

        if (currentFund.value?.id == id) {
          currentFund.value = null;
          fundId.value = 0;
        }
        AppHelperFunction.showSuccessSnackBar(
          'Xóa quỹ tiết kiệm thành công',
        );
        return true;
      },
    );
    isLoadingFunds.value = false;
    return isSuccess;
  }

  void _handleFailure(Failure failure) {
    _showError(failure.message);
  }

  void _showError(String message) {
    errorMessage?.value = message;
    AppHelperFunction.showErrorSnackBar(message);
  }

  int get currentFundId => fundId.value;

  SavingFundEntity? get selectedFund => currentFund.value;
}
