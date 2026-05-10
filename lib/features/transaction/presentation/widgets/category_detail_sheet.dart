import 'package:flutter/material.dart';
import 'package:money_care/core/constants/category_constants.dart';
import 'package:money_care/core/constants/colors.dart';
import 'package:money_care/core/theme/app_theme_colors.dart';
import 'package:money_care/features/transaction/domain/entities/category_entity.dart';
import 'package:money_care/features/transaction/presentation/controllers/user_category_controller.dart';
import 'package:get/get.dart';

class CategoryDetailSheet extends StatefulWidget {
  final CategoryEntity category;

  const CategoryDetailSheet({super.key, required this.category});

  @override
  State<CategoryDetailSheet> createState() => _CategoryDetailSheetState();
}

class _CategoryDetailSheetState extends State<CategoryDetailSheet> {
  late bool _isEssential;
  bool _isUpdating = false;
  final _controller = Get.find<UserCategoryController>();

  @override
  void initState() {
    super.initState();
    _isEssential = widget.category.isEssential;
  }

  Future<void> _toggleEssential(bool value) async {
    setState(() {
      _isUpdating = true;
    });

    final success = await _controller.updateCategory(
      widget.category.id!,
      widget.category.name,
      widget.category.icon,
      widget.category.type,
      value,
    );

    if (success) {
      setState(() {
        _isEssential = value;
      });
    } else {
      // Revert if failed
      setState(() {
        _isEssential = widget.category.isEssential;
      });
    }

    setState(() {
      _isUpdating = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Try to get detail by name, if not found or if it's 'Khác', try with type suffix
    String key = widget.category.name;
    if (widget.category.name == 'Khác') {
      key = widget.category.type == 'income' ? 'Khác (Thu nhập)' : 'Khác';
    }
    
    final detail = CategoryConstants.categoryDetails[key];
    final theme = AppThemeColors.of(context);

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: theme.cardBackground,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.borderPrimary,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(widget.category.icon, style: const TextStyle(fontSize: 32)),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.category.name,
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        color: theme.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _isEssential ? 'Danh mục thiết yếu' : 'Danh mục không thiết yếu',
                      style: TextStyle(
                        fontSize: 14,
                        color: _isEssential ? AppColors.primary : AppColors.text4,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          
          // Toggle Essential (Only for Expense)
          if (widget.category.type == 'expense')
            Container(
              margin: const EdgeInsets.only(bottom: 24),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: theme.surfaceBackground,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.borderPrimary.withOpacity(0.5)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.star_outline, color: AppColors.primary),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Text(
                      'Đánh dấu là thiết yếu',
                      style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                    ),
                  ),
                  if (_isUpdating)
                    const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  else
                    Switch(
                      value: _isEssential,
                      onChanged: _toggleEssential,
                      activeColor: AppColors.primary,
                    ),
                ],
              ),
            ),

          _buildSection(
            context,
            title: 'Giới thiệu',
            content: detail?.description ?? 'Thông tin đang được cập nhật...',
            icon: Icons.info_outline,
          ),
          const SizedBox(height: 20),
          _buildSection(
            context,
            title: 'Ví dụ giao dịch',
            isList: true,
            examples: detail?.examples ?? [],
            icon: Icons.lightbulb_outline,
          ),
          const SizedBox(height: 20),
          if (detail?.savingTip != null)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.amber.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.amber.withOpacity(0.3)),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.stars, color: Colors.amber, size: 20),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      detail!.savingTip,
                      style: const TextStyle(
                        fontSize: 13,
                        height: 1.5,
                        fontStyle: FontStyle.italic,
                        color: Colors.orange,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildSection(
    BuildContext context, {
    required String title,
    String? content,
    bool isList = false,
    List<String> examples = const [],
    required IconData icon,
  }) {
    final theme = AppThemeColors.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 18, color: AppColors.primary),
            const SizedBox(width: 8),
            Text(
              title,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: theme.textPrimary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        if (isList)
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: examples.map((e) => Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: theme.surfaceBackground,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.borderPrimary.withOpacity(0.5)),
              ),
              child: Text(
                e,
                style: TextStyle(fontSize: 13, color: theme.textSecondary),
              ),
            )).toList(),
          )
        else
          Text(
            content!,
            style: TextStyle(
              fontSize: 14,
              height: 1.5,
              color: theme.textSecondary,
            ),
          ),
      ],
    );
  }
}
