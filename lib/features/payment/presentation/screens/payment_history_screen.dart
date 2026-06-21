import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:intl/intl.dart';
import 'package:money_care/app/widgets/layout/app_header.dart';
import 'package:money_care/app/widgets/states/app_empty_state.dart';
import 'package:money_care/core/constants/colors.dart';
import 'package:money_care/core/theme/app_theme_colors.dart';
import 'package:money_care/features/payment/domain/entities/payment_entity.dart';
import 'package:money_care/features/payment/presentation/controllers/payment_controller.dart';

class PaymentHistoryScreen extends GetView<PaymentController> {
  const PaymentHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeColors = AppThemeColors.of(context);

    // Load history khi vào màn hình
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.loadPaymentHistory();
    });

    return Scaffold(
      backgroundColor: themeColors.cardBackground,
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            AppHeader(
              title: 'Lịch sử thanh toán',
              showBackButton: true,
              height: 120,
            ),
            Expanded(
              child: Obx(() {
                if (controller.isLoadingHistory.value) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (controller.paymentHistory.isEmpty) {
                  return const AppEmptyState(
                    message: 'Chưa có giao dịch nào',
                  );
                }

                return ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: controller.paymentHistory.length,
                  separatorBuilder: (_, _a) => const SizedBox(height: 8),
                  itemBuilder: (context, index) {
                    final payment = controller.paymentHistory[index];
                    return _buildPaymentCard(context, themeColors, payment);
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentCard(
    BuildContext context,
    AppThemeColors themeColors,
    PaymentEntity payment,
  ) {
    final statusColor = _getStatusColor(payment.status);
    final formatter = NumberFormat('#,###', 'vi_VN');

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: themeColors.cardBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: themeColors.borderSecondary,
          width: 0.5,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: statusColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              payment.isSuccess ? Iconsax.tick_circle : Iconsax.close_circle,
              color: statusColor,
              size: 22,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'MNCARE Premium',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: themeColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  _formatDateTime(payment.paidAt ?? payment.createdAt),
                  style: TextStyle(
                    fontSize: 12,
                    color: themeColors.textMuted,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${formatter.format(payment.amount)}đ',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: themeColors.textPrimary,
                  fontFamily: 'BeVietnamPro',
                ),
              ),
              const SizedBox(height: 2),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 2,
                ),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  payment.statusLabel,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: statusColor,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'success':
        return AppColors.success;
      case 'pending':
        return AppColors.warning;
      case 'failed':
      case 'cancelled':
        return AppColors.error;
      default:
        return AppColors.text4;
    }
  }

  String _formatDateTime(DateTime date) {
    return '${date.day}/${date.month}/${date.year} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }
}
