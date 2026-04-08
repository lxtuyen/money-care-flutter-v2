import 'package:get/get.dart';
import 'package:money_care/core/constants/route_path.dart';
import 'package:money_care/core/controllers/app_controller.dart';
import 'package:money_care/core/errors/failure.dart';
import 'package:money_care/core/storage/local_storage.dart';
import 'package:money_care/core/utils/helper/helper_functions.dart';
import 'package:money_care/features/auth/data/models/user_model.dart';
import 'package:money_care/features/fund/data/models/models.dart';
import 'package:money_care/features/fund/domain/entities/fund_entity.dart';
import 'package:money_care/features/fund/domain/usecases/usecases.dart';
import 'package:money_care/features/auth/presentation/controllers/auth_controller.dart';
import 'package:money_care/features/user/presentation/controllers/user_controller.dart';

class FundController extends GetxController {
  final GetFundsByUserUseCase getFundsByUserUseCase;
  final GetFundUseCase getFundUseCase;
  final UpdateFundUseCase updateFundUseCase;
  final DeleteFundUseCase deleteFundUseCase;
  final SelectFundUseCase selectFundUseCase;
  final CheckExpiredFundUseCase checkExpiredFundUseCase;
  final MarkAsNotifiedUseCase markAsNotifiedUseCase;
  final ExtendFundUseCase extendFundUseCase;
  final GetFundReportUseCase getFundReportUseCase;
  final AppController appController = Get.find<AppController>();
  final UserController userController = Get.find<UserController>();

  FundController({
    required this.getFundsByUserUseCase,
    required this.getFundUseCase,
    required this.updateFundUseCase,
    required this.deleteFundUseCase,
    required this.selectFundUseCase,
    required this.checkExpiredFundUseCase,
    required this.markAsNotifiedUseCase,
    required this.extendFundUseCase,
    required this.getFundReportUseCase,
  });

  RxList<FundEntity> funds = <FundEntity>[].obs;
  Rxn<FundEntity> currentFund = Rxn<FundEntity>();
  RxBool isLoadingFunds = false.obs;
  RxBool isLoadingCurrent = false.obs;
  RxString? errorMessage = RxString('');
  var fundId = 0.obs;
  RxInt selectedFundIndex = 0.obs;

  // Expired fund state
  Rxn<ExpiredFundInfoModel> expiredFund = Rxn<ExpiredFundInfoModel>();
  RxBool hasExpiredFund = false.obs;
  Rxn<FundReportModel> fundReport = Rxn<FundReportModel>();
  RxBool isLoadingReport = false.obs;

  @override
  void onInit() {
    super.onInit();
    final authController = Get.find<AuthController>();
    ever(authController.user, (user) {
      if (user != null && user.fund != null) {
        currentFund.value = user.fund;
        fundId.value = user.fund!.id;
      }
    });

    if (authController.user.value?.fund != null) {
      currentFund.value = authController.user.value!.fund;
      fundId.value = authController.user.value!.fund!.id;
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
    final result = await getFundsByUserUseCase(userId);
    result.fold(_handleFailure, (list) {
      funds.assignAll(list);
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
      final result = await getFundsByUserUseCase(user.id);
      result.fold(_handleFailure, (list) {
        funds.assignAll(list);
        selectedFundIndex.value = funds.indexWhere(
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

  Future<void> initializeSelectFund() async {
    await loadUserAndFunds();
  }

  void updateSelectedFundIndex(int index) {
    selectedFundIndex.value = index;
  }

  void goToCreateFund() {
    Get.toNamed(RoutePath.createFund);
  }

  Future<void> loadFundById() async {
    isLoadingCurrent.value = true;
    final result = await getFundUseCase(fundId.value);
    result.fold(_handleFailure, (fund) {
      currentFund.value = fund;
      loadFundReport(fund.id); // Tải thêm báo cáo để có dữ liệu tiến độ
    });
    isLoadingCurrent.value = false;
  }

  Future<bool> selectFund(int userId, int id) async {
    isLoadingCurrent.value = true;
    final result = await selectFundUseCase(userId, id);
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
    if (funds.isEmpty) return;

    final selectedFund = funds[selectedFundIndex.value];
    final currentUserId = appController.userId.value ?? 0;

    final isSuccess = await selectFund(currentUserId, selectedFund.id);
    if (!isSuccess) {
      return;
    }

    Get.toNamed(RoutePath.main);
  }

  Future<bool> updateFund(FundDto dto) async {
    isLoadingFunds.value = true;
    final result = await updateFundUseCase(dto);
    final isSuccess = result.fold(
      (failure) {
        _handleFailure(failure);
        return false;
      },
      (updated) {
        final index = funds.indexWhere((f) => f.id == dto.id);
        if (index != -1) {
          funds[index] = updated;
          funds.refresh();
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
    final result = await deleteFundUseCase(id);
    final isSuccess = result.fold(
      (failure) {
        _handleFailure(failure);
        return false;
      },
      (_) {
        funds.removeWhere((f) => f.id == id);
        funds.refresh();

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

  FundEntity? get selectedFund => currentFund.value;

  List<FundEntity> get expiredFunds {
    return funds.where((f) => f.isExpired).toList()
      ..sort((a, b) => b.endDate!.compareTo(a.endDate!));
  }

  // ============ EXPIRED FUND METHODS ============

  Future<void> checkExpiredFund(int userId) async {
    final result = await checkExpiredFundUseCase(userId);
    result.fold(
      (_) {}, // Silently fail - không interrupt UX
      (data) {
        hasExpiredFund.value = data.hasExpiredFund;
        expiredFund.value = data.expiredFund;
      },
    );
  }

  Future<void> markAsNotified(int fundId) async {
    await markAsNotifiedUseCase(fundId);
    hasExpiredFund.value = false;
    expiredFund.value = null;
  }

  Future<bool> extendFund(int fundId, DateTime newEndDate, {DateTime? newStartDate}) async {
    final result = await extendFundUseCase(fundId, newEndDate, newStartDate: newStartDate);
    return result.fold(
      (failure) {
        _handleFailure(failure);
        return false;
      },
      (updated) {
        hasExpiredFund.value = false;
        expiredFund.value = null;
        currentFund.value = updated as FundEntity?;
        AppHelperFunction.showSuccessSnackBar('Gia hạn quỹ thành công');
        return true;
      },
    );
  }

  Future<void> loadFundReport(int fundId) async {
    isLoadingReport.value = true;
    final result = await getFundReportUseCase(fundId);
    result.fold(
      _handleFailure,
      (report) => fundReport.value = report,
    );
    isLoadingReport.value = false;
  }
}
