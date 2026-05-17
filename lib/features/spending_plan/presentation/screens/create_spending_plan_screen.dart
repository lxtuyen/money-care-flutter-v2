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
  final _fixedExpenses = <_FixedExpenseDraft>[];
  SpendingPlanEntity? _editingPlan;

  int get _daysInMonth {
    final now = DateTime.now();
    return DateTime(now.year, now.month + 1, 0).day;
  }

  double get _income => _parseMoney(_incomeController.text);

  double get _fixedExpensesTotal {
    double total = 0;
    for (final expense in _fixedExpenses) {
      final amount = _parseMoney(expense.amount.text);
      if (amount <= 0) continue;

      final val = int.tryParse(expense.frequencyValue.text) ?? 1;
      if (expense.frequencyType == 'daily') {
        total += amount * val * _daysInMonth;
      } else if (expense.frequencyType == 'weekly') {
        total += amount * val * 4.33; // 4.33 weeks per month
      } else {
        total += amount * val;
      }
    }
    return total;
  }

  double get _remaining => _income - _fixedExpensesTotal;

  @override
  void initState() {
    super.initState();
    _incomeController.addListener(_refreshPreview);
    final argument = Get.arguments;
    if (argument is SpendingPlanEntity) {
      _editingPlan = argument;
    }

    if (_editingPlan == null) {
      // Auto-populate a default "Tiền ăn" daily expense
      final mealDraft = _FixedExpenseDraft();
      mealDraft.amount.addListener(_refreshPreview);
      mealDraft.frequencyType = 'daily';
      mealDraft.frequencyValue.text = '3';
      _fixedExpenses.add(mealDraft);
    } else {
      _incomeController.text = _formatNumberInput(_editingPlan!.totalAmount);
      for (final expense in _editingPlan!.fixedExpenses) {
        final draft = _FixedExpenseDraft();
        draft.amount.text = _formatNumberInput(expense.amount);
        draft.amount.addListener(_refreshPreview);
        draft.frequencyType = expense.frequencyType;
        draft.frequencyValue.text = expense.frequencyValue.toString();
        draft.dueDay.text = expense.dueDay?.toString() ?? '';
        draft.note.text = expense.note ?? '';
        draft.isReminderEnabled = expense.isReminderEnabled;
        _fixedExpenses.add(draft);
      }
    }

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final userId = Get.find<AppController>().userId.value;
      if (userId != null) {
        if (categoryController.categories.isEmpty) {
          await categoryController.loadCategories(userId);
        }
        if (_editingPlan == null) {
          // Auto-select "Ăn uống" category if available
          final foodCat = categoryController.categories.firstWhereOrNull(
            (cat) =>
                cat.name.toLowerCase().contains('ăn') ||
                cat.name.toLowerCase().contains('food'),
          );
          if (foodCat != null && _fixedExpenses.isNotEmpty) {
            setState(() {
              _fixedExpenses[0].selectedCategory = foodCat;
            });
          }
        } else {
          setState(() {
            for (var i = 0; i < _editingPlan!.fixedExpenses.length; i++) {
              final categoryName = _editingPlan!.fixedExpenses[i].category;
              _fixedExpenses[i].selectedCategory = categoryController.categories
                  .firstWhereOrNull((cat) => cat.name == categoryName);
            }
          });
        }
      }
    });
  }

  @override
  void dispose() {
    _incomeController.dispose();
    for (final expense in _fixedExpenses) {
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
                      fixedCost: _fixedExpensesTotal,
                      remaining: _remaining,
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Chi phí cố định',
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(fontWeight: FontWeight.w700),
                          ),
                        ),
                        IconButton(
                          tooltip: 'Thêm khoản phí',
                          onPressed: _addFixedExpense,
                          icon: const Icon(Icons.add_circle_outline),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Obx(() {
                      final categories = _expenseCategories;
                      if (_fixedExpenses.isEmpty) {
                        return Text(
                          'Thêm các khoản chi phí cố định định kỳ như tiền ăn, tiền trọ, điện nước, internet hoặc học phí.',
                          style: TextStyle(color: Colors.grey.shade700),
                        );
                      }

                      return Column(
                        children: _fixedExpenses.asMap().entries.map((entry) {
                          return _FixedExpenseFields(
                            draft: entry.value,
                            onRemove: () => _removeFixedExpense(entry.key),
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
              icon: controller.isSaving.value
                  ? const SizedBox(
                      height: 18,
                      width: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.save_outlined),
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

  void _addFixedExpense() {
    setState(() {
      final draft = _FixedExpenseDraft();
      draft.amount.addListener(_refreshPreview);
      _fixedExpenses.add(draft);
    });
  }

  void _removeFixedExpense(int index) {
    setState(() {
      _fixedExpenses.removeAt(index).dispose();
    });
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    final hasInvalidExtraFee = _fixedExpenses.any((expense) {
      final hasAnyInput =
          expense.selectedCategory != null ||
          expense.amount.text.trim().isNotEmpty ||
          expense.dueDay.text.trim().isNotEmpty ||
          expense.note.text.trim().isNotEmpty;
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

    final fixedExpenses = _buildFixedExpenseRequests();
    final success = _editingPlan == null
        ? await controller.createPlan(
            CreateSpendingPlanRequest(
              totalAmount: _income,
              savingTargetAmount: 0,
              fixedExpenses: fixedExpenses,
            ),
          )
        : await controller.updatePlan(
            _editingPlan!.id,
            UpdateSpendingPlanRequest(
              month: _editingPlan!.month,
              year: _editingPlan!.year,
              totalAmount: _income,
              savingTargetAmount: _editingPlan!.savingTargetAmount,
              fixedExpenses: fixedExpenses,
            ),
          );
    if (success) {
      Get.back();
    }
  }

  List<CreateFixedExpenseRequest> _buildFixedExpenseRequests() {
    return _fixedExpenses
        .where(
          (expense) =>
              expense.selectedCategory != null &&
              _parseMoney(expense.amount.text) > 0,
        )
        .map(
          (expense) => CreateFixedExpenseRequest(
            category: expense.selectedCategory!.name,
            amount: _parseMoney(expense.amount.text),
            frequencyType: expense.frequencyType,
            frequencyValue: int.tryParse(expense.frequencyValue.text) ?? 1,
            dueDay: int.tryParse(expense.dueDay.text),
            note: expense.note.text.trim().isEmpty
                ? null
                : expense.note.text.trim(),
            isReminderEnabled: expense.isReminderEnabled,
          ),
        )
        .toList();
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
  final double fixedCost;
  final double remaining;

  const _MonthlyPreviewCard({
    required this.income,
    required this.fixedCost,
    required this.remaining,
  });

  @override
  Widget build(BuildContext context) {
    final safeIncome = income <= 0 ? 1.0 : income;
    final fixedRatio = (fixedCost / safeIncome).clamp(0.0, 1.0);
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
                  if (fixedRatio > 0)
                    Expanded(
                      flex: _ratioFlex(fixedRatio),
                      child: Container(color: const Color(0xFFF59E0B)),
                    ),
                  if (remainingRatio > 0)
                    Expanded(
                      flex: _ratioFlex(remainingRatio),
                      child: Container(color: const Color(0xFF10B981)),
                    ),
                  if (fixedRatio == 0 && remainingRatio == 0)
                    Expanded(child: Container(color: Colors.grey.shade200)),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          _PreviewRow(
            color: const Color(0xFFF59E0B),
            label: 'Chi phí cố định',
            value: fixedCost,
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

class _FixedExpenseDraft {
  final amount = TextEditingController();
  final dueDay = TextEditingController();
  final note = TextEditingController();
  final frequencyValue = TextEditingController(text: '1');
  String frequencyType = 'monthly';
  bool isReminderEnabled = false;
  CategoryEntity? selectedCategory;

  void dispose() {
    amount.dispose();
    dueDay.dispose();
    note.dispose();
    frequencyValue.dispose();
  }
}

class _FixedExpenseFields extends StatelessWidget {
  final _FixedExpenseDraft draft;
  final VoidCallback onRemove;
  final VoidCallback onChanged;
  final List<CategoryEntity> categories;

  const _FixedExpenseFields({
    required this.draft,
    required this.onRemove,
    required this.onChanged,
    required this.categories,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade200),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: InkWell(
                  borderRadius: BorderRadius.circular(8),
                  onTap: () => _selectCategory(context),
                  child: Container(
                    height: 48,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade50,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: Row(
                      children: [
                        Text(
                          draft.selectedCategory?.icon ?? '📁',
                          style: const TextStyle(fontSize: 20),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            draft.selectedCategory?.name ?? 'Chọn danh mục',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              color: draft.selectedCategory == null
                                  ? Colors.grey.shade600
                                  : Colors.black,
                            ),
                          ),
                        ),
                        const Icon(Icons.keyboard_arrow_down_rounded),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                tooltip: 'Xóa khoản',
                onPressed: onRemove,
                icon: const Icon(Icons.delete_outline),
              ),
            ],
          ),
          const SizedBox(height: 10),
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
                child: DropdownButtonFormField<String>(
                  initialValue: draft.frequencyType,
                  decoration: const InputDecoration(
                    labelText: 'Tần suất',
                    border: OutlineInputBorder(),
                    isDense: true,
                  ),
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
                      if (val == 'daily') {
                        draft.dueDay.text = '';
                      } else if (val == 'weekly') {
                        draft.dueDay.text = '1';
                        draft.frequencyValue.text = '1';
                      } else {
                        draft.dueDay.text = '1';
                        draft.frequencyValue.text = '1';
                      }
                      onChanged();
                    }
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          if (draft.frequencyType == 'monthly')
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: draft.dueDay,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Ngày trả (1 - 31)',
                      border: OutlineInputBorder(),
                      isDense: true,
                      prefixIcon: Icon(Icons.calendar_month_outlined),
                    ),
                    onChanged: (_) => onChanged(),
                  ),
                ),
              ],
            ),
          if (draft.frequencyType == 'weekly')
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<int>(
                    initialValue: int.tryParse(draft.dueDay.text) ?? 1,
                    decoration: const InputDecoration(
                      labelText: 'Chọn thứ',
                      border: OutlineInputBorder(),
                      isDense: true,
                      prefixIcon: Icon(Icons.today_outlined),
                    ),
                    items: const [
                      DropdownMenuItem(value: 1, child: Text('Thứ 2')),
                      DropdownMenuItem(value: 2, child: Text('Thứ 3')),
                      DropdownMenuItem(value: 3, child: Text('Thứ 4')),
                      DropdownMenuItem(value: 4, child: Text('Thứ 5')),
                      DropdownMenuItem(value: 5, child: Text('Thứ 6')),
                      DropdownMenuItem(value: 6, child: Text('Thứ 7')),
                      DropdownMenuItem(value: 7, child: Text('Chủ Nhật')),
                    ],
                    onChanged: (val) {
                      if (val != null) {
                        draft.dueDay.text = val.toString();
                        onChanged();
                      }
                    },
                  ),
                ),
              ],
            ),
          if (draft.frequencyType == 'daily')
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: draft.frequencyValue,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Số lần / ngày',
                      border: OutlineInputBorder(),
                      isDense: true,
                      prefixIcon: Icon(Icons.repeat),
                    ),
                    onChanged: (_) => onChanged(),
                  ),
                ),
              ],
            ),
          const SizedBox(height: 10),
          TextFormField(
            controller: draft.note,
            minLines: 1,
            maxLines: 2,
            decoration: const InputDecoration(
              labelText: 'Ghi chú',
              border: OutlineInputBorder(),
              isDense: true,
            ),
          ),
          const SizedBox(height: 10),
          StatefulBuilder(
            builder: (context, setState) {
              return SwitchListTile(
                title: const Text('Nhắc nhở thanh toán'),
                subtitle: const Text('Gửi thông báo vào ngày hẹn trả'),
                value: draft.isReminderEnabled,
                onChanged: (val) {
                  setState(() {
                    draft.isReminderEnabled = val;
                  });
                  onChanged();
                },
                contentPadding: EdgeInsets.zero,
                dense: true,
              );
            },
          ),
        ],
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
      draft.selectedCategory = selected;
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
