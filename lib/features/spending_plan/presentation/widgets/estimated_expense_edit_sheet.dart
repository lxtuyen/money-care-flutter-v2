import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:money_care/app/controllers/app_controller.dart';
import 'package:money_care/app/widgets/icon/app_svg_icon.dart';
import 'package:money_care/app/widgets/text_field/app_currency_form_field.dart';
import 'package:money_care/core/constants/colors.dart';
import 'package:money_care/core/utils/helper/helper_functions.dart';
import 'package:money_care/features/spending_plan/domain/entities/spending_plan_entity.dart';
import 'package:money_care/features/spending_plan/domain/entities/spending_plan_request.dart';
import 'package:money_care/features/spending_plan/presentation/controllers/spending_plan_controller.dart';
import 'package:money_care/features/transaction/domain/entities/category_entity.dart';
import 'package:money_care/features/transaction/presentation/controllers/user_category_controller.dart';
import 'package:money_care/features/transaction/presentation/widgets/category_sheet.dart';

class EstimatedExpenseEditSheet extends StatefulWidget {
  final SpendingPlanEntity? plan;
  final EstimatedExpenseEntity? expense;
  final EstimatedExpenseEntity? initialDraft;
  final Future<bool> Function(CreateEstimatedExpenseRequest request)? onSave;

  const EstimatedExpenseEditSheet({
    super.key,
    this.plan,
    this.expense,
    this.initialDraft,
    this.onSave,
  });

  @override
  State<EstimatedExpenseEditSheet> createState() =>
      _EstimatedExpenseEditSheetState();
}

class _EstimatedExpenseEditSheetState extends State<EstimatedExpenseEditSheet> {
  final _amountController = TextEditingController();
  CategoryEntity? _selectedCategory;
  final _categoryController = Get.find<UserCategoryController>();
  final _spendingPlanController = Get.find<SpendingPlanController>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final userId = Get.find<AppController>().userId.value;
      if (userId != null && _categoryController.categories.isEmpty) {
        _categoryController.loadCategories(userId);
      }

