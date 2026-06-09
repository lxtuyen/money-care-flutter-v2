import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:money_care/core/constants/colors.dart';
import 'package:money_care/core/theme/app_theme_colors.dart';
import 'package:money_care/core/utils/helper/helper_functions.dart';
import 'package:money_care/features/spending_plan/presentation/controllers/spending_plan_controller.dart';
import 'package:money_care/app/controllers/statistics_controller.dart';
import 'package:money_care/app/controllers/app_controller.dart';
import 'package:money_care/features/spending_plan/domain/entities/spending_plan_entity.dart';
import 'package:money_care/features/spending_plan/domain/entities/spending_plan_request.dart';
import 'package:money_care/features/ai_feedback/data/models/ai_feedback_dto.dart';
import 'package:money_care/app/widgets/text_field/app_currency_form_field.dart';
import 'package:money_care/app/widgets/button/primary_button.dart';

enum StagedAction { applied, removed }

class StagedChange {
  final StagedAction action;
  final double? customAmount;

  StagedChange({required this.action, this.customAmount});
}

class BudgetRecommendationBubble extends StatefulWidget {
  final Map<String, dynamic> metadata;

  const BudgetRecommendationBubble({super.key, required this.metadata});

  @override
  State<BudgetRecommendationBubble> createState() => _BudgetRecommendationBubbleState();
}

class _BudgetRecommendationBubbleState extends State<BudgetRecommendationBubble> {
  final Map<int, StagedChange> _stagedChanges = {};
  bool _isSaving = false;

  void stageApply(Map<String, dynamic> item) {
    final categoryId = item['categoryId'] as int?;
    if (categoryId == null) return;
    setState(() {
      _stagedChanges[categoryId] = StagedChange(
        action: StagedAction.applied,
      );
    });
  }

  void stageRemove(Map<String, dynamic> item) {
    final categoryId = item['categoryId'] as int?;
    if (categoryId == null) return;
    setState(() {
      _stagedChanges[categoryId] = StagedChange(
        action: StagedAction.removed,
      );
    });
  }

  void stageModify(Map<String, dynamic> item, double customAmount) {
    final categoryId = item['categoryId'] as int?;
    if (categoryId == null) return;
    setState(() {
      _stagedChanges[categoryId] = StagedChange(
        action: StagedAction.applied,
        customAmount: customAmount,
      );
    });
  }

