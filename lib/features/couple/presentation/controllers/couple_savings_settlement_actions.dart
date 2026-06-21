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

      // Find goal name before deleting
      final goal = savingGoals.firstWhereOrNull((g) => g.id == goalId);
      final goalName = goal?.name ?? 'Quỹ tiết kiệm';

      // Update goal status to completed
      await updateCoupleSavingGoalUseCase(
        id: goalId,
        status: 'completed',
      );

      // Delete the goal wallet
      await walletController.deleteWallet(sourceWalletId, showSuccessMessage: false, ignoreBalanceCheck: true);

      // Refresh data
      await fetchSavingGoals();
      await fetchSharedWallets();

      // Send chat notification
      if (Get.isRegistered<SocketService>()) {
        final authController = Get.find<AuthController>();
        final senderName = authController.user.value?.profile.firstName ?? 'Thành viên';
        final content = 'Tiết kiệm: $senderName đã quyết toán hoàn thành và đóng quỹ "$goalName" trị giá ${AppHelperFunction.formatAmount(amount)}! 🎉';

        Get.find<SocketService>().sendMessage(
          content,
          metadata: {
            '__type': 'saving_goal_completed',
            'goalId': goalId,
            'goalName': goalName,
            'amount': amount,
          },
        );
      }

      AppHelperFunction.showSuccessSnackBar(
        'Quyết toán và đóng quỹ tiết kiệm chung thành công!',
      );
    } catch (e) {
      AppHelperFunction.showErrorSnackBar('Lỗi khi quyết toán mục tiêu chung: $e');
    } finally {
      isSettlingSharedGoal.value = false;
    }
  }

  Future<void> completeSharedSavingGoalOnly({
    required int goalId,
    required int sourceWalletId,
    required double totalAmount,
  }) async {
    isSettlingSharedGoal.value = true;
    try {
      final walletController = Get.find<WalletController>();

      // Update goal status to completed
      await updateCoupleSavingGoalUseCase(
        id: goalId,
        status: 'completed',
      );

      // Delete the goal wallet
      await walletController.deleteWallet(sourceWalletId, showSuccessMessage: false, ignoreBalanceCheck: true);

      // Refresh data
      await fetchSavingGoals();
      await fetchSharedWallets();
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
    bool? isBudgetEnabled,
  }) async {
    if (couple.value == null) return;
    isLoading.value = true;
    final result = await createCoupleSavingGoalUseCase(
      coupleId: couple.value!.id,
      name: name,
      target: target,
      endDate: endDate,
      isBudgetEnabled: isBudgetEnabled,
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

        // Send chat notification
        final goal = savingGoals.firstWhereOrNull((g) => g.id == goalId);
        if (Get.isRegistered<SocketService>()) {
          final authController = Get.find<AuthController>();
          final senderName = authController.user.value?.profile.firstName ?? 'Thành viên';
          final goalName = goal?.name ?? 'Quỹ tiết kiệm';
          final content = 'Tiết kiệm: $senderName đã đóng góp ${AppHelperFunction.formatAmount(amount)} vào quỹ "$goalName"! 💰';

          Get.find<SocketService>().sendMessage(
            content,
            metadata: {
              '__type': 'saving_contribution_completed',
              'goalId': goalId,
              'goalName': goalName,
              'amount': amount,
              'savedAmount': goal?.savedAmount ?? 0.0,
              'target': goal?.target ?? 0.0,
            },
          );
        }

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
    bool? isBudgetEnabled,
  }) async {
    isLoading.value = true;
    final result = await updateCoupleSavingGoalUseCase(
      id: id,
      name: name,
      target: target,
      endDate: endDate,
      status: status,
      completionNotified: completionNotified,
      isBudgetEnabled: isBudgetEnabled,
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
    
    // Capture the outstanding debt before resetting it
    final summaryBefore = settlementSummary.value;
    final whoOwes = summaryBefore?.whoOwesWhom;

    final result = await settleUpCoupleUseCase(couple.value!.id);
    await result.fold(
      (failure) async {
        AppHelperFunction.showErrorSnackBar(
          'Lỗi quyết toán: ${failure.message}',
        );
      },
      (_) async {
        if (whoOwes != null && whoOwes.amount > 0) {
          final authController = Get.find<AuthController>();
          final senderName = authController.user.value?.profile.firstName ?? 'Thành viên';
          final content = 'Quyết toán: $senderName đã xác nhận thanh toán xong toàn bộ số dư nợ chung trị giá ${AppHelperFunction.formatAmount(whoOwes.amount)}! 🎉';
          
          if (Get.isRegistered<SocketService>()) {
            Get.find<SocketService>().sendMessage(
              content,
              metadata: {
                '__type': 'settlement_completed',
                'amount': whoOwes.amount,
                'debtorName': whoOwes.debtorName,
                'creditorName': whoOwes.creditorName,
              },
            );
          }
        }
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

    final summaryBefore = settlementSummary.value;
    final tx = summaryBefore?.unsettledTransactions.firstWhereOrNull((t) => t.id == transactionId);

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
        if (tx != null) {
          final authController = Get.find<AuthController>();
          final senderName = authController.user.value?.profile.firstName ?? 'Thành viên';
          final txName = tx.note != null && tx.note!.isNotEmpty ? tx.note! : (tx.category?.name ?? 'Giao dịch chung');
          final content = 'Quyết toán: $senderName đã quyết toán xong khoản chi "$txName" trị giá ${AppHelperFunction.formatAmount(tx.amount.toDouble())}! ✅';
          
          if (Get.isRegistered<SocketService>()) {
            Get.find<SocketService>().sendMessage(
              content,
              metadata: {
                '__type': 'single_settlement_completed',
                'amount': tx.amount,
                'transactionId': transactionId,
                'note': txName,
              },
            );
          }
        }
        await fetchSettlementSummary();
        await fetchSharedTransactions();
        AppHelperFunction.showSuccessSnackBar(
          'Đã quyết toán khoản chi này thành công!',
        );
      },
    );
    isLoading.value = false;
  }

  Future<void> activateSharedSavingGoal(int goalId) async {
    isLoading.value = true;
    final result = await activateCoupleSavingGoalUseCase(goalId);
    await result.fold(
      (failure) async {
        AppHelperFunction.showErrorSnackBar(
          'Lỗi: ${failure.message}',
        );
      },
      (_) async {
        await fetchSavingGoals();
        AppHelperFunction.showSuccessSnackBar(
          'Đã kích hoạt mục tiêu tiết kiệm!',
        );
      },
    );
    isLoading.value = false;
  }

  Future<void> pauseSharedSavingGoal(int goalId) async {
    isLoading.value = true;
    final result = await pauseCoupleSavingGoalUseCase(goalId);
    await result.fold(
      (failure) async {
        AppHelperFunction.showErrorSnackBar(
          'Lỗi: ${failure.message}',
        );
      },
      (_) async {
        await fetchSavingGoals();
        AppHelperFunction.showSuccessSnackBar(
          'Đã tạm dừng mục tiêu tiết kiệm!',
        );
      },
    );
    isLoading.value = false;
  }
}
