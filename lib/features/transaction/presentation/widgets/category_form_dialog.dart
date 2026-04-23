import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:money_care/core/constants/colors.dart';
import 'package:money_care/core/constants/sizes.dart';
import 'package:money_care/features/transaction/domain/entities/category_entity.dart';
import 'package:money_care/features/transaction/presentation/controllers/user_category_controller.dart';

class CategoryFormDialog extends StatefulWidget {
  final CategoryEntity? category;
  final String? initialType;

  const CategoryFormDialog({super.key, this.category, this.initialType});

  @override
  State<CategoryFormDialog> createState() => _CategoryFormDialogState();
}

class _CategoryFormDialogState extends State<CategoryFormDialog> {
  final _nameController = TextEditingController();
  final _iconController = TextEditingController();
  late String _selectedType;
  late bool _isEssential;
  final _controller = Get.find<UserCategoryController>();

  int _selectedCategoryIndex = 0;

  static const List<Map<String, dynamic>> _iconCategories = [
    {
      'name': 'Nhà & Bill',
      'icons': [
        '🏠',
        '⚡',
        '💧',
        '📶',
        '🔌',
        '🧹',
        '🧼',
        '🧺',
        '🧴',
        '🛒',
        '🛋️',
        '🌱',
      ],
    },
    {
      'name': 'Ăn uống',
      'icons': [
        '🍔',
        '🍕',
        '🍜',
        '☕',
        '🍱',
        '🍰',
        '🍺',
        '🍹',
        '🥯',
        '🍣',
        '🥗',
        '🥪',
      ],
    },
    {
      'name': 'Di chuyển',
      'icons': ['🚗', '🛵', '🚲', '🚌', '🚕', '⛽', '🛠️', '🅿️', '🚂', '✈️'],
    },
    {
      'name': 'Giải trí',
      'icons': ['🎮', '🎬', '🎤', '🎪', '🎨', '🎭', '🎸', '🎡', '🧩', '🎳'],
    },
    {
      'name': 'Sức khỏe',
      'icons': ['💊', '🏥', '🩺', '🦷', '👟', '💆', '🧴', '🚿'],
    },
    {
      'name': 'Khác',
      'icons': ['🎁', '💰', '🎓', '🐾', '🧸', '📦', '🛍️', '🧺'],
    },
  ];

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.category?.name ?? '';
    _iconController.text = widget.category?.icon ?? '🍔';
    _selectedType = widget.category?.type ?? widget.initialType ?? 'expense';
    _isEssential = widget.category?.isEssential ?? true;

