import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:money_care/core/constants/colors.dart';
import 'package:money_care/features/gamification/presentation/controllers/streak_calendar_controller.dart';

class StreakCalendarScreen extends StatelessWidget {
  const StreakCalendarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.isRegistered<StreakCalendarController>()
        ? Get.find<StreakCalendarController>()
        : Get.put(StreakCalendarController());

    return Scaffold(
      backgroundColor: AppColors.backgroundPrimary,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18),
          color: AppColors.text1,
          onPressed: () => Get.back(),
        ),
        title: const Text(
          'Lịch Thành Tích',
          style: TextStyle(
            color: AppColors.text1,
            fontWeight: FontWeight.w700,
            fontSize: 17,
          ),
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height: 16),
          _buildMonthHeader(controller),
          const SizedBox(height: 16),
          _buildWeekdayRow(),
          const SizedBox(height: 8),
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(
                  child: CircularProgressIndicator(color: AppColors.primary),
                );
              }
              return SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  children: [
                    _buildCalendarGrid(controller),
                    const SizedBox(height: 16),
                    _buildLegend(),
                    const SizedBox(height: 24),
                  ],
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildMonthHeader(StreakCalendarController controller) {
    return Obx(() {
      final monthName = DateFormat('MMMM yyyy', 'vi_VN').format(controller.focusedMonth.value);
      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _NavButton(
              icon: Icons.chevron_left_rounded,
              onTap: controller.prevMonth,
            ),
            Text(
              monthName,
              style: const TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 16,
                color: AppColors.text1,
              ),
            ),
            _NavButton(
              icon: Icons.chevron_right_rounded,
              onTap: controller.nextMonth,
            ),
          ],
        ),
      );
    });
  }

  Widget _buildWeekdayRow() {
    const labels = ['T2', 'T3', 'T4', 'T5', 'T6', 'T7', 'CN'];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: labels
            .map(
              (l) => Expanded(
                child: Center(
                  child: Text(
                    l,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.text4,
                    ),
                  ),
                ),
              ),
            )
            .toList(),
      ),
    );
  }

  Widget _buildCalendarGrid(StreakCalendarController controller) {
    final focus = controller.focusedMonth.value;
    final firstDay = DateTime(focus.year, focus.month, 1);
    final daysInMonth = DateTime(focus.year, focus.month + 1, 0).day;
    final startOffset = firstDay.weekday - 1; // Mon=0

    final totalCells = startOffset + daysInMonth;
    final rows = (totalCells / 7).ceil();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: GridView.builder(
          padding: const EdgeInsets.all(12),
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 7,
            childAspectRatio: 0.68,
          ),
          itemCount: rows * 7,
          itemBuilder: (context, index) {
            final dayNum = index - startOffset + 1;
            if (dayNum < 1 || dayNum > daysInMonth) {
              return const SizedBox.shrink();
            }

            final hasTx = controller.daysWithTx.contains(dayNum);
            final net = controller.dailyNet[dayNum] ?? 0;
            final isToday = controller.isToday(dayNum);

            return _DayCell(
              day: dayNum,
              hasTx: hasTx,
              net: net,
              isToday: isToday,
            );
          },
        ),
      ),
    );
  }

  Widget _buildLegend() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _LegendItem(
            color: const Color(0xFFFFF3E0),
            borderColor: const Color(0xFFFFB300),
            label: 'Có giao dịch',
            icon: '🔥',
          ),
          const SizedBox(width: 24),
          _LegendItem(
            color: AppColors.primary,
            label: 'Hôm nay',
            isToday: true,
          ),
        ],
      ),
    );
  }
}

class _NavButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _NavButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppColors.backgroundPrimary,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: AppColors.text2, size: 20),
      ),
    );
  }
}

class _DayCell extends StatelessWidget {
  final int day;
  final bool hasTx;
  final int net;
  final bool isToday;

  const _DayCell({
    required this.day,
    required this.hasTx,
    required this.net,
    required this.isToday,
  });

  @override
  Widget build(BuildContext context) {
    final formatter = NumberFormat.compact(locale: 'vi');

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          height: 18,
          child: hasTx ? const Text('🔥', style: TextStyle(fontSize: 12)) : null,
        ),
        const SizedBox(height: 1),
        Container(
          width: 34,
          height: 34,
          decoration: BoxDecoration(
            color: isToday
                ? AppColors.primary
                : hasTx
                    ? const Color(0xFFFFF3E0)
                    : Colors.transparent,
            shape: BoxShape.circle,
            border: isToday
                ? null
                : hasTx
                    ? Border.all(color: const Color(0xFFFFB300), width: 1.5)
                    : null,
          ),
          child: Center(
            child: Text(
              '$day',
              style: TextStyle(
                fontSize: 13,
                fontWeight: isToday || hasTx ? FontWeight.w700 : FontWeight.w500,
                color: isToday
                    ? Colors.white
                    : hasTx
                        ? const Color(0xFFE65100)
                        : AppColors.text3,
              ),
            ),
          ),
        ),
        const SizedBox(height: 2),
        SizedBox(
          height: 13,
          child: hasTx
              ? Text(
                  net >= 0 ? '+${formatter.format(net)}' : formatter.format(net),
                  style: TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.w600,
                    color: net >= 0 ? const Color(0xFF27AE60) : const Color(0xFFE53935),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.clip,
                )
              : null,
        ),
      ],
    );
  }
}

class _LegendItem extends StatelessWidget {
  final Color color;
  final Color? borderColor;
  final String label;
  final String? icon;
  final bool isToday;

  const _LegendItem({
    required this.color,
    required this.label,
    this.borderColor,
    this.icon,
    this.isToday = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            border: borderColor != null ? Border.all(color: borderColor!, width: 1.5) : null,
          ),
          child: icon != null
              ? Center(child: Text(icon!, style: const TextStyle(fontSize: 11)))
              : null,
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: AppColors.text4,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
