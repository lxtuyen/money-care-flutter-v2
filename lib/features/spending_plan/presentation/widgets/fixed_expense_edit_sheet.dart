import 'package:flutter/material.dart';
import 'package:get/get.dart';
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

class FixedExpenseEditSheet extends StatefulWidget {
  final SpendingPlanEntity plan;
  final FixedExpenseEntity? expense;

  const FixedExpenseEditSheet({super.key, required this.plan, this.expense});

  @override
  State<FixedExpenseEditSheet> createState() => _FixedExpenseEditSheetState();
}

class _FixedExpenseEditSheetState extends State<FixedExpenseEditSheet> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _noteController = TextEditingController();
  final _frequencyValueController = TextEditingController(text: '1');
  final _dueDayController = TextEditingController(text: '1');

  String _frequencyType = 'monthly';
  bool _isReminderEnabled = false;
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
        _noteController.text = exp.note ?? '';
        _frequencyValueController.text = exp.frequencyValue.toString();
        _dueDayController.text = (exp.dueDay ?? 1).toString();
        _frequencyType = exp.frequencyType;
        _isReminderEnabled = exp.isReminderEnabled;

        if (exp.category != null || exp.name.isNotEmpty) {
          final catName = exp.category ?? exp.name;
          _selectedCategory = _categoryController.categories.firstWhereOrNull(
            (c) => c.name.toLowerCase() == catName.toLowerCase(),
          );
        }
      }
    });
  }

  @override
  void dispose() {
    _amountController.dispose();
    _noteController.dispose();
    _frequencyValueController.dispose();
    _dueDayController.dispose();
    super.dispose();
  }

  double _parseMoney(String text) {
    return double.tryParse(text.replaceAll('.', '').replaceAll(',', '')) ?? 0.0;
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    if (_selectedCategory == null) {
      AppHelperFunction.showErrorSnackBar('Vui lòng chọn danh mục.');
      return;
    }

    final amount = _parseMoney(_amountController.text);
    if (amount <= 0) {
      AppHelperFunction.showErrorSnackBar('Vui lòng nhập số tiền hợp lệ.');
      return;
    }

    final freqVal = int.tryParse(_frequencyValueController.text) ?? 1;
    final dueDayVal = int.tryParse(_dueDayController.text);

    final request = CreateFixedExpenseRequest(
      category: _selectedCategory!.name,
      amount: amount,
      frequencyType: _frequencyType,
      frequencyValue: freqVal,
      dueDay: dueDayVal,
      note: _noteController.text.trim().isEmpty
          ? null
          : _noteController.text.trim(),
      isReminderEnabled: _isReminderEnabled,
    );

    final bool success;
    if (widget.expense == null) {
      success = await _spendingPlanController.createFixedExpense(
        widget.plan.id,
        request,
        showSuccessMessage: false,
      );
    } else {
      success = await _spendingPlanController.updateFixedExpense(
        widget.plan.id,
        widget.expense!.id,
        request.toJson(),
        showSuccessMessage: false,
      );
    }

    if (success) {
      Get.back();
      Future.delayed(const Duration(milliseconds: 150), () {
        AppHelperFunction.showSuccessSnackBar(
          widget.expense == null
              ? 'Đã thêm chi phí cố định thành công'
              : 'Đã cập nhật chi phí cố định',
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

    if (selected != null) {
      setState(() {
        _selectedCategory = selected;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final title = widget.expense == null
        ? 'Thêm Chi phí cố định'
        : 'Sửa Chi phí cố định';

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: EdgeInsets.fromLTRB(
        16,
        16,
        16,
        MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Get.back(),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              InkWell(
                onTap: _selectCategory,
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  height: 48,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: Row(
                    children: [
                      Text(
                        _selectedCategory?.icon ?? '',
                        style: const TextStyle(fontSize: 20),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          _selectedCategory?.name ?? 'Chọn danh mục',
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            color: _selectedCategory == null
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
              const SizedBox(height: 12),

              Row(
                children: [
                  Expanded(
                    child: AppCurrencyFormField(
                      controller: _amountController,
                      label: 'Số tiền',
                      icon: Icons.payments_outlined,
                      hintText: 'VD: 1.000.000',
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      initialValue: _frequencyType,
                      decoration: const InputDecoration(
                        labelText: 'Tần suất',
                        border: OutlineInputBorder(),
                        isDense: true,
                      ),
                      items: const [
                        DropdownMenuItem(
                          value: 'daily',
                          child: Text('Hàng ngày'),
                        ),
                        DropdownMenuItem(
                          value: 'weekly',
                          child: Text('Hàng tuần'),
                        ),
                        DropdownMenuItem(
                          value: 'monthly',
                          child: Text('Hàng tháng'),
                        ),
                      ],
                      onChanged: (val) {
                        if (val != null) {
                          setState(() {
                            _frequencyType = val;
                            if (val == 'daily') {
                              _dueDayController.text = '';
                            } else if (val == 'weekly') {
                              _dueDayController.text = '1';
                              _frequencyValueController.text = '1';
                            } else {
                              _dueDayController.text = '1';
                              _frequencyValueController.text = '1';
                            }
                          });
                        }
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              if (_frequencyType == 'monthly')
                TextFormField(
                  controller: _dueDayController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Ngày trả (1 - 31)',
                    border: OutlineInputBorder(),
                    isDense: true,
                    prefixIcon: Icon(Icons.calendar_month_outlined),
                  ),
                ),
              if (_frequencyType == 'weekly')
                DropdownButtonFormField<int>(
                  initialValue: int.tryParse(_dueDayController.text) ?? 1,
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
                      setState(() {
                        _dueDayController.text = val.toString();
                      });
                    }
                  },
                ),
              if (_frequencyType == 'daily')
                TextFormField(
                  controller: _frequencyValueController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Số lần / ngày',
                    border: OutlineInputBorder(),
                    isDense: true,
                    prefixIcon: Icon(Icons.repeat),
                  ),
                ),
              if (_frequencyType == 'monthly' ||
                  _frequencyType == 'weekly' ||
                  _frequencyType == 'daily')
                const SizedBox(height: 12),

              TextFormField(
                controller: _noteController,
                minLines: 1,
                maxLines: 2,
                decoration: const InputDecoration(
                  labelText: 'Ghi chú',
                  border: OutlineInputBorder(),
                  isDense: true,
                ),
              ),
              const SizedBox(height: 12),

              SwitchListTile(
                title: const Text('Nhắc nhở thanh toán'),
                subtitle: const Text('Gửi thông báo vào ngày hẹn trả'),
                value: _isReminderEnabled,
                onChanged: (val) {
                  setState(() {
                    _isReminderEnabled = val;
                  });
                },
                contentPadding: EdgeInsets.zero,
                dense: true,
              ),
              const SizedBox(height: 16),

              Obx(
                () => ElevatedButton(
                  onPressed: _spendingPlanController.isSaving.value
                      ? null
                      : _submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: _spendingPlanController.isSaving.value
                      ? const SizedBox(
                          height: 24,
                          width: 24,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.5,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.white,
                            ),
                          ),
                        )
                      : const Text(
                          'Lưu',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
