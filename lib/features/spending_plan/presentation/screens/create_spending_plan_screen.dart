import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:money_care/app/widgets/layout/app_header.dart';
import 'package:money_care/app/controllers/app_controller.dart';
import 'package:money_care/app/widgets/text_field/app_currency_form_field.dart';
import 'package:money_care/core/constants/colors.dart';
import 'package:money_care/core/utils/helper/helper_functions.dart';
import 'package:money_care/features/spending_plan/data/models/spending_plan_model.dart';
import 'package:money_care/features/spending_plan/domain/entities/spending_plan_entity.dart';
import 'package:money_care/features/spending_plan/presentation/controllers/spending_plan_controller.dart';
import 'package:money_care/features/transaction/domain/entities/category_entity.dart';
import 'package:money_care/features/transaction/presentation/controllers/user_category_controller.dart';
import 'package:money_care/features/transaction/presentation/widgets/category_sheet.dart';
import 'package:money_care/app/widgets/dialog/selection_dialog.dart';
import 'package:money_care/app/widgets/text_field/app_text_form_field.dart';
import 'package:money_care/app/widgets/text_field/app_dropdown_field.dart';

class CreateSpendingPlanScreen extends StatefulWidget {
  const CreateSpendingPlanScreen({super.key});

  @override
  State<CreateSpendingPlanScreen> createState() =>
      _CreateSpendingPlanScreenState();
}

class _CreateSpendingPlanScreenState extends State<CreateSpendingPlanScreen> {
  final SpendingPlanController controller = Get.find<SpendingPlanController>();
  final UserCategoryController categoryController =
      Get.find<UserCategoryController>();
  final _formKey = GlobalKey<FormState>();
  final _incomeController = TextEditingController();
  final _estimatedExpenses = <_EstimatedExpenseDraft>[];
  SpendingPlanEntity? _editingPlan;

  int get _daysInMonth {
    final plan = _editingPlan;
    if (plan != null) {
      return DateTime(plan.year, plan.month + 1, 0).day;
    }
    final now = DateTime.now();
    return DateTime(now.year, now.month + 1, 0).day;
  }

  double get _income => _parseMoney(_incomeController.text);

  double get _estimatedExpensesTotal {
    double total = 0;
    for (final expense in _estimatedExpenses) {
      final amount = _parseMoney(expense.amount.text);
      if (amount <= 0) continue;

      final val = int.tryParse(expense.frequencyValue.text) ?? 1;
      if (expense.frequencyType == 'daily') {
        total += amount * val * _daysInMonth;
      } else if (expense.frequencyType == 'weekly') {
        total += amount * val * (_daysInMonth / 7);
      } else {
        total += amount * val;
      }
    }
    return total;
  }

  double get _remaining => _income - _estimatedExpensesTotal;

