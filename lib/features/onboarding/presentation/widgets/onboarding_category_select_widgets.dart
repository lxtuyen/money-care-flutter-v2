import 'package:flutter/material.dart';
import 'package:money_care/core/constants/colors.dart';
import '../../onboarding_data.dart';

class OnboardingSectionLabel extends StatelessWidget {
  final String label;
  final String? hint;
  const OnboardingSectionLabel({super.key, required this.label, this.hint});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: AppColors.text1)),
        if (hint != null) ...[
          const SizedBox(height: 4),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('💡 ', style: TextStyle(fontSize: 12)),
              Expanded(
                child: Text(hint!,
                    style: const TextStyle(
                        fontSize: 12, color: AppColors.text4, height: 1.4)),
              ),
            ],
          ),
        ],
      ],
    );
  }
}

class OnboardingCategoryChipGrid extends StatelessWidget {
  final List<SuggestedCategory> categories;
  final Set<String> selectedNames;
  final void Function(String) onToggle;

  const OnboardingCategoryChipGrid({
    super.key,
    required this.categories,
    required this.selectedNames,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: categories.map((cat) {
        final isSelected = selectedNames.contains(cat.name);
        return GestureDetector(
          onTap: () => onToggle(cat.name),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 160),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: isSelected
                  ? AppColors.primary.withOpacity(0.1)
                  : AppColors.backgroundPrimary,
              borderRadius: BorderRadius.circular(50),
              border: Border.all(
                color: isSelected ? AppColors.primary : Colors.transparent,
                width: 1.5,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(cat.emoji, style: const TextStyle(fontSize: 16)),
                const SizedBox(width: 6),
                Text(
                  cat.name,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: isSelected ? AppColors.primary : AppColors.text2,
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}

class OnboardingAddNewButton extends StatelessWidget {
  final VoidCallback onTap;
  const OnboardingAddNewButton({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 11),
        decoration: BoxDecoration(
          color: AppColors.text1,
          borderRadius: BorderRadius.circular(50),
        ),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.add, color: Colors.white, size: 18),
            SizedBox(width: 6),
            Text('Thêm mới',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }
}

class OnboardingTypeChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  const OnboardingTypeChip({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: selected
              ? AppColors.primary.withOpacity(0.12)
              : AppColors.backgroundPrimary,
          borderRadius: BorderRadius.circular(50),
          border: Border.all(
            color: selected ? AppColors.primary : Colors.transparent,
            width: 1.5,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: selected ? AppColors.primary : AppColors.text3,
          ),
        ),
      ),
    );
  }
}

class OnboardingCategoryBottomBar extends StatelessWidget {
  final int selectedExpenseCount;
  final int selectedIncomeCount;
  final bool isValid;
  final VoidCallback onContinue;

  const OnboardingCategoryBottomBar({
    super.key,
    required this.selectedExpenseCount,
    required this.selectedIncomeCount,
    required this.isValid,
    required this.onContinue,
  });

  @override
  Widget build(BuildContext context) {
    // Build hint message for what's still missing
    String? hint;
    if (selectedExpenseCount < 3 && selectedIncomeCount < 1) {
      hint = 'Cần chọn ít nhất 3 chi phí và 1 thu nhập';
    } else if (selectedExpenseCount < 3) {
      final remaining = 3 - selectedExpenseCount;
      hint = 'Cần chọn thêm $remaining danh mục chi phí';
    } else if (selectedIncomeCount < 1) {
      hint = 'Cần chọn ít nhất 1 danh mục thu nhập';
    }

    return Container(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: AppColors.text1.withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (hint != null) ...[
            Text(
              hint,
              style: const TextStyle(
                fontSize: 12,
                color: AppColors.text4,
              ),
            ),
            const SizedBox(height: 8),
          ],
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              onPressed: isValid ? onContinue : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                disabledBackgroundColor: AppColors.disabled,
                foregroundColor: Colors.white,
                disabledForegroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
                elevation: 0,
              ),
              child: const Text(
                'Tiếp tục',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
