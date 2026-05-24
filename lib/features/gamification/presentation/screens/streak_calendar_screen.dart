import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:money_care/app/controllers/app_controller.dart';
import 'package:money_care/app/widgets/layout/app_header.dart';
import 'package:money_care/core/constants/colors.dart';
import 'package:money_care/features/gamification/presentation/controllers/streak_calendar_controller.dart';
import 'package:money_care/features/gamification/presentation/widgets/streak_calendar_grid.dart';
import 'package:money_care/features/gamification/presentation/widgets/streak_calendar_legend.dart';
import 'package:money_care/features/gamification/presentation/widgets/streak_day_transaction_list.dart';
import 'package:money_care/features/statistics/presentation/widgets/statistics_time_navigator.dart';
import 'package:money_care/features/gamification/presentation/widgets/streak_weekday_row.dart';

class StreakCalendarScreen extends StatelessWidget {
  const StreakCalendarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.isRegistered<StreakCalendarController>()
        ? Get.find<StreakCalendarController>()
        : Get.put(StreakCalendarController());
    final appController = Get.find<AppController>();

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Column(
        children: [
          AppHeader(
            title: 'streak.calendarTitle'.tr,
            showBackButton: true,
            height: 110,
          ),
          const SizedBox(height: 16),
          Obx(() => StatisticsTimeNavigator(
            focusedMonth: controller.focusedMonth.value,
            onPrevious: () => controller.prevMonth(),
            onNext: () => controller.nextMonth(),
          )),
          const SizedBox(height: 16),
          const StreakWeekdayRow(),
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
                    StreakCalendarGrid(controller: controller),
                    const SizedBox(height: 16),
                    const StreakCalendarLegend(),
                    const SizedBox(height: 24),
                    StreakDayTransactionList(
                      controller: controller,
                      appController: appController,
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
