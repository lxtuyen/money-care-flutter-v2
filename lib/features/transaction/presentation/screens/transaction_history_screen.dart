import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:money_care/core/constants/colors.dart';
import 'package:money_care/core/controllers/app_controller.dart';
import 'package:money_care/core/presentation/widgets/layout/app_header.dart';
import 'package:money_care/core/presentation/widgets/states/transaction_empty_state.dart';
import 'package:money_care/core/utils/helper/helper_functions.dart';
import 'package:money_care/features/home/presentation/widgets/transaction/transaction_item.dart';
import 'package:money_care/features/saving_fund/presentation/controllers/saving_fund_controller.dart';
import 'package:money_care/features/statistics/presentation/controllers/statistics_controller.dart';
import 'package:money_care/features/statistics/presentation/widgets/transaction_type_summary_toggle.dart';
import 'package:money_care/features/transaction/data/models/transaction_model.dart';
import 'package:money_care/features/transaction/domain/entities/transaction_entity.dart';
import 'package:money_care/features/transaction/presentation/controllers/filter_controller.dart';
import 'package:money_care/features/transaction/presentation/controllers/transaction_controller.dart';
import 'package:money_care/features/transaction/presentation/widgets/filter_dialog.dart';
import 'package:money_care/features/transaction/presentation/widgets/search_filter.dart';
import 'package:money_care/features/transaction/presentation/widgets/transaction_detail.dart';

class TransactionHistoryScreen extends StatefulWidget {
  const TransactionHistoryScreen({super.key});

  @override
  State<TransactionHistoryScreen> createState() =>
      _TransactionHistoryScreenState();
}

class _TransactionHistoryScreenState extends State<TransactionHistoryScreen> {
  String selected = 'chi';
  final TextEditingController searchController = TextEditingController();

  final AppController appController = Get.find<AppController>();
  final TransactionController transactionController =
      Get.find<TransactionController>();
  final SavingFundController savingFundController =
      Get.find<SavingFundController>();
  final FilterController filterController = Get.find<FilterController>();
  final SavingFundController fundController = Get.find<SavingFundController>();
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

