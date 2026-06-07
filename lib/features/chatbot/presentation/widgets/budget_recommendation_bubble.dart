import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:money_care/core/constants/colors.dart';
import 'package:money_care/core/theme/app_theme_colors.dart';
import 'package:money_care/core/utils/helper/helper_functions.dart';
import 'package:money_care/features/spending_plan/presentation/controllers/spending_plan_controller.dart';
import 'package:money_care/app/controllers/statistics_controller.dart';
import 'package:money_care/app/controllers/app_controller.dart';
import 'package:money_care/features/spending_plan/domain/entities/spending_plan_request.dart';
import 'package:money_care/features/ai_feedback/data/models/ai_feedback_dto.dart';

class BudgetRecommendationBubble extends StatelessWidget {
  final Map<String, dynamic> metadata;

  const BudgetRecommendationBubble({super.key, required this.metadata});

  @override
  Widget build(BuildContext context) {
    final colors = AppThemeColors.of(context);
    final String summary = metadata['summary'] ?? 'Đề xuất điều chỉnh ngân sách từ AI.';
    final double recommendedTotal = (metadata['recommendedTotalBudget'] as num?)?.toDouble() ?? 0;
    final double expectedSavings = (metadata['expectedSavingsAmount'] as num?)?.toDouble() ?? 0;
    final double confidence = (metadata['confidence'] as num?)?.toDouble() ?? 0.5;
    final List<dynamic> items = metadata['items'] as List<dynamic>? ?? [];

    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.88,
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
                  Icon(Icons.auto_awesome_rounded, size: 20, color: Colors.white),
                  SizedBox(width: 10),
                  Text(
                    'Đề xuất ngân sách thông minh',
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
                  // Summary from AI
                  Text(
                    summary,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: colors.textPrimary,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 14),

                  // Overall metrics row
                  IntrinsicHeight(
                    child: Row(
                      children: [
                        Expanded(
                          child: _buildMetricTile(
                            context,
                            'Tổng ngân sách',
                            AppHelperFunction.formatAmount(recommendedTotal),
                            AppColors.success,
                          ),
                        ),
                        VerticalDivider(
                          width: 16,
                          thickness: 0.8,
                          color: colors.textMuted.withValues(alpha: 0.2),
                        ),
                        Expanded(
                          child: _buildMetricTile(
                            context,
                            'Tiết kiệm kỳ vọng',
                            AppHelperFunction.formatAmount(expectedSavings),
                            AppColors.info,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Confidence score bar
                  Row(
                    children: [
                      Text(
                        'Độ tin cậy của đề xuất:',
                        style: TextStyle(
                          fontSize: 10.5,
                          color: colors.textSecondary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        '${(confidence * 100).round()}%',
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: AppColors.success,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(3),
                    child: LinearProgressIndicator(
                      value: confidence,
                      minHeight: 5,
                      backgroundColor: Colors.grey.shade100,
                      valueColor: const AlwaysStoppedAnimation<Color>(AppColors.success),
                    ),
                  ),

                  const Divider(height: 24, thickness: 0.8),

                  // Recommendation Items
                  if (items.isEmpty)
                    Text(
                      'Không có danh mục nào cần điều chỉnh ngân sách.',
                      style: TextStyle(
                        fontSize: 12,
                        fontStyle: FontStyle.italic,
                        color: colors.textSecondary,
                      ),
                    )
                  else
                    ...items.map((item) => _RecommendationItemCard(
                          item: Map<String, dynamic>.from(item),
                          parent: this,
                        )),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricTile(
    BuildContext context,
    String label,
    String value,
    Color color,
  ) {
    final colors = AppThemeColors.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            color: colors.textSecondary,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }

  Future<void> _sendFeedback(
    Map<String, dynamic> item,
    String action, {
    double? finalLimitAmount,
  }) async {
    final recommendationId = item['recommendationId']?.toString() ?? '';
    final statsCtrl = Get.find<StatisticsController>();

    if (statsCtrl.submittedFeedbackIds.contains(recommendationId) ||
        statsCtrl.sendingFeedbackIds.contains(recommendationId)) {
      return;
    }

    statsCtrl.sendingFeedbackIds.add(recommendationId);
    try {
      await statsCtrl.sendAiFeedbackUseCase(
        AiFeedbackDto(
          recommendationType: 'budget',
          recommendationId: recommendationId,
          sourceModel: 'personalized_budget_optimizer',
          sourceModelVersion: 'v2',
          userAction: action,
          sourcePayload: {
            'categoryName': item['categoryName'],
            'currentLimitAmount': item['currentLimitAmount'],
            'recommendedLimitAmount': item['recommendedLimitAmount'],
            'predictedSpendAmount': item['predictedSpendAmount'],
            'spentAmount': item['spentAmount'],
            'confidence': item['confidence'],
            'reason': item['explanation'] ?? item['reason'],
            'actionType': item['actionType'],
            'riskBefore': item['riskBefore'],
            'riskAfter': item['riskAfter'],
            'elasticity': item['elasticity'],
            'reasonCodes': item['reasonCodes'] != null
                ? List<String>.from(item['reasonCodes'])
                : <String>[],
          },
          modifiedPayload: finalLimitAmount == null
              ? null
              : {'finalLimitAmount': finalLimitAmount},
          contextPayload: {
            'screen': 'chatbot',
            'entryPoint': 'budget_recommendation_bubble',
            'riskLevel': item['riskAfter'] ?? item['riskLevel']
          },
        ),
      );
      statsCtrl.submittedFeedbackIds.add(recommendationId);
      AppHelperFunction.showSuccessSnackBar('Đã ghi nhận phản hồi AI');
    } catch (e) {
      AppHelperFunction.showErrorSnackBar('Không thể gửi phản hồi AI: $e');
    } finally {
      statsCtrl.sendingFeedbackIds.remove(recommendationId);
    }
  }

  Future<void> _applyRecommendation(
    Map<String, dynamic> item, {
    double? customAmount,
  }) async {
    final planId = item['planId'] as int?;
    final planItemId = item['planItemId'] as int?;
    final categoryId = item['categoryId'] as int?;
    final recommendedAmount = customAmount ?? (item['recommendedLimitAmount'] as num).toDouble();

    if (planId == null || categoryId == null) {
      AppHelperFunction.showErrorSnackBar('Không đủ thông tin định danh để áp dụng');
      return;
    }

    final planCtrl = Get.find<SpendingPlanController>();
    final statsCtrl = Get.find<StatisticsController>();
    final appCtrl = Get.find<AppController>();

    final request = CreateEstimatedExpenseRequest(
      categoryId: categoryId,
      amount: recommendedAmount,
      frequencyType: 'monthly',
      frequencyValue: 1,
    );

    bool success = false;
    if (planItemId != null) {
      success = await planCtrl.updatePlanExpense(
        planId,
        planItemId,
        request,
        showSuccessMessage: false,
      );
    } else {
      success = await planCtrl.addPlanExpense(
        planId,
        request,
        showSuccessMessage: false,
      );
    }

    if (success) {
      AppHelperFunction.showSuccessSnackBar(
        customAmount != null
            ? 'Đã cập nhật hạn mức ${item['categoryName']} thành ${AppHelperFunction.formatAmount(customAmount)}'
            : 'Đã áp dụng hạn mức đề xuất cho ${item['categoryName']}',
      );

      await _sendFeedback(
        item,
        customAmount != null ? 'modified' : 'accepted',
        finalLimitAmount: recommendedAmount,
      );

      await planCtrl.loadActivePlan();
      final userId = appCtrl.userId.value;
      if (userId != null) {
        await statsCtrl.refreshStatisticsData(userId);
      }
    }
  }

  Future<void> _showModifySheet(
    BuildContext context,
    Map<String, dynamic> item,
  ) async {
    final recommendedVal = (item['recommendedLimitAmount'] as num).toDouble();
    final amountController = TextEditingController(
      text: recommendedVal.round().toString(),
    );
    final colors = AppThemeColors.of(context);

    final customAmount = await Get.bottomSheet<double>(
      SafeArea(
        child: Container(
          padding: const EdgeInsets.fromLTRB(18, 16, 18, 18),
          decoration: BoxDecoration(
            color: colors.dialogBackground,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Sửa đề xuất ngân sách: ${item['categoryName']}',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: colors.textPrimary,
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: amountController,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                style: TextStyle(color: colors.textPrimary),
                decoration: InputDecoration(
                  labelText: 'Hạn mức mong muốn',
                  labelStyle: TextStyle(color: colors.textSecondary),
                  suffixText: 'VND',
                  suffixStyle: TextStyle(color: colors.textSecondary),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: colors.borderSecondary),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: colors.borderPrimary),
                  ),
                  border: const OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Get.back<double>(),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: colors.textPrimary,
                        side: BorderSide(color: colors.borderSecondary),
                      ),
                      child: const Text('Hủy'),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        final amount = double.tryParse(amountController.text);
                        if (amount == null || amount <= 0) {
                          AppHelperFunction.showErrorSnackBar(
                            'Vui lòng nhập số tiền hợp lệ',
                          );
                          return;
                        }
                        Get.back<double>(result: amount);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('Áp dụng hạn mức'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      isScrollControlled: true,
      backgroundColor: colors.dialogBackground,
    );

    amountController.dispose();

    if (customAmount != null) {
      await _applyRecommendation(item, customAmount: customAmount);
    }
  }
}

class _RecommendationItemCard extends StatelessWidget {
  final Map<String, dynamic> item;
  final BudgetRecommendationBubble parent;

  const _RecommendationItemCard({required this.item, required this.parent});

  @override
  Widget build(BuildContext context) {
    final colors = AppThemeColors.of(context);
    final statsCtrl = Get.find<StatisticsController>();
    final recommendationId = item['recommendationId']?.toString() ?? '';

    final currentLimit = (item['currentLimitAmount'] as num?)?.toDouble() ?? 0;
    final recommendedLimit = (item['recommendedLimitAmount'] as num?)?.toDouble() ?? 0;
    final predictedSpend = (item['predictedSpendAmount'] as num?)?.toDouble() ?? 0;

    final canApply = item['canApply'] as bool? ?? false;

    return Obx(() {
      final isSubmitted = statsCtrl.submittedFeedbackIds.contains(recommendationId);
      final isSending = statsCtrl.sendingFeedbackIds.contains(recommendationId);

      return Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: colors.surfaceBackground,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: colors.borderSecondary),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Row 1: Title (Category Name), Risk Badge, and X Button
            Row(
              children: [
                Expanded(
                  child: Text(
                    item['categoryName'] ?? '',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: colors.textPrimary,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (!isSubmitted) ...[
                  const SizedBox(width: 8),
                  // Close/X button (replaces "Không hợp" / "Bỏ qua đề xuất")
                  InkWell(
                    onTap: isSending
                        ? null
                        : () => parent._sendFeedback(item, 'rejected'),
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: colors.textMuted.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.close_rounded,
                        size: 14,
                        color: AppColors.error,
                      ),
                    ),
                  ),
                ],
              ],
            ),
            const SizedBox(height: 10),

            // Row 2: Comparison metrics
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: _buildCompactVal(
                    context,
                    'Hiện tại',
                    currentLimit > 0
                        ? AppHelperFunction.formatAmount(currentLimit)
                        : 'Chưa đặt',
                    isStrikethrough: currentLimit > 0 && currentLimit != recommendedLimit,
                  ),
                ),
                Expanded(
                  child: _buildCompactVal(
                    context,
                    'Dự báo',
                    AppHelperFunction.formatAmount(predictedSpend),
                    color: AppColors.expense,
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildCompactVal(
                        context,
                        'Đề xuất',
                        AppHelperFunction.formatAmount(recommendedLimit),
                        color: AppColors.primary,
                        isBold: true,
                      ),
                    ],
                  ),
                ),
              ],
            ),

            // Row 3: Action Buttons / Warnings / Status
            if (isSubmitted) ...[
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.check_circle_outline_rounded, color: AppColors.primary, size: 12),
                        SizedBox(width: 4),
                        Text(
                          'Đã áp dụng',
                          style: TextStyle(
                            fontSize: 10,
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ] else if (!canApply) ...[
              const SizedBox(height: 8),
              Text(
                'Vui lòng tạo kế hoạch chi tiêu trước',
                style: TextStyle(
                  fontSize: 10,
                  fontStyle: FontStyle.italic,
                  color: colors.textMuted,
                ),
              ),
            ] else ...[
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  // Sửa button
                  OutlinedButton(
                    onPressed: isSending
                        ? null
                        : () => parent._showModifySheet(context, item),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: colors.textPrimary,
                      side: BorderSide(color: colors.borderSecondary),
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      minimumSize: const Size(64, 28),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: const Text(
                      'Sửa',
                      style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
                    ),
                  ),
                  const SizedBox(width: 8),
                  // Áp dụng button
                  ElevatedButton(
                    onPressed: isSending
                        ? null
                        : () => parent._applyRecommendation(item),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      minimumSize: const Size(64, 28),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: const Text(
                      'Áp dụng',
                      style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      );
    });
  }

  Widget _buildCompactVal(
    BuildContext context,
    String label,
    String value, {
    Color? color,
    bool isBold = false,
    bool isStrikethrough = false,
  }) {
    final colors = AppThemeColors.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 9.5, color: colors.textSecondary),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: TextStyle(
            fontSize: 11,
            fontWeight: isBold ? FontWeight.bold : FontWeight.w600,
            color: color ?? colors.textPrimary,
            decoration: isStrikethrough ? TextDecoration.lineThrough : null,
          ),
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}
