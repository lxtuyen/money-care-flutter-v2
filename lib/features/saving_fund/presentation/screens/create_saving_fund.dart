import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:money_care/core/presentation/widgets/appbar/appbar.dart';
import 'package:money_care/core/presentation/widgets/button/primary_button.dart';
import 'package:money_care/core/presentation/widgets/text_field/app_currency_form_field.dart';
import 'package:money_care/core/presentation/widgets/text_field/app_text_form_field.dart';
import 'package:money_care/core/presentation/widgets/text_field/date_picker_field.dart';
import 'package:money_care/core/utils/validatiors/validation.dart';
import 'package:money_care/features/saving_fund/presentation/controllers/create_saving_fund_controller.dart';
import 'package:money_care/features/saving_fund/presentation/widgets/category_percentage_card.dart';

class CreateSavingFund extends StatefulWidget {
  const CreateSavingFund({super.key});

  @override
  State<CreateSavingFund> createState() => _CreateSavingFundState();
}

class _CreateSavingFundState extends State<CreateSavingFund> {
  final _formKey = GlobalKey<FormState>();
  final CreateSavingFundController _controller =
      Get.find<CreateSavingFundController>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _controller.initializeCreateFundForm();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppbarCustom(
        title: Obx(
          () => Text(
            _controller.isEditMode.value
                ? 'Cập nhật quỹ tiết kiệm'
                : 'Tạo quỹ tiết kiệm',
          ),
        ),
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
                  AppTextFormField(
                    controller: _controller.fundNameController,
                    label: 'Tên quỹ',
                    icon: Icons.savings,
                    validator: AppValidator.validateName,
                  ),
                  const SizedBox(height: 16),
                  AppCurrencyFormField(
                    controller: _controller.targetAmountController,
                    label: 'Mục tiêu',
                    icon: Icons.attach_money,
                    hintText: 'VD: 5.000.000',
                    onRawChanged: _controller.updateTargetAmount,
                    validator: (value) => AppValidator.validateAmount(value),
                  ),
                  const SizedBox(height: 16),
                  DatePickerField(
                    selectedDate: _controller.startDate,
                    label: 'Bắt đầu',
                    placeholder: 'Chọn ngày bắt đầu',
                    onTap: () => _controller.selectStartDate(context),
                  ),
                  const SizedBox(height: 16),
                  DatePickerField(
                    selectedDate: _controller.endDate,
                    label: 'Kết thúc',
                    placeholder: 'Chọn ngày kết thúc',
                    onTap: () => _controller.selectEndDate(context),
                  ),
                  const SizedBox(height: 16),
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
                    final isLoading = _controller.isLoading.value;
                    final isValid = _controller.totalPercentage.value == 100;
                    final totalPercentage = _controller.totalPercentage.value;

                    return PrimaryButton(
                      label:
                          isValid
                              ? (_controller.isEditMode.value
                                  ? 'Cập nhật'
                                  : 'Tạo quỹ')
                              : 'Tổng phần trăm: $totalPercentage',
                      onPressed: _controller.submitCreateFund,
                      isLoading: isLoading,
                      isEnabled: isValid,
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
