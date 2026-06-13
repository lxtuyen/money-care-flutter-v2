import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:money_care/app/controllers/app_controller.dart';
import 'package:money_care/core/utils/helper/helper_functions.dart';
import 'package:money_care/features/couple/domain/entities/couple_entity.dart';
import 'package:money_care/features/couple/domain/usecases/couple_usecases.dart';
import 'package:money_care/features/transaction/data/models/transaction_create_dto.dart';
import 'package:money_care/features/transaction/data/models/transaction_filter_dto.dart';
import 'package:money_care/features/transaction/domain/entities/transaction_entity.dart';
import 'package:money_care/features/transaction/domain/repositories/transaction_repository.dart';
import 'package:money_care/features/wallet/domain/entities/wallet_entity.dart';
import 'package:money_care/features/wallet/presentation/controllers/wallet_controller.dart';
import 'package:money_care/app/controllers/transaction_controller.dart';

import 'package:money_care/features/couple/domain/entities/couple_saving_goal_entity.dart';
import 'package:money_care/features/couple/domain/entities/couple_settlement_entity.dart';
import 'package:money_care/features/couple/domain/entities/couple_report_entity.dart';

part 'couple_finance_actions.dart';
part 'couple_savings_settlement_actions.dart';
part 'couple_report_actions.dart';

class CoupleController extends GetxController {
  final GetCoupleInfoUseCase getCoupleInfoUseCase;
  final CreateCoupleUseCase createCoupleUseCase;
  final JoinCoupleUseCase joinCoupleUseCase;
  final CancelCoupleInviteUseCase cancelCoupleInviteUseCase;
  final LeaveCoupleUseCase leaveCoupleUseCase;
  final UpdateCoupleSettingsUseCase updateCoupleSettingsUseCase;
  final GetCoupleSavingGoalsUseCase getCoupleSavingGoalsUseCase;
  final CreateCoupleSavingGoalUseCase createCoupleSavingGoalUseCase;
  final ContributeToCoupleSavingGoalUseCase contributeToCoupleSavingGoalUseCase;
  final DeleteCoupleSavingGoalUseCase deleteCoupleSavingGoalUseCase;
  final UpdateCoupleSavingGoalUseCase updateCoupleSavingGoalUseCase;
  final GetCoupleSettlementSummaryUseCase getCoupleSettlementSummaryUseCase;
  final SettleUpCoupleUseCase settleUpCoupleUseCase;
  final SettleUpSingleCoupleUseCase settleUpSingleCoupleUseCase;
  final GetCoupleReportUseCase getCoupleReportUseCase;
  final MarkCoupleAlertReadUseCase markCoupleAlertReadUseCase;
  final UpdateCoupleAlertUseCase updateCoupleAlertUseCase;

  CoupleController({
    required this.getCoupleInfoUseCase,
    required this.createCoupleUseCase,
    required this.joinCoupleUseCase,
    required this.cancelCoupleInviteUseCase,
    required this.leaveCoupleUseCase,
    required this.updateCoupleSettingsUseCase,
    required this.getCoupleSavingGoalsUseCase,
    required this.createCoupleSavingGoalUseCase,
    required this.contributeToCoupleSavingGoalUseCase,
    required this.deleteCoupleSavingGoalUseCase,
    required this.updateCoupleSavingGoalUseCase,
    required this.getCoupleSettlementSummaryUseCase,
    required this.settleUpCoupleUseCase,
    required this.settleUpSingleCoupleUseCase,
    required this.getCoupleReportUseCase,
    required this.markCoupleAlertReadUseCase,
    required this.updateCoupleAlertUseCase,
  });

  final RxBool isLoading = false.obs;
  final Rxn<CoupleEntity> couple = Rxn<CoupleEntity>();
  final TextEditingController inviteCodeController = TextEditingController();

  final RxInt selectedTabIndex = 0.obs;
  final Rx<DateTime> selectedMonth = DateTime.now().obs;
  final RxList<WalletEntity> sharedWallets = <WalletEntity>[].obs;
  final RxList<TransactionEntity> sharedTransactions =
      <TransactionEntity>[].obs;

  // Phase 3 State
  final RxList<CoupleSavingGoalEntity> savingGoals =
      <CoupleSavingGoalEntity>[].obs;
  final Rxn<CoupleSettlementSummaryEntity> settlementSummary =
      Rxn<CoupleSettlementSummaryEntity>();
  final RxBool isSavingsLoading = false.obs;
  final RxBool isSettlementLoading = false.obs;
  final Rxn<CoupleReportEntity> coupleReport = Rxn<CoupleReportEntity>();
  final RxBool isReportLoading = false.obs;
  final RxString alertFilter = 'all'.obs;
  final RxBool isUpdatingSettings = false.obs;

