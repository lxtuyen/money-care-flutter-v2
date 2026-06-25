import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:money_care/core/constants/colors.dart';
import 'package:money_care/app/widgets/button/primary_button.dart';
import 'package:money_care/app/widgets/text_field/app_currency_form_field.dart';
import 'package:money_care/app/widgets/text_field/app_text_form_field.dart';
import 'package:money_care/app/widgets/text_field/date_picker_field.dart';
import 'package:money_care/core/utils/validators/validation.dart';
import 'package:money_care/features/saving_goal/presentation/controllers/create_saving_goal_controller.dart';
import 'package:money_care/core/utils/helper/helper_functions.dart';
import 'package:money_care/features/saving_goal/data/models/budget_suggestion_model.dart';
import 'package:money_care/app/controllers/app_controller.dart';

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
    // Reset form ngay lập tức để tránh hiển thị state cũ
    _controller.resetBeforeBuild();
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
                    keyboardDismissBehavior:
                        ScrollViewKeyboardDismissBehavior.onDrag,
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
                            validator: (value) => AppValidator.validateAmount(
                              value,
                              minAmount: 10000,
                            ),
                            onRawChanged: (value) => _controller.target.value =
                                double.tryParse(value),
                          ),
                          Obx(() {
                            if (_controller.isCoupleMode.value) {
                              return const SizedBox.shrink();
                            }
                            return Column(
                              children: [
                                const SizedBox(height: 16),
                                Container(
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: AppColors.primary.withValues(alpha: 0.05),
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(
                                      color: AppColors.primary.withValues(alpha: 0.1),
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.account_balance_wallet_rounded,
                                        color: AppColors.primary.withValues(
                                          alpha: 0.8,
                                        ),
                                        size: 24,
                                      ),
                                      const SizedBox(width: 12),
                                      const Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Ví tiết kiệm tự động',
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
                              ],
                            );
                          }),
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
                                  onTap: () =>
                                      _controller.selectStartDate(context),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: DatePickerField(
                                  selectedDate: _controller.endDate,
                                  label: 'Dự kiến xong',
                                  placeholder: 'Chọn ngày',
                                  onTap: () =>
                                      _controller.selectEndDate(context),
                                ),
                              ),
                            ],
                          ),
                          Obx(() => Get.find<AppController>().isPremium.value
                              ? BudgetAnalysisSection(controller: _controller)
                              : const SizedBox.shrink()),
                          const SizedBox(height: 24),
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

class BudgetAnalysisSection extends StatefulWidget {
  final CreateSavingGoalController controller;

  const BudgetAnalysisSection({super.key, required this.controller});

  @override
  State<BudgetAnalysisSection> createState() => _BudgetAnalysisSectionState();
}

class _BudgetAnalysisSectionState extends State<BudgetAnalysisSection> {
  final Map<int, bool> _goalEnabled = {};

  double _computeToggleAdjustedBudget(BudgetSuggestionModel suggestion) {
    double total = 0;
    for (final goal in suggestion.existingGoals) {
      final isEnabled = _goalEnabled[goal.id] ?? true;
      if (isEnabled) total += goal.monthlyBudget;
    }
    return total;
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final suggestion = widget.controller.budgetSuggestion.value;
      if (widget.controller.isLoadingSuggestion.value) {
        return const Padding(
          padding: EdgeInsets.symmetric(vertical: 16),
          child: Center(
            child: SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.primary),
            ),
          ),
        );
      }

      if (suggestion == null) return const SizedBox.shrink();

      final adjustedExisting = _computeToggleAdjustedBudget(suggestion);
      final adjustedAvailable = suggestion.averageMonthlySavings - adjustedExisting;
      final adjustedSufficient = adjustedAvailable >= suggestion.requiredMonthly;
      final adjustedDeficit = adjustedSufficient ? 0.0 : suggestion.requiredMonthly - adjustedAvailable;

      final formattedAvg = AppHelperFunction.formatAmount(suggestion.averageMonthlySavings);
      final formattedExisting = AppHelperFunction.formatAmount(adjustedExisting);
      final formattedAvailable = AppHelperFunction.formatAmount(adjustedAvailable);
      final formattedRequired = AppHelperFunction.formatAmount(suggestion.requiredMonthly);
      final formattedDeficit = AppHelperFunction.formatAmount(adjustedDeficit);

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 24),
          const Row(
            children: [
              Icon(Icons.analytics_outlined, color: AppColors.primary, size: 20),
              SizedBox(width: 8),
              Text(
                'Phân tích ngân sách',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.primary),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.02),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.primary.withValues(alpha: 0.08)),
            ),
            child: Column(
              children: [
                _buildRow('Tích lũy TB hàng tháng', formattedAvg, AppColors.text1),
                const SizedBox(height: 8),
                _buildRow('Đã sử dụng cho quỹ khác', '-$formattedExisting', Colors.red[700]!),
                // Existing goals detail list
                if (suggestion.existingGoals.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  _buildExistingGoalsList(suggestion),
                ],
                const SizedBox(height: 8),
                const Divider(height: 1, color: AppColors.borderSecondary),
                const SizedBox(height: 8),
                _buildRow(
                  'Ngân sách còn dư',
                  formattedAvailable,
                  adjustedAvailable >= 0 ? Colors.green[700]! : Colors.red[700]!,
                  isBold: true,
                ),
                if (suggestion.requiredMonthly > 0) ...[
                  const SizedBox(height: 8),
                  _buildRow('Cần góp mỗi tháng', formattedRequired, AppColors.primary, isBold: true),
                ],
                if (!adjustedSufficient && suggestion.requiredMonthly > 0) ...[
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.amber.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.amber.withValues(alpha: 0.3)),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.warning_amber_rounded, color: Colors.amber, size: 20),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Cảnh báo: Ngân sách tích lũy không đủ. Thiếu khoảng $formattedDeficit/tháng. Hãy cân nhắc kéo dài thời hạn hoặc giảm số tiền mục tiêu.',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.orange[900],
                              height: 1.4,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      );
    });
  }

  Widget _buildExistingGoalsList(BudgetSuggestionModel suggestion) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.grey.withValues(alpha: 0.04),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.withValues(alpha: 0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Chi tiết các quỹ đang hoạt động:',
            style: TextStyle(fontSize: 11, color: AppColors.text3, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 6),
          ...suggestion.existingGoals.map((goal) {
            final isEnabled = _goalEnabled[goal.id] ?? true;
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 2),
              child: Row(
                children: [
                  SizedBox(
                    width: 22,
                    height: 22,
                    child: Checkbox(
                      value: isEnabled,
                      onChanged: (val) {
                        setState(() {
                          _goalEnabled[goal.id] = val ?? true;
                        });
                      },
                      activeColor: AppColors.primary,
                      shape: const CircleBorder(),
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      visualDensity: VisualDensity.compact,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      goal.name,
                      style: TextStyle(
                        fontSize: 12,
                        color: isEnabled ? AppColors.text2 : AppColors.text3,
                        decoration: isEnabled ? null : TextDecoration.lineThrough,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Text(
                    '${AppHelperFunction.formatAmount(goal.monthlyBudget)}/tháng',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: isEnabled ? Colors.red[700] : AppColors.text3,
                      decoration: isEnabled ? null : TextDecoration.lineThrough,
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildRow(String title, String value, Color valueColor, {bool isBold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 13,
            color: isBold ? AppColors.text1 : AppColors.text2,
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 13,
            color: valueColor,
            fontWeight: isBold ? FontWeight.bold : FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
