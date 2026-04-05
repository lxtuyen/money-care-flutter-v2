import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:money_care/core/constants/colors.dart';
import 'package:money_care/core/constants/route_path.dart';
import 'package:money_care/core/presentation/widgets/appbar/appbar.dart';
import 'package:money_care/core/presentation/widgets/button/primary_button.dart';
import 'package:money_care/core/presentation/widgets/text_field/app_currency_form_field.dart';
import 'package:money_care/core/presentation/widgets/text_field/app_text_form_field.dart';
import 'package:money_care/core/presentation/widgets/text_field/date_picker_field.dart';
import 'package:money_care/core/utils/validators/validation.dart';
import 'package:money_care/features/fund/domain/entities/fund_entity.dart';
import 'package:money_care/features/fund/presentation/controllers/create_fund_controller.dart';
import 'package:money_care/features/fund/presentation/controllers/fund_controller.dart';
import 'package:money_care/features/fund/presentation/widgets/category_percentage_card.dart';

class CreateFund extends StatefulWidget {
  const CreateFund({super.key});

  @override
  State<CreateFund> createState() => _CreateFundState();
}

class _CreateFundState extends State<CreateFund> {
  final _formKey = GlobalKey<FormState>();
  final CreateFundController _controller =
      Get.find<CreateFundController>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _controller.initializeCreateFundForm();
    });
  }

  @override
  Widget build(BuildContext context) {
    final fundController = Get.find<FundController>();
    final isOnboarding = fundController.funds.isEmpty &&
        fundController.currentFund.value == null;

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
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Obx(() => DropdownButtonFormField<FundType>(
                        value: _controller.selectedType.value,
                        decoration: InputDecoration(
                          labelText: 'Loại quỹ',
                          prefixIcon: const Icon(Icons.account_balance_wallet, color: AppColors.primary),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: AppColors.borderPrimary),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: AppColors.borderPrimary),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: AppColors.primary, width: 2),
                          ),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                        ),
                        items: const [
                          DropdownMenuItem(
                            value: FundType.spending,
                            child: Text('Quỹ chi tiêu (Wallet)'),
                          ),
                          DropdownMenuItem(
                            value: FundType.savingGoal,
                            child: Text('Mục tiêu tiết kiệm (Piggy Bank)'),
                          ),
                        ],
                        onChanged: (value) {
                          if (value != null) {
                            _controller.selectedType.value = value;
                          }
                        },
                      )),
                  const SizedBox(height: 16),
                  AppTextFormField(
                    controller: _controller.fundNameController,
                    label: 'Tên quỹ',
                    icon: Icons.savings,
                    validator: AppValidator.validateName,
                  ),
                  const SizedBox(height: 16),
                  Obx(() {
                    if (_controller.selectedType.value == FundType.spending) {
                      return const SizedBox.shrink();
                    }
                    return Column(
                      children: [
                        AppCurrencyFormField(
                          controller: _controller.targetController,
                          label: 'Mục tiêu tiết kiệm',
                          icon: Icons.flag,
                          hintText: 'VD: 10.000.000',
                          onRawChanged: _controller.updateTargetAmount,
                          validator: (value) => AppValidator.validateAmount(value),
                        ),
                        const SizedBox(height: 16),
                      ],
                    );
                  }),
                  Obx(() {
                    if (_controller.selectedType.value == FundType.savingGoal) {
                      return const SizedBox.shrink();
                    }
                    return Column(
                      children: [
                        AppCurrencyFormField(
                          controller: _controller.balanceController,
                          label: 'Ngân sách tổng (Tùy chọn)',
                          icon: Icons.attach_money,
                          hintText: 'VD: 5.000.000',
                          onRawChanged: _controller.updateBudget,
                        ),
                        const SizedBox(height: 16),
                      ],
                    );
                  }),
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
                  Obx(() {
                    return ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
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
                  const SizedBox(height: 20),
                  Obx(() {
                    final isLoading = _controller.isLoading.value;
                    final isValid = _controller.totalPercentage.value == 100;
                    final totalPercentage = _controller.totalPercentage.value;

                    return PrimaryButton(
                      label:
                          isValid
                              ? (_controller.isEditMode.value
                                  ? 'Cập nhật­t'
                                  : 'Tạo')
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
