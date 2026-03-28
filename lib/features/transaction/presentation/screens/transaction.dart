import 'package:money_care/features/statistics/presentation/controllers/statistics_controller.dart';
import 'package:money_care/core/presentation/widgets/layout/app_header.dart';
import 'package:money_care/features/transaction/data/models/transaction_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:money_care/features/transaction/presentation/controllers/filter_controller.dart';
import 'package:money_care/features/saving_fund/presentation/controllers/saving_fund_controller.dart';
import 'package:money_care/features/transaction/presentation/controllers/transaction_controller.dart';
import 'package:money_care/core/constants/colors.dart';
import 'package:money_care/core/constants/icon_string.dart';
import 'package:money_care/core/constants/sizes.dart';
import 'package:money_care/core/utils/Helper/helper_functions.dart';
import 'package:money_care/core/controllers/app_controller.dart';
import 'package:money_care/features/transaction/domain/entities/transaction_entity.dart';
import 'package:get/get.dart';
import 'package:money_care/features/home/presentation/widgets/transaction/transaction_item.dart';
import 'package:money_care/features/statistics/presentation/widgets/statistics_header.dart';
import 'package:money_care/features/transaction/presentation/widgets/filter_dialog.dart';
import 'package:money_care/features/transaction/presentation/widgets/search_filter.dart';
import 'package:money_care/features/transaction/presentation/widgets/transaction/transaction_detail.dart';

class TransactionScreen extends StatefulWidget {
  const TransactionScreen({super.key});

  @override
  State<TransactionScreen> createState() => _TransactionScreenState();
}

class _TransactionScreenState extends State<TransactionScreen> {
  String selected = 'chi';
  TextEditingController searchController = TextEditingController();
  String searchKeyword = '';

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
    initData();
  }

  Future<void> initData() async {
    final userId = await appController.getCurrentUserId();
    if (userId == null) return;

    await transactionController.loadTransactionScreenData(
      userId,
      TransactionFilterDto(
        fundId:
            fundController.fundId.value > 0
                ? fundController.fundId.value
                : null,
        startDate: filterController.startDate.toString(),
        endDate: filterController.endDate.toString(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          AppHeader(
            title: "Thu - Chi",
            child: Obx(() {
              final data = statisticsController.totalByType.value;

              if (transactionController.isLoading.value) {
                return const SizedBox(
                  height: 120,
                  child: Center(child: CircularProgressIndicator()),
                );
              }

              if (data == null) {
                return StatisticsHeader(
                  selected: selected,
                  onSelected: (value) => setState(() => selected = value),
                  title: "Thu - Chi",
                  spendText: 0,
                  incomeText: 0,
                );
              }

              return StatisticsHeader(
                selected: selected,
                onSelected: (value) => setState(() => selected = value),
                title: "Thu - Chi",
                spendText: data.expenseTotal,
                incomeText: data.incomeTotal,
              );
            }),
          ),

          SearchWithFilter(
            controller: searchController,
            onChanged: (value) {
              setState(() {
                searchKeyword = value;
              });
            },
            onFilterTap: () => _showFilterSheet(context),
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
      final filtered =
          data.expenseTransactions.where((t) {
            final note = t.note?.toLowerCase() ?? '';
            final keyword = searchKeyword.toLowerCase();
            return note.contains(keyword);
          }).toList();

      if (filtered.isEmpty) {
        return _buildEmptyView();
      }

      return ListView(
        key: const ValueKey('chi'),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children:
            filtered.map((item) {
              return TransactionItem(
                color: AppHelperFunction.getRandomColor(),
                item: item,
                isShowDate: true,
                onTap: () => _showTransactionDetail(context, item),
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

      final filtered =
          data.incomeTransactions.where((t) {
            final note = t.note?.toLowerCase() ?? '';
            final keyword = searchKeyword.toLowerCase();
            return note.contains(keyword);
          }).toList();

      if (filtered.isEmpty) return _buildEmptyView();

      return ListView(
        key: const ValueKey('thu'),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children:
            filtered.map((item) {
              return TransactionItem(
                color: AppHelperFunction.getRandomColor(),
                item: item,
                isShowDate: true,
                onTap: () => _showTransactionDetail(context, item),
              );
            }).toList(),
      );
    });
  }

  Widget _buildEmptyView() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(AppIcons.emptyFolder, width: 150, height: 150),
          const SizedBox(height: AppSizes.spaceBtwItems),
          const Text(
            'Không có giao dịch nào gần đây',
            style: TextStyle(fontSize: 16, color: AppColors.text5),
          ),
        ],
      ),
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

            if (data != null) {
              return FilterDialog(
                title: "Lọc theo phân loại",
                categories: data.categories,
                onApply: (result) {
                  _applyFilter();
                },
              );
            }

            return const SizedBox.shrink();
          }),
    );
  }

  void _showTimeFilterDialog(context) {
    showDialog(
      context: context,
      builder:
          (_) => FilterDialog(
            title: 'Lọc theo thời gian',
            items: const ['Hôm nay', 'Tuần này', 'Tháng này'],
            onApply: (result) {
              _applyFilter();
            },
          ),
    );
  }

  void _applyFilter() {
    final userId = appController.userId.value;
    if (userId == null) return;

    transactionController.filterTransactions(
      userId,
      TransactionFilterDto(
        categoryId: filterController.categoryId.toInt(),
        startDate: filterController.startDate.toString(),
        endDate: filterController.endDate.toString(),
      ),
    );
  }

  void _showFilterSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Text(
                'Bộ lọc giao dịch',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const Divider(height: AppSizes.dividerHeight),
            ListTile(
              leading: const Icon(Icons.category_outlined),
              title: const Text('Lọc theo phân loại'),
              onTap: () {
                Get.back();
                _showCategoryFilterDialog(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.access_time_outlined),
              title: const Text('Lọc theo thời gian'),
              onTap: () {
                Get.back();
                _showTimeFilterDialog(context);
              },
            ),
          ],
        );
      },
    );
  }
}
