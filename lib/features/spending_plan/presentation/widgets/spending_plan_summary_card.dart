import 'package:flutter/material.dart';
import 'package:money_care/core/constants/colors.dart';
import 'package:money_care/features/spending_plan/domain/entities/spending_plan_entity.dart';

class SpendingPlanSummaryCard extends StatelessWidget {
  final SpendingPlanEntity plan;

  const SpendingPlanSummaryCard({super.key, required this.plan});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Kế hoạch chi tiêu',
                  style: textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              _StatusChip(status: plan.status),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'Tháng ${plan.month}/${plan.year}',
            style: textTheme.bodyMedium?.copyWith(color: Colors.grey.shade700),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              _MetricTile(label: 'Tổng tiền', value: plan.totalAmount),
              _MetricTile(
                label: 'Chi dự kiến',
                value: plan.estimatedExpenseTotal,
              ),
              _MetricTile(
                label: 'Còn chi linh hoạt',
                value: plan.availableSpendingAmount,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MetricTile extends StatelessWidget {
  final String label;
  final double value;

  const _MetricTile({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 140,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: Colors.grey.shade600),
          ),
          const SizedBox(height: 4),
          Text(
            _formatMoney(value),
            style: Theme.of(
              context,
            ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  final String status;

  const _StatusChip({required this.status});

  @override
  Widget build(BuildContext context) {
    final isActive = status == 'active';
    final isPaused = status == 'paused';
    final isArchived = status == 'archived';
    final color = isActive
        ? AppColors.primary
        : isPaused
        ? Colors.blueGrey
        : isArchived
        ? Colors.grey
        : Colors.orange;
    final label = isActive
        ? 'Đang áp dụng'
        : isPaused
        ? 'Tạm dừng'
        : isArchived
        ? 'Đã lưu trữ'
        : 'Bản nháp';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(99),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

String _formatMoney(double value) {
  final rounded = value.round().toString();
  final buffer = StringBuffer();
  for (var i = 0; i < rounded.length; i++) {
    final reversedIndex = rounded.length - i;
    buffer.write(rounded[i]);
    if (reversedIndex > 1 && reversedIndex % 3 == 1) {
      buffer.write('.');
    }
  }
  return '${buffer.toString()}đ';
}
