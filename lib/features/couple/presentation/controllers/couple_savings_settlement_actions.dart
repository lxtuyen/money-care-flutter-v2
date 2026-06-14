part of 'couple_controller.dart';

extension CoupleSavingsSettlementActions on CoupleController {
  Future<void> fetchSavingGoals() async {
    if (couple.value == null) return;
    isSavingsLoading.value = true;
    final result = await getCoupleSavingGoalsUseCase(couple.value!.id);
    result.fold(
      (failure) =>
          debugPrint('Error fetching saving goals: ${failure.message}'),
      (list) async {
        savingGoals.assignAll(list);
      },
    );
    isSavingsLoading.value = false;
  }

  Future<void> markSharedGoalAsNotified(int id) async {
    final result = await updateCoupleSavingGoalUseCase(
      id: id,
      completionNotified: true,
    );
    result.fold(
      (failure) => debugPrint('Error marking joint goal notified: ${failure.message}'),
      (updatedGoal) {
        final idx = savingGoals.indexWhere((g) => g.id == id);
        if (idx != -1) {
          savingGoals[idx] = updatedGoal;
          savingGoals.refresh();
        }
      },
    );
  }

  Future<void> completeSharedSavingGoalWithTransfer({
    required int goalId,
    required int sourceWalletId,
    required int destinationWalletId,
    required double amount,
  }) async {
    isSettlingSharedGoal.value = true;
    try {
      final walletController = Get.find<WalletController>();
      final categoryController = Get.find<UserCategoryController>();

      if (amount > 0) {
        final categoryId = await categoryController.getOrCreateTransferCategory();
        await walletController.transfer(
          sourceWalletId,
          destinationWalletId,
          amount,
          note: 'Quyết toán hoàn thành mục tiêu chung',
          categoryId: categoryId,
        );
      }

      // Update goal status to completed
      await updateCoupleSavingGoalUseCase(
        id: goalId,
        status: 'completed',
      );

      // Delete the goal wallet
      await walletController.deleteWallet(sourceWalletId, showSuccessMessage: false);

      // Refresh data
      await fetchSavingGoals();
      await fetchSharedWallets();

      AppHelperFunction.showSuccessSnackBar(
        'Quyết toán và đóng quỹ tiết kiệm chung thành công!',
      );
    } catch (e) {
      AppHelperFunction.showErrorSnackBar('Lỗi khi quyết toán mục tiêu chung: $e');
    } finally {
      isSettlingSharedGoal.value = false;
    }
  }

  Future<void> createSharedSavingGoal({
    required String name,
    required double target,
    DateTime? endDate,
  }) async {
    if (couple.value == null) return;
    isLoading.value = true;
    final result = await createCoupleSavingGoalUseCase(
      coupleId: couple.value!.id,
      name: name,
      target: target,
      endDate: endDate,
    );
    await result.fold(
      (failure) async {
        AppHelperFunction.showErrorSnackBar(
          'Lỗi tạo quỹ tiết kiệm: ${failure.message}',
        );
      },
      (_) async {
        await fetchSavingGoals();
        AppHelperFunction.showSuccessSnackBar(
          'Tạo quỹ tiết kiệm chung thành công!',
        );
      },
    );
    isLoading.value = false;
  }

  Future<void> addSavingContribution({
    required int goalId,
    required double amount,
    int? sourceWalletId,
  }) async {
    isLoading.value = true;
    final result = await contributeToCoupleSavingGoalUseCase(
      goalId: goalId,
      amount: amount,
      sourceWalletId: sourceWalletId,
    );
    await result.fold(
      (failure) async {
        AppHelperFunction.showErrorSnackBar('Lỗi đóng góp: ${failure.message}');
      },
      (_) async {
        await fetchSavingGoals();
        if (Get.isRegistered<WalletController>()) {
          await Get.find<WalletController>().refreshWallets();
        }
        await fetchSharedWallets();
        AppHelperFunction.showSuccessSnackBar('Đóng góp vào quỹ thành công!');
      },
    );
    isLoading.value = false;
  }

  Future<void> deleteSharedSavingGoal(int id) async {
    isLoading.value = true;
    final result = await deleteCoupleSavingGoalUseCase(id);
    await result.fold(
      (failure) async {
        AppHelperFunction.showErrorSnackBar('Lỗi xóa quỹ: ${failure.message}');
      },
      (_) async {
        await fetchSavingGoals();
        AppHelperFunction.showSuccessSnackBar('Xóa quỹ tiết kiệm thành công!');
      },
    );
    isLoading.value = false;
  }

  Future<void> updateSharedSavingGoal({
    required int id,
    String? name,
    double? target,
    DateTime? endDate,
    String? status,
    bool? completionNotified,
  }) async {
    isLoading.value = true;
    final result = await updateCoupleSavingGoalUseCase(
      id: id,
      name: name,
      target: target,
      endDate: endDate,
      status: status,
      completionNotified: completionNotified,
    );
    await result.fold(
      (failure) async {
        AppHelperFunction.showErrorSnackBar(
          'Lỗi cập nhật quỹ tiết kiệm: ${failure.message}',
        );
      },
      (_) async {
        await fetchSavingGoals();
        if (Get.isRegistered<WalletController>()) {
          await Get.find<WalletController>().refreshWallets();
        }
        await fetchSharedWallets();
        AppHelperFunction.showSuccessSnackBar(
          'Cập nhật quỹ tiết kiệm chung thành công!',
        );
      },
    );
    isLoading.value = false;
  }

  Future<void> fetchSettlementSummary() async {
    if (couple.value == null) return;
    isSettlementLoading.value = true;
    final result = await getCoupleSettlementSummaryUseCase(couple.value!.id);
    result.fold(
      (failure) => debugPrint('Error fetching settlement: ${failure.message}'),
      (data) => settlementSummary.value = data,
    );
    isSettlementLoading.value = false;
  }

  Future<void> settleUpAll() async {
    if (couple.value == null) return;
    isLoading.value = true;
    final result = await settleUpCoupleUseCase(couple.value!.id);
    await result.fold(
      (failure) async {
        AppHelperFunction.showErrorSnackBar(
          'Lỗi quyết toán: ${failure.message}',
        );
      },
      (_) async {
        await fetchSettlementSummary();
        await fetchSharedTransactions();
        AppHelperFunction.showSuccessSnackBar(
          'Đã quyết toán tất cả các khoản thành công!',
        );
      },
    );
    isLoading.value = false;
  }

  Future<void> settleUpSingle(int transactionId) async {
    if (couple.value == null) return;
    isLoading.value = true;
    final result = await settleUpSingleCoupleUseCase(
      coupleId: couple.value!.id,
      transactionId: transactionId,
    );
    await result.fold(
      (failure) async {
        AppHelperFunction.showErrorSnackBar(
          'Lỗi quyết toán: ${failure.message}',
        );
      },
      (_) async {
        await fetchSettlementSummary();
        await fetchSharedTransactions();
        AppHelperFunction.showSuccessSnackBar(
          'Đã quyết toán khoản chi này thành công!',
        );
      },
    );
    isLoading.value = false;
  }
}
