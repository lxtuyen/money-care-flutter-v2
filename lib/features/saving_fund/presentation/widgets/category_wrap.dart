import 'package:flutter/material.dart';
import 'package:money_care/core/presentation/widgets/icon/rounded_icon.dart';
import 'package:money_care/features/transaction/domain/entities/category_entity.dart';
import 'package:money_care/core/constants/app_assets.dart';

class CategoryWrap extends StatelessWidget {
  final List<CategoryEntity> categories;

  const CategoryWrap({super.key, required this.categories});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 0.85,
      ),
      itemCount: categories.length,
      itemBuilder: (context, index) {
        final cat = categories[index];
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RoundedIcon(
              padding: const EdgeInsets.all(8),
              applyIconRadius: true,
              width: 40,
              height: 40,
              backgroundColor: Colors.grey.shade200,
              iconPath: AppAssets.iconSvgPath(cat.icon),
              size: 24,
            ),
            const SizedBox(height: 8),
            Text(
              cat.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
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
      },
    );
  }
}
