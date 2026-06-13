import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:money_care/app/controllers/app_controller.dart';
import 'package:money_care/app/widgets/states/app_empty_state.dart';
import 'package:money_care/core/theme/app_theme_colors.dart';
import 'package:money_care/core/utils/helper/helper_functions.dart';
import 'package:money_care/features/couple/presentation/controllers/couple_controller.dart';
import 'package:money_care/features/transaction/domain/entities/transaction_entity.dart';
import 'package:money_care/features/transaction/presentation/controllers/user_category_controller.dart';
import 'package:money_care/core/constants/route_path.dart';
import 'package:money_care/features/statistics/presentation/widgets/statistics_time_navigator.dart';
import 'package:money_care/features/transaction/presentation/widgets/filter_dialog.dart';
import 'package:money_care/features/home/presentation/widgets/transaction/transaction_item.dart';
import 'package:money_care/features/transaction/presentation/widgets/transaction_detail.dart';
import 'package:money_care/features/transaction/presentation/widgets/search_filter.dart';

import 'couple_settlement_view.dart';

part 'couple_transactions_view_sections.dart';

class CoupleTransactionsView extends StatefulWidget {
  final CoupleController controller;

  const CoupleTransactionsView({super.key, required this.controller});

  @override
  State<CoupleTransactionsView> createState() => _CoupleTransactionsViewState();
}

