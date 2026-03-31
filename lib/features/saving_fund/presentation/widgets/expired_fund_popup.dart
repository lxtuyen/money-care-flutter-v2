import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:money_care/core/constants/colors.dart';
import 'package:money_care/core/constants/route_path.dart';
import 'package:money_care/core/utils/helper/date_picker_helper.dart';
import 'package:money_care/features/saving_fund/data/models/models.dart';
import 'package:money_care/features/saving_fund/presentation/controllers/saving_fund_controller.dart';

class ExpiredFundPopup extends StatelessWidget {
  final ExpiredFundInfoModel fund;

  const ExpiredFundPopup({super.key, required this.fund});

  static void show(ExpiredFundInfoModel fund) {
    Get.dialog(
      ExpiredFundPopup(fund: fund),
      barrierDismissible: false,
    );
  }

  String _formatCurrency(double amount) {
    final formatter = NumberFormat.currency(locale: 'vi_VN', symbol: '₫', decimalDigits: 0);
    return formatter.format(amount);
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<SavingFundController>();

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            const Text('🎉', style: TextStyle(fontSize: 48)),
            const SizedBox(height: 8),
            const Text(
              'Chúc mừng!',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppColors.text1,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Quỹ "${fund.name}" đã kết thúc',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 14, color: AppColors.text3),
            ),

            const SizedBox(height: 20),

            // Stats
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.backgroundPrimary,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  _StatRow(
                    icon: Icons.flag_rounded,
                    label: 'Hoàn thành mục tiêu',
                    value: '${fund.completionPercentage}%',
                    valueColor: fund.completionPercentage >= 100
                        ? AppColors.success
                        : AppColors.primary,
                  ),
                  const Divider(height: 16),
                  _StatRow(
                    icon: Icons.account_balance_wallet_rounded,
                    label: 'Tổng chi tiêu',
                    value: _formatCurrency(fund.totalSpent),
                  ),
                  if (fund.target > 0) ...[
                    const Divider(height: 16),
                    _StatRow(
                      icon: Icons.track_changes_rounded,
                      label: 'Mục tiêu',
                      value: _formatCurrency(fund.target),
                    ),
                  ],
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Progress bar
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Tiến độ',
                      style: TextStyle(fontSize: 12, color: AppColors.text4),
                    ),
                    Text(
                      '${fund.completionPercentage}%',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: (fund.completionPercentage / 100).clamp(0.0, 1.0),
                    minHeight: 8,
                    backgroundColor: AppColors.borderSecondary,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      fund.completionPercentage >= 100
                          ? AppColors.success
                          : AppColors.primary,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => _onViewReport(controller),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: AppColors.primary),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: const Text(
                      'Xem báo cáo',
                      style: TextStyle(color: AppColors.primary, fontSize: 13),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => _onExtend(context, controller),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: const Text(
                      'Gia hạn',
                      style: TextStyle(color: Colors.white, fontSize: 13),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _onViewReport(SavingFundController controller) async {
    await controller.markAsNotified(fund.id);
    Get.back(); // close dialog
    await controller.loadFundReport(fund.id);
    Get.toNamed(RoutePath.savingFundReport, arguments: fund.id);
  }

  Future<void> _onExtend(BuildContext context, SavingFundController controller) async {
    final newEndDate = await showStyledDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 30)),
      firstDate: DateTime.now(),
    );

    if (newEndDate == null) return;

    Get.back(); // close dialog
    await controller.extendFund(fund.id, newEndDate);
  }
}

class _StatRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color? valueColor;

  const _StatRow({
    required this.icon,
    required this.label,
    required this.value,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 16, color: AppColors.text4),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            label,
            style: const TextStyle(fontSize: 13, color: AppColors.text3),
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: valueColor ?? AppColors.text1,
          ),
        ),
      ],
    );
  }
}
