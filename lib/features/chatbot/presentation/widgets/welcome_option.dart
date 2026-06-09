import 'package:flutter/material.dart';
import 'package:money_care/core/constants/colors.dart';
import 'package:money_care/core/constants/image_string.dart';
import 'package:money_care/features/chatbot/domain/entities/entities.dart';

class WelcomeOptions extends StatelessWidget {
  final List<QuickOption> options;
  final void Function(String template) onTapFill;
  final Future<void> Function(String template) onTapSend;

  const WelcomeOptions({
    super.key,
    required this.options,
    required this.onTapFill,
    required this.onTapSend,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.08),
                shape: BoxShape.circle,
              ),
              child: ClipOval(
                child: Image.asset(
                  AppImages.logo,
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Money Care AI',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w800,
                color: AppColors.text1,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Chào mừng bạn đến với trợ lý tài chính AI! Tôi có thể giúp bạn ghi chép chi tiêu cực nhanh, phân tích xu hướng chi tiêu hoặc đề xuất ngân sách thông minh.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: AppColors.text3,
                height: 1.6,
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.arrow_downward_rounded,
                  size: 16,
                  color: AppColors.text5.withValues(alpha: 0.8),
                ),
                const SizedBox(width: 8),
                Text(
                  'Chọn một gợi ý nhanh bên dưới để bắt đầu',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: AppColors.text5.withValues(alpha: 0.8),
                  ),
                ),
                const SizedBox(width: 8),
                Icon(
                  Icons.arrow_downward_rounded,
                  size: 16,
                  color: AppColors.text5.withValues(alpha: 0.8),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
