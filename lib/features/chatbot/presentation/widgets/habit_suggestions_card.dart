import 'package:flutter/material.dart';
import 'package:money_care/core/constants/colors.dart';
import 'package:get/get.dart';
import 'package:money_care/core/utils/helper/helper_functions.dart';
import 'package:money_care/features/chatbot/data/models/chatbot_expense_analysis_model.dart';
import 'package:money_care/features/chatbot/presentation/widgets/expense_analysis_components.dart';
import 'package:money_care/features/habit_commitments/domain/entities/habit_commitment_entity.dart';
import 'package:money_care/features/habit_commitments/domain/repositories/habit_commitment_repository.dart';

/// Card hiển thị gợi ý cắt giảm chi tiêu dựa trên thói quen.
class HabitSuggestionsCard extends StatefulWidget {
  final List<ChatbotHabitSuggestionModel> suggestions;
  final double? shortfall;
  final int? goalId;
  final ValueChanged<double>? onCommitted;

  const HabitSuggestionsCard({
    super.key,
    required this.suggestions,
    this.shortfall,
    this.goalId,
    this.onCommitted,
  });

  @override
  State<HabitSuggestionsCard> createState() => _HabitSuggestionsCardState();
}

class _HabitSuggestionsCardState extends State<HabitSuggestionsCard> {
  /// Map habitName → commitment entity (đã cam kết)
  final Map<String, HabitCommitmentEntity> _commitments = {};

  /// Set habitName đang loading
  final Set<String> _loading = {};

  @override
  void initState() {
    super.initState();
    _loadExistingCommitments();
  }

  Future<void> _loadExistingCommitments() async {
    try {
      final repo = Get.find<HabitCommitmentRepository>();
      final now = DateTime.now();
      final progress = await repo.getProgress(
        month: now.month,
        year: now.year,
      );
      if (!mounted) return;
      setState(() {
        for (final c in progress) {
          _commitments[c.habitName] = c;
        }
      });
    } catch (_) {
      // Silently fail — commitments are optional
    }
  }

  Future<void> _commit(ChatbotHabitSuggestionModel suggestion) async {
    final repo = Get.find<HabitCommitmentRepository>();
    final now = DateTime.now();

    setState(() => _loading.add(suggestion.habitName));
    try {
      final result = await repo.create(
        habitName: suggestion.habitName,
        subcategoryName: suggestion.habitName,
        committedCount: suggestion.suggestedCount,
        potentialSavings: suggestion.potentialSavings,
        avgPerTransaction: suggestion.avgPerTransaction,
        projectedCount: suggestion.projectedMonthCount,
        month: now.month,
        year: now.year,
        goalId: widget.goalId,
      );
      if (!mounted) return;
      // Reload progress to get currentCount
      final progress = await repo.getProgress(
        month: now.month,
        year: now.year,
      );
      if (!mounted) return;
      setState(() {
        _loading.remove(suggestion.habitName);
        for (final c in progress) {
          _commitments[c.habitName] = c;
        }
      });
      widget.onCommitted?.call(suggestion.potentialSavings);
    } catch (e) {
      if (!mounted) return;
      setState(() => _loading.remove(suggestion.habitName));
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.suggestions.isEmpty) return const SizedBox.shrink();

    final totalSavings = widget.suggestions.fold<double>(
      0,
      (sum, s) => sum + s.potentialSavings,
    );
    final remaining = widget.shortfall != null
        ? (widget.shortfall! - totalSavings).clamp(0.0, double.infinity)
        : 0.0;
    final coversAll =
        widget.shortfall == null || totalSavings >= widget.shortfall!;

    return ExpenseAnalysisCardShell(
      title: 'Gợi ý cắt giảm',
      accentColor: Colors.amber.shade600,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Total potential savings + shortfall coverage
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: coversAll
                  ? Colors.green.withValues(alpha: 0.08)
                  : Colors.orange.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Flexible(
                      child: Text(
                        'Có thể tiết kiệm ~${AppHelperFunction.formatAmount(totalSavings)}',
                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),
                if (!coversAll && remaining > 0) ...[
                  const SizedBox(height: 4),
                  Text(
                    'Còn thiếu ${AppHelperFunction.formatAmount(remaining)} — cần điều chỉnh thêm chi tiêu hoặc gia hạn mục tiêu',
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.red.shade400,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 10),
          // Suggestion items
          ...widget.suggestions.map(
            (s) => _HabitSuggestionRow(
              suggestion: s,
              commitment: _commitments[s.habitName],
              isLoading: _loading.contains(s.habitName),
              onCommit: () => _commit(s),
            ),
          ),
        ],
      ),
    );
  }
}

