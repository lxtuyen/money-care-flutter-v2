import 'package:get/get.dart';
import 'package:money_care/core/constants/api_routes.dart';
import 'package:money_care/core/network/api_client.dart';
import 'package:money_care/features/notification/domain/entities/notification_entity.dart';

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
        '/${ApiRoutes.notification}',
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
      await apiClient.patch('/${ApiRoutes.notification}/$id/read');
      final index = notifications.indexWhere((n) => n.id == id);
      if (index != -1) {
        final item = notifications[index];
        notifications[index] = item.copyWith(isRead: true);
      }
    } catch (e) {
      print('Mark read error: $e');
    }
  }
}
