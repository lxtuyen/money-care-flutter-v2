import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:money_care/core/network/api_client.dart';
import 'package:money_care/core/storage/local_storage.dart';

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
    print("FCM Token: $fcmToken");

    _firebaseMessaging.onTokenRefresh.listen((newToken) {
      fcmToken = newToken;
      if (LocalStorage().getToken() != null) {
        _sendTokenToServer(newToken);
      }
      // Nếu chưa có JWT, chỉ lưu token local.
      // syncToken() sẽ được gọi sau khi đăng nhập thành công.
    });

    return this;
  }

  Future<void> _requestPermissions() async {
    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
    print('User granted permission: ${settings.authorizationStatus}');
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
        // Xử lý khi nhấn vào thông báo (Foreground/Background)
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
      await apiClient.post('/users/device-tokens', body: {'token': token});
    } catch (e) {
      print('Error sending FCM token: $e');
    }
  }

  Future<void> syncToken() async {
     fcmToken ??= await _firebaseMessaging.getToken();
     print('syncToken gọi: $fcmToken');
     if (fcmToken != null) {
       await _sendTokenToServer(fcmToken!);
     }
  }

  Future<void> removeTokenFromServer() async {
    fcmToken ??= await _firebaseMessaging.getToken();
    if (fcmToken != null) {
      try {
        final apiClient = Get.find<ApiClient>();
        await apiClient.delete('/users/device-tokens', body: {'token': fcmToken});
      } catch (e) {
        print('Error removing FCM token: $e');
      }
    }
  }
}