  void undoStage(int categoryId) {
    setState(() {
      _stagedChanges.remove(categoryId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppThemeColors.of(context);
    final double expectedSavings =
        (widget.metadata['expectedSavingsAmount'] as num?)?.toDouble() ?? 0;
    final List<dynamic> items = widget.metadata['items'] as List<dynamic>? ?? [];
    final SpendingPlanController? spendingPlanCtrl =
        Get.isRegistered<SpendingPlanController>()
            ? Get.find<SpendingPlanController>()
            : null;
    if (spendingPlanCtrl != null) {
      _ensureActivePlanLoaded(spendingPlanCtrl);
    }

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
                  Icon(
                    Icons.auto_awesome_rounded,
                    size: 20,
                    color: Colors.white,
                  ),
                  SizedBox(width: 10),
                  Text(
                    'Đề xuất ngân sách',
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
                  _buildSavingsMetrics(
                    context,
                    spendingPlanCtrl,
                    expectedSavings,
                    items,
                  ),
                  const SizedBox(height: 8),
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
                    ...items.map(
                      (item) => _RecommendationItemCard(
                        item: Map<String, dynamic>.from(item),
                        parentState: this,
                      ),
                    ),

                  // Batch save button at the bottom
                  if (_stagedChanges.isNotEmpty) ...[
                    const SizedBox(height: 16),
                    const Divider(height: 1, thickness: 0.8),
                    const SizedBox(height: 16),
                    PrimaryButton(
                      label: 'Lưu thay đổi (${_stagedChanges.length})',
                      onPressed: _commitStagedChanges,
                      isLoading: _isSaving,
                      icon: const Icon(Icons.save_rounded, size: 16),
                      height: 48,
                      fontSize: 13,
                      borderRadius: 12,
                      elevation: 2,
                    ),
                  ],
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
    String savingsValue,
    String spendValue,
    Color savingsColor,
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
            fontWeight: FontWeight.w600,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 6),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'T.kiệm:',
              style: TextStyle(fontSize: 9.5, color: colors.textMuted),
            ),
            const SizedBox(width: 4),
            Expanded(
              child: Text(
                savingsValue,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: savingsColor,
                ),
                textAlign: TextAlign.end,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        const SizedBox(height: 3),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Tổng chi:',
              style: TextStyle(fontSize: 9.5, color: colors.textMuted),
            ),
            const SizedBox(width: 4),
            Expanded(
              child: Text(
                spendValue,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: colors.textPrimary,
                ),
                textAlign: TextAlign.end,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSavingsMetrics(
    BuildContext context,
    SpendingPlanController? spendingPlanCtrl,
    double fallbackExpectedSavings,
    List<dynamic> items,
  ) {
    final double recommendedTotalBudget =
        (widget.metadata['recommended_total_budget'] as num?)?.toDouble() ?? 0;
    
    // Fallback calculation taking staged changes into account
    final Map<int, double> recommendedLimitsMap = {};
    for (var item in items) {
      if (item is Map && item['categoryId'] != null) {
        recommendedLimitsMap[item['categoryId'] as int] =
            (item['recommendedLimitAmount'] as num).toDouble();
      }
    }

    // 1. Proposed Total Budget Fallback with staged changes
    double fallbackProposedTotal = 0;
    if (recommendedTotalBudget > 0) {
      fallbackProposedTotal = recommendedTotalBudget;
      for (var item in items) {
        if (item is Map && item['categoryId'] != null) {
          final cid = item['categoryId'] as int;
          final recAmount = (item['recommendedLimitAmount'] as num).toDouble();
          if (_stagedChanges.containsKey(cid)) {
            final stage = _stagedChanges[cid]!;
            if (stage.action == StagedAction.applied && stage.customAmount != null) {
              fallbackProposedTotal += (stage.customAmount! - recAmount);
            } else if (stage.action == StagedAction.removed) {
              fallbackProposedTotal -= recAmount;
            }
          }
        }
      }
    }

    // 2. Forecasted Spend Fallback with staged changes
    final double fallbackForecastSpend = items.fold<double>(0.0, (sum, item) {
      if (item is! Map) return sum;
      final cid = item['categoryId'] as int?;
      if (cid != null && _stagedChanges.containsKey(cid) && _stagedChanges[cid]!.action == StagedAction.removed) {
        return sum;
      }
      return sum + ((item['predictedSpendAmount'] as num?)?.toDouble() ?? 0.0);
    });

    if (spendingPlanCtrl == null) {
      return IntrinsicHeight(
        child: Row(
          children: [
            Expanded(
              child: _buildMetricTile(
                context,
                'Theo đề xuất',
                AppHelperFunction.formatAmount(fallbackExpectedSavings),
                fallbackProposedTotal > 0
                    ? AppHelperFunction.formatAmount(fallbackProposedTotal)
                    : 'Chưa tính',
                AppColors.primary,
              ),
            ),
            _buildMetricDivider(context),
            Expanded(
              child: _buildMetricTile(
                context,
                'Theo dự báo',
                AppHelperFunction.formatAmount(fallbackExpectedSavings),
                fallbackForecastSpend > 0
                    ? AppHelperFunction.formatAmount(fallbackForecastSpend)
                    : 'Chưa tính',
                AppColors.info,
              ),
            ),
          ],
        ),
      );
    }

    return Obx(() {
      final activePlan = spendingPlanCtrl.activePlan.value;
      final plannedIncome = activePlan?.totalAmount ?? 0;
      final estimatedExpenses = activePlan?.estimatedExpenses ?? [];

      final proposedSpend = _proposedSpendAmount(
        estimatedExpenses: estimatedExpenses,
        items: items,
        stagedChanges: _stagedChanges,
      );
      final forecastSpend = _forecastSpendAmount(
        estimatedExpenses: estimatedExpenses,
        items: items,
        stagedChanges: _stagedChanges,
      );

      final proposedSavings = _proposedSavingsAmount(
        plannedIncome: plannedIncome,
        proposedSpend: proposedSpend,
        fallback: fallbackExpectedSavings,
      );
      final forecastSavings = _forecastSavingsAmount(
        plannedIncome: plannedIncome,
        forecastSpend: forecastSpend,
        fallback: fallbackExpectedSavings,
      );

      return IntrinsicHeight(
        child: Row(
          children: [
            Expanded(
              child: _buildMetricTile(
                context,
                'Theo đề xuất',
                AppHelperFunction.formatAmount(proposedSavings),
                AppHelperFunction.formatAmount(proposedSpend),
                AppColors.primary,
              ),
            ),
            _buildMetricDivider(context),
            Expanded(
              child: _buildMetricTile(
                context,
                'Theo dự báo',
                AppHelperFunction.formatAmount(forecastSavings),
                AppHelperFunction.formatAmount(forecastSpend),
                AppColors.info,
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildMetricDivider(BuildContext context) {
    final colors = AppThemeColors.of(context);
    return VerticalDivider(
      width: 16,
      thickness: 0.8,
      color: colors.textMuted.withValues(alpha: 0.2),
    );
  }

  double _proposedSpendAmount({
    required List<EstimatedExpenseEntity> estimatedExpenses,
    required List<dynamic> items,
    required Map<int, StagedChange> stagedChanges,
  }) {
    final Map<int, double> recommendedLimits = {};
    for (var item in items) {
      if (item is Map && item['categoryId'] != null) {
        recommendedLimits[item['categoryId'] as int] =
            (item['recommendedLimitAmount'] as num).toDouble();
      }
    }

    double total = 0.0;
    final Set<int> existingCategories = {};

    for (var expense in estimatedExpenses) {
      final categoryId = expense.categoryId;
      if (categoryId == null) continue;
      existingCategories.add(categoryId);
      final currentLimit = expense.monthlyLimit > 0
          ? expense.monthlyLimit
          : expense.amount;

      if (stagedChanges.containsKey(categoryId)) {
        final stage = stagedChanges[categoryId]!;
        if (stage.action == StagedAction.applied) {
          total += stage.customAmount ?? recommendedLimits[categoryId] ?? currentLimit;
        } else if (stage.action == StagedAction.removed) {
          total += 0;
        }
      } else {
        if (recommendedLimits.containsKey(categoryId)) {
          total += recommendedLimits[categoryId]!;
        } else {
          total += currentLimit;
        }
      }
    }

    // For new recommended items staged as applied
    for (var item in items) {
      if (item is Map && item['categoryId'] != null) {
        final categoryId = item['categoryId'] as int;
        if (!existingCategories.contains(categoryId)) {
          if (stagedChanges.containsKey(categoryId)) {
            final stage = stagedChanges[categoryId]!;
            if (stage.action == StagedAction.applied) {
              total += stage.customAmount ?? recommendedLimits[categoryId] ?? 0.0;
            }
          }
        }
      }
    }

    return total;
  }

  double _forecastSpendAmount({
    required List<EstimatedExpenseEntity> estimatedExpenses,
    required List<dynamic> items,
    required Map<int, StagedChange> stagedChanges,
  }) {
    final Map<int, double> forecasts = {};
    for (var item in items) {
      if (item is Map && item['categoryId'] != null) {
        forecasts[item['categoryId'] as int] =
            (item['predictedSpendAmount'] as num).toDouble();
      }
    }

    double total = 0.0;
    final Set<int> existingCategories = {};

    for (var expense in estimatedExpenses) {
      final categoryId = expense.categoryId;
      if (categoryId == null) continue;
      existingCategories.add(categoryId);
      final currentLimit = expense.monthlyLimit > 0
          ? expense.monthlyLimit
          : expense.amount;

      if (stagedChanges.containsKey(categoryId)) {
        final stage = stagedChanges[categoryId]!;
        if (stage.action == StagedAction.applied) {
          if (forecasts.containsKey(categoryId)) {
            total += forecasts[categoryId]!;
          } else {
            total += stage.customAmount ?? currentLimit;
          }
        } else if (stage.action == StagedAction.removed) {
          total += 0;
        }
      } else {
        if (forecasts.containsKey(categoryId)) {
          total += forecasts[categoryId]!;
        } else {
          total += currentLimit;
        }
      }
    }

    // For new recommended items staged as applied
    for (var item in items) {
      if (item is Map && item['categoryId'] != null) {
        final categoryId = item['categoryId'] as int;
        if (!existingCategories.contains(categoryId)) {
          if (stagedChanges.containsKey(categoryId)) {
            final stage = stagedChanges[categoryId]!;
            if (stage.action == StagedAction.applied) {
              total += forecasts[categoryId] ?? 0.0;
            }
          }
        }
      }
    }

    return total;
  }

  double _proposedSavingsAmount({
    required double plannedIncome,
    required double proposedSpend,
    required double fallback,
  }) {
    if (plannedIncome <= 0) return fallback;
    return (plannedIncome - proposedSpend)
        .clamp(0.0, double.infinity)
        .toDouble();
  }

  double _forecastSavingsAmount({
    required double plannedIncome,
    required double forecastSpend,
    required double fallback,
  }) {
    if (plannedIncome <= 0) return fallback;
    return (plannedIncome - forecastSpend)
        .clamp(0.0, double.infinity)
        .toDouble();
  }

  void _ensureActivePlanLoaded(SpendingPlanController controller) {
    if (controller.activePlan.value != null) return;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (controller.activePlan.value != null) return;
      controller.loadActivePlan();
    });
  }

  String _uniqueRecId(Map<String, dynamic> item) {
    final originalRecId = item['recommendationId']?.toString() ?? '';
    return '${originalRecId}_${widget.metadata.hashCode}';
  }

  Future<void> _sendFeedback(
    Map<String, dynamic> item,
    String action, {
    double? finalLimitAmount,
  }) async {
    final recommendationId = item['recommendationId']?.toString() ?? '';
    final uniqueRecId = _uniqueRecId(item);
    final statsCtrl = Get.find<StatisticsController>();

    if (statsCtrl.submittedFeedbackIds.contains(uniqueRecId) ||
        statsCtrl.sendingFeedbackIds.contains(uniqueRecId)) {
      return;
    }

    statsCtrl.sendingFeedbackIds.add(uniqueRecId);
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
            'riskLevel': item['riskAfter'] ?? item['riskLevel'],
          },
        ),
      );
      statsCtrl.submittedFeedbackIds.add(uniqueRecId);
      AppHelperFunction.showSuccessSnackBar('Đã ghi nhận phản hồi AI');
    } catch (e) {
      AppHelperFunction.showErrorSnackBar('Không thể gửi phản hồi AI: $e');
    } finally {
      statsCtrl.sendingFeedbackIds.remove(uniqueRecId);
    }
  }

  /// Resolve the plan expense ID from the active plan by category ID.
  int? _resolvePlanItemId(int? originalId, int? categoryId) {
    if (originalId != null) return originalId;
    if (categoryId == null) return null;
    final planCtrl = Get.isRegistered<SpendingPlanController>()
        ? Get.find<SpendingPlanController>()
        : null;
    if (planCtrl == null) return null;
    final activePlan = planCtrl.activePlan.value;
    if (activePlan == null) return null;
    final expense = activePlan.estimatedExpenses.firstWhereOrNull(
      (e) => e.categoryId == categoryId,
    );
    return expense?.id;
  }

  Future<void> _commitStagedChanges() async {
    final planCtrl = Get.isRegistered<SpendingPlanController>()
        ? Get.find<SpendingPlanController>()
        : null;
    final statsCtrl = Get.isRegistered<StatisticsController>()
        ? Get.find<StatisticsController>()
        : null;
    final appCtrl = Get.isRegistered<AppController>()
        ? Get.find<AppController>()
        : null;

    if (planCtrl == null || statsCtrl == null || appCtrl == null) {
      AppHelperFunction.showErrorSnackBar('Không tìm thấy controller cần thiết');
      return;
    }

    setState(() {
      _isSaving = true;
    });

    final List<dynamic> items = widget.metadata['items'] as List<dynamic>? ?? [];
    int successCount = 0;
    int failCount = 0;
    final List<int> succeededKeys = [];

    for (var entry in _stagedChanges.entries) {
      final categoryId = entry.key;
      final stage = entry.value;

      final item = items.firstWhereOrNull((i) => i is Map && i['categoryId'] == categoryId);
      if (item == null) continue;

      final planId = item['planId'] as int?;
      if (planId == null) {
        failCount++;
        continue;
      }

      final resolvedItemId = _resolvePlanItemId(
        item['planItemId'] as int?,
        categoryId,
      );

      bool success = false;

      if (stage.action == StagedAction.applied) {
        final recommendedAmount = stage.customAmount ?? (item['recommendedLimitAmount'] as num).toDouble();
        final request = CreateEstimatedExpenseRequest(
          categoryId: categoryId,
          amount: recommendedAmount,
          monthlyLimit: recommendedAmount,
          frequencyType: 'monthly',
          frequencyValue: 1,
        );

        if (resolvedItemId != null) {
          success = await planCtrl.updatePlanExpense(
            planId,
            resolvedItemId,
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
          successCount++;
          succeededKeys.add(categoryId);
          await _sendFeedback(
            item,
            stage.customAmount != null ? 'modified' : 'accepted',
            finalLimitAmount: recommendedAmount,
          );
        } else {
          failCount++;
        }
      } else if (stage.action == StagedAction.removed) {
        if (resolvedItemId != null) {
          success = await planCtrl.removePlanExpense(planId, resolvedItemId);
        } else {
          success = true;
        }

        if (success) {
          successCount++;
          succeededKeys.add(categoryId);
          await _sendFeedback(item, 'rejected');
        } else {
          failCount++;
        }
      }
    }

    // Refresh active plan and stats once
    await planCtrl.loadActivePlan();
    final userId = appCtrl.userId.value;
    if (userId != null) {
      await statsCtrl.refreshStatisticsData(userId);
    }

    setState(() {
      _isSaving = false;
      for (var key in succeededKeys) {
        _stagedChanges.remove(key);
      }

      if (successCount > 0 && failCount == 0) {
        AppHelperFunction.showSuccessSnackBar('Đã lưu thành công các thay đổi');
      } else if (successCount > 0 && failCount > 0) {
        AppHelperFunction.showWarningSnackBar(
          'Đã lưu $successCount thay đổi thành công, thất bại $failCount',
        );
      } else if (failCount > 0) {
        AppHelperFunction.showErrorSnackBar('Lưu thay đổi thất bại');
      }
    });
  }

  Future<void> _showModifySheet(
    BuildContext context,
    Map<String, dynamic> item,
  ) async {
    double initialVal = (item['recommendedLimitAmount'] as num).toDouble();
    final categoryId = item['categoryId'] as int?;
    
    // Check if there is already a staged custom amount
    if (categoryId != null && _stagedChanges.containsKey(categoryId)) {
      final stage = _stagedChanges[categoryId]!;
      if (stage.action == StagedAction.applied && stage.customAmount != null) {
        initialVal = stage.customAmount!;
      }
    } else {
      // Otherwise fall back to plan limit or AI recommendation
      final planCtrl = Get.isRegistered<SpendingPlanController>()
          ? Get.find<SpendingPlanController>()
          : null;
      if (planCtrl != null && categoryId != null) {
        final activePlan = planCtrl.activePlan.value;
        if (activePlan != null) {
          final expense = activePlan.estimatedExpenses.firstWhereOrNull(
            (e) => e.categoryId == categoryId,
          );
          if (expense != null) {
            final planLimit = expense.monthlyLimit > 0
                ? expense.monthlyLimit
                : expense.amount;
            if (planLimit > 0) initialVal = planLimit;
          }
        }
      }
    }

    final amountController = TextEditingController(
      text: initialVal.round().toString(),
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
              AppCurrencyFormField(
                controller: amountController,
                label: 'Hạn mức dự kiến',
                icon: Icons.attach_money_rounded,
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
                    child: PrimaryButton(
                      label: 'Lưu',
                      onPressed: () {
                        final amount = double.tryParse(
                          AppHelperFunction.unformatCurrency(
                            amountController.text,
                          ),
                        );
                        if (amount == null || amount <= 0) {
                          AppHelperFunction.showErrorSnackBar(
                            'Vui lòng nhập số tiền hợp lệ',
                          );
                          return;
                        }
                        Get.back<double>(result: amount);
                      },
                      height: 45,
                      fontSize: 14,
                      borderRadius: 12,
                      elevation: 0,
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

    Future.delayed(const Duration(milliseconds: 350), () {
      amountController.dispose();
    });

    if (customAmount != null) {
      stageModify(item, customAmount);
    }
  }
}

class _RecommendationItemCard extends StatelessWidget {
  final Map<String, dynamic> item;
  final _BudgetRecommendationBubbleState parentState;

  const _RecommendationItemCard({
    required this.item,
    required this.parentState,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppThemeColors.of(context);
    final statsCtrl = Get.find<StatisticsController>();
    final planCtrl = Get.isRegistered<SpendingPlanController>()
        ? Get.find<SpendingPlanController>()
        : null;

    final originalRecId = item['recommendationId']?.toString() ?? '';
    final uniqueRecId = '${originalRecId}_${parentState.widget.metadata.hashCode}';

    final categoryId = item['categoryId'] as int?;
    final recommendedLimit =
        (item['recommendedLimitAmount'] as num?)?.toDouble() ?? 0;
    final predictedSpend =
        (item['predictedSpendAmount'] as num?)?.toDouble() ?? 0;
    final canApply = item['canApply'] as bool? ?? false;

    return Obx(() {
      final isSubmitted = statsCtrl.submittedFeedbackIds.contains(uniqueRecId);
      final isSending = statsCtrl.sendingFeedbackIds.contains(uniqueRecId);

      double currentLimit =
          (item['currentLimitAmount'] as num?)?.toDouble() ?? 0;
      if (planCtrl != null) {
        final activePlan = planCtrl.activePlan.value;
        if (activePlan != null && categoryId != null) {
          final expense = activePlan.estimatedExpenses.firstWhereOrNull(
            (e) => e.categoryId == categoryId,
          );
          if (expense != null) {
            currentLimit = expense.monthlyLimit > 0
                ? expense.monthlyLimit
                : expense.amount;
          }
        }
      }

      // Check staged status
      final stagedChange = categoryId != null ? parentState._stagedChanges[categoryId] : null;
      final isStaged = stagedChange != null;

      double displayLimit = currentLimit;
      if (isStaged && stagedChange.action == StagedAction.applied) {
        displayLimit = stagedChange.customAmount ?? recommendedLimit;
      }

      final isSameLimit = displayLimit == recommendedLimit;
      final isStagedRemoved = isStaged && stagedChange.action == StagedAction.removed;

      return Opacity(
        opacity: isStagedRemoved ? 0.55 : 1.0,
        child: Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: colors.surfaceBackground,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isStagedRemoved
                  ? AppColors.error.withValues(alpha: 0.3)
                  : isStaged
                      ? AppColors.primary.withValues(alpha: 0.3)
                      : colors.borderSecondary,
              width: isStaged ? 1.5 : 1.0,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Row 1: Title (Category Name), Risk/Staged Badge, and X/Undo Button
              Row(
                children: [
                  Expanded(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Flexible(
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
                        if (isStaged) ...[
                          const SizedBox(width: 8),
                          _buildStagedBadge(context, stagedChange.action),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  // Close/X button / Undo button
                  if (isStaged)
                    InkWell(
                      onTap: () {
                        if (categoryId != null) {
                          parentState.undoStage(categoryId);
                        }
                      },
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: AppColors.info.withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.undo_rounded,
                          size: 14,
                          color: AppColors.info,
                        ),
                      ),
                    )
                  else
                    InkWell(
                      onTap: isSending
                          ? null
                          : () {
                              parentState.stageRemove(item);
                            },
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
                      stagedValue: (isStaged && stagedChange.action == StagedAction.applied && currentLimit != displayLimit)
                          ? AppHelperFunction.formatAmount(displayLimit)
                          : null,
                      isStrikethrough: isStagedRemoved,
                      color: isStagedRemoved ? colors.textMuted : null,
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
                  if (!isSameLimit)
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
              if (isStagedRemoved) ...[
                // No action buttons when staged for removal
              ] else if (isStaged && stagedChange.action == StagedAction.applied) ...[
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    OutlinedButton(
                      onPressed: isSending
                          ? null
                          : () => parentState._showModifySheet(context, item),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: colors.textPrimary,
                        side: BorderSide(color: colors.borderSecondary),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                        minimumSize: const Size(64, 28),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.edit_rounded, size: 12),
                          SizedBox(width: 4),
                          Text(
                            'Sửa',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ] else if (isSubmitted) ...[
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.check_circle_outline_rounded,
                            color: AppColors.primary,
                            size: 12,
                          ),
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
                    const SizedBox(width: 8),
                    OutlinedButton(
                      onPressed: isSending
                          ? null
                          : () => parentState._showModifySheet(context, item),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: colors.textPrimary,
                        side: BorderSide(color: colors.borderSecondary),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                        minimumSize: const Size(64, 28),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.edit_rounded, size: 12),
                          SizedBox(width: 4),
                          Text(
                            'Sửa',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
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
                    if (isSameLimit)
                      PrimaryButton(
                        label: 'Sửa',
                        onPressed: isSending
                            ? null
                            : () => parentState._showModifySheet(context, item),
                        icon: const Icon(Icons.edit_rounded, size: 12),
                        height: 28,
                        width: 64,
                        fontSize: 11,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                      )
                    else
                      OutlinedButton(
                        onPressed: isSending
                            ? null
                            : () => parentState._showModifySheet(context, item),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: colors.textPrimary,
                          side: BorderSide(color: colors.borderSecondary),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 6,
                          ),
                          minimumSize: const Size(64, 28),
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.edit_rounded, size: 12),
                            SizedBox(width: 4),
                            Text(
                              'Sửa',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    if (!isSameLimit) ...[
                      const SizedBox(width: 8),
                      PrimaryButton(
                        label: 'Áp dụng',
                        onPressed: isSending
                            ? null
                            : () => parentState.stageApply(item),
                        icon: const Icon(Icons.check_rounded, size: 12),
                        height: 28,
                        width: 64,
                        fontSize: 11,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ],
          ),
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
    String? stagedValue,
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
        if (stagedValue != null) ...[
          Text(
            value,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w500,
              color: colors.textMuted,
              decoration: TextDecoration.lineThrough,
            ),
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 1),
          Text(
            stagedValue,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ] else
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

  Widget _buildStagedBadge(BuildContext context, StagedAction action) {
    final isApplied = action == StagedAction.applied;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: isApplied
            ? AppColors.primary.withValues(alpha: 0.15)
            : AppColors.error.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isApplied ? Icons.hourglass_empty_rounded : Icons.remove_circle_outline_rounded,
            color: isApplied ? AppColors.primary : AppColors.error,
            size: 10,
          ),
          const SizedBox(width: 2),
          Text(
            isApplied ? 'Chờ áp dụng' : 'Sẽ bị xóa',
            style: TextStyle(
              fontSize: 9,
              color: isApplied ? AppColors.primary : AppColors.error,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
