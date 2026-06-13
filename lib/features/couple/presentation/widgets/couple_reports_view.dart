import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:money_care/core/utils/helper/helper_functions.dart';
import 'package:money_care/features/couple/domain/entities/couple_report_entity.dart';
import 'package:money_care/features/couple/presentation/controllers/couple_controller.dart';

class CoupleReportsView extends StatelessWidget {
  final CoupleController controller;

  const CoupleReportsView({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final report = controller.coupleReport.value;
      if (controller.isReportLoading.value && report == null) {
        return const Center(child: CircularProgressIndicator());
      }
      if (report == null) {
        return RefreshIndicator(
          onRefresh: controller.fetchCoupleReport,
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            children: const [
              SizedBox(height: 180),
              Center(child: Text('Chưa có dữ liệu báo cáo')),
            ],
          ),
        );
      }

      return RefreshIndicator(
        onRefresh: controller.fetchCoupleReport,
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          children: [
            _SummaryGrid(summary: report.summary),
            const SizedBox(height: 16),
            _SectionTitle(
              title: 'AI INSIGHT CHUNG',
              trailing: '${report.insights.length}',
            ),
            const SizedBox(height: 8),
            ...report.insights.map((insight) => _InsightTile(insight: insight)),
            const SizedBox(height: 16),
            _SectionTitle(title: 'TOP DANH MỤC CHI CHUNG'),
            const SizedBox(height: 8),
            _TopCategories(items: report.topCategories),
            const SizedBox(height: 16),
            _SectionTitle(title: 'ĐÓNG GÓP THEO NGƯỜI TRẢ'),
            const SizedBox(height: 8),
            _MemberContributions(items: report.memberContributions),
            const SizedBox(height: 16),
            _SectionTitle(title: 'TIẾN ĐỘ NGÂN SÁCH'),
            const SizedBox(height: 8),
            _BudgetProgress(items: report.budgetProgress),
            const SizedBox(height: 16),
            _SectionTitle(title: 'XU HƯỚNG THEO TUẦN'),
            const SizedBox(height: 8),
            _WeeklyTrend(items: report.weeklyTrend),
            const SizedBox(height: 16),
            _AlertHeader(
              unreadCount: report.unreadAlertCount,
              selected: controller.alertFilter.value,
              onChanged: (value) => controller.alertFilter.value = value,
            ),
            const SizedBox(height: 8),
            ...controller.filteredAlerts.map(
              (alert) => _AlertCard(controller: controller, alert: alert),
            ),
            const SizedBox(height: 24),
          ],
        ),
      );
    });
  }
}

class _SummaryGrid extends StatelessWidget {
  final CoupleReportSummaryEntity summary;

  const _SummaryGrid({required this.summary});

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 10,
      crossAxisSpacing: 10,
      childAspectRatio: 1.75,
      children: [
        _MetricTile(
          label: 'Thu chung',
          value: AppHelperFunction.formatAmount(summary.totalIncome),
          color: Colors.green,
          icon: Icons.trending_up_rounded,
        ),
        _MetricTile(
          label: 'Chi chung',
          value: AppHelperFunction.formatAmount(summary.totalExpense),
          color: Colors.red,
          icon: Icons.trending_down_rounded,
        ),
        _MetricTile(
          label: 'Chênh lệch',
          value: AppHelperFunction.formatAmount(summary.netBalance),
          color: summary.netBalance >= 0 ? Colors.teal : Colors.orange,
          icon: Icons.account_balance_rounded,
        ),
        _MetricTile(
          label: 'Giao dịch',
          value: '${summary.transactionCount}',
          color: Colors.blueGrey,
          icon: Icons.receipt_long_rounded,
        ),
      ],
    );
  }
}

class _MetricTile extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  final IconData icon;

  const _MetricTile({
    required this.label,
    required this.value,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Icon(icon, color: color),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: TextStyle(color: Colors.grey.shade600)),
                const SizedBox(height: 4),
                Text(
                  value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  final String? trailing;

  const _SectionTitle({required this.title, this.trailing});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 12,
              fontWeight: FontWeight.bold,
              letterSpacing: 1,
            ),
          ),
        ),
        if (trailing != null)
          Text(trailing!, style: const TextStyle(fontWeight: FontWeight.bold)),
      ],
    );
  }
}

class _InsightTile extends StatelessWidget {
  final CoupleInsightEntity insight;

  const _InsightTile({required this.insight});

  @override
  Widget build(BuildContext context) {
    final color = switch (insight.severity) {
      'danger' => Colors.red,
      'warning' => Colors.orange,
      'success' => Colors.green,
      _ => Colors.blue,
    };
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border(left: BorderSide(color: color, width: 4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            insight.title,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(insight.message),
          if (insight.evidence.isNotEmpty) ...[
            const SizedBox(height: 6),
            Text(
              insight.evidence,
              style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
            ),
          ],
        ],
      ),
    );
  }
}

class _TopCategories extends StatelessWidget {
  final List<CoupleTopCategoryEntity> items;

  const _TopCategories({required this.items});

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) return const _EmptyBox(text: 'Chưa có chi tiêu chung');
    return Column(
      children: items.map((item) {
        return _ProgressRow(
          icon: item.categoryIcon,
          title: item.categoryName,
          subtitle: AppHelperFunction.formatAmount(item.amount),
          value: (item.percentage / 100).clamp(0.0, 1.0),
          trailing: '${item.percentage.toStringAsFixed(0)}%',
        );
      }).toList(),
    );
  }
}

class _MemberContributions extends StatelessWidget {
  final List<CoupleMemberContributionReportEntity> items;

