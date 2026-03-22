import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import 'package:money_care/core/constants/colors.dart';
import 'package:money_care/core/router/nav_controller.dart';
import 'package:money_care/features/home/presentation/screens/home.dart';
import 'package:money_care/features/statistics/presentation/screens/statistics.dart';
import 'package:money_care/features/transaction/presentation/screens/transaction.dart';
import 'package:money_care/features/user/presentation/screens/user_center.dart';

class ScaffoldWithNavBar extends StatefulWidget {
  const ScaffoldWithNavBar({super.key});

  @override
  State<ScaffoldWithNavBar> createState() => _ScaffoldWithNavBarState();
}

class _ScaffoldWithNavBarState extends State<ScaffoldWithNavBar> {
  bool _isSidebarExpanded = true;

  @override
  Widget build(BuildContext context) {
    final NavController controller = Get.put(NavController());
    final bool isWeb = MediaQuery.of(context).size.width > 800;

    const screens = [
      HomeScreen(),
      TransactionScreen(),
      StatisticsScreen(),
      UserCenterScreen(),
    ];

    final navItems = [
      {'icon': 'home', 'label': 'Trang chá»§'},
      {'icon': 'transaction', 'label': 'Thu - chi'},
      {'icon': 'chart', 'label': 'Thá»‘ng kÃª'},
      {'icon': 'user', 'label': 'CÃ¡ nhÃ¢n'},
    ];

    return Obx(() {
      final currentIndex = controller.selectedIndex.value;

      return Scaffold(
        floatingActionButton:
            isWeb
                ? null
                : FloatingActionButton(
                  onPressed: () => _showTransactionOptions(context),
                  shape: const CircleBorder(),
                  backgroundColor: AppColors.primary,
                  child: const Icon(Icons.add, size: 32, color: Colors.white),
                ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

        body: SafeArea(
          child: Row(
            children: [
              if (isWeb)
                AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  width: _isSidebarExpanded ? 240 : 80,
                  color: AppColors.white,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(12),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            if (_isSidebarExpanded)
                              const Text(
                                'Money Care',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primary,
                                ),
                              ),
                            IconButton(
                              icon: Icon(
                                _isSidebarExpanded
                                    ? Icons.chevron_left
                                    : Icons.chevron_right,
                                color: AppColors.primary,
                              ),
                              onPressed: () {
                                setState(() {
                                  _isSidebarExpanded = !_isSidebarExpanded;
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                      const Divider(height: 1),
                      Expanded(
                        child: ListView.builder(
                          itemCount: navItems.length,
                          itemBuilder: (_, index) {
                            final isActive = currentIndex == index;
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 6,
                              ),
                              child: ListTile(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                tileColor:
                                    isActive
                                        ? AppColors.primary.withOpacity(0.08)
                                        : null,
                                leading: SvgPicture.asset(
                                  isActive
                                      ? 'assets/icons/${navItems[index]['icon']}-active.svg'
                                      : 'assets/icons/${navItems[index]['icon']}.svg',
                                  width: 24,
                                ),
                                title:
                                    _isSidebarExpanded
                                        ? Text(
                                          navItems[index]['label']!,
                                          style: TextStyle(
                                            color:
                                                isActive
                                                    ? AppColors.primary
                                                    : AppColors.text4,
                                            fontWeight:
                                                isActive
                                                    ? FontWeight.w600
                                                    : FontWeight.w400,
                                          ),
                                        )
                                        : null,
                                onTap: () => controller.changeTab(index),
                              ),
                            );
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(12),
                        child: SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: () => _showTransactionOptions(context),
                            icon: const Icon(Icons.add, color: Colors.white),
                            label:
                                _isSidebarExpanded
                                    ? const Text(
                                      'ThÃªm giao dá»‹ch',
                                      style: TextStyle(color: Colors.white),
                                    )
                                    : const SizedBox.shrink(),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

              // ====================== MAIN CONTENT ======================
              Expanded(
                child: Stack(
                  children: [
                    IndexedStack(index: currentIndex, children: screens),

                    // ====================== CHATBOT FLOATING ======================
                    Positioned(
                      right: 16,
                      bottom: 16,
                      child: GestureDetector(
                        onTap: () => Get.toNamed('/chatbot'),
                        child: Material(
                          elevation: 10,
                          shape: const CircleBorder(),
                          child: ClipOval(
                            child: Container(
                              width: 62,
                              height: 62,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.white,
                                  width: 1,
                                ),
                              ),
                              child: Image.asset(
                                'assets/images/ai.gif',
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        // ====================== BOTTOM NAV (MOBILE) ======================
        bottomNavigationBar:
            isWeb
                ? null
                : NavigationBar(
                  height: 80,
                  selectedIndex: currentIndex,
                  onDestinationSelected: controller.changeTab,
                  destinations:
                      navItems.map((item) {
                        return NavigationDestination(
                          icon: SvgPicture.asset(
                            'assets/icons/${item['icon']}.svg',
                            width: 24,
                          ),
                          label: item['label']!,
                        );
                      }).toList(),
                ),
      );
    });
  }

  void _showTransactionOptions(BuildContext context) {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) {
        return CupertinoActionSheet(
          title: const Text('Chá»n loáº¡i giao dá»‹ch'),
          actions: <CupertinoActionSheetAction>[
            CupertinoActionSheetAction(
              onPressed: () {
                Navigator.pop(context);
                Get.toNamed('/income');
              },
              child: const Text('Táº¡o thu'),
            ),
            CupertinoActionSheetAction(
              onPressed: () {
                Navigator.pop(context);
                Get.toNamed('/expense');
              },
              child: const Text('Táº¡o chi'),
            ),
          ],
          cancelButton: CupertinoActionSheetAction(
            isDestructiveAction: true,
            onPressed: () => Navigator.pop(context),
            child: const Text('Há»§y bá»'),
          ),
        );
      },
    );
  }
}
