import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:money_care/app/controllers/app_controller.dart';
import 'package:money_care/app/widgets/layout/app_header.dart';
import 'package:money_care/app/widgets/states/app_empty_state.dart';
import 'package:money_care/features/home/presentation/widgets/transaction/transaction_item.dart';
import 'package:money_care/app/controllers/statistics_controller.dart';
import 'package:money_care/app/widgets/button/transaction_type_toggle.dart';
import 'package:money_care/features/transaction/domain/entities/transaction_entity.dart';
import 'package:money_care/features/transaction/presentation/controllers/filter_controller.dart';
import 'package:money_care/app/controllers/transaction_controller.dart';
import 'package:money_care/features/transaction/presentation/widgets/search_filter.dart';
import 'package:money_care/features/transaction/presentation/widgets/transaction_detail.dart';
import 'package:money_care/features/transaction/presentation/widgets/transaction_history_filter_sheet.dart';
import 'package:money_care/core/theme/app_theme_colors.dart';
import 'package:money_care/core/constants/colors.dart';
import 'package:money_care/features/couple/presentation/widgets/couple_transaction_calendar.dart';
import 'package:money_care/features/photo_transaction/presentation/screens/photo_transaction_detail_screen.dart';
import 'package:money_care/features/statistics/presentation/widgets/statistics_time_navigator.dart';

class TransactionHistoryScreen extends StatefulWidget {
  const TransactionHistoryScreen({super.key});

  @override
  State<TransactionHistoryScreen> createState() =>
      _TransactionHistoryScreenState();
}

class _TransactionHistoryScreenState extends State<TransactionHistoryScreen> {
  final TextEditingController searchController = TextEditingController();

  late DateTime _selectedMonth;
  late int _selectedDay;
  Worker? _filterWorker;

  final AppController appController = Get.find<AppController>();
  final TransactionController transactionController =
      Get.find<TransactionController>();
  final FilterController filterController = Get.find<FilterController>();
  final StatisticsController statisticsController =
      Get.find<StatisticsController>();

  @override
  void initState() {
    super.initState();
    searchController.text = filterController.keyword.value;
    _initializeDateTime();

    // Listen to changes in filterController's date range to update local calendar state
    _filterWorker = ever(filterController.startDate, (DateTime? start) {
      if (start != null) {
        setState(() {
          _selectedMonth = DateTime(start.year, start.month);
          _selectedDay = start.day;
        });
      } else {
        final now = DateTime.now();
        setState(() {
          _selectedMonth = DateTime(now.year, now.month);
          _selectedDay = now.day;
        });
      }
    });

    initData();
  }

  @override
  void dispose() {
    searchController.dispose();
    _filterWorker?.dispose();
    super.dispose();
  }

  void _initializeDateTime() {
    final now = DateTime.now();
    final start = filterController.startDate.value;
    if (start != null) {
      _selectedMonth = DateTime(start.year, start.month);
      _selectedDay = start.day;
    } else {
      _selectedMonth = DateTime(now.year, now.month);
      _selectedDay = now.day;
    }
  }

  void selectDay(int day) {
    setState(() {
      _selectedDay = day;
    });
  }

  Future<void> initData() async {
    final userId = await appController.getCurrentUserId();
    if (userId == null) return;

    statisticsController.refreshStatisticsData(userId);

    if (transactionController.transactionByfilter.value == null) {
      await transactionController.applyFilters(userId);
    }
  }

