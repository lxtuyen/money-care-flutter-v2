part of 'couple_transactions_view.dart';

extension _CoupleTransactionsViewSections on _CoupleTransactionsViewState {
  Widget _buildTransactionsList(BuildContext context, int currentUserId) {
    return Obx(() {
      if (widget.controller.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }

      final filtered = _filterTransactions();

      final listItems = <Widget>[
        const SizedBox(height: 8),
        CoupleTransactionCalendar(
          focusedMonth: widget.controller.selectedMonth.value,
          transactions: filtered,
          selectedDay: _selectedDay,
          onDaySelected: (day) => selectDay(day),
        ),
        const SizedBox(height: 16),
        _selectedDayHeader(context, _selectedDay),
        const SizedBox(height: 8),
      ];

      final selectedDayTxs = filtered
          .where((tx) => tx.transactionDate?.day == _selectedDay)
          .toList()
        ..sort((a, b) => (b.transactionDate ?? DateTime(0)).compareTo(a.transactionDate ?? DateTime(0)));

      if (selectedDayTxs.isEmpty) {
        listItems.add(
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 16),
            child: Center(
              child: Text(
                'Không có giao dịch nào trong ngày này.',
                style: TextStyle(
                  color: AppThemeColors.of(context).textSecondary,
                  fontSize: 13,
                ),
              ),
            ),
          ),
        );
      } else {
        for (int i = 0; i < selectedDayTxs.length; i++) {
          final transaction = selectedDayTxs[i];
          listItems.add(
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: TransactionItem(
                item: transaction,
                currentUserId: currentUserId,
                isShowDate: false,
                isShowDivider: i < selectedDayTxs.length - 1,
                onTap: () =>
                    _showTransactionDetail(context, transaction, currentUserId),
              ),
            ),
          );
        }
      }

      return ListView(
        padding: const EdgeInsets.only(bottom: 80),
        children: listItems,
      );
    });
  }

  List<TransactionEntity> _filterTransactions() {
    return widget.controller.sharedTransactions;
  }

  Widget _selectedDayHeader(BuildContext context, int day) {
    final colors = AppThemeColors.of(context);
    final focus = widget.controller.selectedMonth.value;
    final dateStr = 'Ngày $day Tháng ${focus.month}, ${focus.year}';
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 16,
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            dateStr,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: colors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  void _showTransactionDetail(
    BuildContext context,
    TransactionEntity transaction,
    int currentUserId,
  ) {
    if (transaction.pictureUrl != null && transaction.pictureUrl!.isNotEmpty) {
      final photoTxs = widget.controller.sharedTransactions
          .where((tx) => tx.pictureUrl != null && tx.pictureUrl!.isNotEmpty)
          .toList();
      final initialIndex = photoTxs.indexWhere((tx) => tx.id == transaction.id);

      Get.to(() => PhotoTransactionDetailScreen(
            photoTransactions: photoTxs,
            initialIndex: initialIndex >= 0 ? initialIndex : 0,
            coupleController: widget.controller,
          ));
    } else {
      TransactionDetail.show(
        context,
        item: transaction,
        userId: currentUserId,
      );
    }
  }
}