class _CoupleTransactionsViewState extends State<CoupleTransactionsView> {
  final TextEditingController _searchController = TextEditingController();
  String _searchKeyword = '';
  int? _selectedWalletFilter;
  int? _selectedPayerFilter;
  int? _selectedCategoryFilter;
  String _selectedTypeFilter = 'all';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!Get.isRegistered<UserCategoryController>()) return;
      final appController = Get.find<AppController>();
      final userId = appController.userId.value;
      final categoryController = Get.find<UserCategoryController>();
      if (userId != null &&
          userId > 0 &&
          categoryController.categories.isEmpty) {
        categoryController.loadCategories(userId);
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.primaryColor;
    final appController = Get.find<AppController>();
    final currentUserId = appController.userId.value ?? 0;

    return Scaffold(
      backgroundColor: Colors.transparent,
      floatingActionButton: FloatingActionButton(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        onPressed: () async {
          await Get.toNamed(
            RoutePath.createTransaction,
            arguments: {'type': 'expense', 'isShared': true},
          );
          widget.controller.fetchCoupleData();
        },
        child: const Icon(Icons.add),
      ),
      body: TabBarView(
        children: [
          // Tab 1: Transaction List
          Column(
            children: [
              const SizedBox(height: 12),
              Obx(
                () => StatisticsTimeNavigator(
                  focusedMonth: widget.controller.selectedMonth.value,
                  onPrevious: () {
                    final current = widget.controller.selectedMonth.value;
                    widget.controller.changeMonth(
                      DateTime(current.year, current.month - 1),
                    );
                  },
                  onNext: () {
                    final current = widget.controller.selectedMonth.value;
                    widget.controller.changeMonth(
                      DateTime(current.year, current.month + 1),
                    );
                  },
                  onTap: () async {
                    final DateTime? picked = await showDatePicker(
                      context: context,
                      initialDate: widget.controller.selectedMonth.value,
                      firstDate: DateTime(2020),
                      lastDate: DateTime(2030),
                      initialDatePickerMode: DatePickerMode.year,
                    );
                    if (picked != null) {
                      widget.controller.changeMonth(picked);
                    }
                  },
                ),
              ),
              const SizedBox(height: 8),
              Container(
                color: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                child: Column(
                  children: [
                    SearchWithFilter(
                      controller: _searchController,
                      showFilter: false,
                      padding: EdgeInsets.zero,
                      hintText: 'Tìm ghi chú...',
                      onChanged: (val) {
                        setState(() {
                          _searchKeyword = val.trim().toLowerCase();
                        });
                      },
                      onClearSearch: () {
                        _searchController.clear();
                        setState(() {
                          _searchKeyword = '';
                        });
                      },
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: _buildFilterTrigger(
                            label: 'Ví chung',
                            value: _selectedWalletFilter != null
                                ? widget.controller.sharedWallets
                                          .firstWhereOrNull(
                                            (w) =>
                                                w.id == _selectedWalletFilter,
                                          )
                                          ?.name ??
                                      'Tất cả'
                                : 'Tất cả',
                            onTap: _showWalletFilter,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: _buildFilterTrigger(
                            label: 'Người trả',
                            value: _getPayerName(
                              _selectedPayerFilter,
                              currentUserId,
                            ),
                            onTap: () => _showPayerFilter(currentUserId),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: _buildFilterTrigger(
                            label: 'Danh mục',
                            value: _selectedCategoryFilter != null
                                ? Get.find<UserCategoryController>().categories
                                          .firstWhereOrNull(
                                            (c) =>
                                                c.id == _selectedCategoryFilter,
                                          )
                                          ?.name ??
                                      'Tất cả'
                                : 'Tất cả',
                            onTap: _showCategoryFilter,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: _buildFilterTrigger(
                            label: 'Loại',
                            value: _selectedTypeFilter == 'expense'
                                ? 'Chi tiêu'
                                : _selectedTypeFilter == 'income'
                                ? 'Thu nhập'
                                : 'Tất cả',
                            onTap: _showTypeFilter,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Expanded(child: _buildTransactionsList(context, currentUserId)),
            ],
          ),
          // Tab 2: Settlement Overview
          CoupleSettlementView(controller: widget.controller),
        ],
      ),
    );
  }

  Widget _buildFilterTrigger({
    required String label,
    required String value,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey[300]!),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(fontSize: 10, color: Colors.grey),
            ),
            const SizedBox(height: 2),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    value,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const Icon(Icons.arrow_drop_down, size: 16, color: Colors.grey),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _getPayerName(int? payerId, int currentUserId) {
    if (payerId == null) return 'Tất cả';
    if (payerId == currentUserId) return 'Bạn';
    final partner = widget.controller.couple.value?.partner(currentUserId);
    if (partner != null && partner.userId == payerId) {
      return partner.fullName;
    }
    return 'Chưa rõ';
  }

  void _showWalletFilter() {
    showDialog(
      context: context,
      builder: (context) => FilterDialog(
        title: 'Ví chung',
        wallets: widget.controller.sharedWallets,
        initialSelectedId: _selectedWalletFilter?.toString(),
        onApply: (res) {
          setState(() {
            _selectedWalletFilter = res.selectedId.isNotEmpty
                ? int.tryParse(res.selectedId)
                : null;
          });
        },
      ),
    );
  }

  void _showPayerFilter(int currentUserId) {
    final partner = widget.controller.couple.value?.partner(currentUserId);
    final partnerId = partner?.userId;
    final partnerName = partner?.fullName ?? 'Đối tác';

    final items = ['Tất cả', 'Bạn', partnerName];
    String? initialSelected;
    if (_selectedPayerFilter == currentUserId) {
      initialSelected = 'Bạn';
    } else if (partnerId != null && _selectedPayerFilter == partnerId) {
      initialSelected = partnerName;
    } else if (_selectedPayerFilter == null) {
      initialSelected = 'Tất cả';
    }

    showDialog(
      context: context,
      builder: (context) => FilterDialog(
        title: 'Người trả',
        genericItems: items,
        initialSelectedId: initialSelected,
        onApply: (res) {
          setState(() {
            if (res.selectedId == 'Bạn') {
              _selectedPayerFilter = currentUserId;
            } else if (res.selectedId == partnerName && partnerId != null) {
              _selectedPayerFilter = partnerId;
            } else {
              _selectedPayerFilter = null;
            }
          });
        },
      ),
    );
  }

  void _showCategoryFilter() {
    final categories = Get.find<UserCategoryController>().categories
        .where((category) => category.id != null)
        .toList();

    showDialog(
      context: context,
      builder: (context) => FilterDialog(
        title: 'Danh mục',
        categories: categories,
        initialSelectedId: _selectedCategoryFilter?.toString(),
        onApply: (res) {
          setState(() {
            _selectedCategoryFilter = res.selectedId.isNotEmpty
                ? int.tryParse(res.selectedId)
                : null;
          });
        },
      ),
    );
  }

  void _showTypeFilter() {
    final items = ['Tất cả', 'Chi tiêu', 'Thu nhập'];
    String? initialSelected;
    if (_selectedTypeFilter == 'expense') {
      initialSelected = 'Chi tiêu';
    } else if (_selectedTypeFilter == 'income') {
      initialSelected = 'Thu nhập';
    } else {
      initialSelected = 'Tất cả';
    }

    showDialog(
      context: context,
      builder: (context) => FilterDialog(
        title: 'Loại giao dịch',
        genericItems: items,
        initialSelectedId: initialSelected,
        onApply: (res) {
          setState(() {
            if (res.selectedId == 'Chi tiêu') {
              _selectedTypeFilter = 'expense';
            } else if (res.selectedId == 'Thu nhập') {
              _selectedTypeFilter = 'income';
            } else {
              _selectedTypeFilter = 'all';
            }
          });
        },
      ),
    );
  }
}
