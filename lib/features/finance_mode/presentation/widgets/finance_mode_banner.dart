import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:money_care/core/constants/colors.dart';
import 'package:money_care/core/constants/sizes.dart';
import 'package:money_care/features/finance_mode/domain/entities/finance_mode_entity.dart';
import 'package:money_care/features/finance_mode/presentation/controllers/finance_mode_controller.dart';

class FinanceModeBanner extends StatelessWidget {
  const FinanceModeBanner({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<FinanceModeController>();

    return Obx(() {
      final mode = controller.currentMode.value;
      final color = controller.themeColor.value;

      return GestureDetector(
        onTap: () => _showModeSwitchDialog(context, controller, mode),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: color.withOpacity(0.3), width: 1),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(color: color, shape: BoxShape.circle),
              ),
              const SizedBox(width: 8),
              Text(
                _modeLabel(mode),
                style: TextStyle(
                  fontSize: 12,
                  color: color,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(width: 4),
              Icon(Icons.keyboard_arrow_down_rounded, color: color, size: 16),
            ],
          ),
        ),
      );
    });
  }

  String _modeLabel(FinanceMode mode) {
    switch (mode) {
      case FinanceMode.normal:
        return 'Bình thường';
      case FinanceMode.saving:
        return 'Tiết kiệm';
      case FinanceMode.survival:
        return 'Sinh tồn';
    }
  }

  void _showModeSwitchDialog(
    BuildContext context,
    FinanceModeController controller,
    FinanceMode currentMode,
  ) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppSizes.cardRadiusLg),
        ),
      ),
      builder: (_) =>
          _ModeSwitchSheet(currentMode: currentMode, controller: controller),
    );
  }
}

class _ModeSwitchSheet extends StatelessWidget {
  final FinanceMode currentMode;
  final FinanceModeController controller;

  const _ModeSwitchSheet({required this.currentMode, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppSizes.md),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.borderPrimary,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: AppSizes.md),
          const Text(
            'Chọn chế độ tài chính',
            style: TextStyle(
              fontSize: AppSizes.fontSizeLg,
              fontWeight: FontWeight.w700,
              color: AppColors.text1,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Chọn chế độ phù hợp với tình trạng tài chính hiện tại của bạn.',
            style: TextStyle(
              fontSize: AppSizes.fontSizeSm,
              color: AppColors.text4,
            ),
          ),
          const SizedBox(height: AppSizes.md),
          _ModeOption(
            mode: FinanceMode.normal,
            label: 'Bình thường',
            description: 'Chi tiêu thoải mái, theo dõi thông thường.',
            color: AppColors.success,
            isSelected: currentMode == FinanceMode.normal,
            onTap: () {
              controller.switchMode(FinanceMode.normal);
              Navigator.pop(context);
            },
          ),
          const SizedBox(height: AppSizes.sm),
          _ModeOption(
            mode: FinanceMode.saving,
            label: 'Tiết kiệm',
            description: 'Hạn chế chi tiêu không thiết yếu.',
            color: AppColors.warning,
            isSelected: currentMode == FinanceMode.saving,
            onTap: () {
              controller.switchMode(FinanceMode.saving);
              Navigator.pop(context);
            },
          ),
          const SizedBox(height: AppSizes.sm),
          _ModeOption(
            mode: FinanceMode.survival,
            label: 'Sinh tồn',
            description: 'Chỉ chi tiêu thiết yếu, tiết kiệm tối đa.',
            color: AppColors.error,
            isSelected: currentMode == FinanceMode.survival,
            onTap: () {
              controller.switchMode(FinanceMode.survival);
              Navigator.pop(context);
            },
          ),
          const SizedBox(height: AppSizes.md),
        ],
      ),
    );
  }
}

class _ModeOption extends StatelessWidget {
  final FinanceMode mode;
  final String label;
  final String description;
  final Color color;
  final bool isSelected;
  final VoidCallback onTap;

  const _ModeOption({
    required this.mode,
    required this.label,
    required this.description,
    required this.color,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(AppSizes.md),
        decoration: BoxDecoration(
          color: isSelected ? color.withOpacity(0.08) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? color : AppColors.borderSecondary,
            width: 1.5,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 14,
              height: 14,
              decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            ),
            const SizedBox(width: AppSizes.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: AppSizes.fontSizeSm,
                      fontWeight: FontWeight.w700,
                      color: isSelected ? color : AppColors.text1,
                    ),
                  ),
                  Text(
                    description,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.text4,
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              Icon(
                Icons.check_circle_rounded,
                color: color,
                size: AppSizes.iconMd,
              ),
          ],
        ),
      ),
    );
  }
}
