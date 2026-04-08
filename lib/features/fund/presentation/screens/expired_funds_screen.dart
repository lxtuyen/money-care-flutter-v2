import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:money_care/core/constants/colors.dart';
import 'package:money_care/core/constants/route_path.dart';
import 'package:money_care/core/controllers/app_controller.dart';
import 'package:money_care/core/presentation/widgets/layout/app_header.dart';
import 'package:money_care/core/utils/helper/date_picker_helper.dart';
import 'package:money_care/core/utils/helper/helper_functions.dart';
import 'package:money_care/features/fund/domain/entities/fund_entity.dart';
import 'package:money_care/features/fund/presentation/controllers/fund_controller.dart';

class ExpiredFundsScreen extends StatefulWidget {
  const ExpiredFundsScreen({super.key});

  @override
  State<ExpiredFundsScreen> createState() => _ExpiredFundsScreenState();
}

class _ExpiredFundsScreenState extends State<ExpiredFundsScreen> {
  final FundController controller = Get.find<FundController>();
  final AppController appController = Get.find<AppController>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _load());
  }

  Future<void> _load() async {
    final userId = appController.userId.value;
    if (userId != null) {
      await controller.loadFunds(userId);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundPrimary,
      body: Column(
        children: [
          AppHeader(
            title: 'Quỹ đã hết hạn',
            showBackButton: true,
            height: 130,
          ),
          Expanded(
            child: Obx(() {
              if (controller.isLoadingFunds.value) {
                return const Center(
                  child: CircularProgressIndicator(color: AppColors.primary),
                );
              }

              final expired = controller.expiredFunds;

              if (expired.isEmpty) {
                return _buildEmpty();
              }

              return RefreshIndicator(
                onRefresh: _load,
                child: ListView.builder(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
                  itemCount: expired.length,
                  itemBuilder: (_, i) => _ExpiredFundCard(
                    fund: expired[i],
                    onViewReport: () {
                      controller.loadFundReport(expired[i].id);
                      Get.toNamed(RoutePath.fundReport, arguments: expired[i].id);
                    },
                    onExtend: () => _extend(context, expired[i]),
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildEmpty() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: AppColors.success.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.check_circle_outline_rounded,
              size: 40,
              color: AppColors.success,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Không có quỹ hết hạn',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w700,
              color: AppColors.text2,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Tất cả quỹ tiết kiệm của bạn vẫn còn hiệu lực',
            style: TextStyle(fontSize: 13, color: AppColors.text4),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Future<void> _extend(BuildContext context, FundEntity fund) async {
    final newEndDate = await showStyledDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 30)),
      firstDate: DateTime.now(),
    );
    if (newEndDate == null) return;
    await controller.extendFund(fund.id, newEndDate);
    await _load();
  }
}

class _ExpiredFundCard extends StatelessWidget {
  const _ExpiredFundCard({
    required this.fund,
    required this.onViewReport,
    required this.onExtend,
  });

  final FundEntity fund;
  final VoidCallback onViewReport;
  final VoidCallback onExtend;


  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFFF7D39), Color(0xFFFF4E4E)],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.timer_off_rounded,
                  color: Colors.white,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    fund.name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.22),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'Hết hạn ${fund.daysSinceExpired} ngày trước',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  children: [
                    _DateChip(
                      icon: Icons.play_circle_outline_rounded,
                      label: 'Bắt đầu',
                      value: fund.startDate != null
                          ? AppHelperFunction.getFormattedDate(fund.startDate!)
                          : '—',
                      color: AppColors.primary,
                    ),
                    const SizedBox(width: 8),
                    const Icon(
                      Icons.arrow_forward_rounded,
                      size: 16,
                      color: AppColors.text5,
                    ),
                    const SizedBox(width: 8),
                    _DateChip(
                      icon: Icons.stop_circle_outlined,
                      label: 'Kết thúc',
                      value: fund.endDate != null
                          ? AppHelperFunction.getFormattedDate(fund.endDate!)
                          : '—',
                      color: AppColors.secondaryOrange,
                    ),
                  ],
                ),

                const SizedBox(height: 14),
                const Divider(color: AppColors.borderSecondary, height: 1),
                const SizedBox(height: 14),

                Row(
                  children: [
                    _StatItem(
                      icon: Icons.track_changes_rounded,
                      label: 'Mục tiêu',
                      value: fund.target != null
                          ? AppHelperFunction.formatAmount(fund.target!, 'VND')
                          : '—',
                      color: AppColors.primary,
                    ),
                    const SizedBox(width: 12),
                    _StatItem(
                      icon: Icons.account_balance_wallet_outlined,
                      label: 'Ngân sách',
                      value: fund.balance != null
                          ? AppHelperFunction.formatAmount(fund.balance!, 'VND')
                          : '—',
                      color: AppColors.secondaryNavyBlue,
                    ),
                    const SizedBox(width: 12),
                    _StatItem(
                      icon: Icons.category_outlined,
                      label: 'Danh má»¥c',
                      value: '${fund.categories.length}',
                      color: AppColors.success,
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: onViewReport,
                        icon: const Icon(Icons.bar_chart_rounded, size: 18),
                        label: const Text('Báo cáo'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.primary,
                          side: const BorderSide(color: AppColors.primary),
                          padding: const EdgeInsets.symmetric(vertical: 11),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: onExtend,
                        icon: const Icon(Icons.update_rounded, size: 18),
                        label: const Text('Gia háº¡n'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 11),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DateChip extends StatelessWidget {
  const _DateChip({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  final IconData icon;
  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          color: color.withOpacity(0.07),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Icon(icon, size: 14, color: color),
            const SizedBox(width: 6),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 10,
                      color: color.withOpacity(0.8),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    value,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: color,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  const _StatItem({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  final IconData icon;
  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 18, color: color),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: AppColors.text1,
            ),
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          ),
          Text(
            label,
            style: const TextStyle(fontSize: 11, color: AppColors.text4),
          ),
        ],
      ),
    );
  }
}


