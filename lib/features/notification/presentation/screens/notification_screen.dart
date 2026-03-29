import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:money_care/features/notification/presentation/controllers/notification_controller.dart';
import 'package:intl/intl.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<NotificationController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Thông báo'),
        centerTitle: true,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.notifications.isEmpty) {
          return const Center(
            child: Text('Bạn chưa có thông báo nào.'),
          );
        }

        return ListView.separated(
          itemCount: controller.notifications.length,
          separatorBuilder: (context, index) => const Divider(height: 1),
          itemBuilder: (context, index) {
            final notification = controller.notifications[index];
            return ListTile(
              onTap: () {
                if (!notification.isRead) {
                  controller.markAsRead(notification.id);
                }
              },
              tileColor: notification.isRead ? null : Colors.blue.withOpacity(0.05),
              leading: Icon(
                Icons.notifications,
                color: notification.isRead ? Colors.grey : Colors.blue,
              ),
              title: Text(
                notification.title,
                style: TextStyle(
                  fontWeight: notification.isRead ? FontWeight.normal : FontWeight.bold,
                ),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(notification.body),
                  const SizedBox(height: 4),
                  Text(
                    DateFormat('dd/MM/yyyy HH:mm').format(notification.createdAt.toLocal()),
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            );
          },
        );
      }),
    );
  }
}
