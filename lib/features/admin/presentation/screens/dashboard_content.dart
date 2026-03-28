import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:money_care/features/admin/presentation/controllers/admin_controller.dart';
import 'package:money_care/features/admin/presentation/screens/widgets/stat_card.dart';

class DashboardContent extends StatefulWidget {
  const DashboardContent({super.key});

  @override
  State<DashboardContent> createState() => _DashboardContentState();
}

class _DashboardContentState extends State<DashboardContent> {
  final AdminController adminController = Get.find<AdminController>();

  @override
  void initState() {
    super.initState();
    adminController.fetchAdminUserStats();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Dashboard',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            Obx(() {
              if (adminController.isLoadingStats.value) {
                return const Center(child: CircularProgressIndicator());
              }

              if (adminController.adminUserStats.value == null) {
                return const Center(child: Text('KhÃ´ng cÃ³ dá»¯ liá»‡u'));
              }
              final stats = adminController.adminUserStats.value;
              return GridView.count(
                crossAxisCount: 3,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  StatCard(
                    title: 'Tá»•ng Doanh Thu thÃ¡ng nÃ y',
                    value: stats!.monthlyRevenue.toString(),
                    icon: Icons.money,
                    color: Colors.green,
                  ),
                  StatCard(
                    title: 'NgÆ°á»i DÃ¹ng hiá»‡n táº¡i',
                    value: stats.totalUsers.toString(),
                    icon: Icons.people,
                    color: Colors.purple,
                  ),
                  StatCard(
                    title: 'NgÆ°á»i dÃ¹ng má»›i thÃ¡ng nÃ y',
                    value: stats.newUsersThisMonth.toString(),
                    icon: Icons.trending_down,
                    color: Colors.red,
                  ),
                ],
              );
            }),

          const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
/*
Widget _buildPieChart(double freePercent, double vipPercent) {
  return Container(
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      boxShadow: [BoxShadow(color: Colors.grey.shade200, blurRadius: 8)],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Loáº¡i ngÆ°á»i dÃ¹ng',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        Column(
          children: [
            SizedBox(
              height: 220,
              width: 200,
              child: PieChart(
                PieChartData(
                  sections: [
                    PieChartSectionData(
                      value: freePercent,
                      title: '${freePercent.toStringAsFixed(1)}%',
                      color: Colors.blue,
                      radius: 60,
                      titleStyle: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      titlePositionPercentageOffset: 0.6,
                    ),

                    PieChartSectionData(
                      value: vipPercent,
                      title: '${vipPercent.toStringAsFixed(1)}%',
                      color: Colors.green,
                      radius: 60,
                      titleStyle: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      titlePositionPercentageOffset: 0.6,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 30),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildLegendItem(
                  color: Colors.blue,
                  title: 'FREE',
                  value: freePercent,
                ),
                _buildLegendItem(
                  color: Colors.green,
                  title: 'VIP',
                  value: vipPercent,
                ),
              ],
            ),
          ],
        ),
      ],
    ),
  );
}*/

Widget _buildLegendItem({
  required Color color,
  required String title,
  required double value,
}) {
  return Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Container(
        width: 10,
        height: 10,
        decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      ),
      const SizedBox(width: 8),
      Text(
        '$title (${value.toStringAsFixed(1)}%)',
        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
      ),
    ],
  );
}
