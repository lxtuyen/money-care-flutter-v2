import 'package:flutter/material.dart';
import 'package:money_care/core/constants/colors.dart';
import 'package:money_care/core/theme/app_theme_colors.dart';
import 'package:money_care/core/utils/helper/helper_functions.dart';

class ScenarioSimulationBubble extends StatelessWidget {
  final Map<String, dynamic> metadata;

  const ScenarioSimulationBubble({super.key, required this.metadata});

  @override
  Widget build(BuildContext context) {
    final colors = AppThemeColors.of(context);
    final categoryContext = metadata['categoryContext'];
    final goalImpact = metadata['goalImpact'];

    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.85,
        ),
        decoration: BoxDecoration(
          color: colors.cardBackground,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: colors.borderSecondary, width: 1.2),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                gradient: AppColors.linearGradient,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: const Row(
                children: [
                  Icon(Icons.analytics_rounded, size: 20, color: Colors.white),
                  SizedBox(width: 10),
                  Text(
                    'Kết quả mô phỏng kịch bản',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),

            // Content
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Category Budget Block
                  if (categoryContext != null) ...[
                    _buildCategoryBlock(context, colors, categoryContext),
                    if (goalImpact != null) const Divider(height: 24, thickness: 0.8),
                  ],

                  // Goal Impact Block
                  if (goalImpact != null) ...[
                    _buildGoalBlock(context, colors, goalImpact),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryBlock(
    BuildContext context,
    AppThemeColors colors,
    Map<String, dynamic> category,
  ) {
    final String name = category['categoryName'] ?? 'danh mục';
    final double? limit = category['monthlyLimit'] != null
        ? (category['monthlyLimit'] as num).toDouble()
        : null;
    final double? after = category['forecastAfter'] != null
        ? (category['forecastAfter'] as num).toDouble()
        : null;
    final double? average = category['monthlyAverage'] != null
        ? (category['monthlyAverage'] as num).toDouble()
        : null;
    final double? remainingAfter = category['remainingLimitAfter'] != null
        ? (category['remainingLimitAfter'] as num).toDouble()
        : null;
    final double? usagePct = category['usagePctAfter'] != null
        ? (category['usagePctAfter'] as num).toDouble()
        : null;
    final double? spentSoFar = category['spentSoFar'] != null
        ? (category['spentSoFar'] as num).toDouble()
        : null;
    final double? spentPctNow = category['spentPctNow'] != null
        ? (category['spentPctNow'] as num).toDouble()
        : null;

    final hasLimit = limit != null && limit > 0 && after != null;
    final hasAverage = average != null && average > 0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.pie_chart_rounded, size: 18, color: AppColors.primary),
            const SizedBox(width: 8),
            Text(
              'Ngân sách nhóm: $name',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 13,
                color: colors.textPrimary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        if (hasLimit) ...[
          // Row: Hiện tại (chi tiêu thực tế giai đoạn này)
          if (spentSoFar != null && spentSoFar > 0) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Hiện tại:',
                  style: TextStyle(fontSize: 11.5, color: colors.textSecondary),
                ),
                Text(
                  '${AppHelperFunction.formatAmount(spentSoFar)} / ${AppHelperFunction.formatAmount(limit!)}',
                  style: TextStyle(
                    fontSize: 11.5,
                    fontWeight: FontWeight.bold,
                    color: colors.textPrimary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: ((spentPctNow ?? 0.0) / 100).clamp(0.0, 1.0),
                backgroundColor: Colors.grey.shade100,
                valueColor: AlwaysStoppedAnimation<Color>(
                  (spentPctNow ?? 0) >= 100
                      ? AppColors.error
                      : (spentPctNow ?? 0) >= 80
                      ? const Color(0xFFF59E0B)
                      : AppColors.primary,
                ),
                minHeight: 6,
              ),
            ),
            const SizedBox(height: 6),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Tỷ lệ hiện tại:',
                  style: TextStyle(fontSize: 11, color: colors.textSecondary),
                ),
                Text(
                  '${(spentPctNow ?? 0.0).toStringAsFixed(1)}%',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: (spentPctNow ?? 0) >= 100
                        ? AppColors.error
                        : (spentPctNow ?? 0) >= 80
                        ? const Color(0xFFF59E0B)
                        : AppColors.primary,
                  ),
                ),
              ],
            ),
            const Divider(height: 14, thickness: 0.6),
          ],
          // Row: Dự kiến cuối tháng (sau kịch bản)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Dự kiến cuối tháng:',
                style: TextStyle(fontSize: 11.5, color: colors.textSecondary),
              ),
              Text(
                '${AppHelperFunction.formatAmount(after!)} / ${AppHelperFunction.formatAmount(limit!)}',
                style: TextStyle(
                  fontSize: 11.5,
                  fontWeight: FontWeight.bold,
                  color: colors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          if (spentSoFar == null || spentSoFar <= 0) ...[
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: ((usagePct ?? 0.0) / 100).clamp(0.0, 1.0),
                backgroundColor: Colors.grey.shade100,
                valueColor: AlwaysStoppedAnimation<Color>(
                  remainingAfter != null && remainingAfter >= 0
                      ? AppColors.primary
                      : AppColors.error,
                ),
                minHeight: 6,
              ),
            ),
            const SizedBox(height: 6),
          ],
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Tỷ lệ sử dụng:',
                style: TextStyle(fontSize: 11, color: colors.textSecondary),
              ),
              Text(
                '${(usagePct ?? 0.0).toStringAsFixed(1)}%',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: remainingAfter != null && remainingAfter >= 0
                      ? AppColors.primary
                      : AppColors.error,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                remainingAfter != null && remainingAfter >= 0
                    ? 'Dự kiến còn dư:'
                    : 'Dự kiến vượt:',
                style: TextStyle(fontSize: 11, color: colors.textSecondary),
              ),
              Text(
                AppHelperFunction.formatAmount(remainingAfter?.abs() ?? 0),
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  color: remainingAfter != null && remainingAfter >= 0
                      ? AppColors.success
                      : AppColors.error,
                ),
              ),
            ],
          ),
        ] else if (hasAverage) ...[
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.blue.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              'Bạn thường chi khoảng ${AppHelperFunction.formatAmount(average)}/tháng cho nhóm này. Hãy cài đặt hạn mức để kiểm soát chi tiêu tốt hơn.',
              style: TextStyle(
                fontSize: 11.5,
                color: colors.textSecondary,
                height: 1.4,
              ),
            ),
          ),
        ] else ...[
          Text(
            'Chưa có thông tin hạn mức cho danh mục này.',
            style: TextStyle(
              fontSize: 11.5,
              color: colors.textSecondary,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildGoalBlock(
    BuildContext context,
    AppThemeColors colors,
    Map<String, dynamic> goal,
  ) {
    final String name = goal['goalName'] ?? 'mục tiêu';
    final String statusBefore = _goalStatusText(goal['currentStatus']);
    final String statusAfter = _goalStatusText(goal['newStatus']);
    final String dateBefore = _formatDate(goal['currentPredictedCompletionDate']);
    final String dateAfter = _formatDate(goal['newPredictedCompletionDate']);
    
    final double rateBefore = goal['currentMonthlySavingRate'] != null
        ? (goal['currentMonthlySavingRate'] as num).toDouble()
        : 0;
    final double rateAfter = goal['newMonthlySavingRate'] != null
        ? (goal['newMonthlySavingRate'] as num).toDouble()
        : 0;
    final double reqBefore = goal['requiredMonthlySavingRate'] != null
        ? (goal['requiredMonthlySavingRate'] as num).toDouble()
        : 0;
    final double reqAfter = goal['newRequiredMonthlySavingRate'] != null
        ? (goal['newRequiredMonthlySavingRate'] as num).toDouble()
        : 0;

    final String diffBefore = _goalDifferenceText(goal['currentDaysDifference']);
    final String diffAfter = _goalDifferenceText(goal['newDaysDifference']);

    final statusColor = _statusColor(goal['newStatus']);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.flag_circle_outlined, size: 18, color: AppColors.secondaryOrange),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                'Mục tiêu: $name',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                  color: colors.textPrimary,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        _buildCompareRow(
          colors,
          'Trạng thái:',
          statusBefore,
          statusAfter,
          valueColorAfter: statusColor,
        ),
        // Tạm ẩn: Dự kiến hoàn thành, Tốc độ tích lũy, Tốc độ yêu cầu
        // const SizedBox(height: 6),
        // _buildCompareRow(
        //   colors,
        //   'Dự kiến hoàn thành:',
        //   dateBefore,
        //   dateAfter,
        //   subtitleBefore: diffBefore,
        //   subtitleAfter: diffAfter,
        // ),
        // const SizedBox(height: 6),
        // _buildCompareRow(
        //   colors,
        //   'Tốc độ tích lũy:',
        //   '${_formatMoneyShort(rateBefore)}/th',
        //   '${_formatMoneyShort(rateAfter)}/th',
        // ),
        // const SizedBox(height: 6),
        // _buildCompareRow(
        //   colors,
        //   'Tốc độ yêu cầu:',
        //   '${_formatMoneyShort(reqBefore)}/th',
        //   '${_formatMoneyShort(reqAfter)}/th',
        //   valueColorAfter: reqAfter > reqBefore ? AppColors.error : AppColors.success,
        // ),
      ],
    );
  }

  Widget _buildCompareRow(
    AppThemeColors colors,
    String label,
    String before,
    String after, {
    Color? valueColorAfter,
    String? subtitleBefore,
    String? subtitleAfter,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              flex: 5,
              child: Text(
                label,
                style: TextStyle(fontSize: 11.5, color: colors.textSecondary),
              ),
            ),
            Expanded(
              flex: 7,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        before,
                        style: TextStyle(
                          fontSize: 11,
                          color: colors.textMuted,
                          decoration: TextDecoration.lineThrough,
                        ),
                      ),
                      if (subtitleBefore != null)
                        Text(
                          subtitleBefore,
                          style: TextStyle(fontSize: 9, color: colors.textMuted),
                        ),
                    ],
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 6),
                    child: Icon(Icons.arrow_forward_rounded, size: 10, color: Colors.grey),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        after,
                        style: TextStyle(
                          fontSize: 11.5,
                          fontWeight: FontWeight.bold,
                          color: valueColorAfter ?? colors.textPrimary,
                        ),
                      ),
                      if (subtitleAfter != null)
                        Text(
                          subtitleAfter,
                          style: TextStyle(
                            fontSize: 9,
                            fontWeight: FontWeight.bold,
                            color: valueColorAfter ?? colors.textSecondary,
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  String _goalStatusText(dynamic status) {
    switch (status?.toString()) {
      case 'completed': return 'Đã xong';
      case 'on_track': return 'Đúng hạn';
      case 'slightly_at_risk': return 'Rủi ro nhẹ';
      case 'at_risk': return 'Rủi ro';
      case 'off_track': return 'Trễ hạn';
      case 'overdue': return 'Quá hạn';
      case 'unlikely': return 'Khó đạt';
      case 'tracking': return 'Theo dõi';
      default: return status?.toString() ?? 'Chưa rõ';
    }
  }

  Color _statusColor(dynamic status) {
    switch (status?.toString()) {
      case 'completed': return AppColors.success;
      case 'on_track': return AppColors.primary;
      case 'slightly_at_risk': return AppColors.warning;
      case 'at_risk': return AppColors.secondaryOrange;
      case 'off_track':
      case 'overdue':
      case 'unlikely':
        return AppColors.error;
      default:
        return AppColors.primary;
    }
  }

  String _goalDifferenceText(dynamic diffVal) {
    if (diffVal == null) return 'Đúng hạn';
    final diff = (diffVal as num).toInt();
    if (diff == 999) return 'Trễ vô hạn';
    if (diff > 0) return 'trễ $diff ngày';
    if (diff < 0) return 'sớm ${diff.abs()} ngày';
    return 'đúng hạn';
  }

  String _formatDate(String? dateStr) {
    if (dateStr == null || dateStr.isEmpty) return '';
    try {
      final date = DateTime.parse(dateStr);
      return "${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year.toString().substring(2)}";
    } catch (_) {
      return dateStr;
    }
  }

  String _formatMoneyShort(double amount) {
    if (amount >= 1000000) {
      double value = amount / 1000000;
      return "${value.toStringAsFixed(value == value.toInt() ? 0 : 1)}M";
    } else if (amount >= 1000) {
      double value = amount / 1000;
      return "${value.toStringAsFixed(value == value.toInt() ? 0 : 1)}k";
    }
    return amount.toInt().toString();
  }
}
