import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:money_care/core/constants/colors.dart';
import 'package:money_care/features/transaction/domain/entities/transaction_entity.dart';
import 'package:money_care/features/transaction/presentation/widgets/category_item.dart';
import 'package:money_care/core/theme/app_theme_colors.dart';

class CategorySheet extends StatefulWidget {
  final List<CategoryEntity> categories;
  final CategoryEntity? selectedCategoryInit;

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

  List<CategoryEntity> _filteredCategories() {
    var list = widget.categories.where((c) {
      if (c.type == 'others') return true;

      if (widget.transactionType != null && c.type != null) {
        return c.type == widget.transactionType;
      }
      return true;
    }).toList();

    return list;
  }

  @override
  Widget build(BuildContext context) {
      final displayCategories = _filteredCategories();

      return DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.62,
        minChildSize: 0.38,
        maxChildSize: 0.9,
        builder: (context, scrollController) {
          return Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: AppThemeColors.of(context).cardBackground,
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
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'transaction.selectCategoryTitle'.tr,
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                                color: AppThemeColors.of(context).textPrimary,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'transaction.categoryNormalDesc'.tr,
                              style: TextStyle(
                                fontSize: 13,
                                color: AppThemeColors.of(context).textSecondary,
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
                      color: AppThemeColors.of(context).surfaceBackground,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      selectedCategory != null
                          ? 'filter.selectedCategory'.trParams({
                              'name': selectedCategory!.name,
                            })
                          : 'filter.noCategorySelected'.tr,
                      style: TextStyle(
                        color: AppThemeColors.of(context).textSecondary,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                Expanded(
                  child: displayCategories.isEmpty
                      ? Center(
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 24),
                            child: Text(
                              'transaction.noCategoryAvailable'.tr,
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
  }
}
