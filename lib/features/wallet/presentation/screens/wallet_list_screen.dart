import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:money_care/app/widgets/layout/app_header.dart';
import 'package:money_care/core/theme/app_theme_colors.dart';
import 'package:money_care/features/wallet/presentation/controllers/wallet_controller.dart';
import 'package:money_care/features/wallet/domain/entities/wallet_entity.dart';
import 'package:money_care/core/utils/helper/helper_functions.dart';
import 'package:money_care/core/constants/route_path.dart';
import 'package:money_care/core/constants/colors.dart';
import 'package:money_care/app/widgets/states/app_empty_state.dart';
import 'package:money_care/app/widgets/button/app_action_button.dart';

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
                  action: ElevatedButton(
                    onPressed: () => controller.createWallet(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text("Tạo ví ngay"),
                  ),
                );
              }

              return ListView.builder(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                itemCount: controller.wallets.length,
                itemBuilder: (context, index) {
                  final wallet = controller.wallets[index];
                  return _buildWalletCard(context, wallet);
                },
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildWalletCard(BuildContext context, WalletEntity wallet) {
    final colors = AppThemeColors.of(context);

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: AppColors.primary.withValues(alpha: 0.1)),
      ),
      color: colors.cardBackground,
      child: InkWell(
        onTap: () => Get.toNamed(RoutePath.walletDetail, arguments: wallet),
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Center(
                  child: Text("💰", style: TextStyle(fontSize: 26)),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      wallet.name,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: colors.textPrimary,
                        letterSpacing: 0.2,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Builder(
                      builder: (context) {
                        final activeGoals = wallet.savingGoals
                            .where((g) => !g.isCompleted)
                            .toList();
                        if (activeGoals.isEmpty) return const SizedBox.shrink();

                        return Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Row(
                            children: [
                              Icon(
                                Icons.track_changes_rounded,
                                size: 14,
                                color: AppColors.primary.withValues(alpha: 0.7),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                activeGoals.first.name,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: colors.textSecondary,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    AppHelperFunction.formatAmount(wallet.balance),
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: wallet.balance < 0
                          ? Colors.red
                          : colors.textPrimary,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
