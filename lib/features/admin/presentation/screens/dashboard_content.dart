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
