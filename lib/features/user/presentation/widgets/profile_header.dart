import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:money_care/app/controllers/user_controller.dart';
import 'package:money_care/core/constants/colors.dart';
import 'package:money_care/core/utils/helper/helper_functions.dart';
import 'package:money_care/features/personalization/presentation/controllers/personalization_controller.dart';
import 'package:money_care/features/personalization/data/models/personal_finance_profile_model.dart';

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final userController = Get.find<UserController>();
    final personalizationController = Get.find<PersonalizationController>();

    return Container(
      width: double.infinity,
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
      child: Column(
        children: [
          Obx(() {
            final profile = userController.userProfile.value;
            final avatarUrl = profile?.avatar;
            final hasAvatar = avatarUrl != null && avatarUrl.isNotEmpty;
            final initials = (profile?.firstName?.isNotEmpty == true)
                ? profile!.firstName![0].toUpperCase()
                : 'U';

            return Container(
              width: 90,
              height: 90,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primary.withValues(
                  alpha: 0.1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ClipOval(
                child: hasAvatar
                    ? Image.network(
                        avatarUrl,
                        fit: BoxFit.cover,
                        width: 90,
                        height: 90,
                        errorBuilder: (_, _, _) => _AvatarFallback(
                          initials: initials,
                          size: 90,
                        ),
                        loadingBuilder: (_, child, progress) {
                          if (progress == null) {
                            return child;
                          }
                          return const Center(
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: AppColors.primary,
                            ),
                          );
                        },
                      )
                    : _AvatarFallback(
                        initials: initials,
                        size: 90,
                      ),
              ),
            );
          }),
          const SizedBox(height: 12),
          Obx(() {
            final profile = userController.userProfile.value;
            final fullName = profile != null
                ? '${profile.firstName} ${profile.lastName}'
                : 'User';
            return Text(
              fullName,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.text1,
              ),
            );
          }),
          const SizedBox(height: 8),
          Obx(() {
            final p = personalizationController.profile.value;
            if (p == null) return const SizedBox.shrink();
            final score = p.financialHealthScore.round();
            return Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.favorite, color: AppColors.primary, size: 14),
                      const SizedBox(width: 6),
                      Text(
                        'Sức khỏe tài chính: $score/100',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                _buildGeneralStatsGrid(p),
              ],
            );
          }),
        ],
      ),
    );
  }

  Widget _buildGeneralStatsGrid(PersonalFinanceProfileModel profile) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: 1.5,
      children: [
        _buildStatCard(
          'Thu nhập trung bình',
          AppHelperFunction.formatAmount(profile.averageMonthlyIncome),
          Icons.arrow_upward,
          Colors.green,
          profile.monthlyIncomeTrend,
        ),
        _buildStatCard(
          'Chi tiêu trung bình',
          AppHelperFunction.formatAmount(profile.averageMonthlyExpense),
          Icons.arrow_downward,
          Colors.red,
          profile.monthlyExpenseTrend,
        ),
        _buildStatCard(
          'Tích lũy trung bình',
          AppHelperFunction.formatAmount(profile.averageMonthlySavings),
          Icons.savings_outlined,
          AppColors.primary,
          null,
        ),
        _buildStatCard(
          'Tỷ lệ tiết kiệm',
          '${(profile.savingsRate * 100).toStringAsFixed(1)}%',
          Icons.pie_chart_outline,
          Colors.purple,
          null,
        ),
      ],
    );
  }

  Widget _buildStatCard(String title, String val, IconData icon, Color color, String? trend) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(icon, color: color, size: 20),
              if (trend != null) _buildTrendBadge(trend),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontSize: 11, color: AppColors.text4)),
              const SizedBox(height: 2),
              Text(
                val,
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.text1),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTrendBadge(String trend) {
    IconData icon;
    Color color;
    String label;

    if (trend == 'increasing') {
      icon = Icons.trending_up;
      color = Colors.green;
      label = 'Tăng';
    } else if (trend == 'decreasing') {
      icon = Icons.trending_down;
      color = Colors.red;
      label = 'Giảm';
    } else {
      icon = Icons.trending_flat;
      color = Colors.grey;
      label = 'Ổn định';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 10),
          const SizedBox(width: 2),
          Text(label, style: TextStyle(color: color, fontSize: 8, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}

class _AvatarFallback extends StatelessWidget {
  final String initials;
  final double size;

  const _AvatarFallback({required this.initials, this.size = 90});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      color: AppColors.primary.withValues(alpha: 0.1),
      child: Center(
        child: Text(
          initials,
          style: TextStyle(
            fontSize: size * 0.4,
            fontWeight: FontWeight.bold,
            color: AppColors.primary,
          ),
        ),
      ),
    );
  }
}