    // Tìm index của category chứa icon hiện tại
    final currentIcon = _iconController.text;
    for (int i = 0; i < _iconCategories.length; i++) {
      if ((_iconCategories[i]['icons'] as List<String>).contains(currentIcon)) {
        _selectedCategoryIndex = i;
        break;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.category != null;

    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom + AppSizes.md,
        left: AppSizes.md,
        right: AppSizes.md,
        top: AppSizes.md,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 42,
                height: 5,
                decoration: BoxDecoration(
                  color: AppColors.borderPrimary,
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              isEditing ? 'Sửa danh mục' : 'Thêm danh mục mới',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 20),

            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Tên danh mục',
                hintText: 'Ví dụ: Ăn uống, Di chuyển...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
            const SizedBox(height: 16),

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Loại danh mục',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: ChoiceChip(
                        label: const Center(
                          child: Text(
                            'Chi tiêu',
                            style: TextStyle(fontSize: 12),
                          ),
                        ),
                        selected: _selectedType == 'expense',
                        onSelected: (val) =>
                            setState(() => _selectedType = 'expense'),
                        showCheckmark: false,
                        selectedColor: AppColors.primary,
                        labelStyle: TextStyle(
                          color: _selectedType == 'expense'
                              ? Colors.white
                              : AppColors.text2,
                        ),
                      ),
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: ChoiceChip(
                        label: const Center(
                          child: Text(
                            'Thu nhập',
                            style: TextStyle(fontSize: 12),
                          ),
                        ),
                        selected: _selectedType == 'income',
                        onSelected: (val) =>
                            setState(() => _selectedType = 'income'),
                        showCheckmark: false,
                        selectedColor: AppColors.primary,
                        labelStyle: TextStyle(
                          color: _selectedType == 'income'
                              ? Colors.white
                              : AppColors.text2,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
              ],
            ),

            const Text(
              'Biểu tượng',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppColors.primary.withOpacity(0.3),
                      width: 2,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      _iconController.text,
                      style: const TextStyle(fontSize: 32),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                const Expanded(
                  child: Text(
                    "Chọn biểu tượng phù hợp nhất với danh mục của bạn bên dưới.",
                    style: TextStyle(fontSize: 13, color: AppColors.text4),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Categories Selector
            SizedBox(
              height: 36,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: _iconCategories.length,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (context, index) {
                  final isSelected = _selectedCategoryIndex == index;
                  return ChoiceChip(
                    label: Text(
                      _iconCategories[index]['name'],
                      style: TextStyle(
                        fontSize: 12,
                        color: isSelected ? Colors.white : AppColors.text3,
                        fontWeight: isSelected
                            ? FontWeight.w700
                            : FontWeight.w400,
                      ),
                    ),
                    selected: isSelected,
                    onSelected: (val) {
                      if (val) setState(() => _selectedCategoryIndex = index);
                    },
                    selectedColor: AppColors.primary,
                    backgroundColor: AppColors.backgroundSecondary,
                    showCheckmark: false,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),

            // Icons Grid
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.backgroundSecondary.withOpacity(0.5),
                borderRadius: BorderRadius.circular(20),
              ),
              child: GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 6,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                ),
                itemCount:
                    (_iconCategories[_selectedCategoryIndex]['icons'] as List)
                        .length,
                itemBuilder: (context, index) {
                  final icon =
                      _iconCategories[_selectedCategoryIndex]['icons'][index];
                  final isSelected = _iconController.text == icon;
                  return GestureDetector(
                    onTap: () => setState(() => _iconController.text = icon),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      decoration: BoxDecoration(
                        color: isSelected ? Colors.white : Colors.transparent,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: isSelected
                            ? [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                              ]
                            : [],
                        border: isSelected
                            ? Border.all(color: AppColors.primary, width: 1.5)
                            : null,
                      ),
                      child: Center(
                        child: Text(icon, style: const TextStyle(fontSize: 24)),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 24),

            // isEssential Switch
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.backgroundSecondary,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Danh mục thiết yếu',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          'Sẽ luôn hiển thị trong Chế độ Sinh tồn',
                          style: TextStyle(
                            color: AppColors.text4,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Switch(
                    value: _isEssential,
                    onChanged: (val) => setState(() => _isEssential = val),
                    activeColor: AppColors.primary,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Action Buttons
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _submit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: Obx(
                  () => _controller.isLoading.value
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : Text(
                          isEditing ? 'Cập nhật' : 'Thêm mới',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
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

  void _submit() async {
    if (_nameController.text.trim().isEmpty) {
      Get.snackbar('Lỗi', 'Vui lòng nhập tên danh mục');
      return;
    }

    bool success;
    if (widget.category != null) {
      success = await _controller.updateCategory(
        widget.category!.id!,
        _nameController.text.trim(),
        _iconController.text.trim(),
        _selectedType,
        _isEssential,
      );
    } else {
      success = await _controller.addCategory(
        _nameController.text.trim(),
        _iconController.text.trim(),
        _selectedType,
        _isEssential,
      );
    }

    if (success) {
      Get.back();
      Get.snackbar(
        'Thành công',
        widget.category != null
            ? 'Đã cập nhật danh mục'
            : 'Đã thêm danh mục mới',
      );
    } else {
      Get.snackbar('Lỗi', 'Không thể lưu danh mục. Vui lòng thử lại.');
    }
  }
}
