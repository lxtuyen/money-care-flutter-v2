import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:money_care/core/constants/colors.dart';
import 'package:money_care/app/widgets/appbar/appbar.dart';
import 'package:money_care/app/widgets/button/primary_button.dart';
import 'package:money_care/app/widgets/text_field/app_currency_form_field.dart';
import 'package:money_care/app/widgets/text_field/app_text_form_field.dart';
import 'package:money_care/app/widgets/text_field/date_picker_field.dart';
import 'package:money_care/app/widgets/text_field/app_dropdown_field.dart';
import 'package:money_care/core/utils/validators/validation.dart';
import 'package:money_care/features/saving_goal/presentation/controllers/create_saving_goal_controller.dart';
import 'package:money_care/app/widgets/dialog/selection_dialog.dart';

import 'package:money_care/app/widgets/layout/app_header.dart';

class CreateSavingGoalScreen extends StatefulWidget {
  const CreateSavingGoalScreen({super.key});

  @override
  State<CreateSavingGoalScreen> createState() => _CreateSavingGoalScreenState();
}

class _CreateSavingGoalScreenState extends State<CreateSavingGoalScreen> {
  final _formKey = GlobalKey<FormState>();
  final CreateSavingGoalController _controller =
      Get.find<CreateSavingGoalController>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _controller.initializeForm();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            Obx(
              () => AppHeader(
                title: _controller.isEditMode.value
                    ? 'Cập nhật mục tiêu'
                    : 'Thiết lập mục tiêu mới',
                showBackButton: true,
                height: 140,
              ),
            ),
            Expanded(
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 600),
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16.0),
                    keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                    child: Form(
                      key: _formKey,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Thông tin cơ bản',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary,
                            ),
                          ),
                          const SizedBox(height: 16),
                          AppTextFormField(
                            controller: _controller.nameController,
                            label: 'Tên mục tiêu',
                            icon: Icons.flag_rounded,
                            validator: AppValidator.validateName,
                          ),
                          const SizedBox(height: 16),
                          AppCurrencyFormField(
                            controller: _controller.targetController,
                            label: 'Số tiền cần đạt',
                            icon: Icons.monetization_on,
                            hintText: 'VD: 10.000.000',
                            validator: (value) =>
                                AppValidator.validateAmount(value, minAmount: 10000),
                            onRawChanged: (value) =>
                                _controller.target.value = double.tryParse(value),
                          ),
                          const SizedBox(height: 16),
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withOpacity(0.05),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: AppColors.primary.withOpacity(0.1),
                              ),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.account_balance_wallet_rounded,
                                  color: AppColors.primary.withOpacity(0.8),
                                  size: 24,
                                ),
                                const SizedBox(width: 12),
                                const Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Ví mục tiêu tự động',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                          color: AppColors.text1,
                                        ),
                                      ),
                                      SizedBox(height: 4),
                                      Text(
                                        'Hệ thống sẽ tự động tạo một ví mới dành riêng cho mục tiêu này để dễ dàng theo dõi.',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: AppColors.text3,
                                          height: 1.4,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 24),
                          const Text(
                            'Thời gian thực hiện',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Expanded(
                                child: DatePickerField(
                                  selectedDate: _controller.startDate,
                                  label: 'Bắt đầu',
                                  placeholder: 'Chọn ngày',
                                  onTap: () => _controller.selectStartDate(context),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: DatePickerField(
                                  selectedDate: _controller.endDate,
                                  label: 'Dự kiến xong',
                                  placeholder: 'Chọn ngày',
                                  onTap: () => _controller.selectEndDate(context),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 40),
                          Obx(() {
                            return PrimaryButton(
                              label: _controller.isEditMode.value
                                  ? 'Cập nhật mục tiêu'
                                  : 'Bắt đầu tiết kiệm ngay',
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  _controller.submit();
                                }
                              },
                              isLoading: _controller.isLoading.value,
                            );
                          }),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
