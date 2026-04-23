import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:money_care/core/constants/colors.dart';
import 'package:money_care/app/widgets/appbar/appbar.dart';
import 'package:money_care/app/widgets/button/primary_button.dart';
import 'package:money_care/app/widgets/text_field/app_currency_form_field.dart';
import 'package:money_care/app/widgets/text_field/app_text_form_field.dart';
import 'package:money_care/app/widgets/text_field/date_picker_field.dart';
import 'package:money_care/core/utils/validators/validation.dart';
import 'package:money_care/features/saving_goal/presentation/controllers/create_saving_goal_controller.dart';

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
      appBar: AppbarCustom(
        title: Obx(
          () => Text(
            _controller.isEditMode.value
                ? 'Cập nhật mục tiêu'
                : 'Thiết lập mục tiêu mới',
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
                    validator: (value) => AppValidator.validateAmount(value),
                    onRawChanged: (value) =>
                        _controller.target.value = double.tryParse(value),
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
    );
  }
}
