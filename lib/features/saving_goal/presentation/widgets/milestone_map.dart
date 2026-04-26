import 'package:flutter/material.dart';

import 'package:money_care/core/constants/colors.dart';
import 'package:money_care/features/saving_goal/data/models/saving_goal_report_model.dart';
import 'package:money_care/core/utils/helper/helper_functions.dart';

class MilestoneMap extends StatelessWidget {
  final List<MilestoneModel> milestones;

  const MilestoneMap({super.key, required this.milestones});

  @override
  Widget build(BuildContext context) {
    if (milestones.isEmpty) {
      return const Center(child: Text('Đang tính toán chặng đường...'));
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 4),
          child: Text(
            'Lộ trình tiết kiệm',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.text1,
            ),
          ),
        ),
        const SizedBox(height: 16),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: milestones.length,
          itemBuilder: (context, index) {
            final milestone = milestones[index];
            final isLast = index == milestones.length - 1;

            return IntrinsicHeight(
              child: Row(
                children: [
                  _buildMilestoneNode(milestone, isLast),
                  const SizedBox(width: 16),
                  Expanded(child: _buildMilestoneCard(milestone)),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildMilestoneNode(MilestoneModel milestone, bool isLast) {
    final color = milestone.isCompleted
        ? AppColors.success
        : AppColors.borderPrimary;

    return Column(
      children: [
        Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            color: milestone.isCompleted ? AppColors.success : Colors.white,
            shape: BoxShape.circle,
            border: Border.all(color: color, width: 2),
          ),
          child: milestone.isCompleted
              ? const Icon(Icons.check, size: 14, color: Colors.white)
              : null,
        ),
        if (!isLast)
          Expanded(child: Container(width: 2, color: color.withOpacity(0.5))),
      ],
    );
  }

  Widget _buildMilestoneCard(MilestoneModel milestone) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: milestone.isCompleted
              ? AppColors.success.withOpacity(0.3)
              : AppColors.borderSecondary,
        ),
        boxShadow: [
          if (milestone.isCompleted)
            BoxShadow(
              color: AppColors.success.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                milestone.label,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: milestone.isCompleted
                      ? AppColors.success
                      : AppColors.text1,
                ),
              ),
              Text(
                '${AppHelperFunction.formatDayMonth(milestone.startDate)} - ${AppHelperFunction.formatDayMonth(milestone.endDate)}',
                style: const TextStyle(fontSize: 11, color: AppColors.text3),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildAmountValue('Mục tiêu', milestone.target),
              _buildAmountValue(
                'Thực tế',
                milestone.actual,
                isBold: true,
                color: milestone.actual >= milestone.target
                    ? AppColors.success
                    : AppColors.text1,
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: (milestone.actual / milestone.target).clamp(0.0, 1.0),
              backgroundColor: AppColors.backgroundSecondary,
              valueColor: AlwaysStoppedAnimation<Color>(
                milestone.isCompleted ? AppColors.success : AppColors.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAmountValue(
    String label,
    double amount, {
    bool isBold = false,
    Color? color,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 10, color: AppColors.text4),
        ),
        Text(
          AppHelperFunction.formatAmount(amount, 'VND'),
          style: TextStyle(
            fontSize: 12,
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            color: color ?? AppColors.text1,
          ),
        ),
      ],
    );
  }
}
