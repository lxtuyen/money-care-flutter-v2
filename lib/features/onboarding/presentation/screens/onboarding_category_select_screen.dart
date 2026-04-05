import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:money_care/core/constants/colors.dart';
import 'package:money_care/core/constants/route_path.dart';
import 'package:money_care/core/controllers/app_controller.dart';
import 'package:money_care/core/storage/local_storage.dart';
import 'package:money_care/features/transaction/domain/entities/category_entity.dart';
import 'package:money_care/features/transaction/presentation/controllers/user_category_controller.dart';

// Suggested categories shown to the user during onboarding
const _suggestedExpense = [
  _SuggestedCategory('Thức ăn & Đồ uống', '🍔', 'essential_icon', true),
  _SuggestedCategory('Nhà', '🏠', 'charity_icon', true),
  _SuggestedCategory('Mua sắm', '🛍️', 'pleasure_icon', false),
  _SuggestedCategory('Giao thông', '🚕', 'transportation', true),
  _SuggestedCategory('Du lịch', '✈️', 'freedom_icon', false),
  _SuggestedCategory('Giải trí', '🎮', 'pleasure_icon', false),
  _SuggestedCategory('Sức khỏe', '💊', 'essential_icon', true),
  _SuggestedCategory('Thực phẩm', '🛒', 'essential_icon', true),
  _SuggestedCategory('Thú cưng', '🐾', 'charity_icon', false),
  _SuggestedCategory('Giáo dục', '🎓', 'education_icon', true),
  _SuggestedCategory('Điện tử', '📱', 'savings_icon', false),
  _SuggestedCategory('Làm đẹp', '💄', 'pleasure_icon', false),
  _SuggestedCategory('Thể thao', '⚽', 'freedom_icon', false),
];

const _suggestedIncome = [
  _SuggestedCategory('Lương', '💵', 'savings_icon', true),
  _SuggestedCategory('Đầu tư', '📈', 'chart2', false),
  _SuggestedCategory('Tiền thưởng', '🎁', 'charity_icon', false),
  _SuggestedCategory('Kinh doanh', '💼', 'essential_icon', true),
];

class _SuggestedCategory {
  final String name;
  final String emoji;
  final String icon; // kept for CategoryEntity.icon field
  final bool isEssential;
  const _SuggestedCategory(this.name, this.emoji, this.icon, [this.isEssential = true]);
}

class OnboardingCategorySelectScreen extends StatefulWidget {
  const OnboardingCategorySelectScreen({super.key});

  @override
  State<OnboardingCategorySelectScreen> createState() =>
      _OnboardingCategorySelectScreenState();
}