class _HabitSuggestionRow extends StatelessWidget {
  final ChatbotHabitSuggestionModel suggestion;
  final HabitCommitmentEntity? commitment;
  final bool isLoading;
  final VoidCallback onCommit;

  const _HabitSuggestionRow({
    required this.suggestion,
    this.commitment,
    this.isLoading = false,
    required this.onCommit,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isCommitted = commitment != null;

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: isDark
              ? Colors.white.withValues(alpha: 0.04)
              : Colors.grey.withValues(alpha: 0.06),
          borderRadius: BorderRadius.circular(10),
          border: isCommitted
              ? Border.all(
                  color: Colors.green.withValues(alpha: 0.3),
                  width: 0.5,
                )
              : null,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Row 1: habit name + savings badge
            Row(
              children: [
                Expanded(
                  child: Text(
                    suggestion.habitName,
                    style: TextStyle(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w600,
                      color: isDark ? Colors.white : Colors.black87,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 2,
                  ),
                  child: Text(
                    '-${AppHelperFunction.formatAmount(suggestion.potentialSavings)}/lần',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),

            // Line 1: "Đã chi X lần • Dự báo Y lần/tháng"
            Text(
              'Đã chi ${suggestion.currentMonthCount} lần • Dự báo ${suggestion.projectedMonthCount} lần/tháng',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: isDark ? Colors.white70 : Colors.grey.shade700,
              ),
            ),
            const SizedBox(height: 3),

            // Line 2: "Đề xuất giảm còn Z lần"
            Text(
              '- Đề xuất giảm còn ${suggestion.suggestedCount} lần',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: isDark ? Colors.white54 : Colors.grey.shade600,
              ),
            ),

            // Progress bar (if committed)
            if (isCommitted) ...[
              const SizedBox(height: 6),
              _buildProgressRow(isDark),
            ],

            // Commit button
            const SizedBox(height: 8),
            _buildCommitButton(isDark),

            if (suggestion.isEarlyEstimate) ...[
              const SizedBox(height: 4),
              Text(
                'Ước tính sớm - dữ liệu sẽ chính xác hơn cuối tháng',
                style: TextStyle(
                  fontSize: 10,
                  fontStyle: FontStyle.italic,
                  color: isDark ? Colors.white30 : Colors.grey.shade400,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildCommitButton(bool isDark) {
    if (isLoading) {
      return const Center(
        child: SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
      );
    }

    if (commitment != null) {
      // Đã cam kết — hiện status
      final c = commitment!;
      final color = c.isExceeded ? Colors.red : Colors.green;
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: color.withValues(alpha: 0.2),
            width: 0.5,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              c.isExceeded
                  ? Icons.warning_amber_rounded
                  : Icons.check_circle_rounded,
              size: 14,
              color: color.shade600,
            ),
            const SizedBox(width: 6),
            Text(
              c.isExceeded
                  ? 'Đã vượt cam kết! (${c.currentCount}/${c.committedCount} lần)'
                  : 'Đang cam kết: ${c.currentCount}/${c.committedCount} lần — còn ${c.remaining} lần',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: color.shade700,
              ),
            ),
          ],
        ),
      );
    }

    // Chưa cam kết — hiện nút full width
    return GestureDetector(
      onTap: onCommit,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
        decoration: BoxDecoration(
          color: AppColors.primary.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: AppColors.primary.withValues(alpha: 0.4),
            width: 0.5,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Xác nhận',
              style: TextStyle(
                fontSize: 11.5,
                fontWeight: FontWeight.w600,
                color: AppColors.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressRow(bool isDark) {
    final c = commitment!;
    final progress = c.progressPercent;
    final color = c.isExceeded ? Colors.red : Colors.green;

    return ClipRRect(
      borderRadius: BorderRadius.circular(4),
      child: LinearProgressIndicator(
        value: progress,
        minHeight: 4,
        backgroundColor: isDark
            ? Colors.white.withValues(alpha: 0.08)
            : Colors.grey.withValues(alpha: 0.15),
        valueColor: AlwaysStoppedAnimation<Color>(
          color.withValues(alpha: 0.7),
        ),
      ),
    );
  }
}
