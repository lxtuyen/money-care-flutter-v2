import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:money_care/core/network/api_client.dart';
import 'package:money_care/core/storage/local_storage.dart';
import 'package:money_care/core/constants/route_path.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print("Handling a background message: ${message.messageId}");
}

class NotificationService extends GetxService {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  String? fcmToken;

  Future<NotificationService> init() async {
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    await _requestPermissions();
    await _initLocalNotifications();
    await _setupFCMListener();

    fcmToken = await _firebaseMessaging.getToken();

    _firebaseMessaging.onTokenRefresh.listen((newToken) {
      fcmToken = newToken;
      if (LocalStorage().getToken() != null) {
        _sendTokenToServer(newToken);
      }
    });

    return this;
  }

  Future<void> _requestPermissions() async {
    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  Future<void> _initLocalNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings initializationSettingsDarwin =
        DarwinInitializationSettings(
      requestSoundPermission: false,
      requestBadgePermission: false,
      requestAlertPermission: false,
    );

    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsDarwin,
    );

    await _localNotificationsPlugin.initialize(
      settings: initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        Get.toNamed(RoutePath.notification);
      },
    );
  }

  Future<void> _setupFCMListener() async {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Got a message whilst in the foreground!');
      if (message.notification != null) {
        _showLocalNotification(message);
      }
    });
  }

  Future<void> _showLocalNotification(RemoteMessage message) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'money_care_channel',
      'Money Care Notifications',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: true,
      largeIcon: DrawableResourceAndroidBitmap('@mipmap/ic_launcher'),
    );
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    await _localNotificationsPlugin.show(
      id: message.hashCode,
      title: message.notification?.title,
      body: message.notification?.body,
      notificationDetails: platformChannelSpecifics,
    );
  }

  Future<void> _sendTokenToServer(String token) async {
    try {
      final apiClient = Get.find<ApiClient>();
      final response = await apiClient.post('users/device-tokens', body: {'token': token});
      if (response.success) {
        print('DEBUG: Đã gửi FCM token lên server thành công');
      } else {
        print('DEBUG: Lỗi khi gửi FCM token: ${response.message}');
      }
    } catch (e) {
      print('Error sending FCM token exception: $e');
    }
  }

  Future<void> syncToken() async {
     fcmToken ??= await _firebaseMessaging.getToken();
     print('syncToken gọi: $fcmToken');
     if (fcmToken != null) {
       await _sendTokenToServer(fcmToken!);
     }
  }

  /// Hiển thị thông báo local ngay lập tức (dùng cho balance threshold, badge, v.v.)
  Future<void> showLocalNotification({
    required String title,
    required String body,
    int id = 0,
  }) async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      'money_care_channel',
      'Money Care Notifications',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: true,
      largeIcon: DrawableResourceAndroidBitmap('@mipmap/ic_launcher'),
    );
    const NotificationDetails details =
        NotificationDetails(android: androidDetails);

    await _localNotificationsPlugin.show(id: id, title: title, body: body, notificationDetails: details);
  }

  Future<void> removeTokenFromServer() async {
    fcmToken ??= await _firebaseMessaging.getToken();
    if (fcmToken != null) {
      try {
        final apiClient = Get.find<ApiClient>();
        await apiClient.delete('users/device-tokens', body: {'token': fcmToken});
      } catch (e) {
        print('Error removing FCM token: $e');
      }
    }
  }
}
