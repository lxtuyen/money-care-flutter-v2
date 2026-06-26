import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:money_care/app/controllers/statistics_controller.dart';
import 'package:money_care/core/constants/colors.dart';
import 'package:money_care/core/constants/route_path.dart';
import 'package:money_care/core/utils/helper/helper_functions.dart';
import 'package:money_care/features/spending_insights/domain/entities/recurring_transaction_entity.dart';
import 'package:money_care/features/spending_insights/presentation/controllers/recurring_controller.dart';

class RecurringSummaryCard extends StatelessWidget {
  const RecurringSummaryCard({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<RecurringController>();

    return Obx(() {
      if (controller.isLoading.value) {
        return _buildShimmer();
      }

      final hasConfirmed = controller.confirmedItems.isNotEmpty;
      final hasDetected = controller.recurringItems.isNotEmpty;

      if (!hasConfirmed && !hasDetected) {
        return const SizedBox.shrink();
      }

      return _buildCard(context, controller, hasConfirmed, hasDetected);
    });
  }

  Widget _buildCard(
    BuildContext context,
    RecurringController controller,
    bool hasConfirmed,
    bool hasDetected,
  ) {
    final confirmedItems = controller.confirmedItems;
    final confirmedTotal = controller.confirmedMonthlyTotal;
    final detectedItems = controller.topItems;
    final detectedTotal = controller.totalMonthlyRecurring;

    // Get unpaid recurring from analytics
    final statisticsController = Get.find<StatisticsController>();
    final unpaidList =
        statisticsController.analyticsData.value?.unpaidRecurring ?? [];
    final unpaidDescriptions =
        unpaidList.map((e) => e.description).toSet();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GestureDetector(
        onTap: () => Get.toNamed(RoutePath.recurringDetail),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.06),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildMainHeader(
                confirmedTotal + detectedTotal,
                confirmedItems.length + controller.itemCount,
              ),
              if (hasConfirmed) ...[
                const Divider(height: 1, indent: 16, endIndent: 16),
                _buildSectionLabel(
                  'Đã xác nhận',
                  '${confirmedItems.length} khoản',
                  AppColors.income,
                ),
                ...confirmedItems.take(3).map(
                      (item) => _buildConfirmedItemRow(
                        item,
                        isPaid: !unpaidDescriptions.contains(item.description),
                      ),
                    ),
              ],
              if (hasDetected) ...[
                const Divider(height: 1, indent: 16, endIndent: 16),
                _buildSectionLabel(
                  'Phát hiện mới',
                  '${controller.itemCount} khoản',
                  AppColors.warning,
                ),
                ...detectedItems.map(_buildDetectedItemRow),
              ],
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMainHeader(double totalMonthly, int itemCount) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 14, 12, 12),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Chi phí cố định',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.text1,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '${AppHelperFunction.formatAmount(totalMonthly)}/tháng · $itemCount khoản',
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.text4,
                  ),
                ),
              ],
            ),
          ),
          const Icon(
            Icons.chevron_right_rounded,
            color: AppColors.text5,
            size: 22,
          ),
        ],
      ),
    );
  }

  Widget _buildSectionLabel(String title, String subtitle, Color color) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 4),
      child: Row(
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            subtitle,
            style: const TextStyle(
              fontSize: 11,
              color: AppColors.text5,
            ),
          ),
        ],
      ),
    );
  }

  /// Row cho confirmed item: hiện expectedDay + trạng thái đã trả/chưa trả.
  Widget _buildConfirmedItemRow(
    RecurringTransactionEntity item, {
    required bool isPaid,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Text(
            item.categoryIcon.isNotEmpty ? item.categoryIcon : '📦',
            style: const TextStyle(fontSize: 20),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.description,
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.text2,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    if (item.expectedDay != null) ...[
                      Icon(
                        Icons.calendar_today_rounded,
                        size: 11,
                        color: AppColors.text5,
                      ),
                      const SizedBox(width: 3),
                      Text(
                        'Ngày ${item.expectedDay}',
                        style: const TextStyle(
                          fontSize: 11,
                          color: AppColors.text5,
                        ),
                      ),
                      const SizedBox(width: 8),
                    ],
                    Icon(
                      isPaid
                          ? Icons.check_circle_rounded
                          : Icons.schedule_rounded,
                      size: 12,
                      color: isPaid ? AppColors.income : AppColors.warning,
                    ),
                    const SizedBox(width: 3),
                    Text(
                      isPaid ? 'Đã trả' : 'Chưa trả',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                        color: isPaid ? AppColors.income : AppColors.warning,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Text(
            AppHelperFunction.formatAmount(item.averageAmount),
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppColors.text1,
            ),
          ),
        ],
      ),
    );
  }

  /// Row cho detected item: giữ đơn giản, hiện frequency label.
  Widget _buildDetectedItemRow(RecurringTransactionEntity item) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Text(
            item.categoryIcon.isNotEmpty ? item.categoryIcon : '📦',
            style: const TextStyle(fontSize: 20),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              item.description,
              style: const TextStyle(
                fontSize: 13,
                color: AppColors.text2,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Text(
            AppHelperFunction.formatAmount(item.averageAmount),
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppColors.text1,
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              item.frequencyLabel,
              style: const TextStyle(
                fontSize: 10,
                color: AppColors.primary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildShimmer() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        height: 120,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: const Center(
          child: SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
        ),
      ),
    );
  }
}
