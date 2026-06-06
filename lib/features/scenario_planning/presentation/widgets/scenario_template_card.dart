import 'package:flutter/material.dart';
import 'package:money_care/core/constants/colors.dart';
import 'package:money_care/features/scenario_planning/data/models/scenario_template_model.dart';

class ScenarioTemplateCard extends StatelessWidget {
  final ScenarioTemplateModel template;
  final bool selected;
  final VoidCallback onTap;

  const ScenarioTemplateCard({
    super.key,
    required this.template,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = selected ? AppColors.primary : AppColors.text3;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: selected
              ? AppColors.primary.withValues(alpha: 0.08)
              : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: selected
                ? AppColors.primary.withValues(alpha: 0.4)
                : Colors.grey.shade200,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(_scenarioIcon(template.scenarioType), color: color, size: 22),
            const SizedBox(height: 10),
            Text(
              template.title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: selected ? AppColors.primary : AppColors.text1,
                fontWeight: FontWeight.bold,
                fontSize: 13,
                height: 1.25,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              template.description,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: AppColors.text3,
                fontSize: 11,
                height: 1.3,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

IconData _scenarioIcon(String scenarioType) {
  return switch (scenarioType) {
    'reduce_frequency_expense' => Icons.repeat_rounded,
    'reduce_category_spending' => Icons.tune_rounded,
    'income_drop' => Icons.trending_down_rounded,
    'one_time_purchase' => Icons.shopping_bag_outlined,
    'increase_saving_goal' => Icons.flag_circle_outlined,
    'extend_goal_deadline' => Icons.event_repeat_rounded,
    _ => Icons.auto_graph_rounded,
  };
}
