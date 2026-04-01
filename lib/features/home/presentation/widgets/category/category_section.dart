import 'package:flutter/material.dart';
import 'package:money_care/core/utils/helper/helper_functions.dart';
import 'package:money_care/features/home/presentation/widgets/category/category_card.dart';
import 'package:money_care/features/transaction/domain/entities/transaction_entity.dart';

class CategorySection extends StatelessWidget {
  const CategorySection({
    super.key,
    required this.categories,
  });

  final List<TotalByCategoryEntity> categories;

  @override
  Widget build(BuildContext context) {

    return Align(
      alignment: Alignment.centerLeft,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            ...categories.asMap().entries.map((entry) {
              return CategoryCard(
                title: entry.value.categoryName,
                amount: entry.value.total,
                percent: entry.value.percentage.toString(),
                color: AppHelperFunction.getChartColorByIndex(entry.key),
              );
            }),
          ],
        ),
      ),
    );
  }
}