    await Future.wait([
      transactionController.loadTransactionScreenData(
        userId,
        TransactionFilterDto(
          fundId:
              fundController.fundId.value > 0
                  ? fundController.fundId.value
                  : null,
          startDate: filterController.startDate.value?.toIso8601String(),
          endDate: filterController.endDate.value?.toIso8601String(),
        ),
      ),
      statisticsController.getTotalByType(
        userId,
        startDate: filterController.startDate.value,
        endDate: filterController.endDate.value,
      ),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          AppHeader(
            title: 'Thu - Chi',
            child: Obx(() {
              final data = statisticsController.totalByType.value;

              if (transactionController.isLoading.value || 
                  statisticsController.isLoading.value) {
                return const SizedBox(
                  height: 120,
                  child: Center(child: CircularProgressIndicator()),
                );
              }

              if (data == null) {
                return TransactionTypeSummaryToggle(
                  selected: selected,
                  onSelected: (value) => setState(() => selected = value),
                  spendText: 0,
                  incomeText: 0,
                );
              }

              return TransactionTypeSummaryToggle(
                selected: selected,
                onSelected: (value) => setState(() => selected = value),
                spendText: data.expenseTotal,
                incomeText: data.incomeTotal,
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
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child:
                  selected == 'chi' ? _buildExpenseList() : _buildIncomeList(),
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
      final filtered =
          data.expenseTransactions.where((t) {
            final note = t.note?.toLowerCase() ?? '';
            return note.contains(keyword);
          }).toList();

      if (filtered.isEmpty) {
        return _buildEmptyView();
      }

      return ListView(
        key: const ValueKey('chi'),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children:
            filtered.asMap().entries.map((entry) {
              return TransactionItem(
                color: AppHelperFunction.getChartColorByIndex(entry.key),
                item: entry.value,
                isShowDate: true,
                onTap: () => _showTransactionDetail(context, entry.value),
              );
            }).toList(),
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
      final filtered =
          data.incomeTransactions.where((t) {
            final note = t.note?.toLowerCase() ?? '';
            return note.contains(keyword);
          }).toList();

      if (filtered.isEmpty) {
        return _buildEmptyView();
      }

      return ListView(
        key: const ValueKey('thu'),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children:
            filtered.asMap().entries.map((entry) {
              return TransactionItem(
                color: AppHelperFunction.getChartColorByIndex(entry.key),
                item: entry.value,
                isShowDate: true,
                onTap: () => _showTransactionDetail(context, entry.value),
              );
            }).toList(),
      );
    });
  }

  Widget _buildEmptyView() {
    return TransactionEmptyState(
      message: 'Không có giao dịch phù hợp',
      action:
          filterController.hasActiveFilters
              ? TextButton(
                onPressed: _clearFilters,
                child: const Text('Xóa tất cả bộ lọc'),
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
          isExpense: selected == 'chi',
          userId: appController.userId.value ?? 0,
        );
      },
    );
  }

  void _showCategoryFilterDialog(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (context) => Obx(() {
            final data = savingFundController.currentFund.value;

            if (savingFundController.isLoadingCurrent.value) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.only(top: 50),
                  child: CircularProgressIndicator(),
                ),
              );
            }

            if (data == null) {
              return const SizedBox.shrink();
            }

            return FilterDialog(
              title: 'Lọc theo phân loại',
              categories: data.categories,
              onApply: (_) => _applyFilter(),
            );
          }),
    );
  }

  void _showTimeFilterDialog(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (_) => FilterDialog(
            title: 'Lọc theo thời gian',
            items: const ['Hôm nay', 'Tuần này', 'Tháng này', 'Tùy chỉnh'],
            onApply: (_) => _applyFilter(),
          ),
    );
  }

  Future<void> _applyFilter() async {
    final userId = appController.userId.value;
    if (userId == null) return;

    await Future.wait([
      transactionController.filterTransactions(
        userId,
        TransactionFilterDto(
          categoryId: filterController.categoryId.value,
          fundId:
              fundController.fundId.value > 0 ? fundController.fundId.value : null,
          startDate: filterController.startDate.value?.toIso8601String(),
          endDate: filterController.endDate.value?.toIso8601String(),
        ),
      ),
      statisticsController.getTotalByType(
        userId,
        startDate: filterController.startDate.value,
        endDate: filterController.endDate.value,
      ),
    ]);
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
        return SafeArea(
          child: Obx(
            () => Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
              ),
              padding: const EdgeInsets.fromLTRB(18, 12, 18, 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 44,
                      height: 5,
                      decoration: BoxDecoration(
                        color: AppColors.borderPrimary,
                        borderRadius: BorderRadius.circular(999),
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),
                  Row(
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: AppColors.backgroundPrimary,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: const Icon(
                          Icons.tune_rounded,
                          color: AppColors.primary,
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Bộ lọc giao dịch',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              'Chọn cách bạn muốn thu hẹp danh sách giao dịch.',
                              style: TextStyle(
                                color: AppColors.text4,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppColors.primary.withOpacity(0.12),
                          AppColors.secondaryOrange.withOpacity(0.1),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.auto_awesome_rounded,
                          color: AppColors.primary,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            filterController.hasActiveFilters
                                ? 'Đang áp dụng ${filterController.activeFilterCount} tiêu chí lọc.'
                                : 'Chưa có bộ lọc nào được áp dụng.',
                            style: const TextStyle(
                              color: AppColors.text2,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildFilterSheetTile(
                    icon: Icons.category_outlined,
                    title: 'Lọc theo phân loại',
                    subtitle:
                        filterController.categoryId.value != null
                            ? 'Đã chọn 1 phân loại'
                            : 'Chọn loại chi tiêu hoặc thu nhập cụ thể',
                    onTap: () {
                      Get.back();
                      _showCategoryFilterDialog(context);
                    },
                  ),
                  const SizedBox(height: 12),
                  _buildFilterSheetTile(
                    icon: Icons.calendar_today_rounded,
                    title: 'Lọc theo thời gian',
                    subtitle: filterController.dateLabel.value,
                    onTap: () {
                      Get.back();
                      _showTimeFilterDialog(context);
                    },
                  ),
                  if (filterController.hasActiveFilters) ...[
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: () {
                          Get.back();
                          _clearFilters();
                        },
                        icon: const Icon(Icons.restart_alt_rounded),
                        label: const Text('Xóa tất cả bộ lọc'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.text2,
                          side: const BorderSide(
                            color: AppColors.borderSecondary,
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildFilterSheetTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Ink(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.borderSecondary),
            boxShadow: [
              BoxShadow(
                color: AppColors.text1.withOpacity(0.04),
                blurRadius: 16,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: AppColors.backgroundPrimary,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(icon, color: AppColors.primary),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: AppColors.text2,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        fontSize: 13,
                        color: AppColors.text4,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.arrow_forward_ios_rounded,
                size: 16,
                color: AppColors.text5,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
