import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:money_care/app/controllers/app_controller.dart';
import 'package:money_care/core/theme/app_theme_colors.dart';
import 'package:money_care/features/couple/presentation/controllers/couple_controller.dart';
import 'package:money_care/features/transaction/domain/entities/transaction_entity.dart';
import 'package:money_care/features/transaction/presentation/controllers/user_category_controller.dart';
import 'package:money_care/features/statistics/presentation/widgets/statistics_time_navigator.dart';
import 'package:money_care/features/home/presentation/widgets/transaction/transaction_item.dart';
import 'package:money_care/features/transaction/presentation/widgets/transaction_detail.dart';

import 'couple_settlement_view.dart';
import 'couple_transaction_calendar.dart';
import 'package:money_care/features/couple/presentation/screens/couple_photo_transaction_detail_screen.dart';
import 'package:money_care/features/couple/presentation/screens/couple_photo_transaction_screen.dart';

part 'couple_transactions_view_sections.dart';

class CoupleTransactionsView extends StatefulWidget {
  final CoupleController controller;

  const CoupleTransactionsView({super.key, required this.controller});

  @override
  State<CoupleTransactionsView> createState() => _CoupleTransactionsViewState();
}

class _CoupleTransactionsViewState extends State<CoupleTransactionsView> {
  late int _selectedDay;
  Worker? _monthWorker;

  @override
  void initState() {
    super.initState();
    final today = DateTime.now();
    final focused = widget.controller.selectedMonth.value;
    if (focused.year == today.year && focused.month == today.month) {
      _selectedDay = today.day;
    } else {
      _selectedDay = 1;
    }

    _monthWorker = ever(widget.controller.selectedMonth, (DateTime newMonth) {
      final t = DateTime.now();
      if (newMonth.year == t.year && newMonth.month == t.month) {
        _selectedDay = t.day;
      } else {
        _selectedDay = 1;
      }
      if (mounted) setState(() {});
    });

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
    _monthWorker?.dispose();
    super.dispose();
  }

  void selectDay(int day) {
    setState(() {
      _selectedDay = day;
    });
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
          await Get.to(() => CouplePhotoTransactionScreen(
                coupleController: widget.controller,
              ));
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
              Expanded(child: _buildTransactionsList(context, currentUserId)),
            ],
          ),
          // Tab 2: Settlement Overview
          CoupleSettlementView(controller: widget.controller),
        ],
      ),
    );
  }
}
