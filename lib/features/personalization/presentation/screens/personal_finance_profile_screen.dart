import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:money_care/app/widgets/layout/app_header.dart';
import 'package:money_care/core/constants/colors.dart';
import 'package:money_care/core/utils/helper/helper_functions.dart';
import '../controllers/personalization_controller.dart';
import '../../data/models/personal_finance_profile_model.dart';

class PersonalFinanceProfileScreen extends GetView<PersonalizationController> {
  const PersonalFinanceProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FA),
      body: SafeArea(
        child: Obx(() {
          final profile = controller.profile.value;
          final isLoading = controller.isLoading.value;
          final isRebuilding = controller.isRebuilding.value;

          return Column(
            children: [
              AppHeader(
                title: 'Hồ sơ tài chính (Test)',
                height: 120,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
                        onPressed: () => Get.back(),
                      ),
                      const Text(
                        'AI Personalization Profile',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(width: 48), // Spacer
                    ],
                  ),
                ),
              ),
              Expanded(
                child: isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : profile == null
                        ? _buildEmptyState()
                        : SingleChildScrollView(
                            physics: const BouncingScrollPhysics(),
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildHealthScoreSection(profile),
                                const SizedBox(height: 16),
                                _buildGeneralStatsGrid(profile),
                                const SizedBox(height: 16),
                                _buildDetailScores(profile),
                                const SizedBox(height: 16),
                                _buildCategoryInsights(profile),
                                const SizedBox(height: 16),
                                _buildWeeklyRecurringInsights(profile),
                                const SizedBox(height: 24),
                                _buildRebuildButton(isRebuilding),
                                const SizedBox(height: 32),
                              ],
                            ),
                          ),
              ),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.analytics_outlined, size: 64, color: AppColors.text4),
            const SizedBox(height: 16),
            const Text(
              'Chưa có dữ liệu hồ sơ',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.text1),
            ),
            const SizedBox(height: 8),
            const Text(
              'Hệ thống chưa tính toán hồ sơ tài chính cá nhân của bạn. Vui lòng nhấn nút bên dưới để tạo hồ sơ.',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.text3),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              icon: const Icon(Icons.build_circle_outlined),
              label: const Text('Tính toán hồ sơ ngay'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: () => controller.rebuildProfile(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHealthScoreSection(PersonalFinanceProfileModel profile) {
    final styleText = _getSpendingStyleText(profile.spendingStyle);
    final riskText = _getRiskLevelText(profile.riskLevel);
    final riskColor = _getRiskLevelColor(profile.riskLevel);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1E3C72), Color(0xFF2A5298)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1E3C72).withValues(alpha: 0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Điểm sức khỏe tài chính',
                  style: TextStyle(color: Colors.white70, fontSize: 14),
                ),
                const SizedBox(height: 4),
                Text(
                  '${profile.financialHealthScore.round()}/100',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white24,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        styleText,
                        style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: riskColor.withValues(alpha: 0.25),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: riskColor),
                      ),
                      child: Text(
                        'Rủi ro: $riskText',
                        style: TextStyle(color: riskColor, fontSize: 12, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: 80,
                height: 80,
                child: CircularProgressIndicator(
                  value: profile.financialHealthScore / 100,
                  strokeWidth: 8,
                  backgroundColor: Colors.white12,
                  valueColor: const AlwaysStoppedAnimation<Color>(Colors.greenAccent),
                ),
              ),
              Text(
                '${profile.financialHealthScore.round()}%',
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ],
          ),
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
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
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

  Widget _buildDetailScores(PersonalFinanceProfileModel profile) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Chỉ số hành vi chi tiêu',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.text1),
          ),
          const SizedBox(height: 16),
          _buildScoreBar('Kỷ luật ngân sách', profile.budgetDisciplineScore, Colors.blue),
          const SizedBox(height: 14),
          _buildScoreBar('Độ biến động chi tiêu', profile.expenseVolatilityScore, Colors.orange),
          const SizedBox(height: 14),
          _buildScoreBar('Độ tin cậy hồ sơ (Confidence)', profile.confidenceScore, Colors.green),
          const SizedBox(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Buffer ngân sách khuyên dùng', style: TextStyle(fontSize: 12, color: AppColors.text3)),
              Text(
                '${(profile.preferredBudgetBufferPct * 100).round()}%',
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.text1),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildScoreBar(String label, double score, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: const TextStyle(fontSize: 12, color: AppColors.text3)),
            Text(
              '${score.round()}/100',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.text1),
            ),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: score / 100,
            minHeight: 6,
            backgroundColor: AppColors.backgroundPrimary,
            valueColor: AlwaysStoppedAnimation<Color>(color),
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryInsights(PersonalFinanceProfileModel profile) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Danh mục chi tiêu hàng đầu (Top 5)',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.text1),
          ),
          const SizedBox(height: 12),
          if (profile.topExpenseCategories.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 12),
              child: Center(child: Text('Chưa đủ dữ liệu danh mục', style: TextStyle(color: AppColors.text4))),
            )
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: profile.topExpenseCategories.length,
              separatorBuilder: (context, index) => const Divider(height: 16),
              itemBuilder: (context, index) {
                final cat = profile.topExpenseCategories[index];
                final name = cat['name'] ?? 'Khác';
                final amt = (cat['amount'] ?? 0).toDouble();

                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 14,
                          backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                          child: const Icon(Icons.category_outlined, size: 14, color: AppColors.primary),
                        ),
                        const SizedBox(width: 8),
                        Text(name, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
                      ],
                    ),
                    Text(
                      AppHelperFunction.formatAmount(amt),
                      style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.text2),
                    ),
                  ],
                );
              },
            ),
        ],
      ),
    );
  }

  Widget _buildWeeklyRecurringInsights(PersonalFinanceProfileModel profile) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Phát hiện chi tiêu định kỳ (Dự đoán)',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.text1),
          ),
          const SizedBox(height: 12),
          if (profile.recurringExpenseHints.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 12),
              child: Center(
                child: Text(
                  'Chưa phát hiện khoản chi lặp lại nào.',
                  style: TextStyle(color: AppColors.text4, fontSize: 12),
                ),
              ),
            )
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: profile.recurringExpenseHints.length,
              separatorBuilder: (context, index) => const Divider(height: 16),
              itemBuilder: (context, index) {
                final hint = profile.recurringExpenseHints[index];
                final name = hint['categoryName'] ?? 'Hạng mục';
                final freq = hint['frequency'] == 'weekly' ? 'Hàng tuần' : 'Hàng tháng';
                final amt = (hint['estimatedAmount'] ?? 0).toDouble();

                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(name, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                        const SizedBox(height: 2),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.orange.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            freq,
                            style: const TextStyle(color: Colors.orange, fontSize: 9, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                    Text(
                      '~ ${AppHelperFunction.formatAmount(amt)}',
                      style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.text1),
                    ),
                  ],
                );
              },
            ),
        ],
      ),
    );
  }

  Widget _buildRebuildButton(bool isRebuilding) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
        onPressed: isRebuilding ? null : () => controller.rebuildProfile(),
        child: isRebuilding
            ? const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
              )
            : const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.sync_alt, size: 20),
                  SizedBox(width: 8),
                  Text('Tính toán lại hồ sơ', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                ],
              ),
      ),
    );
  }

  String _getSpendingStyleText(String style) {
    switch (style) {
      case 'stable':
        return 'Ổn định';
      case 'impulsive':
        return 'Bộc phát / Hay mua sắm';
      case 'seasonal':
        return 'Chi tiêu mùa vụ';
      case 'goal_driven':
        return 'Tiết kiệm theo mục tiêu';
      case 'income_driven':
        return 'Chi tiêu theo thu nhập';
      case 'insufficient_data':
      default:
        return 'Chưa đủ dữ liệu';
    }
  }

  String _getRiskLevelText(String risk) {
    switch (risk) {
      case 'high':
        return 'Cao';
      case 'medium':
        return 'Trung bình';
      case 'low':
      default:
        return 'Thấp';
    }
  }

  Color _getRiskLevelColor(String risk) {
    switch (risk) {
      case 'high':
        return Colors.redAccent;
      case 'medium':
        return Colors.orangeAccent;
      case 'low':
      default:
        return Colors.greenAccent;
    }
  }
}
