import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:money_care/app/widgets/button/primary_button.dart';
import 'package:money_care/app/widgets/layout/app_header.dart';
import 'package:money_care/app/widgets/text_field/app_currency_form_field.dart';
import 'package:money_care/core/constants/colors.dart';
import 'package:money_care/features/spending_plan/domain/entities/spending_plan_entity.dart';
import 'package:money_care/features/spending_plan/presentation/controllers/spending_plan_wizard_controller.dart';
import 'package:money_care/features/spending_plan/presentation/widgets/estimated_expense_edit_sheet.dart';
import 'package:money_care/features/spending_plan/presentation/widgets/spending_plan_budget_sketch_card.dart';
import 'package:money_care/features/spending_plan/presentation/widgets/spending_plan_setup_widgets.dart';

class SpendingPlanWizard extends StatefulWidget {
  final double initialIncome;
  final List<EstimatedExpenseEntity> initialExpenses;
  final bool isSaving;
  final bool showWelcomeStep;
  final String saveButtonText;
  final VoidCallback? onCancel;
  final Future<void> Function(
    double income,
    List<EstimatedExpenseEntity> expenses,
    SpendingPlanWizardController wizardController,
  )
  onSave;

  const SpendingPlanWizard({
    super.key,
    required this.initialIncome,
    required this.initialExpenses,
    required this.isSaving,
    required this.showWelcomeStep,
    required this.saveButtonText,
    required this.onSave,
    this.onCancel,
  });

  @override
  State<SpendingPlanWizard> createState() => _SpendingPlanWizardState();
}

