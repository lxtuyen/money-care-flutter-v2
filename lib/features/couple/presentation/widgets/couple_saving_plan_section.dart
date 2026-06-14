import 'package:flutter/material.dart';
import 'package:money_care/core/utils/helper/helper_functions.dart';
import 'package:money_care/features/couple/domain/entities/couple_saving_goal_entity.dart';

/// Displays a monthly contribution plan breakdown for a couple saving goal.
///
/// Shows:
/// - Total required monthly saving
/// - Months remaining until deadline
/// - Per-member breakdown with current month progress bars
/// - Status badges (on track / needs more / exceeded)
class CoupleSavingPlanSection extends StatelessWidget {
  final CoupleSavingGoalEntity goal;

  const CoupleSavingPlanSection({super.key, required this.goal});

  @override
  Widget build(BuildContext context) {
    // Don't show for completed goals
    if (goal.status == 'completed' || goal.savedAmount >= goal.target) {
      return const SizedBox.shrink();
    }

    // No endDate → show a gentle prompt
    if (goal.endDate == null) {
      return _buildNoDeadlineHint();
    }

    final now = DateTime.now();
    final nowLocal = now.toLocal();
    final endLocal = goal.endDate!.toLocal();
    final today = DateTime(nowLocal.year, nowLocal.month, nowLocal.day);
    final deadline = DateTime(endLocal.year, endLocal.month, endLocal.day);

    // Deadline already passed
    if (deadline.isBefore(today)) {
      return _buildOverdueWarning();
    }

    final monthsRemaining = _calcMonthsRemaining(nowLocal, endLocal);

    final remainingAmount = (goal.target - goal.savedAmount).clamp(0.0, goal.target);
    final monthlyRequired = remainingAmount / monthsRemaining;
    final memberCount = goal.memberContributions.length.clamp(1, 100);
    final perPersonMonthly = monthlyRequired / memberCount;

    // Contributions this month per member
    final currentMonthContribs = _getCurrentMonthContributions(now);

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.blue.withValues(alpha: 0.04),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.blue.withValues(alpha: 0.12)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader(),
          const SizedBox(height: 12),
          _buildMetricRow(monthlyRequired, monthsRemaining),
          const SizedBox(height: 14),
          _buildMemberPlanList(perPersonMonthly, currentMonthContribs),
        ],
      ),
    );
  }

  // ──────────────── Header ────────────────

  Widget _buildSectionHeader() {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: Colors.blue.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(
            Icons.event_note_rounded,
            size: 16,
            color: Colors.blue,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          'KẾ HOẠCH ĐÓNG GÓP',
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.bold,
            color: Colors.grey[500],
            letterSpacing: 1.2,
          ),
        ),
      ],
    );
  }

  // ──────────────── Metric Row ────────────────

  Widget _buildMetricRow(double monthlyRequired, int monthsRemaining) {
    return Row(
      children: [
        Expanded(
          child: _MetricCard(
            icon: Icons.savings_outlined,
            label: 'Cần/tháng',
            value: AppHelperFunction.formatAmount(monthlyRequired),
            color: Colors.blue,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _MetricCard(
            icon: Icons.timer_outlined,
            label: 'Còn lại',
            value: '$monthsRemaining tháng',
            color: Colors.orange,
          ),
        ),
      ],
    );
  }

  // ──────────────── Member Plan List ────────────────

  Widget _buildMemberPlanList(
    double perPersonMonthly,
    Map<int, double> currentMonthContribs,
  ) {
    return Column(
      children: goal.memberContributions.map((member) {
        final contributed = currentMonthContribs[member.userId] ?? 0.0;
        final progress = perPersonMonthly > 0
            ? (contributed / perPersonMonthly).clamp(0.0, 2.0)
            : 0.0;
        final progressPercent = (progress * 100).toInt();
        final status = _getMemberStatus(progress);

        return Padding(
          padding: const EdgeInsets.only(top: 10),
          child: _MemberPlanTile(
            name: member.fullName,
            perPersonMonthly: perPersonMonthly,
            contributed: contributed,
            progress: progress,
            progressPercent: progressPercent,
            status: status,
          ),
        );
      }).toList(),
    );
  }

  // ──────────────── No Deadline Hint ────────────────

  Widget _buildNoDeadlineHint() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.amber.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.amber.withValues(alpha: 0.15)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: Colors.amber.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.lightbulb_outline_rounded,
              size: 16,
              color: Colors.amber,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'Đặt hạn chót để xem kế hoạch đóng góp hàng tháng chi tiết.',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
                height: 1.3,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ──────────────── Overdue Warning ────────────────

  Widget _buildOverdueWarning() {
    final remaining = goal.target - goal.savedAmount;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.red.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.red.withValues(alpha: 0.15)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: Colors.red.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.warning_amber_rounded,
              size: 16,
              color: Colors.red,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Đã quá hạn chót!',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Còn thiếu ${AppHelperFunction.formatAmount(remaining)} để đạt mục tiêu. '
                  'Hãy gia hạn hoặc tăng tốc đóng góp.',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ──────────────── Helpers ────────────────

  /// Returns the number of full months from [from] to [to], minimum 1.
  int _calcMonthsRemaining(DateTime from, DateTime to) {
    final months = (to.year - from.year) * 12 + (to.month - from.month);
    // If we're past the day in the target month, count one less
    int remaining = months;
    if (from.day > to.day) {
      remaining--;
    }
    return remaining.clamp(1, 9999);
  }

  /// Aggregates contributions made in the current calendar month per member.
  Map<int, double> _getCurrentMonthContributions(DateTime now) {
    final result = <int, double>{};
    for (final c in goal.contributions) {
      if (c.createdAt.year == now.year && c.createdAt.month == now.month) {
        result[c.userId] = (result[c.userId] ?? 0.0) + c.amount;
      }
    }
    return result;
  }

  _MemberStatus _getMemberStatus(double progress) {
    if (progress >= 1.0) {
      return _MemberStatus.exceeded;
    } else if (progress >= 0.7) {
      return _MemberStatus.onTrack;
    } else {
      return _MemberStatus.needsMore;
    }
  }
}

// ──────────────── Sub-widgets ────────────────

enum _MemberStatus { exceeded, onTrack, needsMore }

class _MemberPlanTile extends StatelessWidget {
  final String name;
  final double perPersonMonthly;
  final double contributed;
  final double progress;
  final int progressPercent;
  final _MemberStatus status;

  const _MemberPlanTile({
    required this.name,
    required this.perPersonMonthly,
    required this.contributed,
    required this.progress,
    required this.progressPercent,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    final statusInfo = _statusInfo(status);

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Name + Status badge
          Row(
            children: [
              CircleAvatar(
                radius: 12,
                backgroundColor: statusInfo.color.withValues(alpha: 0.1),
                child: Text(
                  name.isNotEmpty ? name[0].toUpperCase() : 'U',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: statusInfo.color,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  name,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 3,
                ),
                decoration: BoxDecoration(
                  color: statusInfo.color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  statusInfo.label,
                  style: TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.bold,
                    color: statusInfo.color,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          // Amount info
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Cần: ${AppHelperFunction.formatAmount(perPersonMonthly)}/th',
                style: TextStyle(fontSize: 11, color: Colors.grey[500]),
              ),
              Text(
                'Đã đóng: ${AppHelperFunction.formatAmount(contributed)}',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: statusInfo.color,
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          // Progress bar + percentage
          Row(
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: LinearProgressIndicator(
                    value: progress.clamp(0.0, 1.0),
                    minHeight: 6,
                    backgroundColor: Colors.grey[100],
                    valueColor: AlwaysStoppedAnimation<Color>(statusInfo.color),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '$progressPercent%',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: statusInfo.color,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  ({String label, Color color}) _statusInfo(_MemberStatus status) {
    return switch (status) {
      _MemberStatus.exceeded => (
        label: '✨ Vượt mục tiêu',
        color: Colors.green,
      ),
      _MemberStatus.onTrack => (
        label: '👍 Đúng tiến độ',
        color: Colors.blue,
      ),
      _MemberStatus.needsMore => (
        label: '⚠️ Cần bù thêm',
        color: Colors.orange,
      ),
    };
  }
}

class _MetricCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _MetricCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 14, color: color),
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(fontSize: 10, color: Colors.grey[500]),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