  @override
  void initState() {
    super.initState();
    _incomeController.addListener(_refreshPreview);
    final argument = Get.arguments;
    SpendingPlanEntity? sourcePlan;

    if (argument is SpendingPlanEntity) {
      _editingPlan = argument;
      sourcePlan = argument;
    } else if (argument is Map && argument['isClone'] == true) {
      sourcePlan = argument['plan'] as SpendingPlanEntity?;
    }

    if (sourcePlan == null) {
      // Auto-populate a default "Tiền ăn" daily expense
      final mealDraft = _EstimatedExpenseDraft();
      mealDraft.amount.addListener(_refreshPreview);
      mealDraft.frequencyType = 'daily';
      mealDraft.frequencyValue.text = '3';
      _estimatedExpenses.add(mealDraft);
    } else {
      _incomeController.text = _formatNumberInput(sourcePlan.totalAmount);
      for (final expense in sourcePlan.estimatedExpenses) {
        final draft = _EstimatedExpenseDraft();
        draft.amount.text = _formatNumberInput(expense.amount);
        draft.amount.addListener(_refreshPreview);
        draft.frequencyType = expense.frequencyType;
        draft.frequencyValue.text = expense.frequencyValue.toString();
        _estimatedExpenses.add(draft);
      }
    }

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final userId = Get.find<AppController>().userId.value;
      if (userId != null) {
        if (categoryController.categories.isEmpty) {
          await categoryController.loadCategories(userId);
        }
        if (sourcePlan == null) {
          // Auto-select "Ăn uống" category if available
          final foodCat = categoryController.categories.firstWhereOrNull(
            (cat) =>
                cat.name.toLowerCase().contains('ăn') ||
                cat.name.toLowerCase().contains('food'),
          );
          if (foodCat != null && _estimatedExpenses.isNotEmpty) {
            setState(() {
              _estimatedExpenses[0].selectedCategory = foodCat;
            });
          }
        } else {
          setState(() {
            for (var i = 0; i < sourcePlan!.estimatedExpenses.length; i++) {
              final item = sourcePlan.estimatedExpenses[i];
              final categoryName = item.category;
              final cat = categoryController.categories.firstWhereOrNull(
                (c) => c.name == categoryName,
              );
              _estimatedExpenses[i].selectedCategory = cat;
              if (cat != null && item.subCategory != null) {
                _estimatedExpenses[i].selectedSubCategory = cat.subCategories
                    .firstWhereOrNull((sub) => sub.name == item.subCategory);
              }
            }
          });
        }
      }
    });
  }

  @override
  void dispose() {
    _incomeController.dispose();
    for (final expense in _estimatedExpenses) {
      expense.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            AppHeader(
              title: _editingPlan == null
                  ? 'Tạo kế hoạch chi tiêu'
                  : 'Cập nhật kế hoạch',
              showBackButton: true,
              height: 140,
            ),
            Expanded(
              child: Form(
                key: _formKey,
                child: ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    AppCurrencyFormField(
                      controller: _incomeController,
                      label: 'Thu nhập hàng tháng',
                      icon: Icons.account_balance_wallet_outlined,
                      hintText: 'VD: 3.000.000',
                      validator: _positiveNumber,
                    ),
                    const SizedBox(height: 16),
                    _MonthlyPreviewCard(
                      income: _income,
                      estimatedCost: _estimatedExpensesTotal,
                      remaining: _remaining,
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Khoản chi dự kiến',
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(fontWeight: FontWeight.w700),
                          ),
                        ),
                        IconButton(
                          tooltip: 'Thêm khoản phí',
                          onPressed: _addEstimatedExpense,
                          icon: const Icon(Icons.add_circle_outline),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Obx(() {
                      final categories = _expenseCategories;
                      if (_estimatedExpenses.isEmpty) {
                        return Text(
                          'Thêm các khoản chi tiêu dự tính (ước lượng) như ăn uống, đi lại, tiền nhà, điện nước, internet hoặc học phí.',
                          style: TextStyle(color: Colors.grey.shade700),
                        );
                      }

                      return Column(
                        children: _estimatedExpenses.asMap().entries.map((
                          entry,
                        ) {
                          return _EstimatedExpenseFields(
                            draft: entry.value,
                            onRemove: () => _removeEstimatedExpense(entry.key),
                            onChanged: _refreshPreview,
                            categories: categories,
                          );
                        }).toList(),
                      );
                    }),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Obx(
            () => FilledButton.icon(
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.primary,
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              onPressed: controller.isSaving.value ? null : _submit,
              label: Text(
                _editingPlan == null ? 'Lưu kế hoạch' : 'Cập nhật kế hoạch',
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _refreshPreview() {
    if (mounted) setState(() {});
  }

  void _addEstimatedExpense() {
    setState(() {
      final draft = _EstimatedExpenseDraft();
      draft.amount.addListener(_refreshPreview);
      _estimatedExpenses.add(draft);
    });
  }

  void _removeEstimatedExpense(int index) {
    setState(() {
      _estimatedExpenses.removeAt(index).dispose();
    });
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    final hasInvalidExtraFee = _estimatedExpenses.any((expense) {
      final hasAnyInput =
          expense.selectedCategory != null ||
          expense.amount.text.trim().isNotEmpty;
      final isComplete =
          expense.selectedCategory != null &&
          _parseMoney(expense.amount.text) > 0;
      return hasAnyInput && !isComplete;
    });

    if (hasInvalidExtraFee) {
      AppHelperFunction.showErrorSnackBar(
        'Mỗi khoản phí khác cần có danh mục và số tiền.',
      );
      return;
    }

    final estimatedExpenses = _buildEstimatedExpenseRequests();
    final success = _editingPlan == null
        ? await controller.createPlan(
            CreateSpendingPlanRequest(
              totalAmount: _income,
              estimatedExpenses: estimatedExpenses,
            ),
          )
        : await controller.updatePlan(
            _editingPlan!.id,
            UpdateSpendingPlanRequest(
              totalAmount: _income,
              estimatedExpenses: estimatedExpenses,
            ),
          );
    if (success) {
      Get.back();
    }
  }

  List<CreateEstimatedExpenseRequest> _buildEstimatedExpenseRequests() {
    return _estimatedExpenses
        .where(
          (expense) =>
              expense.selectedCategory != null &&
              _parseMoney(expense.amount.text) > 0,
        )
        .map(
          (expense) => CreateEstimatedExpenseRequest(
            category: expense.selectedCategory!.name,
            categoryId: expense.selectedCategory!.id,
            subCategoryId: expense.selectedSubCategory?.id,
            amount: _parseMoney(expense.amount.text),
            monthlyLimit: _monthlyLimitFor(expense),
            dailyLimit: _dailyLimitFor(expense),
            frequencyType: expense.frequencyType,
            frequencyValue: int.tryParse(expense.frequencyValue.text) ?? 1,
          ),
        )
        .toList();
  }

  double _monthlyLimitFor(_EstimatedExpenseDraft expense) {
    final amount = _parseMoney(expense.amount.text);
    final frequencyValue = int.tryParse(expense.frequencyValue.text) ?? 1;
    switch (expense.frequencyType) {
      case 'daily':
        return amount * frequencyValue * _daysInMonth;
      case 'weekly':
        return amount * frequencyValue * (_daysInMonth / 7);
      case 'monthly':
      default:
        return amount * frequencyValue;
    }
  }

  double? _dailyLimitFor(_EstimatedExpenseDraft expense) {
    if (expense.frequencyType != 'daily') return null;
    final amount = _parseMoney(expense.amount.text);
    final frequencyValue = int.tryParse(expense.frequencyValue.text) ?? 1;
    return amount * frequencyValue;
  }

  String? _positiveNumber(String? value) {
    final number = _parseMoney(value ?? '');
    if (number <= 0) return 'Nhập số tiền lớn hơn 0';
    return null;
  }

  double _parseMoney(String value) {
    return double.tryParse(value.replaceAll('.', '').replaceAll(',', '')) ?? 0;
  }

  String _formatNumberInput(double value) => value.round().toString();

  List<CategoryEntity> get _expenseCategories {
    return categoryController.categories
        .where((category) => category.type != 'income')
        .toList();
  }
}

class _MonthlyPreviewCard extends StatelessWidget {
  final double income;
  final double estimatedCost;
  final double remaining;

  const _MonthlyPreviewCard({
    required this.income,
    required this.estimatedCost,
    required this.remaining,
  });

  @override
  Widget build(BuildContext context) {
    final safeIncome = income <= 0 ? 1.0 : income;
    final estimatedRatio = (estimatedCost / safeIncome).clamp(0.0, 1.0);
    final remainingRatio = (remaining / safeIncome).clamp(0.0, 1.0);
    final isOver = remaining < 0;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Phác họa tháng này',
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: SizedBox(
              height: 14,
              child: Row(
                children: [
                  if (estimatedRatio > 0)
                    Expanded(
                      flex: _ratioFlex(estimatedRatio),
                      child: Container(color: const Color(0xFFF59E0B)),
                    ),
                  if (remainingRatio > 0)
                    Expanded(
                      flex: _ratioFlex(remainingRatio),
                      child: Container(color: const Color(0xFF10B981)),
                    ),
                  if (estimatedRatio == 0 && remainingRatio == 0)
                    Expanded(child: Container(color: Colors.grey.shade200)),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          _PreviewRow(
            color: const Color(0xFFF59E0B),
            label: 'Khoản chi dự kiến',
            value: estimatedCost,
          ),
          _PreviewRow(
            color: isOver ? Colors.red : const Color(0xFF10B981),
            label: isOver ? 'Đang thiếu' : 'Dư ra',
            value: remaining.abs(),
          ),
        ],
      ),
    );
  }

  int _ratioFlex(double ratio) {
    return (ratio * 1000).round().clamp(1, 1000);
  }
}

class _PreviewRow extends StatelessWidget {
  final Color color;
  final String label;
  final double value;

  const _PreviewRow({
    required this.color,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Row(
        children: [
          Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 8),
          Expanded(child: Text(label)),
          Text(
            _formatMoney(value),
            style: const TextStyle(fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }
}

class _EstimatedExpenseDraft {
  final amount = TextEditingController();
  final frequencyValue = TextEditingController(text: '1');
  String frequencyType = 'monthly';
  CategoryEntity? selectedCategory;
  SubCategoryEntity? selectedSubCategory;

  void dispose() {
    amount.dispose();
    frequencyValue.dispose();
  }
}

class _EstimatedExpenseFields extends StatelessWidget {
  final _EstimatedExpenseDraft draft;
  final VoidCallback onRemove;
  final VoidCallback onChanged;
  final List<CategoryEntity> categories;

  const _EstimatedExpenseFields({
    required this.draft,
    required this.onRemove,
    required this.onChanged,
    required this.categories,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: AppColors.borderSecondary),
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.01),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(child: _buildCategoryField(context)),
              const SizedBox(width: 8),
              IconButton(
                tooltip: 'Xóa khoản',
                onPressed: onRemove,
                icon: const Icon(Icons.delete_outline, color: AppColors.error),
              ),
            ],
          ),
          _buildSubCategoryField(context),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: AppCurrencyFormField(
                  controller: draft.amount,
                  label: 'Số tiền',
                  icon: Icons.payments_outlined,
                  hintText: 'VD: 1.000.000',
                  onChanged: (_) => onChanged(),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: AppDropdownField<String>(
                  value: draft.frequencyType,
                  label: 'Tần suất',
                  items: const [
                    DropdownMenuItem(value: 'daily', child: Text('Hàng ngày')),
                    DropdownMenuItem(value: 'weekly', child: Text('Hàng tuần')),
                    DropdownMenuItem(
                      value: 'monthly',
                      child: Text('Hàng tháng'),
                    ),
                  ],
                  onChanged: (val) {
                    if (val != null) {
                      draft.frequencyType = val;
                      if (val != 'daily') {
                        draft.frequencyValue.text = '1';
                      }
                      onChanged();
                    }
                  },
                ),
              ),
            ],
          ),
          if (draft.frequencyType == 'daily')
            AppTextFormField(
              controller: draft.frequencyValue,
              keyboardType: TextInputType.number,
              label: 'Số lần / ngày',
              icon: Icons.repeat,
              onChanged: (_) => onChanged(),
            ),
          if (draft.frequencyType == 'daily') const SizedBox(height: 12),
        ],
      ),
    );
  }

  Widget _buildCategoryField(BuildContext context) {
    return InkWell(
      onTap: () => _selectCategory(context),
      borderRadius: BorderRadius.circular(18),
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: 'Danh mục',
          prefixIcon: Padding(
            padding: const EdgeInsets.only(left: 16, right: 10),
            child: Text(
              draft.selectedCategory?.icon ?? '',
              style: const TextStyle(fontSize: 22),
            ),
          ),
          prefixIconConstraints: const BoxConstraints(
            minWidth: 0,
            minHeight: 0,
          ),
          suffixIcon: const Icon(
            Icons.keyboard_arrow_down_rounded,
            color: AppColors.text3,
          ),
          isDense: true,
          filled: true,
          fillColor: AppColors.backgroundSecondary,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 18,
            vertical: 16,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18),
            borderSide: const BorderSide(
              color: AppColors.borderSecondary,
              width: 1.2,
            ),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18),
            borderSide: const BorderSide(
              color: AppColors.borderSecondary,
              width: 1.2,
            ),
          ),
        ),
        child: Text(
          draft.selectedCategory?.name ?? 'Chọn danh mục',
          style: TextStyle(
            color: draft.selectedCategory == null
                ? AppColors.text4
                : AppColors.text1,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildSubCategoryField(BuildContext context) {
    final subCategories = draft.selectedCategory?.subCategories ?? const [];
    if (subCategories.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      children: [
        const SizedBox(height: 12),
        InkWell(
          onTap: () => _selectSubCategory(context, subCategories),
          borderRadius: BorderRadius.circular(18),
          child: InputDecorator(
            decoration: InputDecoration(
              labelText: 'Danh mục con',
              prefixIcon: Padding(
                padding: const EdgeInsets.only(left: 16, right: 10),
                child: Text(
                  draft.selectedSubCategory?.icon.isNotEmpty == true
                      ? draft.selectedSubCategory!.icon
                      : '',
                  style: const TextStyle(fontSize: 22),
                ),
              ),
              prefixIconConstraints: const BoxConstraints(
                minWidth: 0,
                minHeight: 0,
              ),
              suffixIcon: const Icon(
                Icons.keyboard_arrow_down_rounded,
                color: AppColors.text3,
              ),
              isDense: true,
              filled: true,
              fillColor: AppColors.backgroundSecondary,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 18,
                vertical: 16,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(18),
                borderSide: const BorderSide(
                  color: AppColors.borderSecondary,
                  width: 1.2,
                ),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(18),
                borderSide: const BorderSide(
                  color: AppColors.borderSecondary,
                  width: 1.2,
                ),
              ),
            ),
            child: Text(
              draft.selectedSubCategory?.name ?? 'Chọn danh mục con',
              style: TextStyle(
                color: draft.selectedSubCategory == null
                    ? AppColors.text4
                    : AppColors.text1,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _selectSubCategory(
    BuildContext context,
    List<SubCategoryEntity> subCategories,
  ) async {
    showDialog(
      context: context,
      builder: (context) => SelectionDialog(
        title: 'Danh mục con',
        description: 'Chọn nhóm chi tiết cho khoản chi này',
        clearButtonText: 'Xóa',
        options: subCategories
            .where((item) => item.id != null)
            .map(
              (item) => SelectionOption(
                id: item.id.toString(),
                label:
                    '${item.icon.isNotEmpty ? '${item.icon} ' : ''}${item.name}',
              ),
            )
            .toList(),
        initialSelectedId: draft.selectedSubCategory?.id?.toString(),
        onSelect: (id, label) {
          if (id == null) {
            draft.selectedSubCategory = null;
          } else {
            draft.selectedSubCategory = subCategories.firstWhereOrNull(
              (item) => item.id?.toString() == id,
            );
          }
          onChanged();
        },
      ),
    );
  }

  Future<void> _selectCategory(BuildContext context) async {
    if (categories.isEmpty) return;

    final selected = await showModalBottomSheet<CategoryEntity>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => CategorySheet(
        categories: categories,
        selectedCategoryInit: draft.selectedCategory,
        transactionType: 'expense',
      ),
    );

    if (selected != null) {
      if (draft.selectedCategory?.id != selected.id) {
        draft.selectedCategory = selected;
        draft.selectedSubCategory = null;
      }
      onChanged();
    }
  }
}

String _formatMoney(double value) {
  final rounded = value.round().toString();
  final buffer = StringBuffer();
  for (var i = 0; i < rounded.length; i++) {
    final reversedIndex = rounded.length - i;
    buffer.write(rounded[i]);
    if (reversedIndex > 1 && reversedIndex % 3 == 1) {
      buffer.write('.');
    }
  }
  return '${buffer.toString()}đ';
}
