import 'package:flutter/material.dart';
import 'package:money_care/core/constants/colors.dart';
import 'package:money_care/core/utils/helper/helper_functions.dart';
import 'package:money_care/features/couple/domain/entities/couple_saving_goal_entity.dart';

class CoupleSavingRoadmapSection extends StatefulWidget {
  final CoupleSavingGoalEntity goal;

  const CoupleSavingRoadmapSection({super.key, required this.goal});

  @override
  State<CoupleSavingRoadmapSection> createState() => _CoupleSavingRoadmapSectionState();
}

class _CoupleSavingRoadmapSectionState extends State<CoupleSavingRoadmapSection> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final goal = widget.goal;

    // Don't show for completed goals
    if (goal.status == 'completed' || goal.savedAmount >= goal.target) {
      return const SizedBox.shrink();
    }

    if (goal.endDate == null) {
      return const SizedBox.shrink(); // Handled by plan section
    }

    final createdAt = goal.createdAt ?? DateTime.now();
    final endDate = goal.endDate!;

    final startMonth = DateTime(createdAt.year, createdAt.month);
    final endMonth = DateTime(endDate.year, endDate.month);

    // Generate month list
    final allMonths = <DateTime>[];
    DateTime temp = startMonth;
    while (!temp.isAfter(endMonth)) {
      allMonths.add(temp);
      temp = DateTime(temp.year, temp.month + 1);
      if (allMonths.length > 120) break; // protection
    }
    if (allMonths.isEmpty) {
      allMonths.add(startMonth);
    }

    final totalMonths = allMonths.length;
    final targetPerMonth = goal.target / totalMonths;

    final now = DateTime.now();
    final currentMonth = DateTime(now.year, now.month);

    // Get visible list
    final visibleMonths = _getVisibleMonths(allMonths, currentMonth);

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.03),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader(),
          const SizedBox(height: 14),
          
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: visibleMonths.length,
            itemBuilder: (context, index) {
              final month = visibleMonths[index];
              final isFirst = index == 0;
              final isLast = index == visibleMonths.length - 1;

              // Calculate contribution in this month
              double savedInMonth = 0.0;
              for (final contribution in goal.contributions) {
                if (contribution.createdAt.year == month.year &&
                    contribution.createdAt.month == month.month) {
                  savedInMonth += contribution.amount;
                }
              }

              // Determine status
              final isFuture = month.isAfter(currentMonth);
              final isCurrent = month.year == currentMonth.year && month.month == currentMonth.month;
              final isMet = savedInMonth >= targetPerMonth;

              Color statusColor;
              String statusText;
              IconData statusIcon;

              if (isFuture) {
                statusColor = AppColors.disabled;
                statusText = 'Chờ tích lũy';
                statusIcon = Icons.hourglass_empty_rounded;
              } else if (isMet) {
                statusColor = AppColors.income;
                statusText = 'Đạt chỉ tiêu';
                statusIcon = Icons.check_circle_rounded;
              } else {
                statusColor = isCurrent ? AppColors.info : AppColors.secondaryOrange;
                statusText = isCurrent ? 'Đang tích lũy' : 'Chưa đạt';
                statusIcon = isCurrent ? Icons.trending_flat_rounded : Icons.warning_amber_rounded;
              }

              final progress = targetPerMonth > 0
                  ? (savedInMonth / targetPerMonth).clamp(0.0, 1.0)
                  : 0.0;

              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Timeline column
                  Column(
                    children: [
                      Container(
                        width: 2,
                        height: 12,
                        color: isFirst ? Colors.transparent : Colors.grey[300],
                      ),
                      Container(
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                          color: statusColor.withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                          border: Border.all(color: statusColor, width: 2),
                        ),
                        child: Center(
                          child: Icon(
                            statusIcon,
                            size: 10,
                            color: statusColor,
                          ),
                        ),
                      ),
                      Container(
                        width: 2,
                        height: 48,
                        color: isLast ? Colors.transparent : Colors.grey[300],
                      ),
                    ],
                  ),
                  const SizedBox(width: 12),
                  
                  // Content column
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Tháng ${month.month}/${month.year}${isCurrent ? ' (Tháng này)' : ''}',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: isCurrent ? FontWeight.bold : FontWeight.w600,
                                color: isCurrent ? Colors.black87 : Colors.grey[700],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: statusColor.withValues(alpha: 0.08),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                statusText,
                                style: TextStyle(
                                  fontSize: 9,
                                  fontWeight: FontWeight.bold,
                                  color: statusColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Đã đóng: ${AppHelperFunction.formatAmount(savedInMonth)}',
                              style: TextStyle(
                                fontSize: 11,
                                color: isFuture ? Colors.grey[500] : Colors.black87,
                                fontWeight: isCurrent ? FontWeight.w500 : FontWeight.normal,
                              ),
                            ),
                            Text(
                              'Mục tiêu: ${AppHelperFunction.formatAmount(targetPerMonth)}',
                              style: TextStyle(fontSize: 10, color: Colors.grey[500]),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        if (!isFuture) ...[
                          ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: LinearProgressIndicator(
                              value: progress,
                              minHeight: 4,
                              backgroundColor: Colors.grey[200],
                              valueColor: AlwaysStoppedAnimation<Color>(statusColor),
                            ),
                          ),
                        ] else ...[
                          Container(
                            height: 4,
                            decoration: BoxDecoration(
                              color: Colors.grey[100],
                              borderRadius: BorderRadius.circular(4),
                            ),
                          )
                        ],
                        const SizedBox(height: 8),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
          
          if (allMonths.length > 3) ...[
            const SizedBox(height: 4),
            Align(
              alignment: Alignment.center,
              child: TextButton.icon(
                style: TextButton.styleFrom(
                  foregroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                onPressed: () {
                  setState(() {
                    _isExpanded = !_isExpanded;
                  });
                },
                icon: Icon(
                  _isExpanded ? Icons.keyboard_arrow_up_rounded : Icons.keyboard_arrow_down_rounded,
                  size: 16,
                ),
                label: Text(
                  _isExpanded ? 'Thu gọn lộ trình' : 'Xem toàn bộ lộ trình ($totalMonths tháng)',
                  style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSectionHeader() {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(
            Icons.alt_route_rounded,
            size: 16,
            color: AppColors.primary,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          'LỘ TRÌNH TIẾT KIỆM TỪNG THÁNG',
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

  List<DateTime> _getVisibleMonths(List<DateTime> allMonths, DateTime currentMonth) {
    if (_isExpanded || allMonths.length <= 3) return allMonths;
    
    int currIdx = allMonths.indexWhere(
      (m) => m.year == currentMonth.year && m.month == currentMonth.month,
    );

    if (currIdx == -1) {
      if (currentMonth.isBefore(allMonths.first)) {
        return allMonths.sublist(0, 3);
      } else {
        return allMonths.sublist(allMonths.length - 3);
      }
    }

    int startIdx = (currIdx - 1).clamp(0, allMonths.length - 3);
    return allMonths.sublist(startIdx, startIdx + 3);
  }
}
