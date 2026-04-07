import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:money_care/core/constants/colors.dart';
import 'package:money_care/core/constants/route_path.dart';
import 'package:money_care/features/onboarding/presentation/controllers/onboarding_controller.dart';

/// Banner hiển thị trong ProfileScreen khi người dùng có bước onboarding bị bỏ qua.
///
/// Cho phép người dùng quay lại hoàn thành thiết lập từ màn hình hồ sơ.
/// Requirements: 1.4
class CompleteSetupBannerWidget extends StatelessWidget {
  const CompleteSetupBannerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final OnboardingController? controller =
        Get.isRegistered<OnboardingController>()
            ? Get.find<OnboardingController>()
            : null;

    if (controller == null) return const SizedBox.shrink();

    return Obx(() {
      if (!controller.hasSkippedSteps) return const SizedBox.shrink();

      final skipped = controller.skippedStepsList;
      final firstSkipped = skipped.first;

      return Container(
        width: double.infinity,
        margin: const EdgeInsets.only(bottom: 24),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.warning.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: AppColors.warning.withOpacity(0.4),
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.info_outline,
                  color: AppColors.warning,
                  size: 20,
                ),
                const SizedBox(width: 8),
                const Expanded(
                  child: Text(
                    'Thiết lập chưa hoàn thành',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: AppColors.text1,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              'Bạn đã bỏ qua ${skipped.length} bước. Hoàn thành thiết lập để tận dụng đầy đủ tính năng.',
              style: const TextStyle(
                fontSize: 13,
                color: AppColors.text3,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => _navigateToSkippedStep(firstSkipped),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.warning,
                  minimumSize: const Size.fromHeight(44),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  'Hoàn thành thiết lập',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }

  /// Điều hướng đến bước onboarding bị bỏ qua đầu tiên
  void _navigateToSkippedStep(OnboardingStep step) {
    switch (step) {
      case OnboardingStep.balanceSetup:
        Get.toNamed(RoutePath.onboardingBudgetSetup);
        break;
      case OnboardingStep.categorySelect:
        Get.toNamed(RoutePath.onboardingCategorySelect);
        break;
      case OnboardingStep.incomeInfo:
        Get.toNamed(RoutePath.profile);
        break;
      case OnboardingStep.welcome:
      case OnboardingStep.complete:
        Get.toNamed(RoutePath.onboardingBudgetSetup);
        break;
    }
  }
}
