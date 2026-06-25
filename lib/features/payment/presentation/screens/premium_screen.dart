import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:money_care/app/widgets/button/primary_button.dart';
import 'package:money_care/app/widgets/layout/app_header.dart';
import 'package:money_care/core/constants/colors.dart';
import 'package:money_care/core/theme/app_theme_colors.dart';
import 'package:money_care/features/payment/presentation/controllers/payment_controller.dart';

class PremiumScreen extends GetView<PaymentController> {
  const PremiumScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeColors = AppThemeColors.of(context);

    return Scaffold(
      backgroundColor: themeColors.cardBackground,
      body: SafeArea(
        top: false,
        child: Obx(() {
          final status = controller.subscriptionStatus.value;
          final isPremium = status?.isPremium ?? false;
          final isGrace = status?.isGracePeriod ?? false;
          final canTrial = status?.canStartTrial ?? true;

          return Column(
            children: [
              AppHeader(
                title: isPremium ? 'Premium đang hoạt động' : 'MNCARE Premium',
                showBackButton: true,
                height: isPremium ? 120 : 150,
                child: isPremium
                    ? null
                    : const Text(
                        'Chỉ với 49.999đ /tháng',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white70,
                              ),
                      ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        if (isGrace) _buildGraceBanner(context, status),
                        if (isPremium && !isGrace) _buildActiveBanner(status),
                        const SizedBox(height: 24),
                        _buildFeaturesList(context, themeColors),
                        const SizedBox(height: 20),
                        if (!isPremium) ...[

                          _buildSubscribeButton(context),
                          if (canTrial) ...[
                            const SizedBox(height: 12),
                            _buildTrialButton(context),
                          ],
                        ],
                        /*const SizedBox(height: 16),
                        _buildHistoryLink(context, themeColors),
                        const SizedBox(height: 32),*/
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildGraceBanner(BuildContext context, dynamic status) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.warning.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.warning.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        children: [
          const Icon(Iconsax.warning_2, color: AppColors.warning, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Gói Premium đã hết hạn',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Bạn còn ${status?.daysRemaining ?? 0} ngày để gia hạn trước khi mất quyền truy cập.',
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.text4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActiveBanner(dynamic status) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.income.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.income.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        children: [
          const Icon(Iconsax.verify, color: AppColors.income, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  status?.isTrial == true
                      ? 'Đang dùng thử Premium'
                      : 'Premium đang hoạt động',
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Còn ${status?.daysRemaining ?? 0} ngày — hết hạn ${_formatDate(status?.expiresAt)}',
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.text4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeaturesList(
    BuildContext context,
    AppThemeColors themeColors,
  ) {
    final features = [
      _FeatureItem(
        icon: Iconsax.chart_2,
        title: 'Dự báo tài chính',
        description: 'Phân tích xu hướng và dự đoán chi tiêu thông minh',
      ),
      _FeatureItem(
        icon: Iconsax.flash_1,
        title: 'Phát hiện bất thường',
        description: 'Tự động phát hiện giao dịch bất thường bằng AI',
      ),
      _FeatureItem(
        icon: Iconsax.receipt_1,
        title: 'Chi tiêu định kỳ',
        description: 'Nhận diện subscriptions, hóa đơn lặp lại tự động',
      ),
      _FeatureItem(
        icon: Iconsax.money_send,
        title: 'Gợi ý ngân sách AI',
        description: 'Đề xuất cắt giảm, phân bổ ngân sách thông minh',
      ),
      _FeatureItem(
        icon: Iconsax.star_1,
        title: 'Tính năng sắp ra mắt',
        description: 'AI insights cá nhân hóa, và nhiều hơn nữa',
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Tính năng Premium',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: themeColors.textPrimary,
            fontFamily: 'BeVietnamPro',
          ),
        ),
        const SizedBox(height: 16),
        ...features.map(
          (f) => _buildFeatureTile(context, themeColors, f),
        ),
      ],
    );
  }

  Widget _buildFeatureTile(
    BuildContext context,
    AppThemeColors themeColors,
    _FeatureItem feature,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Container(
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
                color: AppColors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(feature.icon, color: AppColors.primary, size: 22),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    feature.title,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: themeColors.textPrimary,
                      ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    feature.description,
                    style: TextStyle(
                      fontSize: 12,
                      color: themeColors.textMuted,
                      ),
                  ),
                ],
              ),
            ),
            Icon(
              Iconsax.tick_circle,
              color: AppColors.primary.withValues(alpha: 0.6),
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSubscribeButton(BuildContext context) {
    return Obx(
      () => PrimaryButton(
        label: 'Nâng cấp Premium',
        onPressed: () => controller.subscribe(),
        isLoading: controller.isProcessing.value,
        height: 52,
        borderRadius: 14,
        fontSize: 16,
      ),
    );
  }

  Widget _buildTrialButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: OutlinedButton(
        onPressed: controller.isProcessing.value
            ? null
            : () => controller.activateTrial(),
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primary,
          side: const BorderSide(color: AppColors.primary),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        child: const Text(
          'Dùng thử miễn phí 7 ngày',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            fontFamily: 'BeVietnamPro',
          ),
        ),
      ),
    );
  }

  Widget _buildHistoryLink(
    BuildContext context,
    AppThemeColors themeColors,
  ) {
    return TextButton.icon(
      onPressed: () => Get.toNamed('/payment_history'),
      icon: Icon(
        Iconsax.receipt_2_1,
        size: 18,
        color: themeColors.textMuted,
      ),
      label: Text(
        'Lịch sử thanh toán',
        style: TextStyle(
          fontSize: 13,
          color: themeColors.textMuted,
          fontFamily: 'BeVietnamPro',
        ),
      ),
    );
  }

  String _formatDate(DateTime? date) {
    if (date == null) return '';
    return '${date.day}/${date.month}/${date.year}';
  }
}

class _FeatureItem {
  final IconData icon;
  final String title;
  final String description;

  _FeatureItem({
    required this.icon,
    required this.title,
    required this.description,
  });
}
