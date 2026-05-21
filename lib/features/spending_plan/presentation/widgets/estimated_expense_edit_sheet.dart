import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:money_care/app/controllers/app_controller.dart';
import 'package:money_care/app/widgets/dialog/selection_dialog.dart';
import 'package:money_care/app/widgets/text_field/app_currency_form_field.dart';
import 'package:money_care/core/constants/colors.dart';
import 'package:money_care/core/utils/helper/helper_functions.dart';
import 'package:money_care/features/spending_plan/data/models/spending_plan_model.dart';
import 'package:money_care/features/spending_plan/domain/entities/spending_plan_entity.dart';
import 'package:money_care/features/spending_plan/presentation/controllers/spending_plan_controller.dart';
import 'package:money_care/features/transaction/domain/entities/category_entity.dart';
import 'package:money_care/features/transaction/presentation/controllers/user_category_controller.dart';
import 'package:money_care/features/transaction/presentation/widgets/category_sheet.dart';

class EstimatedExpenseEditSheet extends StatefulWidget {
  final SpendingPlanEntity plan;
  final EstimatedExpenseEntity? expense;

  const EstimatedExpenseEditSheet({
    super.key,
    required this.plan,
    this.expense,
  });

  @override
  State<EstimatedExpenseEditSheet> createState() =>
      _EstimatedExpenseEditSheetState();
}

class _EstimatedExpenseEditSheetState extends State<EstimatedExpenseEditSheet> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _frequencyValueController = TextEditingController(text: '1');

  String _frequencyType = 'monthly';
  CategoryEntity? _selectedCategory;
  SubCategoryEntity? _selectedSubCategory;
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
        _frequencyValueController.text = exp.frequencyValue.toString();
        _frequencyType = exp.frequencyType;

        if (exp.category != null) {
          final catName = exp.category!;
          _selectedCategory = _categoryController.categories.firstWhereOrNull(
            (c) => c.name.toLowerCase() == catName.toLowerCase(),
          );
          if (_selectedCategory != null && exp.subCategory != null) {
            _selectedSubCategory = _selectedCategory!.subCategories
                .firstWhereOrNull((sub) => sub.name == exp.subCategory);
          }
        }
      }
    });
  }

  @override
  void dispose() {
    _amountController.dispose();
    _frequencyValueController.dispose();
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
    final request = CreateEstimatedExpenseRequest(
      category: _selectedCategory!.name,
      categoryId: _selectedCategory!.id,
      subCategoryId: _selectedSubCategory?.id,
      amount: amount,
      monthlyLimit: _monthlyLimitFor(amount, freqVal),
      dailyLimit: _dailyLimitFor(amount, freqVal),
      frequencyType: _frequencyType,
      frequencyValue: freqVal,
    );

    final bool success;
    if (widget.expense == null) {
      success = await _spendingPlanController.createEstimatedExpense(
        widget.plan.id,
        request,
        showSuccessMessage: false,
      );
    } else {
      success = await _spendingPlanController.updateEstimatedExpense(
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

    if (selected != null) {
      setState(() {
        if (_selectedCategory?.id != selected.id) {
          _selectedSubCategory = null;
        }
        _selectedCategory = selected;
      });
    }
  }

  Widget _buildSubCategoryField() {
    final subCategories = _selectedCategory?.subCategories ?? const [];
    if (subCategories.isEmpty) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () => _selectSubCategory(subCategories),
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
                _selectedSubCategory?.icon ?? '',
                style: const TextStyle(fontSize: 20),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  _selectedSubCategory?.name ?? 'Chọn danh mục con',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: _selectedSubCategory == null
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
    );
  }

  Future<void> _selectSubCategory(List<SubCategoryEntity> subCategories) async {
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
        initialSelectedId: _selectedSubCategory?.id?.toString(),
        onSelect: (id, label) {
          setState(() {
            if (id == null) {
              _selectedSubCategory = null;
            } else {
              _selectedSubCategory = subCategories.firstWhereOrNull(
                (item) => item.id?.toString() == id,
              );
            }
          });
        },
      ),
    );
  }

  int get _daysInMonth =>
      DateTime(widget.plan.year, widget.plan.month + 1, 0).day;

  double _monthlyLimitFor(double amount, int frequencyValue) {
    final safeFrequencyValue = frequencyValue <= 0 ? 1 : frequencyValue;
    switch (_frequencyType) {
      case 'daily':
        return amount * safeFrequencyValue * _daysInMonth;
      case 'weekly':
        return amount * safeFrequencyValue * (_daysInMonth / 7);
      case 'monthly':
      default:
        return amount * safeFrequencyValue;
    }
  }

  double? _dailyLimitFor(double amount, int frequencyValue) {
    if (_frequencyType != 'daily') return null;
    final safeFrequencyValue = frequencyValue <= 0 ? 1 : frequencyValue;
    return amount * safeFrequencyValue;
  }

  @override
  Widget build(BuildContext context) {
    final title = widget.expense == null
        ? 'Thêm Khoản chi dự kiến'
        : 'Sửa Khoản chi dự kiến';

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
              _buildSubCategoryField(),

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
                            if (val != 'daily') {
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
              if (_frequencyType == 'daily') const SizedBox(height: 12),
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
