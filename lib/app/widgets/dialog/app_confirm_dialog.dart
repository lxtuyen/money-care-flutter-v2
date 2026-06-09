import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:money_care/app/widgets/button/app_outline_button.dart';
import 'package:money_care/core/constants/colors.dart';
import 'package:money_care/core/theme/app_theme_colors.dart';
import 'package:money_care/app/widgets/button/primary_button.dart';

enum ConfirmDialogType { danger, warning, info }

class AppConfirmDialog extends StatelessWidget {
  final String? title;
  final String message;
  final String confirmText;
  final String cancelText;
  final VoidCallback onConfirm;
  final VoidCallback? onCancel;
  final ConfirmDialogType type;

  const AppConfirmDialog({
    super.key,
    this.title,
    required this.message,
    this.confirmText = 'Xác nhận',
    this.cancelText = 'Hủy',
    required this.onConfirm,
    this.onCancel,
    this.type = ConfirmDialogType.danger,
  });

  static void show({
    String? title,
    required String message,
    String confirmText = 'Xác nhận',
    String cancelText = 'Hủy',
    required VoidCallback onConfirm,
    VoidCallback? onCancel,
    ConfirmDialogType type = ConfirmDialogType.danger,
  }) {
    Get.dialog(
      AppConfirmDialog(
        title: title,
        message: message,
        confirmText: confirmText,
        cancelText: cancelText,
        onConfirm: onConfirm,
        onCancel: onCancel,
        type: type,
      ),
      barrierDismissible: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppThemeColors.of(context);

    IconData iconData;
    Color iconColor;
    Color btnColor;

    switch (type) {
      case ConfirmDialogType.danger:
        iconData = Icons.error_outline_rounded;
        iconColor = Colors.redAccent;
        btnColor = Colors.redAccent;
        break;
      case ConfirmDialogType.warning:
        iconData = Icons.warning_amber_rounded;
        iconColor = Colors.orangeAccent;
        btnColor = Colors.orangeAccent;
        break;
      case ConfirmDialogType.info:
        iconData = Icons.info_outline_rounded;
        iconColor = AppColors.primary;
        btnColor = AppColors.primary;
        break;
    }

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
      backgroundColor: Colors.transparent,
      elevation: 0,
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: colors.cardBackground,
          borderRadius: BorderRadius.circular(28),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: iconColor.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(iconData, color: iconColor, size: 40),
            ),
            const SizedBox(height: 20),
            if (title != null) ...[
              Text(
                title!,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: colors.textPrimary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
            ],
            Text(
              message,
              style: TextStyle(
                fontSize: 15,
                color: colors.textSecondary,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            Row(
              children: [
                Expanded(
                  child: AppOutlineButton(
                    label: '',
                    onPressed: () {
                      Get.back();
                      onCancel?.call();
                    },
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      side: BorderSide(
                        color: colors.textMuted.withValues(alpha: 0.3),
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: Text(
                      cancelText,
                      style: TextStyle(
                        color: colors.textSecondary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: PrimaryButton(
                    label: confirmText,
                    onPressed: () {
                      Get.back();
                      onConfirm();
                    },
                    backgroundColor: btnColor,
                    textColor: Colors.white,
                    height: 48,
                    fontSize: 14,
                    borderRadius: 14,
                    elevation: 0,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
