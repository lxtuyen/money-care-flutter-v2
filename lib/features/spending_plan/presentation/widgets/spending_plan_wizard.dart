import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:money_care/app/widgets/button/primary_button.dart';
import 'package:money_care/app/widgets/icon/app_svg_icon.dart';
import 'package:money_care/app/widgets/layout/app_header.dart';
import 'package:money_care/app/widgets/text_field/app_currency_form_field.dart';
import 'package:money_care/core/constants/colors.dart';
import 'package:money_care/core/utils/helper/helper_functions.dart';
import 'package:money_care/features/spending_plan/domain/entities/spending_plan_entity.dart';
import 'package:money_care/features/spending_plan/presentation/controllers/spending_plan_wizard_controller.dart';
import 'package:money_care/features/spending_plan/presentation/widgets/spending_plan_setup_widgets.dart';
import 'package:money_care/features/transaction/domain/entities/category_entity.dart';

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
  final Map<int, TextEditingController> _amountControllers = {};

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
    for (final controller in _amountControllers.values) {
      controller.dispose();
    }
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
    if (_wizardController.currentStep.value ==
        _wizardController.categoryStepIndex) {
      _wizardController.prepareExpensesFromSelectedCategories();
    }
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
                  _buildCategoryStep(),
                  _buildBudgetStep(),
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
                    'Chào mừng bạn đến với\nMoney Care AI',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w900,
                      color: AppColors.text1,
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 18),
                  const Text(
                    'Hãy thiết lập kế hoạch tài chính ban đầu để Money Care AI hiểu thu nhập, danh mục thiết yếu và ngân sách hằng tháng của bạn.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 15,
                      height: 1.5,
                      color: AppColors.text2,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 32),
                  PrimaryButton(label: 'Bắt đầu ngay', onPressed: _nextStep),
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
            '1. Nhập thu nhập hằng tháng',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: AppColors.text1,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Khoản thu nhập trung bình mỗi tháng sẽ là cơ sở để phân bổ ngân sách.',
            style: TextStyle(fontSize: 14, color: AppColors.text3, height: 1.4),
          ),
          const SizedBox(height: 32),
          AppCurrencyFormField(
            controller: _incomeController,
            label: 'Thu nhập hằng tháng',
            icon: Icons.account_balance_wallet_outlined,
            hintText: 'VD: 10.000.000',
            onChanged: _wizardController.updateIncomeFromText,
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
                style: _primaryButtonStyle(),
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

  Widget _buildCategoryStep() {
    return Container(
      color: const Color(0xFFF8FAFC),
      child: Column(
        children: [
          Expanded(
            child: Obx(() {
              final categories = _wizardController.expenseCategories;
              final selectedIds = _wizardController.selectedEssentialCategoryIds
                  .toSet();
              if (categories.isEmpty) {
                return const Center(child: CircularProgressIndicator());
              }

              return GridView.builder(
                padding: const EdgeInsets.fromLTRB(16, 20, 16, 20),
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 190,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 1.2,
                ),
                itemCount: categories.length + 1,
                itemBuilder: (context, index) {
                  if (index == 0) {
                    return _CategoryIntroCard(
                      selectedCount:
                          _wizardController.selectedEssentialCategoryIds.length,
                    );
                  }
                  final category = categories[index - 1];
                  return _EssentialCategoryTile(
                    category: category,
                    selected:
                        category.id != null &&
                        selectedIds.contains(category.id),
                    onTap: () =>
                        _wizardController.toggleEssentialCategory(category),
                  );
                },
              );
            }),
          ),
          Obx(
            () => _BottomActionBar(
              message: _wizardController.hasSelectedEssentialCategories
                  ? null
                  : 'Chọn ít nhất một danh mục thiết yếu để tiếp tục.',
              child: FilledButton(
                style: _primaryButtonStyle(),
                onPressed: _wizardController.hasSelectedEssentialCategories
                    ? _nextStep
                    : null,
                child: const Text(
                  'Tiếp tục',
                  style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBudgetStep() {
    return Container(
      color: const Color(0xFFF8FAFC),
      child: Column(
        children: [
          Expanded(
            child: Obx(() {
              _syncAmountControllers();
              final expenses = _wizardController.estimatedExpenses.toList();
              return ListView(
                padding: const EdgeInsets.fromLTRB(16, 20, 16, 20),
                children: [
                  _BudgetSummaryCard(
                    income: _wizardController.monthlyIncome.value,
                    estimatedExpenseTotal:
                        _wizardController.estimatedExpenseTotal,
                    remainingAmount: _wizardController.remainingAmount,
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    '2. Nhập ngân sách cho từng danh mục',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: AppColors.text1,
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Bạn có thể nhập số tiền hoặc chọn nhanh theo % thu nhập.',
                    style: TextStyle(
                      fontSize: 13,
                      color: AppColors.text3,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 14),
                  ...expenses.map(_buildBudgetExpenseCard),
                ],
              );
            }),
          ),
          _buildBudgetBottomBar(),
        ],
      ),
    );
  }

  Widget _buildBudgetExpenseCard(EstimatedExpenseEntity expense) {
    final category = _wizardController.expenseCategories.firstWhereOrNull(
      (item) => item.id == expense.categoryId,
    );
    final categoryId = expense.categoryId;
    final controller = categoryId != null
        ? _amountControllers[categoryId]
        : TextEditingController();
    final income = _wizardController.monthlyIncome.value;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderSecondary),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _CategoryIcon(category: category),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  expense.category ?? category?.name ?? 'Khoản chi',
                  style: const TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 15,
                    color: AppColors.text1,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (controller != null)
            AppCurrencyFormField(
              controller: controller,
              label: 'Số tiền mỗi tháng',
              icon: Icons.payments_outlined,
              hintText: 'VD: 1.000.000',
              onChanged: (value) {
                if (categoryId == null) return;
                _wizardController.updateExpenseAmountByCategoryId(
                  categoryId,
                  _parseMoney(value),
                );
              },
            ),
          const SizedBox(height: 10),
          Row(
            children: const [5, 10, 15, 20, 25].map((percent) {
              return Expanded(
                child: Padding(
                  padding: EdgeInsets.only(right: percent == 25 ? 0 : 6),
                  child: _PercentChip(
                    percent: percent,
                    onPressed: categoryId == null
                        ? null
                        : () {
                            final amount = income * percent / 100;
                            controller?.text = amount.round().toString();
                            _wizardController.updateExpenseAmountByCategoryId(
                              categoryId,
                              amount,
                            );
                          },
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildBudgetBottomBar() {
    return Obx(() {
      final isOver = _wizardController.remainingAmount < 0;
      final canSave = _wizardController.canSave;
      final isSaving = widget.isSaving;
      final message = isOver
          ? 'Chi phí đang vượt thu nhập, hãy chỉnh lại trước khi lưu.'
          : _wizardController.hasUnfilledExpenses
          ? 'Vui lòng nhập số tiền cho tất cả danh mục đã chọn.'
          : null;

      return _BottomActionBar(
        message: message,
        child: FilledButton(
          style: _primaryButtonStyle(),
          onPressed: canSave && !isSaving
              ? () async {
                  await _wizardController.saveEssentialCategoryPreferences();
                  await widget.onSave(
                    _wizardController.monthlyIncome.value,
                    _wizardController.estimatedExpenses.toList(),
                    _wizardController,
                  );
                }
              : null,
          child: isSaving
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.5,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
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
      );
    });
  }

  void _syncAmountControllers() {
    final activeIds = _wizardController.estimatedExpenses
        .map((expense) => expense.categoryId)
        .whereType<int>()
        .toSet();

    final staleIds = _amountControllers.keys
        .where((id) => !activeIds.contains(id))
        .toList();
    for (final id in staleIds) {
      _amountControllers.remove(id)?.dispose();
    }

    for (final expense in _wizardController.estimatedExpenses) {
      final categoryId = expense.categoryId;
      if (categoryId == null) continue;
      final controller = _amountControllers.putIfAbsent(
        categoryId,
        () => TextEditingController(),
      );
      if (controller.text.isEmpty && expense.amount > 0) {
        controller.text = expense.amount.round().toString();
      }
    }
  }

  double _parseMoney(String value) {
    return double.tryParse(value.replaceAll('.', '').replaceAll(',', '')) ?? 0;
  }

  ButtonStyle _primaryButtonStyle() {
    return FilledButton.styleFrom(
      backgroundColor: AppColors.primary,
      padding: const EdgeInsets.symmetric(vertical: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    );
  }
}

class _PercentChip extends StatelessWidget {
  final int percent;
  final VoidCallback? onPressed;

  const _PercentChip({required this.percent, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          padding: EdgeInsets.zero,
          backgroundColor: AppColors.primary.withValues(alpha: 0.08),
          side: BorderSide(color: AppColors.primary.withValues(alpha: 0.18)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          minimumSize: Size.zero,
        ),
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            '$percent%',
            style: const TextStyle(
              color: AppColors.primary,
              fontWeight: FontWeight.w800,
              fontSize: 12,
            ),
          ),
        ),
      ),
    );
  }
}

class _CategoryIntroCard extends StatelessWidget {
  final int selectedCount;

  const _CategoryIntroCard({required this.selectedCount});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.18)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.auto_awesome_rounded, color: AppColors.primary),
          const Spacer(),
          const Text(
            'Danh mục AI cần ưu tiên',
            style: TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: 14,
              color: AppColors.text1,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Đã chọn $selectedCount danh mục',
            style: const TextStyle(fontSize: 12, color: AppColors.text3),
          ),
        ],
      ),
    );
  }
}

class _EssentialCategoryTile extends StatelessWidget {
  final CategoryEntity category;
  final bool selected;
  final VoidCallback onTap;

  const _EssentialCategoryTile({
    required this.category,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final iconColor = selected ? AppColors.primary : AppColors.text3;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: selected
              ? AppColors.primary.withValues(alpha: 0.1)
              : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: selected ? AppColors.primary : AppColors.borderSecondary,
            width: selected ? 1.5 : 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                _CategoryIcon(category: category, color: iconColor),
                const Spacer(),
                Icon(
                  selected ? Icons.check_circle_rounded : Icons.circle_outlined,
                  size: 20,
                  color: selected ? AppColors.primary : AppColors.text4,
                ),
              ],
            ),
            const Spacer(),
            Text(
              category.name,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontWeight: FontWeight.w800,
                fontSize: 14,
                color: selected ? AppColors.primary : AppColors.text1,
                height: 1.2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CategoryIcon extends StatelessWidget {
  final CategoryEntity? category;
  final Color? color;

  const _CategoryIcon({this.category, this.color});

  @override
  Widget build(BuildContext context) {
    final iconColor = color ?? category?.color ?? AppColors.primary;
    final iconName = category?.icon ?? '';
    return Container(
      width: 38,
      height: 38,
      decoration: BoxDecoration(
        color: iconColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(
        child: iconName.isNotEmpty
            ? AppSvgIcon(iconName: iconName, color: iconColor, size: 20)
            : Icon(Icons.receipt_long_outlined, color: iconColor, size: 20),
      ),
    );
  }
}

class _BudgetSummaryCard extends StatelessWidget {
  final double income;
  final double estimatedExpenseTotal;
  final double remainingAmount;

  const _BudgetSummaryCard({
    required this.income,
    required this.estimatedExpenseTotal,
    required this.remainingAmount,
  });

  @override
  Widget build(BuildContext context) {
    final isOver = remainingAmount < 0;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderSecondary),
      ),
      child: Column(
        children: [
          _AmountRow(label: 'Thu nhập', value: income),
          _AmountRow(
            label: 'Tổng ngân sách đã nhập',
            value: estimatedExpenseTotal,
          ),
          _AmountRow(
            label: isOver ? 'Vượt ngân sách' : 'Số dư còn lại',
            value: remainingAmount.abs(),
            color: isOver ? AppColors.error : AppColors.primary,
            prefix: isOver ? '-' : null,
          ),
        ],
      ),
    );
  }
}

class _AmountRow extends StatelessWidget {
  final String label;
  final double value;
  final String? prefix;
  final Color? color;

  const _AmountRow({
    required this.label,
    required this.value,
    this.prefix,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 13,
                color: AppColors.text2,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Text(
            '${prefix ?? ''}${AppHelperFunction.formatAmount(value)}',
            style: TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: 13,
              color: color ?? AppColors.text1,
            ),
          ),
        ],
      ),
    );
  }
}

class _BottomActionBar extends StatelessWidget {
  final String? message;
  final Widget child;

  const _BottomActionBar({required this.child, this.message});

  @override
  Widget build(BuildContext context) {
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
          if (message != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Text(
                message!,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.error,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          child,
        ],
      ),
    );
  }
}
