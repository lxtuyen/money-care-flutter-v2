import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:money_care/app/widgets/button/app_outline_button.dart';
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
import 'package:money_care/features/chatbot/presentation/widgets/recommendation_item_card.dart';
import 'package:money_care/features/chatbot/presentation/widgets/budget_recommendation_metrics.dart';

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
  State<BudgetRecommendationBubble> createState() =>
      _BudgetRecommendationBubbleState();
}

class _BudgetRecommendationBubbleState
    extends State<BudgetRecommendationBubble> {
  final Map<int, StagedChange> _stagedChanges = {};
  bool _isSaving = false;

  void stageApply(Map<String, dynamic> item) {
    final categoryId = item['categoryId'] as int?;
    if (categoryId == null) return;
    setState(() {
      _stagedChanges[categoryId] = StagedChange(action: StagedAction.applied);
    });
  }

  void stageRemove(Map<String, dynamic> item) {
    final categoryId = item['categoryId'] as int?;
    if (categoryId == null) return;
    setState(() {
      _stagedChanges[categoryId] = StagedChange(action: StagedAction.removed);
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
    final List<dynamic> items =
        widget.metadata['items'] as List<dynamic>? ?? [];
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
                    ...items.map((item) {
                      final Map<String, dynamic> itemMap =
                          Map<String, dynamic>.from(item);
                      final categoryId = itemMap['categoryId'] as int?;
                      return RecommendationItemCard(
                        item: itemMap,
                        proposalHashCode: widget.metadata.hashCode,
                        stagedChange: categoryId != null
                            ? _stagedChanges[categoryId]
                            : null,
                        onUndoStage: () {
                          if (categoryId != null) undoStage(categoryId);
                        },
                        onStageRemove: () => stageRemove(itemMap),
                        onStageApply: () => stageApply(itemMap),
                        onShowModifySheet: (context) =>
                            _showModifySheet(context, itemMap),
                      );
                    }),

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
            if (stage.action == StagedAction.applied &&
                stage.customAmount != null) {
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
      if (cid != null &&
          _stagedChanges.containsKey(cid) &&
          _stagedChanges[cid]!.action == StagedAction.removed) {
        return sum;
      }
      return sum + ((item['predictedSpendAmount'] as num?)?.toDouble() ?? 0.0);
    });

    if (spendingPlanCtrl == null) {
      return BudgetRecommendationMetrics(
        proposedSavings: fallbackExpectedSavings,
        proposedSpend: fallbackProposedTotal,
        forecastSavings: fallbackExpectedSavings,
        forecastSpend: fallbackForecastSpend,
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

      return BudgetRecommendationMetrics(
        proposedSavings: proposedSavings,
        proposedSpend: proposedSpend,
        forecastSavings: forecastSavings,
        forecastSpend: forecastSpend,
      );
    });
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
          total +=
              stage.customAmount ??
              recommendedLimits[categoryId] ??
              currentLimit;
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

    for (var item in items) {
      if (item is Map && item['categoryId'] != null) {
        final categoryId = item['categoryId'] as int;
        if (!existingCategories.contains(categoryId)) {
          if (stagedChanges.containsKey(categoryId)) {
            final stage = stagedChanges[categoryId]!;
            if (stage.action == StagedAction.applied) {
              total +=
                  stage.customAmount ?? recommendedLimits[categoryId] ?? 0.0;
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
      AppHelperFunction.showErrorSnackBar(
        'Không tìm thấy controller cần thiết',
      );
      return;
    }

    setState(() {
      _isSaving = true;
    });

    final List<dynamic> items =
        widget.metadata['items'] as List<dynamic>? ?? [];
    int successCount = 0;
    int failCount = 0;
    final List<int> succeededKeys = [];

    for (var entry in _stagedChanges.entries) {
      final categoryId = entry.key;
      final stage = entry.value;

      final item = items.firstWhereOrNull(
        (i) => i is Map && i['categoryId'] == categoryId,
      );
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
        final recommendedAmount =
            stage.customAmount ??
            (item['recommendedLimitAmount'] as num).toDouble();
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
                    child: AppOutlineButton(
                      label: '',
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