class _SpendingPlanWizardState extends State<SpendingPlanWizard> {
  late final PageController _pageController;
  late final TextEditingController _incomeController;
  late final SpendingPlanWizardController _wizardController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
    _incomeController = TextEditingController(
      text: widget.initialIncome > 0
          ? widget.initialIncome.round().toString()
          : '',
    );
    _wizardController = Get.put(SpendingPlanWizardController());
    _wizardController.initialize(
      income: widget.initialIncome,
      expenses: widget.initialExpenses,
      showWelcomeStep: widget.showWelcomeStep,
    );
    _wizardController.loadCategoriesIfNeeded();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _incomeController.dispose();
    Get.delete<SpendingPlanWizardController>();
    super.dispose();
  }

  Future<void> _animateToCurrentStep() {
    return _pageController.animateToPage(
      _wizardController.currentStep.value,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _nextStep() {
    if (_wizardController.goToNextStep()) {
      _animateToCurrentStep();
    }
  }

  void _handleBackTap() {
    final action = _wizardController.handleBackTap();
    switch (action) {
      case WizardBackAction.changedStep:
        _animateToCurrentStep();
        break;
      case WizardBackAction.close:
        if (widget.onCancel != null) {
          widget.onCancel!();
        } else {
          Get.back();
        }
        break;
      case WizardBackAction.none:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        backgroundColor: Colors.white,
        floatingActionButton: _wizardController.isOnExpensesStep
            ? Padding(
                padding: const EdgeInsets.only(bottom: 120),
                child: FloatingActionButton(
                  onPressed: () => _openExpenseSheet(),
                  backgroundColor: AppColors.primary,
                  elevation: 4,
                  shape: const CircleBorder(),
                  child: const Icon(Icons.add, color: Colors.white, size: 28),
                ),
              )
            : null,
        body: Column(
          children: [
            if (_wizardController.shouldShowHeader)
              AppHeader(
                title: _wizardController.currentTitle,
                showBackButton: true,
                onBackTap: _handleBackTap,
                height: 120,
              ),
            Expanded(
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                onPageChanged: (page) {
                  _wizardController.currentStep.value = page;
                },
                children: [
                  if (widget.showWelcomeStep) _buildWelcomeStep(),
                  _buildIncomeStep(),
                  _buildExpensesStep(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWelcomeStep() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.white, Color(0xFFF3F9FF)],
        ),
      ),
      child: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            child: Container(
              padding: const EdgeInsets.all(28),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.04),
                    blurRadius: 24,
                    offset: const Offset(0, 12),
                  ),
                ],
                border: Border.all(color: AppColors.borderSecondary),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    margin: const EdgeInsets.only(bottom: 28),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withValues(alpha: 0.12),
                          blurRadius: 28,
                          spreadRadius: 6,
                        ),
                      ],
                    ),
                    child: ClipOval(
                      child: Image.asset(
                        'assets/images/logo.png',
                        width: 90,
                        height: 90,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const Text(
                    'Chào mừng bạn đến với\nMoney Care AI 👋',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w900,
                      color: AppColors.text1,
                      height: 1.3,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 18),
                  const Text(
                    'Hãy cùng thiết lập kế hoạch tài chính ban đầu chỉ với 2 bước cực kỳ đơn giản để bắt đầu quản lý chi tiêu thông minh.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 15,
                      height: 1.5,
                      color: AppColors.text2,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 14),
                  const Text(
                    'Kế hoạch này sẽ giúp Money Care AI theo dõi, phân tích và đưa ra các đề xuất điều chỉnh chi tiêu tối ưu cho bạn.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      height: 1.45,
                      color: AppColors.text3,
                    ),
                  ),
                  const SizedBox(height: 32),
                  PrimaryButton(
                    label: 'Bắt đầu ngay',
                    onPressed: _nextStep,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildIncomeStep() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '1. Nhập thu nhập hàng tháng',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: AppColors.text1,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Khoản thu nhập trung bình bạn nhận được mỗi tháng để làm cơ sở phân bổ ngân sách.',
            style: TextStyle(fontSize: 14, color: AppColors.text3, height: 1.4),
          ),
          const SizedBox(height: 32),
          AppCurrencyFormField(
            controller: _incomeController,
            label: 'Thu nhập hàng tháng',
            icon: Icons.account_balance_wallet_outlined,
            hintText: 'VD: 10.000.000',
            onChanged: (val) {
              _wizardController.updateIncomeFromText(val);
            },
          ),
          const SizedBox(height: 18),
          const Text(
            'Gợi ý nhanh:',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: AppColors.text2,
            ),
          ),
          const SizedBox(height: 10),
          Obx(
            () => IncomeQuickChips(
              selectedAmount: _wizardController.monthlyIncome.value,
              onSelected: (amount) {
                setState(() {
                  _incomeController.text = amount.round().toString();
                });
                _wizardController.monthlyIncome.value = amount;
              },
            ),
          ),
          const Spacer(),
          Obx(() {
            final hasIncome = _wizardController.monthlyIncome.value > 0;
            return SizedBox(
              width: double.infinity,
              child: FilledButton(
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                onPressed: hasIncome ? _nextStep : null,
                child: const Text(
                  'Tiếp tục',
                  style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildExpensesStep() {
    return Container(
      color: const Color(0xFFF8FAFC),
      child: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              children: [
                Obx(
                  () => SpendingPlanBudgetSketchCard(
                    income: _wizardController.monthlyIncome.value,
                    fixedExpense: _wizardController.estimatedExpenseTotal,
                    flexibleAmount: _wizardController.remainingAmount,
                    fixedRatio: _wizardController.estimatedExpenseRatio,
                    flexibleRatio: _wizardController.flexibleExpenseRatio,
                    expenses: List.from(_wizardController.estimatedExpenses),
                    monthlyAmountFor: _wizardController.monthlyAmountFor,
                    onEditExpense: _openExpenseSheet,
                    onRemoveExpense: _wizardController.removeExpense,
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  'Gợi ý khoản chi phổ biến',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: AppColors.text1,
                  ),
                ),
                const SizedBox(height: 2),
                const Text(
                  'Chọn nhanh để bắt đầu hoặc tùy chỉnh theo ý muốn của bạn.',
                  style: TextStyle(fontSize: 12, color: AppColors.text3),
                ),
                const SizedBox(height: 12),
                ExpenseTemplatesList(
                  onTapCategory: (cat) {
                    _openExpenseSheet(
                      initial: EstimatedExpenseEntity(
                        id: 0,
                        category: cat.name,
                        categoryId: cat.id,
                        amount: 0,
                        frequencyType: 'monthly',
                        frequencyValue: 1,
                      ),
                    );
                  },
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
          _buildExpensesBottomBar(),
        ],
      ),
    );
  }

  Widget _buildExpensesBottomBar() {
    return Obx(() {
      final isOver = _wizardController.remainingAmount < 0;
      final canSave = _wizardController.canSave;
      final isSaving = widget.isSaving;

      return Container(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
        decoration: BoxDecoration(
          color: Colors.white,
          border: const Border(
            top: BorderSide(color: AppColors.borderSecondary, width: 0.8),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 10,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (isOver)
              const Padding(
                padding: EdgeInsets.only(bottom: 12),
                child: Text(
                  'Chi phí đang vượt thu nhập, hãy chỉnh lại trước khi lưu.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.error,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            Row(
              children: [
                Expanded(
                  child: FilledButton(
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    onPressed: canSave && !isSaving
                        ? () => widget.onSave(
                            _wizardController.monthlyIncome.value,
                            _wizardController.estimatedExpenses.toList(),
                            _wizardController,
                          )
                        : null,
                    child: isSaving
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.5,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.white,
                              ),
                            ),
                          )
                        : Text(
                            widget.saveButtonText,
                            style: const TextStyle(
                              fontWeight: FontWeight.w800,
                              fontSize: 16,
                            ),
                          ),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    });
  }

  Future<void> _openExpenseSheet({
    int? index,
    EstimatedExpenseEntity? initial,
  }) async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => EstimatedExpenseEditSheet(
        initialDraft: initial,
        onSave: (request) async {
          _wizardController.saveDraftExpense(index: index, request: request);
          return true;
        },
      ),
    );
  }
}
