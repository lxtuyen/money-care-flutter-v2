import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:money_care/core/utils/helper/helper_functions.dart';
import 'package:money_care/features/couple/domain/entities/couple_entity.dart';
import 'package:money_care/features/couple/presentation/controllers/couple_controller.dart';
import 'package:money_care/app/widgets/dialog/app_confirm_dialog.dart';

class PendingInvitationView extends StatelessWidget {
  final CoupleEntity couple;
  final CoupleController controller;

  const PendingInvitationView({
    super.key,
    required this.couple,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.primaryColor;

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 30),
          Container(
            height: 100,
            width: 100,
            decoration: BoxDecoration(
              color: Colors.amber.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.hourglass_empty_rounded,
              size: 50,
              color: Colors.amber,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Đang chờ kết nối',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              fontSize: 22,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Chia sẻ mã dưới đây cho đối phương để kết nối vào không gian chung của bạn.',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 40),
          
          // Code Box
          Card(
            elevation: 0,
            color: Colors.grey[50],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: BorderSide(color: Colors.grey[200]!),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 16.0),
              child: Column(
                children: [
                  Text(
                    'MÃ MỜI CỦA BẠN',
                    style: theme.textTheme.bodySmall?.copyWith(
                      letterSpacing: 1.5,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[500],
                    ),
                  ),
                  const SizedBox(height: 12),
                  SelectableText(
                    couple.inviteCode,
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 4,
                      color: primaryColor,
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton.icon(
                    onPressed: () {
                      Clipboard.setData(ClipboardData(text: couple.inviteCode));
                      AppHelperFunction.showSuccessSnackBar('Đã sao chép mã mời vào bộ nhớ tạm.');
                    },
                    icon: const Icon(Icons.copy_rounded, size: 18),
                    label: const Text('Sao chép mã'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    ),
                  ),
                  const SizedBox(height: 12),
                  OutlinedButton.icon(
                    onPressed: () => controller.loadCoupleInfo(),
                    icon: const Icon(Icons.refresh_rounded, size: 18),
                    label: const Text('Kiểm tra kết nối'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      side: BorderSide(color: primaryColor),
                      foregroundColor: primaryColor,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 40),
          
          // Cancel invite button
          OutlinedButton.icon(
            onPressed: () {
              AppConfirmDialog.show(
                title: 'Hủy lời mời?',
                message: 'Bạn có chắc chắn muốn hủy lời mời kết nối này không? Đối phương sẽ không thể tham gia bằng mã này nữa.',
                confirmText: 'Hủy',
                cancelText: 'Không',
                onConfirm: controller.cancelInvitation,
                type: ConfirmDialogType.danger,
              );
            },
            icon: const Icon(Icons.cancel_rounded, size: 18, color: Colors.red),
            label: const Text(
              'Hủy lời mời',
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
            ),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
              side: const BorderSide(color: Colors.red),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