      if (widget.expense != null) {
        final exp = widget.expense!;
        _amountController.text = exp.amount.round().toString();
        if (exp.category != null) {
          _selectedCategory = _categoryController.categories.firstWhereOrNull(
            (c) => c.name.toLowerCase() == exp.category!.toLowerCase(),
          );
          if (_selectedCategory != null) setState(() {});
        }
      } else if (widget.initialDraft != null) {
        final draft = widget.initialDraft!;
        _amountController.text =
            draft.amount > 0 ? draft.amount.round().toString() : '';
        if (draft.category != null) {
          final matched = _categoryController.categories.firstWhereOrNull(
            (c) =>
                c.id == draft.categoryId ||
                c.name.toLowerCase() == draft.category!.toLowerCase(),
          );
          if (matched != null) setState(() => _selectedCategory = matched);
        }
      }
    });
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  double _parseMoney(String text) =>
      double.tryParse(text.replaceAll('.', '').replaceAll(',', '')) ?? 0.0;

  Future<void> _submit() async {
    if (_selectedCategory == null) {
      AppHelperFunction.showErrorSnackBar('Vui lòng chọn danh mục.');
      return;
    }
    final amount = _parseMoney(_amountController.text);
    if (amount <= 0) {
      AppHelperFunction.showErrorSnackBar('Vui lòng nhập số tiền hợp lệ.');
      return;
    }

    final request = CreateEstimatedExpenseRequest(
      category: _selectedCategory!.name,
      categoryId: _selectedCategory!.id,
      amount: amount,
      monthlyLimit: amount,
      dailyLimit: null,
      frequencyType: 'monthly',
      frequencyValue: 1,
    );

    if (widget.onSave != null) {
      final success = await widget.onSave!(request);
      if (success) Get.back();
      return;
    }

    if (widget.plan == null) {
      AppHelperFunction.showErrorSnackBar('Lỗi hệ thống: Thiếu thông tin kế hoạch.');
      return;
    }

    final bool success;
    if (widget.expense == null) {
      success = await _spendingPlanController.addPlanExpense(
        widget.plan!.id,
        request,
        showSuccessMessage: false,
      );
    } else {
      success = await _spendingPlanController.updatePlanExpense(
        widget.plan!.id,
        widget.expense!.id,
        request,
        showSuccessMessage: false,
      );
    }

    if (success) {
      Get.back();
      Future.delayed(const Duration(milliseconds: 150), () {
        AppHelperFunction.showSuccessSnackBar(
          widget.expense == null
              ? 'Đã thêm khoản chi dự kiến thành công'
              : 'Đã cập nhật khoản chi dự kiến',
        );
      });
    }
  }

  Future<void> _selectCategory() async {
    final categories = _categoryController.categories
        .where((c) => c.type != 'income')
        .toList();
    if (categories.isEmpty) return;

    final selected = await showModalBottomSheet<CategoryEntity>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => CategorySheet(
        categories: categories,
        selectedCategoryInit: _selectedCategory,
        transactionType: 'expense',
      ),
    );

    if (selected != null) setState(() => _selectedCategory = selected);
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.expense != null;
    final iconColor = _selectedCategory?.color ?? AppColors.primary;
    final hasIcon = _selectedCategory != null &&
        _selectedCategory!.icon.isNotEmpty;

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.fromLTRB(
        20,
        12,
        20,
        MediaQuery.of(context).viewInsets.bottom + 28,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Handle bar
          Center(
            child: Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(99),
              ),
            ),
          ),

          // Header
          Row(
            children: [
              Expanded(
                child: Text(
                  isEdit ? 'Sửa khoản chi' : 'Thêm khoản chi',
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                    color: AppColors.text1,
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close_rounded, color: AppColors.text3),
                onPressed: () => Get.back(),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Category picker
          InkWell(
            onTap: _selectCategory,
            borderRadius: BorderRadius.circular(14),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
              decoration: BoxDecoration(
                color: _selectedCategory != null
                    ? iconColor.withValues(alpha: 0.06)
                    : Colors.grey.shade50,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: _selectedCategory != null
                      ? iconColor.withValues(alpha: 0.25)
                      : Colors.grey.shade300,
                  width: 1.2,
                ),
              ),
              child: Row(
                children: [
                  if (_selectedCategory != null) ...[
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: iconColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child: hasIcon
                            ? AppSvgIcon(
                                iconName: _selectedCategory!.icon,
                                color: iconColor,
                                size: 16,
                              )
                            : Icon(
                                Icons.receipt_long_outlined,
                                color: iconColor,
                                size: 16,
                              ),
                      ),
                    ),
                    const SizedBox(width: 10),
                  ] else ...[
                    Icon(
                      Icons.grid_view_rounded,
                      color: Colors.grey.shade400,
                      size: 20,
                    ),
                    const SizedBox(width: 10),
                  ],
                  Expanded(
                    child: Text(
                      _selectedCategory?.name ?? 'Chọn danh mục',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                        color: _selectedCategory != null
                            ? AppColors.text1
                            : Colors.grey.shade500,
                      ),
                    ),
                  ),
                  Icon(
                    Icons.keyboard_arrow_down_rounded,
                    color: Colors.grey.shade400,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),

          // Amount field
          AppCurrencyFormField(
            controller: _amountController,
            label: 'Số tiền mỗi tháng',
            icon: Icons.payments_outlined,
            hintText: 'VD: 1.000.000',
          ),
          const SizedBox(height: 20),

          // Save button
          Obx(
            () => FilledButton(
              onPressed: _spendingPlanController.isSaving.value ? null : _submit,
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.primary,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: _spendingPlanController.isSaving.value
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                        valueColor:
                            AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : Text(
                      isEdit ? 'Cập nhật' : 'Thêm',
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
