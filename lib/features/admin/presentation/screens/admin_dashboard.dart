import 'package:flutter/material.dart';
import 'package:money_care/features/admin/presentation/screens/widgets/sidebar.dart';

class AdminDashboard extends StatelessWidget {
  final Widget child;

  const AdminDashboard({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: Row(
        children: [
          const SidebarMenu(),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: child,
            ),
          ),
        ],
      ),
    );
  }
}
