import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:money_care/core/constants/colors.dart';
import 'package:money_care/core/constants/sizes.dart';
import 'package:money_care/core/controllers/app_controller.dart';
import 'package:money_care/features/finance_mode/domain/entities/finance_mode_entity.dart';
import 'package:money_care/features/finance_mode/presentation/controllers/finance_mode_controller.dart';
import 'package:money_care/features/student_profile/data/datasources/student_profile_local_datasource.dart';
import 'package:money_care/features/student_profile/data/repositories/student_profile_repository_impl.dart';
import 'package:money_care/features/student_profile/data/datasources/student_profile_remote_datasource.dart';
import 'package:money_care/features/student_profile/domain/usecases/get_student_profile_usecase.dart';
import 'package:money_care/core/storage/local_storage.dart';
import 'package:money_care/core/network/api_client.dart';

/// Redesigned to be a compact status chip for better integration.
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
    final appController = Get.find<AppController>();
    final userId = await appController.getCurrentUserId();
    if (userId == null) {
      if (mounted) setState(() => _loaded = true);
      return;
    }

    final storage = Get.find<LocalStorage>();
    final apiClient = Get.find<ApiClient>();

    final useCase = GetStudentProfileUseCase(
      StudentProfileRepositoryImpl(
        remoteDatasource: StudentProfileRemoteDatasourceImpl(api: apiClient),
        localDatasource: StudentProfileLocalDatasourceImpl(storage: storage),
      ),
    );

    final result = await useCase(userId);
    result.fold(
      (_) { if (mounted) setState(() => _loaded = true); },
      (profile) {
        final incomeDate = profile.incomeDate;
        if (incomeDate != null) {
          final today = DateTime.now();
          final nextIncome = _nextIncomeDate(today, incomeDate);
          final days = nextIncome.difference(
            DateTime(today.year, today.month, today.day),
          ).inDays;
          if (mounted) {
            setState(() {
              _daysUntilIncome = days > 0 ? days : 0;
              _loaded = true;
            });
          }
        } else {
           if (mounted) setState(() => _loaded = true);
        }
      },
    );
  }

  DateTime _nextIncomeDate(DateTime today, DateTime incomeDate) {
    final incomeDay = incomeDate.day;
    final thisMonthIncome = DateTime(today.year, today.month, incomeDay);

    if (!thisMonthIncome.isBefore(DateTime(today.year, today.month, today.day))) {
      return thisMonthIncome;
    }

    final nextMonth = today.month == 12
        ? DateTime(today.year + 1, 1, incomeDay)
        : DateTime(today.year, today.month + 1, incomeDay);
    return nextMonth;
  }

  @override
  Widget build(BuildContext context) {
    final financeModeController = Get.find<FinanceModeController>();

    return Obx(() {
      final mode = financeModeController.currentMode.value;
      if (mode != FinanceMode.survival) return const SizedBox.shrink();

      if (!_loaded) return const SizedBox.shrink();
      if (_daysUntilIncome == null) return const SizedBox.shrink();

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
