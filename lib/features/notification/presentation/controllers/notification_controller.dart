import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:money_care/core/utils/helper/helper_functions.dart';
import 'package:money_care/core/constants/api_routes.dart';
import 'package:money_care/core/network/api_client.dart';
import 'package:money_care/features/notification/domain/entities/notification_entity.dart';
import 'package:money_care/app/services/notification_service.dart';

class NotificationController extends GetxController {
  final ApiClient apiClient;

  NotificationController({required this.apiClient});

  final notifications = <NotificationEntity>[].obs;
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchNotifications();
  }

  Future<void> fetchNotifications() async {
    try {
      isLoading.value = true;
      final response = await apiClient.get(
        ApiRoutes.notification,
        fromJsonT: (data) => (data as List)
            .map((item) => NotificationEntity.fromJson(item))
            .toList(),
      );
      if (response.data != null) {
        notifications.value = response.data!;
      }
    } catch (e) {
      print('Fetch notifications error: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> markAsRead(int id) async {
    try {
      await apiClient.patch('${ApiRoutes.notification}/$id/read');
      final index = notifications.indexWhere((n) => n.id == id);
      if (index != -1) {
        final item = notifications[index];
        notifications[index] = item.copyWith(isRead: true);
      }
    } catch (e) {
      print('Mark read error: $e');
    }
  }

  Future<void> testNotification() async {
    try {
      isLoading.value = true;

      // Đảm bảo token đã được gửi lên server trước khi test
      await Get.find<NotificationService>().syncToken();

      // Nghỉ 500ms để DB kịp cập nhật
      await Future.delayed(const Duration(milliseconds: 500));

      // Gọi API test của Backend, truyền hàm (json) => json để nhận data thô
      final result = await apiClient.post<dynamic>(
        '${ApiRoutes.notification}/test',
        body: null,
        fromJsonT: (json) => json,
      );
      print(
        'DEBUG: Test notification result: success=${result.success}, data=${result.data}, message=${result.message}',
      );

      await Future.delayed(const Duration(seconds: 1));
      await fetchNotifications();

      final data = result.data;
      if (data != null && data['success'] == true) {
        AppHelperFunction.showSuccessSnackBar(
          'Đã gửi thông báo tới ${data['successCount']} thiết bị.',
        );
      } else {
        AppHelperFunction.showWarningSnackBar(
          'Server báo: ${data?['error'] ?? 'Không rõ lỗi'} (Số token: ${data?['tokenCount'] ?? 0})',
          duration: const Duration(seconds: 5),
        );
      }
    } catch (e) {
      print('Test notification error: $e');
      AppHelperFunction.showErrorSnackBar(
        'Không thể gửi yêu cầu thông báo test: $e',
      );
    } finally {
      isLoading.value = false;
    }
  }
}
