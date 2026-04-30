import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:money_care/core/constants/colors.dart';
import 'package:money_care/features/finance_mode/domain/entities/finance_mode_entity.dart';
import 'package:money_care/features/finance_mode/presentation/controllers/finance_mode_controller.dart';
import 'package:money_care/app/controllers/user_controller.dart';

class DaysUntilIncomeWidget extends StatefulWidget {
  const DaysUntilIncomeWidget({super.key});

  @override
  State<DaysUntilIncomeWidget> createState() => _DaysUntilIncomeWidgetState();
}

class _DaysUntilIncomeWidgetState extends State<DaysUntilIncomeWidget> {
  int? _daysUntilIncome;
  bool _loaded = false;

  @override
  void initState() {
    super.initState();
    _loadIncomeDate();
  }

  Future<void> _loadIncomeDate() async {
    Get.find<UserController>();

    if (mounted) {
      setState(() => _loaded = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final financeModeController = Get.find<FinanceModeController>();
    final userController = Get.find<UserController>();

    return Obx(() {
      final mode = financeModeController.currentMode.value;
      if (mode != FinanceMode.survival) return const SizedBox.shrink();

      if (!_loaded) return const SizedBox.shrink();

      final incomeDate = userController.incomeDate.value;
      if (incomeDate == null) return const SizedBox.shrink();

      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: AppColors.error.withOpacity(0.08),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.error.withOpacity(0.3), width: 1),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.calendar_today_rounded,
              color: AppColors.error,
              size: 14,
            ),
            const SizedBox(width: 8),
            Text(
              _daysUntilIncome == 0
                  ? 'Nhận tiền hôm nay!'
                  : 'Còn $_daysUntilIncome ngày',
              style: const TextStyle(
                fontSize: 12,
                color: AppColors.error,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      );
    });
  }
}
