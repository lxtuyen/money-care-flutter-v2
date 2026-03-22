import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:money_care/core/constants/route_path.dart';
import 'package:money_care/features/auth/presentation/controllers/auth_controller.dart';
import 'package:money_care/core/constants/image_string.dart';
import 'package:money_care/core/presentation/widgets/image/rounded_image.dart';

class SidebarMenu extends StatelessWidget {
  const SidebarMenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final AuthController authController = Get.find<AuthController>();
    final currentRoute = Get.currentRoute;

    final items = [
      _SidebarItem(
        title: 'Dashboard',
        icon: Icons.dashboard,
        route: '/admin/home',
      ),
      _SidebarItem(
        title: 'Người Dùng',
        icon: Icons.people,
        route: '/admin/users',
      ),
    ];

    return Container(
      width: 250,
      color: Colors.white,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                RoundedImage(imageUrl: AppImages.logo, height: 100, width: 100),
                const SizedBox(height: 12),
                const Text(
                  'Money Care',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),

          Expanded(
            child: ListView(
              children:
                  items.map((item) {
                    final isSelected = currentRoute == item.route;

                    return Container(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 4,
                      ),
                      child: ListTile(
                        leading: Icon(
                          item.icon,
                          color:
                              isSelected ? Colors.blue : Colors.grey.shade600,
                        ),
                        title: Text(
                          item.title,
                          style: TextStyle(
                            color:
                                isSelected ? Colors.blue : Colors.grey.shade700,
                            fontWeight:
                                isSelected
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                          ),
                        ),
                        tileColor: isSelected ? Colors.blue.shade50 : null,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        onTap: () {
                          if (!isSelected) {
                            Get.offNamed(item.route);
                          }
                        },
                      ),
                    );
                  }).toList(),
            ),
          ),

          Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.logout),
                  title: const Text('Đăng Xuất'),
                  onTap: () {
                    authController.logout();
                    Get.offAllNamed(RoutePath.loginOption);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SidebarItem {
  final String title;
  final IconData icon;
  final String route;

  const _SidebarItem({
    required this.title,
    required this.icon,
    required this.route,
  });
}
