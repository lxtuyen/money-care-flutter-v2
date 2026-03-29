import 'package:flutter/material.dart';
import 'package:money_care/features/transaction/domain/entities/transaction_entity.dart';

class CategoryShareChip extends StatelessWidget {
  final CategoryEntity category;
  const CategoryShareChip({required this.category, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: category.color?.withOpacity(0.12),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            '${category.percentage.toStringAsFixed(1)}%',
            style: TextStyle(
              color: category.color,
              fontSize: 13,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: 6),
          Flexible(
            child: Text(
              category.name,
              style: TextStyle(
                color: category.color,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
