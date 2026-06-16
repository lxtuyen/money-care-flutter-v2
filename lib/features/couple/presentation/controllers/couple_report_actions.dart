part of 'couple_controller.dart';

extension CoupleReportActions on CoupleController {
  Future<void> fetchCoupleReport() async {
    if (couple.value == null) return;
    isReportLoading.value = true;
    final result = await getCoupleReportUseCase(
      couple.value!.id,
      selectedMonthStr,
    );
    result.fold(
      (failure) =>
          debugPrint('Error fetching couple report: ${failure.message}'),
      (report) => coupleReport.value = report,
    );
    isReportLoading.value = false;
  }

  List<CoupleSpendingAlertEntity> get filteredAlerts {
    final alerts =
        coupleReport.value?.alerts ?? const <CoupleSpendingAlertEntity>[];
    switch (alertFilter.value) {
      case 'unread':
        return alerts.where((alert) => !alert.isRead).toList();
      case 'high':
        return alerts.where((alert) => alert.severity == 'high').toList();
      case 'open':
        return alerts.where((alert) => alert.status == 'open').toList();
      default:
        return alerts;
    }
  }

  Future<void> markAlertRead(int alertId) async {
    final result = await markCoupleAlertReadUseCase(alertId);
    result.fold(
      (failure) => AppHelperFunction.showErrorSnackBar(
        'Lỗi cập nhật cảnh báo: ${failure.message}',
      ),
      (_) => fetchCoupleReport(),
    );
  }

  Future<void> resolveAlert(int alertId) async {
    final result = await updateCoupleAlertUseCase(
      alertId: alertId,
      status: 'resolved',
    );
    result.fold(
      (failure) => AppHelperFunction.showErrorSnackBar(
        'Lỗi xử lý cảnh báo: ${failure.message}',
      ),
      (_) async {
        await fetchCoupleReport();
        AppHelperFunction.showSuccessSnackBar('Đã xử lý cảnh báo');
      },
    );
  }

  Future<void> sendAlertFeedback(int alertId, String feedback) async {
    final result = await updateCoupleAlertUseCase(
      alertId: alertId,
      feedback: feedback,
    );
    result.fold(
      (failure) => AppHelperFunction.showErrorSnackBar(
        'Lỗi gửi phản hồi: ${failure.message}',
      ),
      (_) async {
        await fetchCoupleReport();
        AppHelperFunction.showSuccessSnackBar('Đã ghi nhận phản hồi');
      },
    );
  }

  Future<void> deleteAlert(int alertId) async {
    final result = await deleteCoupleAlertUseCase(alertId);
    result.fold(
      (failure) => AppHelperFunction.showErrorSnackBar(
        'Lỗi xóa cảnh báo: ${failure.message}',
      ),
      (_) async {
        await fetchCoupleReport();
        AppHelperFunction.showSuccessSnackBar('Đã xóa cảnh báo chi tiêu');
      },
    );
  }
}
