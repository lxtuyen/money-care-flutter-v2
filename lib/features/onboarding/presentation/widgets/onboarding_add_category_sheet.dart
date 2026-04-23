import 'package:flutter/material.dart';
import 'package:money_care/core/constants/colors.dart';
import 'onboarding_category_select_widgets.dart';

class OnboardingAddCategorySheet extends StatefulWidget {
  final void Function(String name, String emoji, String type) onAdd;

  const OnboardingAddCategorySheet({super.key, required this.onAdd});

  @override
  State<OnboardingAddCategorySheet> createState() =>
      _OnboardingAddCategorySheetState();
}

class _OnboardingAddCategorySheetState
    extends State<OnboardingAddCategorySheet> {
  final nameController = TextEditingController();
  String selectedEmoji = '📦';
  String selectedType = 'expense';

  final emojiOptions = [
    '🍔',
    '🏠',
    '🛍️',
    '🚕',
    '✈️',
    '🎮',
    '💊',
    '🛒',
    '🐾',
    '🎓',
    '📱',
    '💄',
    '⚽',
    '💵',
    '📈',
    '🎁',
    '💼',
    '📦',
    '🎵',
    '🍕',
    '☕',
    '🚀',
  ];

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      // Đẩy sheet lên khi bàn phím xuất hiện
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Handle bar
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.borderPrimary,
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Thêm danh mục mới',
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: nameController,
                autofocus: true,
                decoration: InputDecoration(
                  hintText: 'Tên danh mục',
                  filled: true,
                  fillColor: AppColors.backgroundPrimary,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 12,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Loại',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.text3,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  OnboardingTypeChip(
                    label: 'Chi phí',
                    selected: selectedType == 'expense',
                    onTap: () => setState(() => selectedType = 'expense'),
                  ),
                  const SizedBox(width: 8),
                  OnboardingTypeChip(
                    label: 'Thu nhập',
                    selected: selectedType == 'income',
                    onTap: () => setState(() => selectedType = 'income'),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Text(
                'Biểu tượng',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.text3,
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: emojiOptions.map((emoji) {
                  final isSelected = selectedEmoji == emoji;
                  return GestureDetector(
                    onTap: () => setState(() {
                      selectedEmoji = emoji;
                    }),
                    child: Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppColors.primary.withOpacity(0.15)
                            : AppColors.backgroundPrimary,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: isSelected
                              ? AppColors.primary
                              : Colors.transparent,
                          width: 1.5,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          emoji,
                          style: const TextStyle(fontSize: 22),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        side: const BorderSide(color: AppColors.borderPrimary),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Huỷ',
                        style: TextStyle(color: AppColors.text3),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        final name = nameController.text.trim();
                        if (name.isEmpty) return;
                        widget.onAdd(name, selectedEmoji, selectedType);
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Thêm',
                        style: TextStyle(fontWeight: FontWeight.w700),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
