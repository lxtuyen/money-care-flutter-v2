import 'package:flutter/material.dart';
import 'package:money_care/core/constants/colors.dart';
import 'package:money_care/core/utils/helper/helper_functions.dart';
import 'package:money_care/features/scenario_planning/data/models/scenario_simulation_model.dart';

class ScenarioResultCard extends StatelessWidget {
  final ScenarioSimulationModel result;

  const ScenarioResultCard({super.key, required this.result});

  @override
  Widget build(BuildContext context) {
    final riskColor = _riskColor(result.budgetRiskAfter);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: riskColor.withValues(alpha: 0.07),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: riskColor.withValues(alpha: 0.22)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.insights_rounded, color: riskColor),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  result.title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: AppColors.text1,
                  ),
                ),
              ),
              _RiskBadge(risk: result.budgetRiskAfter),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            result.summary,
            style: const TextStyle(
              fontSize: 13,
              color: AppColors.text2,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 12),
          _MetricRow(
            label: 'Thay đổi tiết kiệm/tháng',
            value: _signedAmount(result.monthlySaving),
            color: result.monthlySaving >= 0
                ? AppColors.success
                : AppColors.error,
          ),
          _MetricRow(
            label: 'Thay đổi chi tiêu/tháng',
            value: _signedAmount(result.monthlyExpenseChange),
            color: result.monthlyExpenseChange <= 0
                ? AppColors.success
                : AppColors.error,
          ),
          _MetricRow(
            label: 'Tiết kiệm dự kiến sau mô phỏng',
            value: AppHelperFunction.formatAmount(result.expectedSavingsAfter),
            color: AppColors.text1,
          ),
          _MetricRow(
            label: 'Độ tin cậy',
            value: '${(result.confidence * 100).round()}%',
            color: AppColors.info,
          ),
          if (result.goalImpacts.isNotEmpty) ...[
            const Divider(height: 24),
            ...result.goalImpacts.map((impact) => _GoalImpactRow(impact)),
          ],
          if (result.recommendedActions.isNotEmpty) ...[
            const Divider(height: 24),
            ...result.recommendedActions.map(
              (action) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.check_circle_outline_rounded,
                      color: _priorityColor(action.priority),
                      size: 17,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        action.message,
                        style: const TextStyle(
                          color: AppColors.text2,
                          fontSize: 12,
                          height: 1.35,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
          if (result.reasonCodes.isNotEmpty) ...[
            const SizedBox(height: 4),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: result.reasonCodes
                  .take(5)
                  .map((code) => _ReasonChip(code: code))
                  .toList(),
            ),
          ],
        ],
      ),
    );
  }
}

class _GoalImpactRow extends StatelessWidget {
  final ScenarioGoalImpactModel impact;

  const _GoalImpactRow(this.impact);

  @override
  Widget build(BuildContext context) {
    final isEarlier = (impact.impactDays ?? 0) < 0;
    final color = impact.impactDays == null
        ? AppColors.text3
        : isEarlier
        ? AppColors.success
        : impact.impactDays == 0
        ? AppColors.info
        : AppColors.warning;

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.flag_circle_outlined, color: color, size: 18),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  impact.goalName,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                    color: AppColors.text1,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  impact.impactText,
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppColors.text3,
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MetricRow extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _MetricRow({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: const TextStyle(color: AppColors.text3, fontSize: 12),
            ),
          ),
          const SizedBox(width: 12),
          Text(
            value,
            textAlign: TextAlign.right,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}

class _RiskBadge extends StatelessWidget {
  final String risk;

  const _RiskBadge({required this.risk});

  @override
  Widget build(BuildContext context) {
    final color = _riskColor(risk);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(9),
      ),
      child: Text(
        _riskText(risk),
        style: TextStyle(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class _ReasonChip extends StatelessWidget {
  final String code;

  const _ReasonChip({required this.code});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.info.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        code.replaceAll('_', ' '),
        style: const TextStyle(
          color: AppColors.text3,
          fontSize: 10,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

String _signedAmount(double value) {
  final prefix = value > 0 ? '+' : '';
  return '$prefix${AppHelperFunction.formatAmount(value)}';
}

String _riskText(String risk) {
  return switch (risk) {
    'high' => 'Rủi ro cao',
    'medium' => 'Rủi ro TB',
    _ => 'Rủi ro thấp',
  };
}

Color _riskColor(String risk) {
  return switch (risk) {
    'high' => AppColors.error,
    'medium' => AppColors.warning,
    _ => AppColors.success,
  };
}

Color _priorityColor(String priority) {
  return switch (priority) {
    'high' => AppColors.error,
    'low' => AppColors.info,
    _ => AppColors.warning,
  };
}
