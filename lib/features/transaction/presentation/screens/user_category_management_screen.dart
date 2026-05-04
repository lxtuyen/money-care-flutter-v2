import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:money_care/core/constants/colors.dart';
import 'package:money_care/core/constants/sizes.dart';
import 'package:money_care/core/utils/helper/helper_functions.dart';
import 'package:money_care/features/transaction/domain/entities/category_entity.dart';
import 'package:money_care/features/transaction/presentation/controllers/user_category_controller.dart';
import 'package:money_care/features/transaction/presentation/widgets/category_form_dialog.dart';
import 'package:money_care/core/theme/app_theme_colors.dart';
import 'package:money_care/app/widgets/layout/app_header.dart';
import 'package:money_care/app/widgets/dialog/app_confirm_dialog.dart';
import 'package:money_care/app/widgets/states/app_empty_state.dart';

class UserCategoryManagementScreen extends StatefulWidget {
  const UserCategoryManagementScreen({super.key});

  @override
  State<UserCategoryManagementScreen> createState() =>
      _UserCategoryManagementScreenState();
}

class _UserCategoryManagementScreenState
    extends State<UserCategoryManagementScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _controller = Get.find<UserCategoryController>();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            AppHeader(
              title: 'Quản lý danh mục',
              showBackButton: true,
              height: 180,
              child: TabBar(
                controller: _tabController,
                labelColor: Colors.white,
                unselectedLabelColor: Colors.white.withOpacity(0.7),
                indicatorColor: Colors.white,
                indicatorWeight: 3,
                indicatorSize: TabBarIndicatorSize.label,
                tabs: const [
                  Tab(text: 'Chi tiêu'),
                  Tab(text: 'Thu nhập'),
                  Tab(text: 'Khác'),
                ],
              ),
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildCategoryList('expense'),
                  _buildCategoryList('income'),
                  _buildCategoryList('others'),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showFormDialog(),
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildCategoryList(String type) {
    return Obx(() {
      final list = _controller.categories.where((c) => c.type == type).toList();

      if (_controller.isLoading.value && list.isEmpty) {
        return const Center(child: CircularProgressIndicator());
      }

      if (list.isEmpty) {
        return AppEmptyState(
          message: type == 'others'
              ? 'Chưa có danh mục chưa phân loại'
              : 'Chưa có danh mục ${type == 'expense' ? 'chi tiêu' : 'thu nhập'} nào',
          action: type != 'others' 
              ? ElevatedButton(
                  onPressed: () => _showFormDialog(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text("Thêm ngay"),
                )
              : null,
        );
      }

      return ListView.separated(
        padding: const EdgeInsets.all(AppSizes.md),
        itemCount: list.length,
        separatorBuilder: (_, _) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final item = list[index];
          return _CategoryItem(
            category: item,
            onEdit: () => _showFormDialog(category: item),
            onDelete: () => _confirmDelete(item),
          );
        },
      );
    });
  }

  void _showFormDialog({CategoryEntity? category}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => CategoryFormDialog(
        category: category,
        initialType: _tabController.index == 0
            ? 'expense'
            : (_tabController.index == 1 ? 'income' : 'others'),
      ),
    );
  }

  void _confirmDelete(CategoryEntity category) {
    AppConfirmDialog.show(
      title: 'Xóa danh mục?',
      message: 'Bạn có chắc chắn muốn xóa danh mục "${category.name}"? Hành động này không thể hoàn tác.',
      confirmText: 'Xóa',
      cancelText: 'Hủy',
      onConfirm: () async {
        final success = await _controller.deleteCategory(category.id!);
        if (success) {
          AppHelperFunction.showSuccessSnackBar('Xóa danh mục này thành công');
        } else {
          AppHelperFunction.showErrorSnackBar('Không thể xóa danh mục này');
        }
      },
    );
  }
}

class _CategoryItem extends StatelessWidget {
  final CategoryEntity category;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _CategoryItem({
    required this.category,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final bool isLocked = category.name == 'Khác' || 
                         category.name == 'Mục khác' || 
                         category.name == 'Chuyển tiền' ||
                         category.name == 'Chưa phân loại';

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppThemeColors.of(context).cardBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderPrimary.withOpacity(0.5)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppThemeColors.of(context).surfaceBackground,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(category.icon, style: const TextStyle(fontSize: 24)),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  category.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    if (category.isEssential)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Text(
                          'Thiết yếu',
                          style: TextStyle(
                            fontSize: 10,
                            color: AppColors.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      )
                    else
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.text4.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Text(
                          'Không thiết yếu',
                          style: TextStyle(
                            fontSize: 10,
                            color: AppColors.text4,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    if (isLocked) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.orange.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Text(
                          'Hệ thống',
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.orange,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),

          if (!isLocked) ...[
            IconButton(
              onPressed: onEdit,
              icon: const Icon(
                Icons.edit_outlined,
                color: AppColors.primary,
                size: 20,
              ),
            ),
            IconButton(
              onPressed: onDelete,
              icon: const Icon(
                Icons.delete_outline,
                color: AppColors.error,
                size: 20,
              ),
            ),
          ] else
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 12),
              child: Icon(
                Icons.lock_outline,
                color: AppColors.text4,
                size: 20,
              ),
            ),
        ],
      ),
    );
  }
}
