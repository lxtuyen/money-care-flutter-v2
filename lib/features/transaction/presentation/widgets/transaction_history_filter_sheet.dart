import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:money_care/core/constants/colors.dart';
import 'package:money_care/core/theme/app_theme_colors.dart';
import 'package:money_care/app/controllers/app_controller.dart';
import 'package:money_care/app/controllers/saving_goal_controller.dart';
import 'package:money_care/app/controllers/statistics_controller.dart';
import 'package:money_care/app/controllers/transaction_controller.dart';
import 'package:money_care/features/wallet/presentation/controllers/wallet_controller.dart';
import 'package:money_care/features/transaction/domain/entities/transaction_entity.dart';
import 'package:money_care/features/transaction/presentation/controllers/filter_controller.dart';
import 'package:money_care/features/transaction/presentation/widgets/filter_dialog.dart';

class TransactionHistoryFilterSheet extends StatelessWidget {
  final VoidCallback? onClearFilters;

  const TransactionHistoryFilterSheet({super.key, this.onClearFilters});

  @override
  Widget build(BuildContext context) {
    final appController = Get.find<AppController>();
    final savingGoalController = Get.find<SavingGoalController>();
    final walletController = Get.find<WalletController>();
    final filterController = Get.find<FilterController>();
    final statisticsController = Get.find<StatisticsController>();
    final transactionController = Get.find<TransactionController>();

    return SafeArea(
      child: Obx(() {
        String categorySubtitle = 'filter.byCategorySubtitle'.tr;
        if (filterController.categoryId.value != null) {
          final categoryId = filterController.categoryId.value;
          final cats = savingGoalController.currentGoal.value?.categories ?? [];
          final cat = cats.cast<CategoryEntity?>().firstWhere(
            (c) => c?.id == categoryId,
            orElse: () => null,
          );
          if (cat != null) {
            categorySubtitle = 'filter.selectedCategory'.tr.replaceAll(
              '@name',
              cat.name,
            );
          } else {
            categorySubtitle = 'filter.selected1Category'.tr;
          }
        }

        String walletSubtitle = 'common.all'.tr;
        if (filterController.walletId.value != null) {
          final wallet = walletController.wallets.firstWhereOrNull(
            (w) => w.id == filterController.walletId.value,
          );
          if (wallet != null) {
            walletSubtitle = wallet.name;
          }
        }

        return Container(
          decoration: BoxDecoration(
            color: AppThemeColors.of(context).cardBackground,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
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
                      color: AppThemeColors.of(context).surfaceBackground,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Icon(
                      Icons.tune_rounded,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'filter.title'.tr,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: AppThemeColors.of(context).textPrimary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'filter.description'.tr,
                          style: const TextStyle(
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
              _FilterSheetTile(
                icon: Icons.category_outlined,
                title: 'filter.byCategory'.tr,
                subtitle: categorySubtitle,
                onTap: () {
                  Get.back();
                  _showCategoryFilterDialog(
                    context,
                    statisticsController,
                    savingGoalController,
                    filterController,
                    transactionController,
                    appController,
                  );
                },
              ),
              const SizedBox(height: 12),
              _FilterSheetTile(
                icon: Icons.account_balance_wallet_outlined,
                title: 'filter.byWallet'.tr == 'filter.byWallet'
                    ? 'Lọc theo ví'
                    : 'filter.byWallet'.tr,
                subtitle: walletSubtitle,
                onTap: () {
                  Get.back();
                  _showWalletFilterDialog(
                    context,
                    walletController,
                    filterController,
                    transactionController,
                    appController,
                  );
                },
              ),
              const SizedBox(height: 12),
              _FilterSheetTile(
                icon: Icons.calendar_today_rounded,
                title: 'filter.byTime'.tr,
                subtitle: filterController.dateLabel.value,
                onTap: () {
                  Get.back();
                  _showTimeFilterDialog(
                    context,
                    filterController,
                    transactionController,
                    appController,
                  );
                },
              ),
              if (filterController.hasActiveFilters) ...[
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () {
                      Get.back();
                      if (onClearFilters != null) {
                        onClearFilters!();
                      } else {
                        _clearFilters(
                          filterController,
                          transactionController,
                          appController,
                        );
                      }
                    },
                    icon: const Icon(Icons.restart_alt_rounded),
                    label: Text('common.clearAllFilters'.tr),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.text2,
                      side: BorderSide(
                        color: AppThemeColors.of(context).textMuted,
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
        );
      }),
    );
  }

  void _showCategoryFilterDialog(
    BuildContext context,
    StatisticsController statisticsController,
    SavingGoalController savingGoalController,
    FilterController filterController,
    TransactionController transactionController,
    AppController appController,
  ) {
    showDialog(
      context: context,
      builder: (context) => Obx(() {
        final isExpenseTab = statisticsController.selectedType.value == 'chi';

        final categoriesFromStats = isExpenseTab
            ? statisticsController.expenseCategories
            : statisticsController.incomeCategories;

        List<CategoryEntity> filteredCategories = categoriesFromStats
            .map<CategoryEntity>(
              (e) => CategoryEntity(
                id: e.categoryId,
                name: e.categoryName,
                icon: e.categoryIcon,
                type: isExpenseTab ? 'expense' : 'income',
              ),
            )
            .toList();

        if (filteredCategories.isEmpty) {
          final data = savingGoalController.currentGoal.value;
          final fundCategories = data?.categories ?? [];
          filteredCategories = fundCategories.where((c) {
            final catType = c.type?.toLowerCase() ?? '';
            return isExpenseTab ? catType != 'income' : catType == 'income';
          }).toList();
        }

        if (savingGoalController.isLoadingCurrent.value &&
            filteredCategories.isEmpty) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.only(top: 50),
              child: CircularProgressIndicator(),
            ),
          );
        }

        return FilterDialog(
          title: 'filter.byCategory',
          categories: filteredCategories,
          onApply: (_) => _applyFilter(transactionController, appController),
        );
      }),
    );
  }

  void _showTimeFilterDialog(
    BuildContext context,
    FilterController filterController,
    TransactionController transactionController,
    AppController appController,
  ) {
    showDialog(
      context: context,
      builder: (_) => FilterDialog(
        title: 'filter.byTime'.tr,
        items: [
          'filter.timeToday'.tr,
          'filter.timeWeek'.tr,
          'filter.timeMonth'.tr,
          'filter.timeCustom'.tr,
        ],
        onApply: (_) => _applyFilter(transactionController, appController),
      ),
    );
  }

  void _showWalletFilterDialog(
    BuildContext context,
    WalletController walletController,
    FilterController filterController,
    TransactionController transactionController,
    AppController appController,
  ) {
    showDialog(
      context: context,
      builder: (context) => Obx(() {
        if (walletController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return FilterDialog(
          title: 'filter.byWallet',
          wallets: walletController.wallets,
          onApply: (_) => _applyFilter(transactionController, appController),
        );
      }),
    );
  }

  Future<void> _applyFilter(
    TransactionController transactionController,
    AppController appController,
  ) async {
    final userId = appController.userId.value;
    if (userId == null) return;

    await transactionController.applyFilters(userId);
  }

  void _clearFilters(
    FilterController filterController,
    TransactionController transactionController,
    AppController appController,
  ) {
    filterController.clearAll();
    _applyFilter(transactionController, appController);
  }
}

class _FilterSheetTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _FilterSheetTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Ink(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppThemeColors.of(context).cardBackground,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: AppThemeColors.of(
                context,
              ).textMuted.withValues(alpha: 0.2),
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.text1.withValues(alpha: 0.04),
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
                  color: AppThemeColors.of(context).surfaceBackground,
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
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: AppThemeColors.of(context).textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 13,
                        color: AppThemeColors.of(context).textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios_rounded,
                size: 16,
                color: AppThemeColors.of(context).textMuted,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
