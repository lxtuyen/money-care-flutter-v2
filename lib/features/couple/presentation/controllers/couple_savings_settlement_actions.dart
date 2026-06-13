part of 'couple_controller.dart';

extension CoupleSavingsSettlementActions on CoupleController {
  Future<void> fetchSavingGoals() async {
    if (couple.value == null) return;
    isSavingsLoading.value = true;
    final result = await getCoupleSavingGoalsUseCase(couple.value!.id);
    result.fold(
      (failure) =>
          debugPrint('Error fetching saving goals: ${failure.message}'),
      (list) => savingGoals.assignAll(list),
    );
    isSavingsLoading.value = false;
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
  }) async {
    isLoading.value = true;
    final result = await contributeToCoupleSavingGoalUseCase(
      goalId: goalId,
      amount: amount,
    );
    await result.fold(
      (failure) async {
        AppHelperFunction.showErrorSnackBar('Lỗi đóng góp: ${failure.message}');
      },
      (_) async {
        await fetchSavingGoals();
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
