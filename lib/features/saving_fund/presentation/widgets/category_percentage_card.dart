import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:money_care/core/constants/colors.dart';
import 'package:money_care/core/presentation/widgets/text_field/percentage_input_field.dart';
import 'package:money_care/features/transaction/domain/entities/category_entity.dart';

class CategoryPercentageCard extends StatelessWidget {
  final CategoryEntity category;
  final int index;
  final Function(int percentage) onPercentageChanged;

  const CategoryPercentageCard({
    super.key,
    required this.category,
    required this.index,
    required this.onPercentageChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: SvgPicture.asset(
                    'assets/icons/${category.icon}.svg',
                    width: 28,
                    height: 28,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    category.name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                PercentageInputField(
                  value: category.percentage,
                  onChanged: (value) {
                    onPercentageChanged(value);
                  },
                ),
              ],
            ),

            SliderTheme(
              data: SliderThemeData(
                activeTrackColor: AppColors.primary,
                inactiveTrackColor: AppColors.primary.withOpacity(0.2),
                thumbColor: AppColors.primary,
                overlayColor: AppColors.primary.withOpacity(0.3),
              ),
              child: Slider(
                value: category.percentage.toDouble(),
                min: 0,
                max: 100,
                divisions: 100,
                label: '${category.percentage}%',
                onChanged: (value) {
                  onPercentageChanged(value.toInt());
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