  final RxDouble totalIncome = 0.0.obs;
  final RxDouble totalExpense = 0.0.obs;
  final RxDouble totalBalance = 0.0.obs;

  @override
  void onInit() {
    super.onInit();
    loadCoupleInfo().then((_) {
      if (couple.value?.isActive == true) {
        fetchCoupleData();
      }
    });

    if (Get.isRegistered<TransactionController>()) {
      ever(Get.find<TransactionController>().transactionChangedCount, (_) {
        if (couple.value?.isActive == true) {
          fetchCoupleData();
        }
      });
    }
  }

  @override
  void onClose() {
    inviteCodeController.dispose();
    super.onClose();
  }

  Future<void> loadCoupleInfo() async {
    isLoading.value = true;
    final result = await getCoupleInfoUseCase();
    result.fold(
      (failure) {
        isLoading.value = false;
        AppHelperFunction.showErrorSnackBar(
          'Lỗi tải thông tin: ${failure.message}',
        );
      },
      (data) {
        couple.value = data;
        isLoading.value = false;
      },
    );
  }

  Future<void> createCoupleSpace() async {
    isLoading.value = true;
    final result = await createCoupleUseCase();
    result.fold(
      (failure) {
        isLoading.value = false;
        AppHelperFunction.showErrorSnackBar(
          'Tạo nhóm thất bại: ${failure.message}',
        );
      },
      (data) {
        couple.value = data;
        isLoading.value = false;
        fetchCoupleData();
        AppHelperFunction.showSuccessSnackBar('Tạo nhóm thành công!');
      },
    );
  }

  Future<void> joinCoupleSpace() async {
    final code = inviteCodeController.text.trim().toUpperCase();
    if (code.isEmpty) {
      AppHelperFunction.showErrorSnackBar('Vui lòng nhập mã mời');
      return;
    }
    if (code.length != 6) {
      AppHelperFunction.showErrorSnackBar('Mã mời phải gồm 6 ký tự');
      return;
    }

    isLoading.value = true;
    final result = await joinCoupleUseCase(code);
    result.fold(
      (failure) {
        isLoading.value = false;
        AppHelperFunction.showErrorSnackBar(
          'Kết nối thất bại: ${failure.message}',
        );
      },
      (data) {
        couple.value = data;
        inviteCodeController.clear();
        isLoading.value = false;
        fetchCoupleData();
        AppHelperFunction.showSuccessSnackBar('Kết nối cặp đôi thành công!');
      },
    );
  }

  Future<void> cancelInvitation() async {
    isLoading.value = true;
    final result = await cancelCoupleInviteUseCase();
    result.fold(
      (failure) {
        isLoading.value = false;
        AppHelperFunction.showErrorSnackBar(
          'Hủy lời mời thất bại: ${failure.message}',
        );
      },
      (_) {
        couple.value = null;
        isLoading.value = false;
        AppHelperFunction.showSuccessSnackBar('Đã hủy lời mời kết nối');
      },
    );
  }

  Future<void> leaveCoupleSpace() async {
    isLoading.value = true;
    final result = await leaveCoupleUseCase();
    result.fold(
      (failure) {
        isLoading.value = false;
        AppHelperFunction.showErrorSnackBar(
          'Rời nhóm thất bại: ${failure.message}',
        );
      },
      (_) {
        couple.value = null;
        isLoading.value = false;
        sharedWallets.clear();
        sharedTransactions.clear();
        AppHelperFunction.showSuccessSnackBar(
          'Đã ngắt kết nối không gian cặp đôi',
        );
      },
    );
  }

  Future<void> toggleShareTransactions(bool val) async {
    isUpdatingSettings.value = true;
    final result = await updateCoupleSettingsUseCase(
      sharePersonalTransactions: val,
    );
    result.fold(
      (failure) {
        isUpdatingSettings.value = false;
        AppHelperFunction.showErrorSnackBar(
          'Cập nhật thất bại: ${failure.message}',
        );
      },
      (data) {
        couple.value = data;
        isUpdatingSettings.value = false;
        AppHelperFunction.showSuccessSnackBar(
          'Đã cập nhật quyền chia sẻ giao dịch',
        );
      },
    );
  }

  Future<void> toggleAllowAiShare(bool val) async {
    isUpdatingSettings.value = true;
    final result = await updateCoupleSettingsUseCase(allowAiShare: val);
    result.fold(
      (failure) {
        isUpdatingSettings.value = false;
        AppHelperFunction.showErrorSnackBar(
          'Cập nhật thất bại: ${failure.message}',
        );
      },
      (data) {
        couple.value = data;
        isUpdatingSettings.value = false;
        AppHelperFunction.showSuccessSnackBar('Đã cập nhật quyền phân tích AI');
      },
    );
  }
}
