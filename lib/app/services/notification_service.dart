import 'package:flutter/foundation.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:money_care/core/constants/api_routes.dart';
import 'package:money_care/core/constants/route_path.dart';
import 'package:money_care/core/network/api_client.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {}

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

    try {
      fcmToken = await _firebaseMessaging.getToken();
    } catch (e) {
      debugPrint('Error getting FCM token: $e');
    }

    return this;
  }

  Future<void> _requestPermissions() async {
    await _firebaseMessaging.requestPermission(
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
    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
    );

    await _localNotificationsPlugin.show(
      id: message.hashCode,
      title: message.notification?.title,
      body: message.notification?.body,
      notificationDetails: platformChannelSpecifics,
    );
  }

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
    const NotificationDetails details = NotificationDetails(
      android: androidDetails,
    );

    await _localNotificationsPlugin.show(
      id: id,
      title: title,
      body: body,
      notificationDetails: details,
    );
  }

  /// Upload FCM token to backend so server-side push notifications can reach this device.
  /// Call this once after login (or whenever [FirebaseMessaging.onTokenRefresh] fires).
  Future<void> registerFcmTokenToBackend() async {
    final token = fcmToken ?? await _firebaseMessaging.getToken();
    if (token == null) return;
    fcmToken = token;

    try {
      final api = Get.find<ApiClient>();
      await api.patch<void>(
        ApiRoutes.fcmToken,
        body: {'token': token},
      );
    } catch (e) {
      debugPrint('Failed to register FCM token: $e');
    }

    // Keep token fresh — re-register on token refresh
    _firebaseMessaging.onTokenRefresh.listen((newToken) async {
      fcmToken = newToken;
      try {
        final api = Get.find<ApiClient>();
        await api.patch<void>(
          ApiRoutes.fcmToken,
          body: {'token': newToken},
        );
      } catch (e) {
        debugPrint('Failed to refresh FCM token: $e');
      }
    });
  }
}
