part of 'couple_transactions_view.dart';

extension _CoupleTransactionsViewSections on _CoupleTransactionsViewState {
  Widget _buildTransactionsList(BuildContext context, int currentUserId) {
    return Obx(() {
      if (widget.controller.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }

      final filtered = _filterTransactions();
      if (filtered.isEmpty) {
        return const AppEmptyState(
          message: 'Không tìm thấy giao dịch chung nào phù hợp.',
        );
      }

      final grouped = AppHelperFunction.groupByDate(
        filtered,
        (transaction) => transaction.transactionDate,
      );

      final listItems = <Widget>[];
      grouped.forEach((header, transactions) {
        listItems.add(_dateHeader(context, header));
        for (int i = 0; i < transactions.length; i++) {
          final transaction = transactions[i];
          listItems.add(
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: TransactionItem(
                item: transaction,
                currentUserId: currentUserId,
                isShowDate: false,
                isShowDivider: i < transactions.length - 1,
                onTap: () =>
                    _showTransactionDetail(context, transaction, currentUserId),
              ),
            ),
          );
        }
      });

      return ListView(
        padding: const EdgeInsets.only(bottom: 80),
        children: listItems,
      );
    });
  }

  List<TransactionEntity> _filterTransactions() {
    return widget.controller.sharedTransactions.where((transaction) {
      if (_searchKeyword.isNotEmpty) {
        final note = transaction.note?.toLowerCase() ?? '';
        final categoryName = transaction.category?.name.toLowerCase() ?? '';
        if (!note.contains(_searchKeyword) &&
            !categoryName.contains(_searchKeyword)) {
          return false;
        }
      }
      if (_selectedWalletFilter != null &&
          transaction.walletId != _selectedWalletFilter) {
        return false;
      }
      if (_selectedPayerFilter != null &&
          transaction.payerId != _selectedPayerFilter) {
        return false;
      }
      if (_selectedCategoryFilter != null &&
          transaction.category?.id != _selectedCategoryFilter) {
        return false;
      }
      if (_selectedTypeFilter != 'all' &&
          transaction.type != _selectedTypeFilter) {
        return false;
      }
      return true;
    }).toList();
  }

  Widget _dateHeader(BuildContext context, String header) {
    return Padding(
      padding: const EdgeInsets.only(top: 20, left: 16, right: 16, bottom: 8),
      child: Text(
        header,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w700,
          color: AppThemeColors.of(context).textPrimary.withValues(alpha: 0.8),
        ),
      ),
    );
  }

  void _showTransactionDetail(
    BuildContext context,
    TransactionEntity transaction,
    int currentUserId,
  ) {
    TransactionDetail.show(
      context,
      item: transaction,
      userId: currentUserId,
    );
  }
}
