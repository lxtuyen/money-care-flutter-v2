import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:money_care/features/payment/domain/entities/subscription_entity.dart';
import 'package:money_care/features/payment/domain/entities/payment_entity.dart';
import 'package:money_care/features/payment/domain/repositories/payment_repository.dart';
import 'package:money_care/app/controllers/app_controller.dart';
import 'package:money_care/core/utils/helper/helper_functions.dart';

class PaymentController extends GetxController {
  final PaymentRepository repository;

  PaymentController({required this.repository});

  final isProcessing = false.obs;
  final subscriptionStatus = Rxn<SubscriptionEntity>();
  final paymentHistory = <PaymentEntity>[].obs;
  final isLoadingHistory = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadSubscriptionStatus();
  }

  /// Load trạng thái Premium và cập nhật AppController
  Future<void> loadSubscriptionStatus() async {
    final result = await repository.getSubscriptionStatus();
    result.fold(
      (failure) =>
          debugPrint('Error loading subscription status: ${failure.message}'),
      (status) {
        subscriptionStatus.value = status;
        _syncAppController(status);
      },
    );
  }

  /// Mua Premium → mở PayOS checkout
  Future<void> subscribe() async {
    if (isProcessing.value) return;
    isProcessing.value = true;

    try {
      final result = await repository.subscribe();
      result.fold(
        (failure) {
          AppHelperFunction.showErrorSnackBar(failure.message);
        },
        (checkoutUrl) async {
          final uri = Uri.parse(checkoutUrl);
          try {
            await launchUrl(uri, mode: LaunchMode.externalApplication);
            // Sau khi user quay lại app, verify payment
            Future.delayed(const Duration(seconds: 3), () {
              refreshAfterPayment();
            });
          } catch (_) {
            AppHelperFunction.showErrorSnackBar(
              'Không thể mở trang thanh toán',
            );
          }
        },
      );
    } catch (e) {
      AppHelperFunction.showErrorSnackBar('Lỗi: $e');
    } finally {
      isProcessing.value = false;
    }
  }

  /// Kích hoạt free trial
  Future<void> activateTrial() async {
    if (isProcessing.value) return;
    isProcessing.value = true;

    try {
      final result = await repository.activateTrial();
      result.fold(
        (failure) {
          AppHelperFunction.showErrorSnackBar(failure.message);
        },
        (status) {
          subscriptionStatus.value = status;
          _syncAppController(status);
          AppHelperFunction.showSuccessSnackBar(
            'Kích hoạt dùng thử 7 ngày thành công!',
          );
        },
      );
    } catch (e) {
      AppHelperFunction.showErrorSnackBar('Lỗi: $e');
    } finally {
      isProcessing.value = false;
    }
  }

  /// Tải lịch sử thanh toán
  Future<void> loadPaymentHistory() async {
    isLoadingHistory.value = true;
    final result = await repository.getPaymentHistory();
    result.fold(
      (failure) =>
          debugPrint('Error loading payment history: ${failure.message}'),
      (history) => paymentHistory.assignAll(history),
    );
    isLoadingHistory.value = false;
  }

  /// Verify pending payments và refresh status sau khi từ PayOS quay về
  Future<void> refreshAfterPayment() async {
    // Load history để tìm pending payments
    await loadPaymentHistory();
    final pendingPayments = paymentHistory
        .where((p) => p.status == 'pending')
        .toList();

    for (final payment in pendingPayments) {
      final result = await repository.verifyPayment(payment.orderCode);
      result.fold(
        (_) {},
        (verified) {
          if (verified) {
            AppHelperFunction.showSuccessSnackBar(
              'Nâng cấp Premium thành công! 🎉',
            );
          }
        },
      );
    }

    // Refresh lại status và history
    await loadSubscriptionStatus();
    await loadPaymentHistory();
  }

  void _syncAppController(SubscriptionEntity status) {
    try {
      final appController = Get.find<AppController>();
      appController.isPremium.value = status.isPremium;
      appController.isGracePeriod.value = status.isGracePeriod;
      appController.premiumExpiresAt.value = status.expiresAt;
    } catch (_) {
      // AppController chưa registered
    }
  }
}
