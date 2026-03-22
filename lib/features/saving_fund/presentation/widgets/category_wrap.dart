import 'package:flutter/material.dart';
import 'package:money_care/core/presentation/widgets/icon/rounded_icon.dart';
import 'package:money_care/features/transaction/domain/entities/category_entity.dart';

class CategoryWrap extends StatelessWidget {
  final List<CategoryEntity> categories;

  const CategoryWrap({super.key, required this.categories});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: categories.map((cat) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RoundedIcon(
              padding: const EdgeInsets.all(8),
              applyIconRadius: true,
              width: 40,
              height: 40,
              backgroundColor: Colors.grey.shade200,
              iconPath: 'assets/icons/${cat.icon}.svg',
              size: 24,
            ),
            const SizedBox(height: 8),
            Text(
              cat.name,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
            ),
            Text(
              '${cat.percentage}%',
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 11,
              ),
            ),
          ],
        );
      }).toList(),
    );
  }
}
