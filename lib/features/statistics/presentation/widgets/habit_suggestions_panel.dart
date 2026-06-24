import 'package:flutter/material.dart';
import 'package:money_care/core/constants/colors.dart';
import 'package:money_care/core/theme/app_theme_colors.dart';
import 'package:money_care/core/utils/helper/helper_functions.dart';
import 'package:money_care/features/statistics/data/models/analytics_model.dart';

class HabitSuggestionsPanel extends StatefulWidget {
  final List<HabitSuggestionModel> habits;

  const HabitSuggestionsPanel({super.key, required this.habits});

  @override
  State<HabitSuggestionsPanel> createState() => _HabitSuggestionsPanelState();
}

class _HabitSuggestionsPanelState extends State<HabitSuggestionsPanel> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    if (widget.habits.isEmpty) return const SizedBox.shrink();

    final showAll = _expanded || widget.habits.length <= 3;
    final displayItems = showAll ? widget.habits : widget.habits.take(3).toList();

    final totalSavings = widget.habits.fold<double>(
      0.0,
      (sum, h) => sum + h.potentialSavings,
    );

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.04),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.15),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.lightbulb_outline_rounded,
                color: AppColors.primary,
                size: 18,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'G\u1EE3i \u00FD ti\u1EBFt ki\u1EC7m',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w700,
                      ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...displayItems.map((habit) => _buildHabitCard(context, habit)),
          if (widget.habits.length > 3)
            GestureDetector(
              onTap: () => setState(() => _expanded = !_expanded),
              child: Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Center(
                  child: Text(
                    _expanded
                        ? 'Thu g\u1ECDn'
                        : 'Xem th\u00EAm ${widget.habits.length - 3} th\u00F3i quen',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                ),
              ),
            ),
          const SizedBox(height: 8),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
            decoration: BoxDecoration(
              color: AppColors.income.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.savings_outlined,
                  color: AppColors.income,
                  size: 16,
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    'T\u1ED5ng ti\u1EBFt ki\u1EC7m d\u1EF1 ki\u1EBFn: ${AppHelperFunction.formatAmount(totalSavings)}/th\u00E1ng',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: AppColors.income,
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHabitCard(BuildContext context, HabitSuggestionModel habit) {
    final themeColors = AppThemeColors.of(context);
    final progress = habit.projectedMonthCount > 0
        ? habit.currentMonthCount / habit.projectedMonthCount
        : 0.0;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: themeColors.surfaceBackground,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: themeColors.borderSecondary.withValues(alpha: 0.5),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header: habit name + category
            Row(
              children: [
                Text(
                  _habitEmoji(habit.habitName),
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    habit.habitName,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: themeColors.textPrimary,
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: themeColors.textMuted.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    habit.categoryName,
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: themeColors.textSecondary,
                          fontSize: 9,
                        ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            // Current month stats
            Text(
              'Th\u00E1ng n\u00E0y: ${habit.currentMonthCount} l\u1EA7n \u00B7 ${AppHelperFunction.formatAmount(habit.currentMonthTotal)}',
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: themeColors.textSecondary,
                  ),
            ),
            const SizedBox(height: 6),
            // Progress bar
            Row(
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: progress.clamp(0.0, 1.0),
                      minHeight: 6,
                      backgroundColor:
                          themeColors.textMuted.withValues(alpha: 0.1),
                      valueColor: AlwaysStoppedAnimation<Color>(
                        progress >= 0.8
                            ? AppColors.expense
                            : AppColors.primary,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  '${habit.currentMonthCount}/${habit.projectedMonthCount} l\u1EA7n',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: themeColors.textSecondary,
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            // Suggestion
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
              decoration: BoxDecoration(
                color: AppColors.income.withValues(alpha: 0.06),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('\uD83D\uDCB0 ', style: TextStyle(fontSize: 12)),
                  Expanded(
                    child: Text(
                      'Gi\u1EA3m xu\u1ED1ng ${habit.suggestedCount} l\u1EA7n \u2192 ti\u1EBFt ki\u1EC7m ~${AppHelperFunction.formatAmount(habit.potentialSavings)}',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: AppColors.income,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                  ),
                ],
              ),
            ),
            if (habit.isEarlyEstimate)
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Row(
                  children: [
                    Icon(
                      Icons.schedule_rounded,
                      size: 10,
                      color: themeColors.textMuted,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '(\u01B0\u1EDBc t\u00EDnh s\u1EDBm)',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: themeColors.textMuted,
                            fontSize: 9,
                            fontStyle: FontStyle.italic,
                          ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  String _habitEmoji(String habitName) {
    final lower = habitName.toLowerCase();
    if (lower.contains('cafe') || lower.contains('c\u00E0 ph\u00EA')) {
      return '\u2615';
    }
    if (lower.contains('tr\u00E0 s\u1EEFa')) return '\uD83E\uDDCB';
    if (lower.contains('online') || lower.contains('\u0111\u1ED3 \u0103n')) {
      return '\uD83C\uDF54';
    }
    if (lower.contains('\u0103n v\u1EB7t')) return '\uD83C\uDF6A';
    return '\uD83D\uDCB8';
  }
}
