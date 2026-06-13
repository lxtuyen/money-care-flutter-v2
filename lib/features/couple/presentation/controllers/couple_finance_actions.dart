part of 'couple_controller.dart';

extension CoupleFinanceActions on CoupleController {
  String get selectedMonthStr =>
      DateFormat('yyyy-MM').format(selectedMonth.value);

  void changeMonth(DateTime newMonth) {
    selectedMonth.value = newMonth;
    if (couple.value?.isActive == true) {
      fetchCoupleData();
    }
  }

  Future<void> fetchCoupleData() async {
    if (couple.value == null) return;
    isLoading.value = true;
    try {
      await Future.wait([
        fetchSharedWallets(),
        fetchSharedTransactions(),
        fetchSavingGoals(),
        fetchSettlementSummary(),
        fetchCoupleReport(),
      ]);
    } catch (e) {
      debugPrint('Error fetching couple data: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchSharedWallets() async {
    try {
      final walletController = Get.find<WalletController>();
      final list = await walletController.repository.findAll(
        coupleId: couple.value!.id,
      );
      sharedWallets.assignAll(list);
      totalBalance.value = list.fold(
        0.0,
        (sum, wallet) => sum + wallet.balance,
      );
    } catch (e) {
      debugPrint('Error fetching shared wallets: $e');
    }
  }

  Future<void> fetchSharedTransactions() async {
    try {
      final appController = Get.find<AppController>();
      final userId = appController.userId.value ?? 0;
      final transactionRepo = Get.find<TransactionRepository>();
      final firstDay = DateTime(
        selectedMonth.value.year,
        selectedMonth.value.month,
        1,
      );
      final lastDay = DateTime(
        selectedMonth.value.year,
        selectedMonth.value.month + 1,
        0,
        23,
        59,
        59,
      );
      final filter = TransactionFilterDto(
        startDate: firstDay.toIso8601String(),
        endDate: lastDay.toIso8601String(),
        includeTransfer: 'false',
      );
      final result = await transactionRepo.findAllByFilter(
        userId,
        filter,
        coupleId: couple.value!.id,
      );

      final all = <TransactionEntity>[];
      var incomeSum = 0.0;
      var expenseSum = 0.0;
      for (final transaction in result.incomeTransactions) {
        all.add(transaction);
        incomeSum += transaction.amount;
      }
      for (final transaction in result.expenseTransactions) {
        all.add(transaction);
        expenseSum += transaction.amount;
      }
      all.sort(
        (a, b) => (b.transactionDate ?? DateTime.now()).compareTo(
          a.transactionDate ?? DateTime.now(),
        ),
      );
      sharedTransactions.assignAll(all);
      totalIncome.value = incomeSum;
      totalExpense.value = expenseSum;
    } catch (e) {
      debugPrint('Error fetching shared transactions: $e');
    }
  }



  Future<void> addSharedTransaction({
    required int amount,
    required String type,
    required String note,
    required int walletId,
    required int categoryId,
    int? subCategoryId,
    required int payerId,
    DateTime? date,
    String? splitMethod,
    List<Map<String, dynamic>>? splits,
  }) async {
    await _saveSharedTransaction(
      amount: amount,
      type: type,
      note: note,
      walletId: walletId,
      categoryId: categoryId,
      subCategoryId: subCategoryId,
      payerId: payerId,
      date: date,
      splitMethod: splitMethod,
      splits: splits,
    );
  }

  Future<void> editSharedTransaction({
    required int id,
    required int amount,
    required String type,
    required String note,
    required int walletId,
    required int categoryId,
    int? subCategoryId,
    required int payerId,
    DateTime? date,
    String? splitMethod,
    List<Map<String, dynamic>>? splits,
  }) async {
    await _saveSharedTransaction(
      id: id,
      amount: amount,
      type: type,
      note: note,
      walletId: walletId,
      categoryId: categoryId,
      subCategoryId: subCategoryId,
      payerId: payerId,
      date: date,
      splitMethod: splitMethod,
      splits: splits,
    );
  }

  Future<void> _saveSharedTransaction({
    int? id,
    required int amount,
    required String type,
    required String note,
    required int walletId,
    required int categoryId,
    int? subCategoryId,
    required int payerId,
    DateTime? date,
    String? splitMethod,
    List<Map<String, dynamic>>? splits,
  }) async {
    isLoading.value = true;
    try {
      final transactionRepo = Get.find<TransactionRepository>();
      final dto = TransactionCreateDto(
        amount: amount,
        type: type,
        note: note,
        categoryId: categoryId,
        subCategoryId: subCategoryId,
        walletId: walletId,
        transactionDate: date ?? DateTime.now(),
      );

      if (id == null) {
        await transactionRepo.createTransaction(
          dto,
          coupleId: couple.value!.id,
          payerId: payerId,
          splitMethod: splitMethod,
          splits: splits,
        );
      } else {
        await transactionRepo.updateTransaction(
          dto,
          id,
          coupleId: couple.value!.id,
          payerId: payerId,
          splitMethod: splitMethod,
          splits: splits,
        );
      }

      await fetchCoupleData();
      AppHelperFunction.showSuccessSnackBar(
        id == null
            ? 'Ghi nhận giao dịch chung thành công'
            : 'Cập nhật giao dịch chung thành công',
      );
    } catch (e) {
      AppHelperFunction.showErrorSnackBar('Lỗi giao dịch: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteSharedTransaction(int id) async {
    isLoading.value = true;
    try {
      final transactionRepo = Get.find<TransactionRepository>();
      await transactionRepo.deleteTransaction(id);
      await fetchCoupleData();
      AppHelperFunction.showSuccessSnackBar('Đã xóa giao dịch chung');
    } catch (e) {
      AppHelperFunction.showErrorSnackBar('Lỗi xóa giao dịch: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> addSharedWallet(String name, double balance) async {
    isLoading.value = true;
    try {
      final walletController = Get.find<WalletController>();
      await walletController.repository.create({
        'name': name,
        'balance': balance,
        'coupleId': couple.value!.id,
      });
      await fetchSharedWallets();
      AppHelperFunction.showSuccessSnackBar('Tạo ví chung thành công');
    } catch (e) {
      AppHelperFunction.showErrorSnackBar('Lỗi tạo ví: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
