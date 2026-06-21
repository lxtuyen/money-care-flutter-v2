import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:money_care/core/constants/colors.dart';
import 'package:money_care/core/theme/app_theme_colors.dart';
import 'package:money_care/app/controllers/app_controller.dart';

/// Widget overlay hiển thị khi user truy cập tính năng Premium mà chưa mua.
/// Wrap quanh content cần bảo vệ.
///
/// ```dart
/// PremiumGateWidget(
///   featureName: 'Không gian cặp đôi',
///   child: CoupleSpaceContent(),
/// )
/// ```
class PremiumGateWidget extends StatelessWidget {
  final String featureName;
  final Widget child;

  const PremiumGateWidget({
    super.key,
    required this.featureName,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final appController = Get.find<AppController>();
    final themeColors = AppThemeColors.of(context);

    return Obx(() {
      if (appController.isPremium.value) {
        return child;
      }

      return Stack(
        children: [
          // Blurred content behind
          Opacity(
            opacity: 0.3,
            child: IgnorePointer(child: child),
          ),
          // Premium gate overlay
          Positioned.fill(
            child: Container(
              color: themeColors.surfaceBackground.withValues(alpha: 0.7),
              child: Center(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 32),
                  padding: const EdgeInsets.all(28),
                  decoration: BoxDecoration(
                    color: themeColors.cardBackground,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [
                              Color(0xFF71C4FF),
                              Color(0xFF0966A7),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Icon(
                          Iconsax.crown_1,
                          size: 32,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'Tính năng Premium',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: themeColors.textPrimary,
                          fontFamily: 'BeVietnamPro',
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '$featureName là tính năng dành cho gói Premium. Nâng cấp để trải nghiệm đầy đủ.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14,
                          color: themeColors.textMuted,
                          fontFamily: 'BeVietnamPro',
                          height: 1.4,
                        ),
                      ),
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: ElevatedButton(
                          onPressed: () => Get.toNamed('/premium'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 0,
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Iconsax.crown_1, size: 18),
                              SizedBox(width: 8),
                              Text(
                                'Nâng cấp ngay',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: 'BeVietnamPro',
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      );
    });
  }
}
