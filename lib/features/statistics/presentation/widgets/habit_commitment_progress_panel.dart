import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:money_care/core/constants/colors.dart';
import 'package:money_care/core/theme/app_theme_colors.dart';
import 'package:money_care/features/habit_commitments/domain/entities/habit_commitment_entity.dart';
import 'package:money_care/features/habit_commitments/domain/repositories/habit_commitment_repository.dart';

/// Panel hiển thị tiến độ cam kết giảm thói quen trong tháng.
class HabitCommitmentProgressPanel extends StatefulWidget {
  const HabitCommitmentProgressPanel({super.key});

  @override
  State<HabitCommitmentProgressPanel> createState() =>
      _HabitCommitmentProgressPanelState();
}

class _HabitCommitmentProgressPanelState
    extends State<HabitCommitmentProgressPanel> {
  List<HabitCommitmentEntity> _commitments = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final repo = Get.find<HabitCommitmentRepository>();
      final now = DateTime.now();
      final data = await repo.getProgress(month: now.month, year: now.year);
      if (!mounted) return;
      setState(() {
        _commitments = data;
        _loading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) return const SizedBox.shrink();
    if (_commitments.isEmpty) return const SizedBox.shrink();

    final themeColors = AppThemeColors.of(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: themeColors.cardBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.borderSecondary),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
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
              Icon(
                Icons.handshake_outlined,
                size: 16,
                color: Colors.amber.shade700,
              ),
              const SizedBox(width: 6),
              Text(
                'Cam kết giảm chi tiêu',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: themeColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ..._commitments.map((c) => _CommitmentRow(commitment: c)),
        ],
      ),
    );
  }
}

class _CommitmentRow extends StatelessWidget {
  final HabitCommitmentEntity commitment;

  const _CommitmentRow({required this.commitment});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final progress = commitment.progressPercent;
    final color = commitment.isExceeded ? Colors.red : Colors.green;

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  commitment.habitName,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  '${commitment.currentCount}/${commitment.committedCount} lần',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: color.shade600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          ClipRRect(
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
          ),
          const SizedBox(height: 2),
          Text(
            commitment.isExceeded
                ? 'Đã vượt cam kết!'
                : commitment.remaining == 0
                    ? 'Đã đạt giới hạn cam kết'
                    : 'Còn ${commitment.remaining} lần trong tháng',
            style: TextStyle(
              fontSize: 10,
              color: commitment.isExceeded
                  ? Colors.red.shade400
                  : (isDark ? Colors.white54 : Colors.grey.shade600),
            ),
          ),
        ],
      ),
    );
  }
}