  const _MemberContributions({required this.items});

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) return const _EmptyBox(text: 'Chưa có thành viên');
    final total = items.fold<double>(0, (sum, item) => sum + item.paidAmount);
    return Column(
      children: items.map((item) {
        return _ProgressRow(
          icon: item.fullName.isNotEmpty ? item.fullName[0].toUpperCase() : 'U',
          title: item.fullName,
          subtitle: AppHelperFunction.formatAmount(item.paidAmount),
          value: total > 0 ? item.paidAmount / total : 0,
        );
      }).toList(),
    );
  }
}

class _BudgetProgress extends StatelessWidget {
  final List<CoupleBudgetProgressReportEntity> items;

  const _BudgetProgress({required this.items});

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) return const _EmptyBox(text: 'Chưa thiết lập ngân sách');
    return Column(
      children: items.map((item) {
        return _ProgressRow(
          icon: item.categoryIcon,
          title: item.categoryName,
          subtitle:
              '${AppHelperFunction.formatAmount(item.spentAmount)} / ${AppHelperFunction.formatAmount(item.amount)}',
          value: (item.usagePercentage / 100).clamp(0.0, 1.0),
          trailing: '${item.usagePercentage.toStringAsFixed(0)}%',
          color: item.usagePercentage >= 100 ? Colors.red : Colors.teal,
        );
      }).toList(),
    );
  }
}

class _WeeklyTrend extends StatelessWidget {
  final List<CoupleWeeklyTrendEntity> items;

  const _WeeklyTrend({required this.items});

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) return const _EmptyBox(text: 'Chưa có dữ liệu tuần');
    final maxValue = items.fold<double>(
      1,
      (max, item) =>
          [max, item.income, item.expense].reduce((a, b) => a > b ? a : b),
    );
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: _boxDecoration(),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: items.map((item) {
          return Expanded(
            child: Column(
              children: [
                _Bar(value: item.income / maxValue, color: Colors.green),
                const SizedBox(height: 4),
                _Bar(value: item.expense / maxValue, color: Colors.red),
                const SizedBox(height: 8),
                Text(
                  'T${item.weekIndex}',
                  style: const TextStyle(fontSize: 11),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _Bar extends StatelessWidget {
  final double value;
  final Color color;

  const _Bar({required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        height: 54 * value.clamp(0.05, 1.0),
        width: 12,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(6),
        ),
      ),
    );
  }
}

class _AlertHeader extends StatelessWidget {
  final int unreadCount;
  final String selected;
  final ValueChanged<String> onChanged;

  const _AlertHeader({
    required this.unreadCount,
    required this.selected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    const filters = {
      'all': 'Tất cả',
      'unread': 'Chưa đọc',
      'high': 'Mức cao',
      'open': 'Đang mở',
    };
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionTitle(
          title: 'CẢNH BÁO CHI TIÊU',
          trailing: unreadCount > 0 ? '$unreadCount chưa đọc' : null,
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          children: filters.entries.map((entry) {
            return ChoiceChip(
              label: Text(entry.value),
              selected: selected == entry.key,
              onSelected: (_) => onChanged(entry.key),
            );
          }).toList(),
        ),
      ],
    );
  }
}

class _AlertCard extends StatelessWidget {
  final CoupleController controller;
  final CoupleSpendingAlertEntity alert;

  const _AlertCard({required this.controller, required this.alert});

  @override
  Widget build(BuildContext context) {
    final color = alert.severity == 'high'
        ? Colors.red
        : alert.severity == 'medium'
        ? Colors.orange
        : Colors.blueGrey;
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: _boxDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.warning_rounded, color: color),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  alert.title,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              if (!alert.isRead)
                Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 6),
          Text(alert.message),
          const SizedBox(height: 6),
          Text(
            AppHelperFunction.formatAmount(alert.amount),
            style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            children: [
              TextButton(
                onPressed: alert.isRead
                    ? null
                    : () => controller.markAlertRead(alert.id),
                child: const Text('Đã đọc'),
              ),
              TextButton(
                onPressed: alert.status == 'resolved'
                    ? null
                    : () => controller.resolveAlert(alert.id),
                child: const Text('Xử lý'),
              ),
              TextButton(
                onPressed: () =>
                    controller.sendAlertFeedback(alert.id, 'correct'),
                child: const Text('Đúng'),
              ),
              TextButton(
                onPressed: () =>
                    controller.sendAlertFeedback(alert.id, 'ignored'),
                child: const Text('Bỏ qua'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ProgressRow extends StatelessWidget {
  final String icon;
  final String title;
  final String subtitle;
  final double value;
  final String? trailing;
  final Color color;

  const _ProgressRow({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.value,
    this.trailing,
    this.color = Colors.teal,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: _boxDecoration(),
      child: Row(
        children: [
          CircleAvatar(
            radius: 16,
            backgroundColor: Colors.grey.shade100,
            child: Text(icon, style: const TextStyle(fontSize: 13)),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    if (trailing != null) Text(trailing!),
                  ],
                ),
                const SizedBox(height: 4),
                LinearProgressIndicator(
                  value: value.clamp(0.0, 1.0),
                  minHeight: 6,
                  backgroundColor: Colors.grey.shade100,
                  valueColor: AlwaysStoppedAnimation<Color>(color),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyBox extends StatelessWidget {
  final String text;

  const _EmptyBox({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: _boxDecoration(),
      child: Center(
        child: Text(text, style: TextStyle(color: Colors.grey.shade600)),
      ),
    );
  }
}

BoxDecoration _boxDecoration() {
  return BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(12),
    border: Border.all(color: Colors.grey.shade200),
  );
}
