import 'package:get/get.dart';
import 'package:money_care/core/network/api_client.dart';
import 'package:money_care/features/notification/presentation/controllers/notification_controller.dart';

class NotificationBinding extends Bindings {
  final ApiClient apiClient;

  NotificationBinding({required this.apiClient});

  @override
  void dependencies() {
    Get.lazyPut<NotificationController>(() => NotificationController(apiClient: apiClient));
  }
}
