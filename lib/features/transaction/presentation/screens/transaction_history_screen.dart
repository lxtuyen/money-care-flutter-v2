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
import 'package:money_care/core/utils/helper/helper_functions.dart';
import 'package:money_care/core/constants/colors.dart';

class TransactionHistoryScreen extends StatefulWidget {
  const TransactionHistoryScreen({super.key});

  @override
  State<TransactionHistoryScreen> createState() =>
      _TransactionHistoryScreenState();
}

class _TransactionHistoryScreenState extends State<TransactionHistoryScreen> {
  final TextEditingController searchController = TextEditingController();

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
    initData();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  Future<void> initData() async {
    final userId = await appController.getCurrentUserId();
    if (userId == null) return;

    statisticsController.refreshStatisticsData(userId);

    if (transactionController.transactionByfilter.value == null) {
      await transactionController.applyFilters(userId);
    }
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

      if (filtered.isEmpty) {
        return _buildEmptyView();
      }

      final grouped = AppHelperFunction.groupByDate(
        filtered,
        (t) => t.transactionDate,
      );

      final List<Widget> listItems = [];
      grouped.forEach((header, txs) {
        listItems.add(
          Padding(
            padding: const EdgeInsets.only(top: 20, bottom: 8),
            child: Text(
              header,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: AppThemeColors.of(context).textPrimary.withValues(alpha: 0.8),
              ),
            ),
          ),
        );

        for (int i = 0; i < txs.length; i++) {
          final tx = txs[i];
          listItems.add(
            TransactionItem(
              item: tx,
              isShowDate: false,
              isShowDivider: i < txs.length - 1,
              onTap: () => _showTransactionDetail(context, tx),
            ),
          );
        }
      });

      return ListView(
        key: const ValueKey('chi'),
        padding: const EdgeInsets.symmetric(horizontal: 16),
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

      if (filtered.isEmpty) {
        return _buildEmptyView();
      }

      final grouped = AppHelperFunction.groupByDate(
        filtered,
        (t) => t.transactionDate,
      );

      final List<Widget> listItems = [];
      grouped.forEach((header, txs) {
        listItems.add(
          Padding(
            padding: const EdgeInsets.only(top: 20, bottom: 8),
            child: Text(
              header,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: AppThemeColors.of(context).textPrimary.withValues(alpha: 0.8),
              ),
            ),
          ),
        );

        for (int i = 0; i < txs.length; i++) {
          final tx = txs[i];
          listItems.add(
            TransactionItem(
              item: tx,
              isShowDate: false,
              isShowDivider: i < txs.length - 1,
              onTap: () => _showTransactionDetail(context, tx),
            ),
          );
        }
      });

      return ListView(
        key: const ValueKey('thu'),
        padding: const EdgeInsets.symmetric(horizontal: 16),
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