class _OnboardingCategorySelectScreenState
    extends State<OnboardingCategorySelectScreen> {
  // Track selected names per type
  final Set<String> _selectedExpenseNames = {};
  final Set<String> _selectedIncomeNames = {};

  Set<String> get _selectedNames => {..._selectedExpenseNames, ..._selectedIncomeNames};

  int get _selectedExpenseCount => _selectedExpenseNames.length;
  int get _selectedIncomeCount => _selectedIncomeNames.length;
  bool get _isValid => _selectedExpenseCount >= 3 && _selectedIncomeCount >= 1;

  // All available categories (suggested + user-added custom)
  final List<_SuggestedCategory> _expenseCategories =
      List.from(_suggestedExpense);
  final List<_SuggestedCategory> _incomeCategories =
      List.from(_suggestedIncome);

  void _toggle(String name, bool isExpense) {
    setState(() {
      final set = isExpense ? _selectedExpenseNames : _selectedIncomeNames;
      if (set.contains(name)) {
        set.remove(name);
      } else {
        set.add(name);
      }
    });
  }

  void _showAddCategoryDialog() {
    final nameController = TextEditingController();
    String selectedEmoji = '📦';
    String selectedIcon = 'freedom_icon';
    final emojiOptions = [
      ('🍔', 'essential_icon'), ('🏠', 'charity_icon'), ('🛍️', 'pleasure_icon'),
      ('🚕', 'transportation'), ('✈️', 'freedom_icon'), ('🎮', 'pleasure_icon'),
      ('💊', 'essential_icon'), ('🛒', 'essential_icon'), ('🐾', 'charity_icon'),
      ('🎓', 'education_icon'), ('📱', 'savings_icon'), ('💄', 'pleasure_icon'),
      ('⚽', 'freedom_icon'), ('💵', 'savings_icon'), ('📈', 'chart2'),
      ('🎁', 'charity_icon'), ('💼', 'essential_icon'), ('📦', 'freedom_icon'),
      ('🎵', 'pleasure_icon'), ('🍕', 'essential_icon'), ('☕', 'essential_icon'),
      ('🚀', 'freedom_icon'),
    ];
    String selectedType = 'expense';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setSheetState) => Padding(
          // Đẩy sheet lên khi bàn phím xuất hiện
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(ctx).viewInsets.bottom,
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
                          horizontal: 14, vertical: 12),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Loại',
                    style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppColors.text3),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      _TypeChip(
                        label: 'Chi phí',
                        selected: selectedType == 'expense',
                        onTap: () =>
                            setSheetState(() => selectedType = 'expense'),
                      ),
                      const SizedBox(width: 8),
                      _TypeChip(
                        label: 'Thu nhập',
                        selected: selectedType == 'income',
                        onTap: () =>
                            setSheetState(() => selectedType = 'income'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Biểu tượng',
                    style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppColors.text3),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: emojiOptions.map((pair) {
                      final emoji = pair.$1;
                      final icon = pair.$2;
                      final isSelected = selectedEmoji == emoji;
                      return GestureDetector(
                        onTap: () => setSheetState(() {
                          selectedEmoji = emoji;
                          selectedIcon = icon;
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
                            child: Text(emoji,
                                style: const TextStyle(fontSize: 22)),
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
                          onPressed: () => Navigator.pop(ctx),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            side: const BorderSide(color: AppColors.borderPrimary),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                          ),
                          child: const Text('Huỷ',
                              style: TextStyle(color: AppColors.text3)),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            final name = nameController.text.trim();
                            if (name.isEmpty) return;
                            final newCat = _SuggestedCategory(
                                name, selectedEmoji, selectedIcon, selectedType == 'expense'); // New custom expense is usually essential by default, income too
                            setState(() {
                              if (selectedType == 'expense') {
                                _expenseCategories.add(newCat);
                                _selectedExpenseNames.add(name);
                              } else {
                                _incomeCategories.add(newCat);
                                _selectedIncomeNames.add(name);
                              }
                            });
                            Navigator.pop(ctx);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                          ),
                          child: const Text('Thêm',
                              style: TextStyle(fontWeight: FontWeight.w700)),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _onContinue() {
    if (!_isValid) return;

    final userCategoryController = Get.find<UserCategoryController>();

    final selected = [
      ..._expenseCategories
          .where((c) => _selectedExpenseNames.contains(c.name))
          .map((c) => CategoryEntity(
              name: c.name,
              icon: c.emoji,
              percentage: 0,
              type: 'expense',
              isEssential: c.isEssential)),
      ..._incomeCategories
          .where((c) => _selectedIncomeNames.contains(c.name))
          .map((c) => CategoryEntity(
              name: c.name,
              icon: c.emoji,
              percentage: 0,
              type: 'income',
              isEssential: c.isEssential)),
    ];

    const uncategorizedName = 'Chưa phân loại';
    if (!selected.any((c) => c.name == uncategorizedName)) {
      selected.add(const CategoryEntity(
        name: uncategorizedName,
        icon: '❓',
        percentage: 0,
        type: 'others',
        isEssential: true, 
      ));
    }

    userCategoryController.saveCategories(selected);

    // Đánh dấu onboarding đã hoàn thành cho user này
    final appController = Get.find<AppController>();
    final userId = appController.userId.value;
    if (userId != null) {
      LocalStorage().setOnboardingDone(userId);
    }

    Get.offAllNamed(RoutePath.main);
  }

  void _onSkip() {
    // Bỏ qua onboarding - cũng đánh dấu là đã xem để không hiện lại
    final appController = Get.find<AppController>();
    final userId = appController.userId.value;
    if (userId != null) {
      LocalStorage().setOnboardingDone(userId);
    }
    Get.offAllNamed(RoutePath.main);
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () => Get.back(),
                          child: const Icon(Icons.arrow_back_ios_new_rounded,
                              size: 20, color: AppColors.text2),
                        ),
                        GestureDetector(
                          onTap: _onSkip,
                          child: const Text(
                            'Bỏ qua',
                            style: TextStyle(
                              fontSize: 14,
                              color: AppColors.text3,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
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
                    _SectionLabel(
                      label: 'Đề xuất chi phí',
                      hint:
                          'Bạn có thể thêm các danh mục phụ sau này (ví dụ: nhà hàng, quán cà phê)',
                    ),
                    const SizedBox(height: 12),
                    _CategoryChipGrid(
                      categories: _expenseCategories,
                      selectedNames: _selectedExpenseNames,
                      onToggle: (name) => _toggle(name, true),
                    ),
                    const SizedBox(height: 16),
                    _AddNewButton(onTap: _showAddCategoryDialog),
                    const SizedBox(height: 24),
                    _SectionLabel(label: 'Đề xuất thu nhập'),
                    const SizedBox(height: 12),
                    _CategoryChipGrid(
                      categories: _incomeCategories,
                      selectedNames: _selectedIncomeNames,
                      onToggle: (name) => _toggle(name, false),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
            _BottomBar(
              selectedExpenseCount: _selectedExpenseCount,
              selectedIncomeCount: _selectedIncomeCount,
              isValid: _isValid,
              onContinue: _onContinue,
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Sub-widgets ────────────────────────────────────────────────────────────

class _SectionLabel extends StatelessWidget {
  final String label;
  final String? hint;
  const _SectionLabel({required this.label, this.hint});

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

class _CategoryChipGrid extends StatelessWidget {
  final List<_SuggestedCategory> categories;
  final Set<String> selectedNames;
  final void Function(String) onToggle;

  const _CategoryChipGrid({
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
            padding:
                const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: isSelected
                  ? AppColors.primary.withOpacity(0.1)
                  : AppColors.backgroundPrimary,
              borderRadius: BorderRadius.circular(50),
              border: Border.all(
                color: isSelected
                    ? AppColors.primary
                    : Colors.transparent,
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
                    color:
                        isSelected ? AppColors.primary : AppColors.text2,
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

class _AddNewButton extends StatelessWidget {
  final VoidCallback onTap;
  const _AddNewButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding:
            const EdgeInsets.symmetric(horizontal: 18, vertical: 11),
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

class _TypeChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  const _TypeChip(
      {required this.label, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
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

class _BottomBar extends StatelessWidget {
  final int selectedExpenseCount;
  final int selectedIncomeCount;
  final bool isValid;
  final VoidCallback onContinue;

  const _BottomBar({
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



