import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:money_care/core/constants/colors.dart';
import 'package:money_care/core/theme/app_theme_colors.dart';
import 'package:money_care/core/utils/helper/helper_functions.dart';
import 'package:money_care/features/habit_commitments/domain/entities/habit_commitment_entity.dart';
import 'package:money_care/features/habit_commitments/domain/repositories/habit_commitment_repository.dart';

/// Section hiển thị danh sách cam kết hiện tại của 1 goal.
/// Cho phép sửa số lần bằng +/- và xóa cam kết.
class GoalCommitmentsSection extends StatefulWidget {
  final int? goalId;

  /// Callback khi tổng savings thay đổi (dương = tăng, âm = giảm)
  final ValueChanged<double>? onSavingsChanged;

  const GoalCommitmentsSection({
    super.key,
    this.goalId,
    this.onSavingsChanged,
  });

  @override
  State<GoalCommitmentsSection> createState() => GoalCommitmentsSectionState();
}

class GoalCommitmentsSectionState extends State<GoalCommitmentsSection> {
  List<HabitCommitmentEntity> _commitments = [];
  bool _loading = true;
  final Set<int> _updating = {};

  @override
  void initState() {
    super.initState();
    _load();
  }

  /// Public method cho parent gọi reload khi có cam kết mới.
  Future<void> reload() => _load();

  Future<void> _load() async {
    try {
      final repo = Get.find<HabitCommitmentRepository>();
      final now = DateTime.now();
      final all = await repo.getProgress(month: now.month, year: now.year);
      if (!mounted) return;
      setState(() {
        _commitments = widget.goalId != null
            ? all.where((c) => c.goalId == widget.goalId).toList()
            : all;
        _loading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() => _loading = false);
    }
  }

  Future<void> _updateCount(HabitCommitmentEntity item, int newCount) async {
    if (newCount < 1) return;
    final repo = Get.find<HabitCommitmentRepository>();
    setState(() => _updating.add(item.id));
    try {
      await repo.update(item.id, committedCount: newCount);
      if (!mounted) return;

      // Reload data first
      await _load();

      // Calculate savings delta and notify parent AFTER load
      final oldSavings = item.potentialSavings;
      final avgPerTx = item.avgPerTransaction;
      final projected = item.projectedCount;
      final newReduced = (projected - newCount).clamp(0, projected);
      final newSavings = newReduced * avgPerTx;
      final delta = newSavings - oldSavings;
      widget.onSavingsChanged?.call(delta);
    } catch (e) {
      debugPrint('[GoalCommitmentsSection] update error: $e');
    } finally {
      if (mounted) {
        setState(() => _updating.remove(item.id));
      }
    }
  }

  Future<void> _delete(HabitCommitmentEntity item) async {
    final repo = Get.find<HabitCommitmentRepository>();
    setState(() => _updating.add(item.id));
    try {
      await repo.delete(item.id);
      // Removing commitment = losing that savings
      widget.onSavingsChanged?.call(-item.potentialSavings);
      await _load();
    } catch (_) {
      if (!mounted) return;
      setState(() => _updating.remove(item.id));
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) return const SizedBox.shrink();
    if (_commitments.isEmpty) return const SizedBox.shrink();

    final colors = AppThemeColors.of(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colors.cardBackground,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: colors.borderSecondary),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.checklist_rounded,
                  size: 16, color: AppColors.primary),
              const SizedBox(width: 6),
              Text(
                'Cam kết hiện tại',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: colors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ...List.generate(_commitments.length, (i) {
            final item = _commitments[i];
            final isLast = i == _commitments.length - 1;
            return _buildItem(item, colors, isLast);
          }),
        ],
      ),
    );
  }

  Widget _buildItem(
    HabitCommitmentEntity item,
    AppThemeColors colors,
    bool isLast,
  ) {
    final isUpdating = _updating.contains(item.id);
    final progress = item.progressPercent;
    final progressColor =
        item.isExceeded ? AppColors.expense : AppColors.primary;

    return Opacity(
      opacity: isUpdating ? 0.5 : 1.0,
      child: Column(
        children: [
          // Header: name + count
          Row(
            children: [
              Expanded(
                child: Text(
                  item.habitName,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: colors.textPrimary,
                  ),
                ),
              ),
              Text(
                '${item.currentCount}/${item.committedCount} lần',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: item.isExceeded ? AppColors.expense : AppColors.income,
                ),
              ),
              if (item.isExceeded)
                Padding(
                  padding: const EdgeInsets.only(left: 4),
                  child: Icon(Icons.warning_amber_rounded,
                      size: 14, color: AppColors.expense),
                ),
            ],
          ),
          const SizedBox(height: 6),

          // Progress bar
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progress.clamp(0.0, 1.0),
              minHeight: 5,
              backgroundColor: progressColor.withValues(alpha: 0.12),
              valueColor: AlwaysStoppedAnimation(progressColor),
            ),
          ),
          const SizedBox(height: 8),

          // Stepper + delete
          Builder(builder: (_) {
            final canDecrease = item.committedCount > item.currentCount
                && item.committedCount > 1;
            final canIncrease = item.projectedCount > 0
                ? item.committedCount < item.projectedCount
                : true;
            return Row(
            children: [
              Text(
                'Cam kết:',
                style: TextStyle(
                  fontSize: 11,
                  color: colors.textSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(width: 8),

              _stepperButton(
                icon: Icons.remove,
                onTap: isUpdating || !canDecrease
                    ? null
                    : () => _updateCount(item, item.committedCount - 1),
                enabled: canDecrease && !isUpdating,
                colors: colors,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  '${item.committedCount}',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: colors.textPrimary,
                  ),
                ),
              ),
              _stepperButton(
                icon: Icons.add,
                onTap: isUpdating || !canIncrease
                    ? null
                    : () => _updateCount(item, item.committedCount + 1),
                enabled: canIncrease && !isUpdating,
                colors: colors,
              ),
              const Spacer(),
              Text(
                '~${AppHelperFunction.formatAmount(item.potentialSavings, currency: '')} đ',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: AppColors.income,
                ),
              ),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: isUpdating ? null : () => _confirmDelete(item),
                child: Icon(
                  Icons.delete_outline_rounded,
                  size: 18,
                  color: isUpdating
                      ? colors.textSecondary
                      : AppColors.expense,
                ),
              ),
            ],
          );
          }),
          if (!isLast)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Divider(height: 1, color: colors.borderSecondary),
            ),
          if (isLast) const SizedBox(height: 4),
        ],
      ),
    );
  }

  Widget _stepperButton({
    required IconData icon,
    required VoidCallback? onTap,
    required bool enabled,
    required AppThemeColors colors,
  }) {
    final color = enabled ? AppColors.primary : colors.textSecondary;
    return GestureDetector(
      onTap: enabled ? onTap : null,
      child: Container(
        width: 26,
        height: 26,
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: color.withValues(alpha: 0.3)),
        ),
        child: Icon(icon, size: 14, color: color),
      ),
    );
  }

  void _confirmDelete(HabitCommitmentEntity item) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Hủy cam kết'),
        content: Text('Bạn muốn hủy cam kết "${item.habitName}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Không'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              _delete(item);
            },
            child: const Text('Hủy cam kết',
                style: TextStyle(color: AppColors.expense)),
          ),
        ],
      ),
    );
  }
}
