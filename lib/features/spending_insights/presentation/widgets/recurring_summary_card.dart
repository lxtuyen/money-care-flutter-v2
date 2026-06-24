import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:money_care/core/constants/colors.dart';
import 'package:money_care/core/constants/route_path.dart';
import 'package:money_care/core/utils/helper/helper_functions.dart';
import 'package:money_care/features/spending_insights/presentation/controllers/recurring_controller.dart';

/// Summary card hiển thị trong Statistics screen.
/// Hiển thị tổng chi phí cố định/tháng + top 3 khoản lớn nhất.
class RecurringSummaryCard extends StatelessWidget {
  const RecurringSummaryCard({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<RecurringController>();

    return Obx(() {
      if (controller.isLoading.value) {
        return _buildShimmer();
      }

      if (controller.hasError.value || controller.itemCount == 0) {
        return const SizedBox.shrink();
      }

      return _buildCard(context, controller);
    });
  }

  Widget _buildCard(BuildContext context, RecurringController controller) {
    final topItems = controller.topItems;
    final totalMonthly = controller.totalMonthlyRecurring;
    final itemCount = controller.itemCount;

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
            children: [
              _buildHeader(totalMonthly, itemCount),
              if (topItems.isNotEmpty) ...[
                const Divider(height: 1, indent: 16, endIndent: 16),
                ...topItems.map((item) => _buildItemRow(item)),
              ],
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(double totalMonthly, int itemCount) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 14, 12, 12),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.repeat_rounded,
              size: 20,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(width: 12),
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

  Widget _buildItemRow(dynamic item) {
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
