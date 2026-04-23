import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:money_care/features/notification/presentation/controllers/notification_controller.dart';
import 'package:money_care/features/notification/domain/entities/notification_entity.dart';
import 'package:money_care/app/widgets/states/app_empty_state.dart';
import 'package:money_care/core/utils/helper/helper_functions.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<NotificationController>();

    return Scaffold(
      appBar: AppBar(title: const Text('Thông báo'), centerTitle: true),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.notifications.isEmpty) {
          return const AppEmptyState(message: 'Bạn chưa có thông báo nào.');
        }

        return ListView.separated(
          itemCount: controller.notifications.length,
          separatorBuilder: (context, index) => const Divider(height: 1),
          itemBuilder: (context, index) {
            final notification = controller.notifications[index];
            final bool isRead = notification.isRead;

            return ListTile(
              onTap: () {
                if (!isRead) controller.markAsRead(notification.id);
              },
              tileColor: isRead ? null : Colors.blue.withValues(alpha: 0.05),
              leading: _buildLeadingIcon(notification),
              title: Text(
                notification.title,
                style: TextStyle(
                  fontWeight: isRead ? FontWeight.normal : FontWeight.bold,
                  fontSize: 15,
                ),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    notification.body,
                    style: TextStyle(
                      color: isRead ? Colors.grey : Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    AppHelperFunction.formatDateTime(
                      notification.createdAt.toLocal(),
                    ),
                    style: const TextStyle(fontSize: 11, color: Colors.grey),
                  ),
                ],
              ),
            );
          },
        );
      }),
    );
  }

  Widget _buildLeadingIcon(NotificationEntity notification) {
    final bool isRead = notification.isRead;
    final String type = notification.type.toLowerCase();

    IconData iconData;
    Color iconColor;

    switch (type) {
      case 'alert':
        iconData = Icons.report_problem_rounded;
        iconColor = isRead ? Colors.grey : Colors.red;
        break;
      case 'reminder':
        iconData = Icons.notifications_active_rounded;
        iconColor = isRead ? Colors.grey : Colors.orange;
        break;
      case 'system':
      default:
        iconData = Icons.notifications_rounded;
        iconColor = isRead ? Colors.grey : Colors.blue;
    }

    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: iconColor.withValues(alpha: 0.1),
        shape: BoxShape.circle,
      ),
      child: Icon(iconData, color: iconColor, size: 22),
    );
  }
}
