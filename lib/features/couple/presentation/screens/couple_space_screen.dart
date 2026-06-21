import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:money_care/features/payment/presentation/widgets/premium_gate_widget.dart';
import 'package:money_care/app/widgets/layout/app_header.dart';
import 'package:money_care/core/constants/route_path.dart';
import 'package:money_care/core/constants/colors.dart';
import 'package:money_care/features/auth/presentation/controllers/auth_controller.dart';
import 'package:money_care/features/couple/domain/entities/couple_entity.dart';
import 'package:money_care/features/couple/presentation/controllers/couple_controller.dart';
import 'package:money_care/features/couple/presentation/widgets/active_couple_view.dart';
import 'package:money_care/features/couple/presentation/widgets/not_connected_view.dart';
import 'package:money_care/features/couple/presentation/widgets/pending_invitation_view.dart';
import 'package:money_care/features/couple/presentation/widgets/couple_dashboard_view.dart';
import 'package:money_care/features/couple/presentation/widgets/couple_transactions_view.dart';

import 'package:money_care/features/couple/presentation/widgets/couple_savings_view.dart';
import 'package:money_care/features/couple/presentation/widgets/couple_chat_view.dart';

class CoupleSpaceScreen extends GetView<CoupleController> {
  const CoupleSpaceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final coupleData = controller.couple.value;
      final showBottomBar = coupleData != null && coupleData.isActive;
      final isTransactionsTab =
          showBottomBar && controller.selectedTabIndex.value == 1;
      final isSavingsTab =
          showBottomBar && controller.selectedTabIndex.value == 2;

      Widget? headerChild;
      if (isTransactionsTab) {
        headerChild = TabBar(
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white.withValues(alpha: 0.7),
          indicatorColor: Colors.white,
          indicatorWeight: 3,
          indicatorSize: TabBarIndicatorSize.label,
          labelStyle: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 13,
          ),
          unselectedLabelStyle: const TextStyle(fontSize: 13),
          tabs: const [
            Tab(text: 'Lịch sử giao dịch'),
            Tab(text: 'Quyết toán & Chia tiền'),
          ],
        );
      } else if (isSavingsTab) {
        headerChild = TabBar(
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white.withValues(alpha: 0.7),
          indicatorColor: Colors.white,
          indicatorWeight: 3,
          indicatorSize: TabBarIndicatorSize.label,
          labelStyle: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 13,
          ),
          unselectedLabelStyle: const TextStyle(fontSize: 13),
          tabs: const [
            Tab(text: 'Đang hoạt động'),
            Tab(text: 'Đã hoàn thành'),
          ],
        );
      }

      Widget mainContent = Column(
        children: [
          AppHeader(
            title: showBottomBar
                ? _getTabTitle(controller.selectedTabIndex.value)
                : 'Không Gian Chung',
            showBackButton: true,
            height: 180,
            actions: showBottomBar && controller.selectedTabIndex.value == 0
                ? [
                    _buildNotificationBadge(context),
                  ]
                : null,
            child: headerChild,
          ),
          Expanded(
            child: controller.isLoading.value
                ? const Center(child: CircularProgressIndicator())
                : _buildBody(context, coupleData),
          ),
        ],
      );

      if (isTransactionsTab) {
        mainContent = DefaultTabController(
          key: ValueKey('transaction_tab_${controller.selectedSubTabIndex.value}'),
          length: 2,
          initialIndex: controller.selectedSubTabIndex.value,
          child: mainContent,
        );
      } else if (isSavingsTab) {
        mainContent = DefaultTabController(
          length: 2,
          child: mainContent,
        );
      }

      return Scaffold(
        bottomNavigationBar: showBottomBar
            ? BottomNavigationBar(
                currentIndex: controller.selectedTabIndex.value,
                onTap: (index) {
                  controller.selectedTabIndex.value = index;
                  if (index == 1) {
                    controller.selectedSubTabIndex.value = 0;
                  }
                },
                type: BottomNavigationBarType.fixed,
                selectedItemColor: Theme.of(context).primaryColor,
                unselectedItemColor: Colors.grey,
                selectedLabelStyle: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 11,
                ),
                unselectedLabelStyle: const TextStyle(fontSize: 11),
                items: const [
                  BottomNavigationBarItem(
                    icon: Icon(Icons.favorite_rounded),
                    label: 'Tổng quan',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.receipt_long_rounded),
                    label: 'Giao dịch',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.savings_rounded),
                    label: 'Tiết kiệm',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.chat_bubble_rounded),
                    label: 'Trò chuyện',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.settings_rounded),
                    label: 'Cài đặt',
                  ),
                ],
              )
            : null,
        body: SafeArea(
          top: false,
          child: PremiumGateWidget(
            featureName: 'Không gian cặp đôi',
            child: mainContent,
          ),
        ),
      );
    });
  }

  String _getTabTitle(int index) {
    switch (index) {
      case 0:
        return 'Tổng Quan';
      case 1:
        return 'Giao Dịch';
      case 2:
        return 'Quỹ Tiết Kiệm';
      case 3:
        return 'Trò Chuyện';
      case 4:
        return 'Cài Đặt';
      default:
        return 'Không Gian Chung';
    }
  }

  Widget _buildBody(BuildContext context, CoupleEntity? coupleData) {
    final authController = Get.find<AuthController>();
    final currentUserId = authController.user.value?.id ?? 0;

    if (coupleData == null) {
      return NotConnectedView(controller: controller);
    }

    if (coupleData.isPending) {
      return PendingInvitationView(couple: coupleData, controller: controller);
    }

    if (coupleData.isActive) {
      switch (controller.selectedTabIndex.value) {
        case 0:
          return CoupleDashboardView(controller: controller);
        case 1:
          return CoupleTransactionsView(controller: controller);
        case 2:
          return CoupleSavingsView(controller: controller);
        case 3:
          return CoupleChatView(controller: controller);
        case 4:
          return ActiveCoupleView(
            couple: coupleData,
            controller: controller,
            currentUserId: currentUserId,
          );
        default:
          return CoupleDashboardView(controller: controller);
      }
    }

    // Fallback to not connected if status is cancelled or left
    return NotConnectedView(controller: controller);
  }

  Widget _buildNotificationBadge(BuildContext context) {
    const notificationAlertTypes = {
      'budget_exceeded',
      'low_wallet_balance',
      'shared_overspend',
      'couple_forecast_overspend',
      'couple_category_surge',
    };

    return Obx(() {
      final report = controller.coupleReport.value;
      final count = report == null
          ? 0
          : report.alerts
              .where(
                (a) =>
                    notificationAlertTypes.contains(a.type) && !a.isRead,
              )
              .length;

      return GestureDetector(
        onTap: () => Get.toNamed(RoutePath.notification),
        child: Container(
          margin: const EdgeInsets.only(right: 16),
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.16),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.2),
            ),
          ),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              const Icon(
                Icons.notifications_outlined,
                color: Colors.white,
                size: 22,
              ),
              if (count > 0)
                Positioned(
                  right: -6,
                  top: -6,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: AppColors.expense,
                      shape: BoxShape.circle,
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 16,
                      minHeight: 16,
                    ),
                    child: Text(
                      count > 99 ? '99+' : '$count',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 8,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          ),
        ),
      );
    });
  }
}
