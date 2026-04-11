import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:money_care/core/constants/colors.dart';
import 'package:money_care/core/constants/route_path.dart';
import 'package:money_care/app/controllers/app_controller.dart';
import 'package:money_care/app/widgets/icon/app_svg_icon.dart';
import 'package:money_care/app/router/nav_controller.dart';
import 'package:money_care/features/home/presentation/screens/home.dart';
import 'package:money_care/app/controllers/fund_controller.dart';
import 'package:money_care/features/fund/presentation/widgets/expired_fund_popup.dart';
import 'package:money_care/features/statistics/presentation/screens/statistics.dart';
import 'package:money_care/features/transaction/presentation/screens/transaction_history_screen.dart';
import 'package:money_care/features/user/presentation/screens/user_center.dart';

class ScaffoldWithNavBar extends StatefulWidget {
  const ScaffoldWithNavBar({super.key});

  @override
  State<ScaffoldWithNavBar> createState() => _ScaffoldWithNavBarState();
}

class _ScaffoldWithNavBarState extends State<ScaffoldWithNavBar> {
  bool _isSidebarExpanded = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _checkExpiredFund());
  }

  Future<void> _checkExpiredFund() async {
    try {
      final fundController = Get.find<FundController>();
      final appController = Get.find<AppController>();
      final userId = appController.userId.value;
      if (userId == null) return;

      await fundController.checkExpiredFund(userId);

      if (fundController.hasExpiredFund.value &&
          fundController.expiredFund.value != null) {
        ExpiredFundPopup.show(fundController.expiredFund.value!);
      }
    } catch (_) {
      
    }
  }

  static const _screens = [
    HomeScreen(),
    TransactionHistoryScreen(),
    StatisticsScreen(),
    UserCenterScreen(),
  ];

  static const _navItems = [
    _NavItem(icon: 'home', activeIcon: 'home-active', label: 'Trang chủ'),
    _NavItem(
      icon: 'transaction',
      activeIcon: 'transaction-active',
      label: 'Thu - chi',
    ),
    _NavItem(
      icon: 'chart',
      activeIcon: 'chart-active',
      label: 'Thống kê',
    ),
    _NavItem(icon: 'user', activeIcon: 'user-active', label: 'Cá nhân'),
  ];

  @override
  Widget build(BuildContext context) {
    final NavController controller = Get.put(NavController());
    final bool isWeb = MediaQuery.of(context).size.width > 800;
    final bool isKeyboardVisible = MediaQuery.of(context).viewInsets.bottom > 0;

    return Obx(() {
      final currentIndex = controller.selectedIndex.value;

      return Scaffold(
        resizeToAvoidBottomInset: true,
        floatingActionButton:
            isWeb
                ? null
                : IgnorePointer(
                  ignoring: isKeyboardVisible,
                  child: AnimatedSlide(
                    duration: const Duration(milliseconds: 120),
                    curve: Curves.easeOut,
                    offset:
                        isKeyboardVisible ? const Offset(0, 1.2) : Offset.zero,
                    child: AnimatedOpacity(
                      duration: const Duration(milliseconds: 90),
                      opacity: isKeyboardVisible ? 0 : 1,
                      child: FloatingActionButton(
                        onPressed: () => _showTransactionOptions(context),
                        elevation: 8,
                        shape: const CircleBorder(),
                        backgroundColor: AppColors.primary,
                        child: const Icon(
                          Icons.add,
                          size: 30,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        body: SafeArea(
          child: Row(
            children: [
              if (isWeb) _buildSidebar(controller, currentIndex, context),
              Expanded(
                child: IndexedStack(index: currentIndex, children: _screens),
              ),
            ],
          ),
        ),
        bottomNavigationBar:
            isWeb
                ? null
                : _buildMobileBottomBar(controller, currentIndex, context),
      );
    });
  }

  Widget _buildSidebar(
    NavController controller,
    int currentIndex,
    BuildContext context,
  ) {
    return AnimatedContainer(
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
              itemCount: _navItems.length,
              itemBuilder: (_, index) {
                final isActive = currentIndex == index;
                final item = _navItems[index];
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
                        isActive ? AppColors.primary.withOpacity(0.08) : null,
                    leading: AppSvgIcon(
                      iconName: isActive ? item.activeIcon : item.icon,
                      width: 24,
                    ),
                    title:
                        _isSidebarExpanded
                            ? Text(
                              item.label,
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
                          'Thêm giao dịch',
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
    );
  }

  Widget _buildMobileBottomBar(
    NavController controller,
    int currentIndex,
    BuildContext context,
  ) {
    final leftItems = _navItems.take(2).toList();
    final rightItems = _navItems.skip(2).toList();

    return SafeArea(
      top: false,
      child: Container(
        margin: const EdgeInsets.fromLTRB(12, 0, 12, 10),
        padding: const EdgeInsets.fromLTRB(10, 10, 10, 12),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.96),
          borderRadius: BorderRadius.circular(28),
          border: Border.all(color: AppColors.borderSecondary),
          boxShadow: [
            BoxShadow(
              color: AppColors.text1.withOpacity(0.08),
              blurRadius: 24,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Row(
          children: [
            ...List.generate(leftItems.length, (index) {
              final item = leftItems[index];
              return Expanded(
                child: _buildNavItem(
                  item: item,
                  isActive: index == currentIndex,
                  onTap: () => controller.changeTab(index),
                ),
              );
            }),
            const SizedBox(width: 56),
            ...List.generate(rightItems.length, (index) {
              final actualIndex = index + 2;
              final item = rightItems[index];
              return Expanded(
                child: _buildNavItem(
                  item: item,
                  isActive: actualIndex == currentIndex,
                  onTap: () => controller.changeTab(actualIndex),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required _NavItem item,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color:
                    isActive
                        ? AppColors.primary.withOpacity(0.12)
                        : Colors.transparent,
                borderRadius: BorderRadius.circular(16),
              ),
              child: AppSvgIcon(
                iconName: isActive ? item.activeIcon : item.icon,
                width: 24,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              item.label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 12,
                fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
                color: isActive ? AppColors.text1 : AppColors.text4,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showTransactionOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return SafeArea(
          child: Container(
            margin: const EdgeInsets.fromLTRB(12, 0, 12, 12),
            padding: const EdgeInsets.fromLTRB(18, 12, 18, 20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(28),
              boxShadow: [
                BoxShadow(
                  color: AppColors.text1.withOpacity(0.1),
                  blurRadius: 28,
                  offset: const Offset(0, 12),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 42,
                  height: 5,
                  decoration: BoxDecoration(
                    color: AppColors.borderPrimary,
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
                const SizedBox(height: 18),
                const Text(
                  'Thêm giao dịch',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: AppColors.text1,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Chọn loại giao dịch bạn muốn tạo mới.',
                  style: TextStyle(fontSize: 13, color: AppColors.text4),
                ),
                const SizedBox(height: 18),
                _buildTransactionOptionTile(
                  icon: Icons.north_east_rounded,
                  iconColor: AppColors.success,
                  iconBackground: AppColors.success.withOpacity(0.12),
                  title: 'Tạo thu',
                  subtitle: 'Ghi nhận khoản tiền bạn nhận được',
                  onTap: () {
                    Navigator.pop(context);
                    Get.toNamed(RoutePath.income);
                  },
                ),
                const SizedBox(height: 12),
                _buildTransactionOptionTile(
                  icon: Icons.south_east_rounded,
                  iconColor: AppColors.secondaryOrange,
                  iconBackground: AppColors.secondaryOrange.withOpacity(0.12),
                  title: 'Tạo chi',
                  subtitle: 'Ghi lại khoản chi tiêu của bạn',
                  onTap: () {
                    Navigator.pop(context);
                    Get.toNamed(RoutePath.expense);
                  },
                ),
                const SizedBox(height: 12),
                _buildTransactionOptionTile(
                  icon: Icons.add_a_photo_outlined,
                  iconColor: AppColors.secondaryNavyBlue,
                  iconBackground: AppColors.primary.withOpacity(0.12),
                  title: 'Bản ghi kèm ảnh',
                  subtitle: 'Chụp ảnh, nhập số tiền và lưu giao dịch nhanh',
                  onTap: () {
                    Navigator.pop(context);
                    Get.toNamed(RoutePath.transactionWithImage);
                  },
                ),
                const SizedBox(height: 12),
                _buildTransactionOptionTile(
                  icon: Icons.smart_toy_outlined,
                  iconColor: AppColors.primary,
                  iconBackground: AppColors.primary.withOpacity(0.12),
                  title: 'Chat với AI',
                  subtitle: 'Nhờ trợ lý AI giúp bạn quản lý tài chính',
                  onTap: () {
                    Navigator.pop(context);
                    Get.toNamed(RoutePath.chatbot);
                  },
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.text2,
                      side: const BorderSide(color: AppColors.borderSecondary),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: const Text('Đóng'),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildTransactionOptionTile({
    required IconData icon,
    required Color iconColor,
    required Color iconBackground,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Ink(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.borderSecondary),
          ),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: iconBackground,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(icon, color: iconColor),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: AppColors.text1,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        fontSize: 13,
                        color: AppColors.text4,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.arrow_forward_ios_rounded,
                size: 16,
                color: AppColors.text5,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavItem {
  final String icon;
  final String activeIcon;
  final String label;

  const _NavItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
  });
}
