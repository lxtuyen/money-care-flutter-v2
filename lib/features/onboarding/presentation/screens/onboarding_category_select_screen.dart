import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:money_care/core/constants/colors.dart';
import 'package:money_care/features/onboarding/presentation/controllers/onboarding_category_select_controller.dart';
import '../widgets/onboarding_add_category_sheet.dart';
import '../widgets/onboarding_category_select_widgets.dart';

class OnboardingCategorySelectScreen
    extends GetView<OnboardingCategorySelectController> {
  const OnboardingCategorySelectScreen({super.key});

  void _showAddCategoryDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => OnboardingAddCategorySheet(
        onAdd: controller.addCustomCategory,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () => Get.back(),
                      child: const Icon(Icons.arrow_back_ios_new_rounded,
                          size: 20, color: AppColors.text2),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Chọn danh mục hoặc tạo\ndanh mục tùy chỉnh',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                        color: AppColors.text1,
                        height: 1.3,
                      ),
                    ),
                    const SizedBox(height: 24),
                    const OnboardingSectionLabel(
                      label: 'Đề xuất chi phí',
                      hint:
                          'Bạn có thể thêm các danh mục phụ sau này (ví dụ: nhà hàng, quán cà phê)',
                    ),
                    const SizedBox(height: 12),
                    Obx(() {
                      final cats = controller.expenseCategories.toList();
                      final selected = controller.selectedExpenseNames.toSet();
                      return OnboardingCategoryChipGrid(
                        categories: cats,
                        selectedNames: selected,
                        onToggle: (name) =>
                            controller.toggleCategory(name, true),
                      );
                    }),
                    const SizedBox(height: 16),
                    OnboardingAddNewButton(
                        onTap: () => _showAddCategoryDialog(context)),
                    const SizedBox(height: 24),
                    const OnboardingSectionLabel(label: 'Đề xuất thu nhập'),
                    const SizedBox(height: 12),
                    Obx(() {
                      final cats = controller.incomeCategories.toList();
                      final selected = controller.selectedIncomeNames.toSet();
                      return OnboardingCategoryChipGrid(
                        categories: cats,
                        selectedNames: selected,
                        onToggle: (name) =>
                            controller.toggleCategory(name, false),
                      );
                    }),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
            Obx(() {
              final expenseCount = controller.selectedExpenseNames.length;
              final incomeCount = controller.selectedIncomeNames.length;
              final valid = expenseCount >= 3 && incomeCount >= 1;
              return OnboardingCategoryBottomBar(
                selectedExpenseCount: expenseCount,
                selectedIncomeCount: incomeCount,
                isValid: valid,
                onContinue: controller.onContinue,
              );
            }),
          ],
        ),
      ),
    );
  }
}
