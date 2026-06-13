import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:money_care/features/couple/domain/entities/couple_budget_entity.dart';
import 'package:money_care/features/couple/presentation/controllers/couple_controller.dart';
import 'package:money_care/features/transaction/presentation/controllers/user_category_controller.dart';

class CoupleBudgetForm extends StatefulWidget {
  final CoupleController controller;
  final CoupleBudgetEntity? initialBudget;

  const CoupleBudgetForm({
    super.key,
    required this.controller,
    this.initialBudget,
  });

  @override
  State<CoupleBudgetForm> createState() => _CoupleBudgetFormState();
}

class _CoupleBudgetFormState extends State<CoupleBudgetForm> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  int? _selectedCategoryId;

  @override
  void initState() {
    super.initState();
    if (widget.initialBudget != null) {
      _amountController.text = widget.initialBudget!.amount.toInt().toString();
      _selectedCategoryId = widget.initialBudget!.categoryId;
    }
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.primaryColor;
    final categoryController = Get.find<UserCategoryController>();

    // Expense categories only for budgeting
    final expenseCategories = categoryController.categories
        .where((c) => c.type == 'expense' || c.type == null || c.type == 'others')
        .toList();

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      widget.initialBudget == null ? 'Thiết lập Ngân sách' : 'Sửa Ngân sách',
                      style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'Tháng: ${widget.controller.selectedMonthStr}',
                  style: TextStyle(color: Colors.grey[600], fontSize: 13, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 20),

                // Category Selector (disabled if editing)
                DropdownButtonFormField<int>(
                  value: _selectedCategoryId,
                  disabledHint: widget.initialBudget != null
                      ? Text('${widget.initialBudget!.categoryIcon} ${widget.initialBudget!.categoryName}')
                      : null,
                  decoration: const InputDecoration(
                    labelText: 'Danh mục chi tiêu',
                    prefixIcon: Icon(Icons.category_outlined),
                  ),
                  items: widget.initialBudget == null
                      ? expenseCategories.map((c) {
                          return DropdownMenuItem<int>(
                            value: c.id,
                            child: Text('${c.icon} ${c.name}'),
                          );
                        }).toList()
                      : null,
                  onChanged: widget.initialBudget == null
                      ? (val) => setState(() => _selectedCategoryId = val)
                      : null,
                  validator: (val) =>
                      _selectedCategoryId == null ? 'Vui lòng chọn danh mục' : null,
                ),
                const SizedBox(height: 16),

                // Amount Field
                TextFormField(
                  controller: _amountController,
                  keyboardType: TextInputType.number,
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  decoration: const InputDecoration(
                    labelText: 'Hạn mức ngân sách (VND)',
                    labelStyle: TextStyle(fontSize: 14),
                    prefixIcon: Icon(Icons.monetization_on_outlined),
                  ),
                  validator: (val) {
                    if (val == null || val.trim().isEmpty) return 'Nhập số tiền hạn mức';
                    final amount = double.tryParse(val.trim());
                    if (amount == null || amount <= 0) return 'Số tiền không hợp lệ';
                    return null;
                  },
                ),
                const SizedBox(height: 24),

                // Save Button
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    backgroundColor: primaryColor,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      final amount = double.parse(_amountController.text.trim());
                      widget.controller.setSharedBudget(_selectedCategoryId!, amount);
                      Navigator.of(context).pop();
                    }
                  },
                  child: Text(
                    widget.initialBudget == null ? 'Thiết lập hạn mức' : 'Cập nhật',
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
