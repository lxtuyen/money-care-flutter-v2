import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:money_care/core/constants/colors.dart';
import 'package:money_care/core/constants/route_path.dart';
import 'package:money_care/core/constants/sizes.dart';
import 'package:money_care/features/gamification/presentation/controllers/gamification_controller.dart';

class StreakDialog extends StatelessWidget {
  const StreakDialog({super.key});

  static void show() {
    Get.dialog(const StreakDialog(), barrierDismissible: false);
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<GamificationController>();
    final streak = controller.currentStreak.value;
    final progress = controller.weeklyProgress;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
      elevation: 0,
      backgroundColor: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 10),
            const Text('🔥', style: TextStyle(fontSize: 80)),
            const SizedBox(height: 10),
            Text(
              '$streak',
              style: const TextStyle(
                fontSize: 72,
                fontWeight: FontWeight.w900,
                color: Color(0xFFFF9500),
                height: 1,
              ),
            ),
            const Text(
              'ngày chuỗi',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w500,
                color: Color(0xFFFF9500),
              ),
            ),
            const SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(7, (index) {
                final days = [
                  'Th 2',
                  'Th 3',
                  'Th 4',
                  'Th 5',
                  'Th 6',
                  'Th 7',
                  'CN',
                ];
                final hasTx = progress[index];
                final isToday = DateTime.now().weekday == (index + 1);

                return Column(
                  children: [
                    Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        color: hasTx
                            ? const Color(0xFFFFC107)
                            : Colors.transparent,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: hasTx
                              ? const Color(0xFFFFC107)
                              : Colors.grey.shade300,
                          width: 2,
                        ),
                      ),
                      child: hasTx
                          ? const Center(
                              child: Text('💰', style: TextStyle(fontSize: 12)),
                            )
                          : null,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      days[index],
                      style: TextStyle(
                        fontSize: 11,
                        color: isToday ? AppColors.text1 : AppColors.text3,
                        fontWeight: isToday ? FontWeight.w700 : FontWeight.w400,
                      ),
                    ),
                  ],
                );
              }),
            ),
            const SizedBox(height: 40),

            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: () => Get.back(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF00CED1),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  'Tiếp tục',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1.2,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),

            TextButton(
              onPressed: () {
                Get.back();
                Get.toNamed(RoutePath.streakCalendar);
              },
              child: Text(
                'Xem thành tích',
                style: TextStyle(
                  color: Colors.grey.shade500,
                  decoration: TextDecoration.underline,
                  fontSize: 13,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