  Widget _selectedDayHeader(BuildContext context, int day) {
    final colors = AppThemeColors.of(context);
    final dateStr = 'Ngày $day Tháng ${_selectedMonth.month}, ${_selectedMonth.year}';
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

  void _changeMonth(DateTime newMonth) {
    setState(() {
      _selectedMonth = DateTime(newMonth.year, newMonth.month);
      final today = DateTime.now();
      if (newMonth.year == today.year && newMonth.month == today.month) {
        _selectedDay = today.day;
      } else {
        _selectedDay = 1;
      }
    });

    final start = DateTime(_selectedMonth.year, _selectedMonth.month, 1);
    final end = DateTime(_selectedMonth.year, _selectedMonth.month + 1, 0);
    
    filterController.updateDateRange(
      start,
      end,
      label: '${_selectedMonth.year}/${_selectedMonth.month.toString().padLeft(2, '0')}',
    );

    _applyFilter();
  }

  bool _canGoPreviousMonth() {
    final first = statisticsController.firstTransactionDate.value;
    if (first == null) return true;
    return !(_selectedMonth.year == first.year &&
        _selectedMonth.month == first.month);
  }

  List<TransactionEntity> _filterTransactionsByDay(
    List<TransactionEntity> transactions,
  ) {
    return transactions
        .where((tx) => tx.transactionDate?.day == _selectedDay)
        .toList()
      ..sort((a, b) =>
          (b.transactionDate ?? DateTime(0))
              .compareTo(a.transactionDate ?? DateTime(0)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Column(
        children: [
          AppHeader(
            title: 'transaction.title'.tr,
            child: Obx(() {
              final data = statisticsController.totalByType.value;
              final selectedType = statisticsController.selectedType.value;

              return Stack(
                children: [
                  TransactionTypeToggle(
                    selected: selectedType,
                    onSelected: (value) =>
                        statisticsController.changeType(value),
                    spendText: data?.expenseTotal ?? 0,
                    incomeText: data?.incomeTotal ?? 0,
                  ),
                  if (transactionController.isLoading.value ||
                      statisticsController.isLoading.value)
                    Positioned(
                      top: 0,
                      left: 0,
                      right: 0,
                      child: LinearProgressIndicator(
                        backgroundColor: Colors.transparent,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          AppColors.primary.withValues(alpha: 0.5),
                        ),
                        minHeight: 2,
                      ),
                    ),
                ],
              );
            }),
          ),
          const SizedBox(height: 12),
          StatisticsTimeNavigator(
            focusedMonth: _selectedMonth,
            onPrevious: () => _changeMonth(
              DateTime(_selectedMonth.year, _selectedMonth.month - 1),
            ),
            onNext: () => _changeMonth(
              DateTime(_selectedMonth.year, _selectedMonth.month + 1),
            ),
            canGoNext: !(_selectedMonth.year == DateTime.now().year &&
                _selectedMonth.month == DateTime.now().month),
            canGoPrevious: _canGoPreviousMonth(),
            onTap: () async {
              final DateTime? picked = await showDatePicker(
                context: context,
                initialDate: _selectedMonth,
                firstDate: DateTime(2020),
                lastDate: DateTime(2030),
                initialDatePickerMode: DatePickerMode.year,
              );
              if (picked != null) {
                _changeMonth(picked);
              }
            },
          ),
          Obx(
            () => SearchWithFilter(
              controller: searchController,
              hasActiveFilters: filterController.hasActiveFilters,
              activeFilterCount: filterController.activeFilterCount,
              onChanged: filterController.updateKeyword,
              onClearSearch: () {
                searchController.clear();
                filterController.updateKeyword('');
              },
              onFilterTap: () => _showFilterSheet(context),
            ),
          ),
          Expanded(
            child: Obx(
              () => AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: statisticsController.selectedType.value == 'chi'
                    ? _buildExpenseList()
                    : _buildIncomeList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExpenseList() {
    return Obx(() {
      if (transactionController.isLoading.value) {
        return const Center(
          child: Padding(
            padding: EdgeInsets.only(top: 50),
            child: CircularProgressIndicator(),
          ),
        );
      }

      final data = transactionController.transactionByfilter.value;
      if (data == null || data.expenseTransactions.isEmpty) {
        return _buildEmptyView();
      }

      final keyword = filterController.keyword.value.toLowerCase().trim();
      final filtered = data.expenseTransactions.where((t) {
        final note = t.note?.toLowerCase() ?? '';
        return note.contains(keyword);
      }).toList();

      final listItems = <Widget>[
        const SizedBox(height: 8),
        CoupleTransactionCalendar(
          focusedMonth: _selectedMonth,
          transactions: filtered,
          selectedDay: _selectedDay,
          onDaySelected: selectDay,
        ),
        const SizedBox(height: 16),
        _selectedDayHeader(context, _selectedDay),
        const SizedBox(height: 8),
      ];

      final selectedDayTxs = _filterTransactionsByDay(filtered);

      if (selectedDayTxs.isEmpty) {
        listItems.add(
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 16),
            child: Center(
              child: Text(
                'transaction.noTransactions'.tr,
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
          final tx = selectedDayTxs[i];
          listItems.add(
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: TransactionItem(
                item: tx,
                isShowDate: false,
                isShowDivider: i < selectedDayTxs.length - 1,
                onTap: () => _showTransactionDetail(context, tx),
              ),
            ),
          );
        }
      }

      return ListView(
        key: const ValueKey('chi'),
        padding: const EdgeInsets.only(bottom: 80),
        children: listItems,
      );
    });
  }

  Widget _buildIncomeList() {
    return Obx(() {
      if (transactionController.isLoading.value) {
        return const Center(
          child: Padding(
            padding: EdgeInsets.only(top: 50),
            child: CircularProgressIndicator(),
          ),
        );
      }

      final data = transactionController.transactionByfilter.value;
      if (data == null || data.incomeTransactions.isEmpty) {
        return _buildEmptyView();
      }

      final keyword = filterController.keyword.value.toLowerCase().trim();
      final filtered = data.incomeTransactions.where((t) {
        final note = t.note?.toLowerCase() ?? '';
        return note.contains(keyword);
      }).toList();

      final listItems = <Widget>[
        const SizedBox(height: 8),
        CoupleTransactionCalendar(
          focusedMonth: _selectedMonth,
          transactions: filtered,
          selectedDay: _selectedDay,
          onDaySelected: selectDay,
        ),
        const SizedBox(height: 16),
        _selectedDayHeader(context, _selectedDay),
        const SizedBox(height: 8),
      ];

      final selectedDayTxs = _filterTransactionsByDay(filtered);

      if (selectedDayTxs.isEmpty) {
        listItems.add(
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 16),
            child: Center(
              child: Text(
                'transaction.noTransactions'.tr,
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
          final tx = selectedDayTxs[i];
          listItems.add(
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: TransactionItem(
                item: tx,
                isShowDate: false,
                isShowDivider: i < selectedDayTxs.length - 1,
                onTap: () => _showTransactionDetail(context, tx),
              ),
            ),
          );
        }
      }

      return ListView(
        key: const ValueKey('thu'),
        padding: const EdgeInsets.only(bottom: 80),
        children: listItems,
      );
    });
  }

  Widget _buildEmptyView() {
    return AppEmptyState(
      message: 'transaction.noTransactions'.tr,
      action: filterController.hasActiveFilters
          ? TextButton(
              onPressed: _clearFilters,
              child: Text('common.clearAllFilters'.tr),
            )
          : null,
    );
  }

  void _showTransactionDetail(BuildContext context, TransactionEntity item) {
    if (item.pictureUrl != null && item.pictureUrl!.isNotEmpty) {
      // Collect all photo transactions from the current list (expense or income)
      final data = transactionController.transactionByfilter.value;
      if (data == null) return;

      final currentList = statisticsController.selectedType.value == 'chi'
          ? data.expenseTransactions
          : data.incomeTransactions;

      final photoTxs = currentList
          .where((tx) => tx.pictureUrl != null && tx.pictureUrl!.isNotEmpty)
          .toList();
      final initialIndex = photoTxs.indexWhere((tx) => tx.id == item.id);

      Get.to(() => PhotoTransactionDetailScreen(
            photoTransactions: photoTxs,
            initialIndex: initialIndex >= 0 ? initialIndex : 0,
            isPersonal: true,
            ownerId: appController.userId.value,
          ));
    } else {
      showDialog(
        context: context,
        builder: (context) {
          return TransactionDetail(
            item: item,
            isExpense: statisticsController.selectedType.value == 'chi',
            userId: appController.userId.value ?? 0,
          );
        },
      );
    }
  }

  Future<void> _applyFilter() async {
    final userId = appController.userId.value;
    if (userId == null) return;

    await transactionController.applyFilters(userId);
  }

  void _clearFilters() {
    searchController.clear();
    filterController.clearAll();
    _applyFilter();
  }

  void _showFilterSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return TransactionHistoryFilterSheet(onClearFilters: _clearFilters);
      },
    );
  }
}
