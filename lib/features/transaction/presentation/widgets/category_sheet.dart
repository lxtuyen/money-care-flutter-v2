import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:money_care/core/constants/colors.dart';
import 'package:money_care/features/finance_mode/domain/entities/finance_mode_entity.dart';
import 'package:money_care/features/finance_mode/presentation/controllers/finance_mode_controller.dart';
import 'package:money_care/features/transaction/domain/entities/transaction_entity.dart';
import 'package:money_care/features/transaction/presentation/widgets/category_item.dart';

class CategorySheet extends StatefulWidget {
  final List<CategoryEntity> categories;
  final CategoryEntity? selectedCategoryInit;
  /// 'income' hoặc 'expense' — chỉ hiển thị category khớp type hoặc type null.
  final String? transactionType;

  const CategorySheet({
    super.key,
    required this.categories,
    this.selectedCategoryInit,
    this.transactionType,
  });

  @override
  State<CategorySheet> createState() => _CategorySheetState();
}

class _CategorySheetState extends State<CategorySheet> {
  CategoryEntity? selectedCategory;

  @override
  void initState() {
    super.initState();
    selectedCategory = widget.selectedCategoryInit;
  }

  /// Returns the filtered category list.
  /// - Lọc theo [transactionType] nếu category có type (null = hiển thị cho cả hai).
  /// - Trong SURVIVAL mode, ẩn các category không thiết yếu (Requirement 5.8).
  List<CategoryEntity> _filteredCategories(FinanceMode mode) {
    var list = widget.categories.where((c) {
      // Nếu là 'others' thì luôn cho phép hiển thị bất kể transactionType là gì.
      if (c.type == 'others') return true;
      
      if (widget.transactionType != null && c.type != null) {
        return c.type == widget.transactionType;
      }
      return true;
    }).toList();

    if (mode == FinanceMode.survival) {
      list = list.where((c) => c.isEssential).toList();
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    final financeModeController = Get.find<FinanceModeController>();

    return Obx(() {
      final mode = financeModeController.currentMode.value;
      final isSurvival = mode == FinanceMode.survival;
      final displayCategories = _filteredCategories(mode);

      return DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.62,
        minChildSize: 0.38,
        maxChildSize: 0.9,
        builder: (context, scrollController) {
          return Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
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
                const SizedBox(height: 18),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18),
                  child: Row(
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: AppColors.backgroundPrimary,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: const Icon(
                          Icons.category_rounded,
                          color: AppColors.primary,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Chọn phân loại',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                                color: AppColors.text1,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              isSurvival
                                  ? 'Chế độ Sinh tồn: chỉ hiển thị danh mục thiết yếu.'
                                  : 'Chọn nhóm phù hợp cho giao dịch của bạn.',
                              style: TextStyle(
                                fontSize: 13,
                                color: isSurvival
                                    ? AppColors.error
                                    : AppColors.text4,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: AppColors.backgroundPrimary,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      selectedCategory != null
                          ? 'Đang chọn: ${selectedCategory!.name}'
                          : 'Chưa chọn phân loại nào',
                      style: const TextStyle(
                        color: AppColors.text3,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                Expanded(
                  child: displayCategories.isEmpty
                      ? const Center(
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 24),
                            child: Text(
                              'Không có phân loại nào.\nVui lòng kiểm tra lại thiết lập quỹ.',
                              textAlign: TextAlign.center,
                              style: TextStyle(color: AppColors.text4),
                            ),
                          ),
                        )
                      : GridView.builder(
                          controller: scrollController,
                          padding: const EdgeInsets.fromLTRB(18, 4, 18, 24),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                            childAspectRatio: 1.28,
                          ),
                          itemCount: displayCategories.length,
                          itemBuilder: (context, index) {
                            final item = displayCategories[index];
                            final isSelected = selectedCategory == item;

                            return GestureDetector(
                              onTap: () {
                                setState(() => selectedCategory = item);
                                Navigator.pop(context, item);
                              },
                              child: CategoryItem(
                                title: item.name,
                                percentage: item.percentage,
                                icon: item.icon,
                                isSelected: isSelected,
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
          );
        },
      );
    });
  }
}
