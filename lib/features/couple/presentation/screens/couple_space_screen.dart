import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:money_care/app/widgets/layout/app_header.dart';
import 'package:money_care/features/auth/presentation/controllers/auth_controller.dart';
import 'package:money_care/features/couple/domain/entities/couple_entity.dart';
import 'package:money_care/features/couple/presentation/controllers/couple_controller.dart';
import 'package:money_care/features/couple/presentation/widgets/active_couple_view.dart';
import 'package:money_care/features/couple/presentation/widgets/not_connected_view.dart';
import 'package:money_care/features/couple/presentation/widgets/pending_invitation_view.dart';
import 'package:money_care/features/couple/presentation/widgets/couple_dashboard_view.dart';
import 'package:money_care/features/couple/presentation/widgets/couple_transactions_view.dart';

import 'package:money_care/features/couple/presentation/widgets/couple_savings_view.dart';

class CoupleSpaceScreen extends GetView<CoupleController> {
  const CoupleSpaceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final coupleData = controller.couple.value;
      final showBottomBar = coupleData != null && coupleData.isActive;
      final isTransactionsTab =
          showBottomBar && controller.selectedTabIndex.value == 1;

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
      }

      Widget mainContent = Column(
        children: [
          AppHeader(
            title: showBottomBar
                ? _getTabTitle(controller.selectedTabIndex.value)
                : 'Không Gian Cặp Đôi',
            showBackButton: true,
            height: 180,
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
        mainContent = DefaultTabController(length: 2, child: mainContent);
      }

      return Scaffold(
        bottomNavigationBar: showBottomBar
            ? BottomNavigationBar(
                currentIndex: controller.selectedTabIndex.value,
                onTap: (index) => controller.selectedTabIndex.value = index,
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
                    icon: Icon(Icons.settings_rounded),
                    label: 'Cài đặt',
                  ),
                ],
              )
            : null,
        body: SafeArea(top: false, child: mainContent),
      );
    });
  }

  String _getTabTitle(int index) {
    switch (index) {
      case 0:
        return 'Tổng Quan Cặp Đôi';
      case 1:
        return 'Giao Dịch Chung';
      case 2:
        return 'Quỹ Tiết Kiệm Chung';
      case 3:
        return 'Cài Đặt Cặp Đôi';
      default:
        return 'Không Gian Cặp Đôi';
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
}
