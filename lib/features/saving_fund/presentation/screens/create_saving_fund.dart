import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:money_care/core/constants/colors.dart';
import 'package:money_care/core/presentation/widgets/appbar/appbar.dart';
import 'package:money_care/core/utils/Helper/helper_functions.dart';
import 'package:money_care/core/utils/validatiors/validation.dart';
import 'package:money_care/features/saving_fund/data/models/models.dart';
import 'package:money_care/features/saving_fund/presentation/controllers/saving_fund_controller.dart';
import 'package:money_care/features/saving_fund/presentation/widgets/category_percentage_card.dart';
import 'package:money_care/core/presentation/widgets/text_field/date_picker_field.dart';
import 'package:money_care/core/presentation/widgets/button/primary_button.dart';

class CreateSavingFund extends StatefulWidget {
  const CreateSavingFund({super.key});

  @override
  State<CreateSavingFund> createState() => _CreateSavingFundState();
}

class _CreateSavingFundState extends State<CreateSavingFund> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final SavingFundController _controller = Get.find<SavingFundController>();

  @override
  void initState() {
    super.initState();
    _initializeScreen();
  }

  Future<void> _initializeScreen() async {
    await _controller.initializeUserInfo();
    _controller.initializeCategoryDefaults();
    _controller.startDate.value = DateTime.now();
  }

  Future<void> _createSavingFund() async {
    if (!_formKey.currentState!.validate()) return;
    if (_controller.userId.value == null) {
      AppHelperFunction.showSnackBar('Không thể xác định người dùng hiện tại');
      return;
    }

    if (_controller.startDate.value == null) {
      AppHelperFunction.showSnackBar('Vui long chon ngay bat dau');
      return;
    }

    if (_controller.endDate.value == null) {
      AppHelperFunction.showSnackBar('Vui long chon ngay ket thuc');
      return;
    }

    if (_controller.endDate.value!.isBefore(_controller.startDate.value!)) {
      AppHelperFunction.showSnackBar('Ngay ket thuc phai sau ngay bat dau');
      return;
    }

    if (!_controller.validatePercentages()) {
      AppHelperFunction.showSnackBar(
        'Tổng phần trăm phải là 100%. Hiện tại là ${_controller.totalPercentage.value}%',
      );
      return;
    }

    try {
      final dto = SavingFundDto(
        categories: _controller.categories.toList(),
        name: _nameController.text.trim(),
        id: _controller.userId.value,
        targetAmount: _controller.targetAmount.value,
        startDate: _controller.startDate.value,
        endDate: _controller.endDate.value,
      );
      await _controller.createFund(dto);

      if (!mounted) return;
      Get.back();
      AppHelperFunction.showSnackBar('Tạo quỹ thành công');
    } catch (e) {
      AppHelperFunction.showSnackBar(e.toString());
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _selectStartDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _controller.startDate.value ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      _controller.startDate.value = picked;
    }
  }

  Future<void> _selectEndDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate:
          _controller.endDate.value ??
          (_controller.startDate.value?.add(const Duration(days: 30)) ??
              DateTime.now().add(const Duration(days: 30))),
      firstDate: _controller.startDate.value ?? DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      _controller.endDate.value = picked;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppbarCustom(
        title: const Text('Tạo quỹ tiết kiệm'),
        showBackArrow: true,
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      labelText: 'Tên quỹ',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: AppColors.primary,
                          width: 2,
                        ),
                      ),
                      prefixIcon: const Icon(Icons.savings),
                    ),
                    validator: AppValidator.validateName,
                  ),
                  const SizedBox(height: 16),

                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Mục tiêu',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: AppColors.primary,
                          width: 2,
                        ),
                      ),
                      prefixIcon: const Icon(Icons.attach_money),
                      hintText: 'VD: 5.000.000',
                    ),
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      final amount = double.tryParse(value);
                      _controller.targetAmount.value = amount;
                    },
                    validator: (value) => AppValidator.validateAmount(value),
                  ),
                  const SizedBox(height: 16),

                  DatePickerField(
                    selectedDate: _controller.startDate,
                    label: 'Bắt đầu',
                    placeholder: 'Chọn ngày bắt đầu',
                    onTap: () => _selectStartDate(context),
                  ),
                  const SizedBox(height: 16),

                  DatePickerField(
                    selectedDate: _controller.endDate,
                    label: 'Kết thúc',
                    placeholder: 'Chọn ngày kết thúc',
                    onTap: () => _selectEndDate(context),
                  ),
                  const SizedBox(height: 18),

                  Expanded(
                    child: Obx(() {
                      return ListView.builder(
                        itemCount: _controller.categories.length,
                        itemBuilder: (context, index) {
                          final cat = _controller.categories[index];
                          return CategoryPercentageCard(
                            category: cat,
                            index: index,
                            onPercentageChanged: (percentage) {
                              _controller.updateCategoryPercentage(
                                index,
                                percentage,
                              );
                            },
                          );
                        },
                      );
                    }),
                  ),
                  const SizedBox(height: 20),

                  Obx(() {
                    final isLoading = _controller.isLoadingFunds.value;
                    final isValid = _controller.totalPercentage.value == 100;
                    final totalPercentage = _controller.totalPercentage.value;

                    return Column(
                      children: [
                        PrimaryButton(
                          label:
                              isValid
                                  ? 'Tạo quỹ'
                                  : 'Tổng phần trăm: $totalPercentage',
                          onPressed: _createSavingFund,
                          isLoading: isLoading,
                          isEnabled: isValid,
                        ),
                      ],
                    );
                  }),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
