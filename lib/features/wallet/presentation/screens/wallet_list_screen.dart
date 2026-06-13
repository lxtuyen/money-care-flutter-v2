import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:money_care/app/widgets/button/primary_button.dart';
import 'package:money_care/app/widgets/layout/app_header.dart';
import 'package:money_care/core/theme/app_theme_colors.dart';
import 'package:money_care/features/wallet/presentation/controllers/wallet_controller.dart';
import 'package:money_care/core/utils/helper/helper_functions.dart';
import 'package:money_care/core/constants/route_path.dart';
import 'package:money_care/core/constants/colors.dart';
import 'package:money_care/app/widgets/states/app_empty_state.dart';
import 'package:money_care/app/widgets/button/app_action_button.dart';
import 'package:money_care/features/wallet/presentation/widgets/wallet_card.dart';

class WalletListScreen extends GetView<WalletController> {
  const WalletListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = AppThemeColors.of(context);

    return Scaffold(
      backgroundColor: colors.surfaceBackground,
      body: Column(
        children: [
          AppHeader(
            title: "Ví của tôi",
            showBackButton: true,
            height: 180,
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Obx(() {
                final total = controller.totalAssets.value;
                return Text(
                  AppHelperFunction.formatAmount(total),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 36,
                    fontWeight: FontWeight.w900,
                    letterSpacing: -0.5,
                  ),
                );
              }),
            ),
          ),

          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
            child: Row(
              children: [
                Expanded(
                  child: AppActionButton(
                    onTap: () => Get.toNamed(RoutePath.walletTransfer),
                    icon: Icons.swap_horiz,
                    label: "Chuyển tiền",
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: AppActionButton(
                    onTap: () => controller.createWallet(),
                    icon: Icons.add_circle_outline_rounded,
                    label: "Thêm ví",
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value && controller.wallets.isEmpty) {
                return const Center(child: CircularProgressIndicator());
              }

              if (controller.wallets.isEmpty) {
                return AppEmptyState(
                  message: "Bạn chưa có ví nào",
                  action: PrimaryButton(
                    label: "Tạo ví ngay",
                    onPressed: () => controller.createWallet(),
                    backgroundColor: AppColors.primary,
                    width: 160,
                    height: 48,
                    borderRadius: 12,
                    fontSize: 14,
                    elevation: 0,
                  ),
                );
              }

              return ListView.builder(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                itemCount: controller.wallets.length,
                itemBuilder: (context, index) {
                  final wallet = controller.wallets[index];
                  return WalletCard(wallet: wallet);
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}
