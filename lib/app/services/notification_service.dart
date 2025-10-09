import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/material.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static Future<void> initialize() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    await _notificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        // 알림 탭 시 처리
        print('Notification tapped: ${response.payload}');
      },
    );

    // Android 알림 권한 요청
    await _requestPermissions();

    // 알림 채널 생성 (Android 8.0+)
    await _createNotificationChannel();
  }

  static Future<void> _createNotificationChannel() async {
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'conversion_channel',
      'Video Conversion',
      description: 'Notifications for video conversion completion and errors',
      importance: Importance.high,
      playSound: true,
      enableVibration: true,
      showBadge: true,
    );

    await _notificationsPlugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(channel);
  }

  static Future<void> _requestPermissions() async {
    await _notificationsPlugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.requestNotificationsPermission();
  }

  static Future<void> showConversionCompleteNotification({
    required String fileName,
    required String format,
  }) async {
    final AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
          'conversion_channel',
          'Video Conversion',
          channelDescription: 'Notifications for video conversion completion',
          importance: Importance.high,
          priority: Priority.high,
          showWhen: true,
          enableVibration: true,
          playSound: true,
          enableLights: true,
          color: const Color(0xFF0064FF),
          visibility: NotificationVisibility.public,
          fullScreenIntent: false,
          ongoing: false,
          autoCancel: true,
          category: AndroidNotificationCategory.status,
          channelShowBadge: true,
          icon: '@drawable/push_icon',
          largeIcon: const DrawableResourceAndroidBitmap('@drawable/push_icon'),
        );

    final NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
    );

    await _notificationsPlugin.show(
      0, // 알림 ID
      '🎬 Video Conversion Complete!',
      '$fileName has been successfully converted to $format and saved to your gallery.',
      platformChannelSpecifics,
      payload: 'conversion_complete',
    );
  }

  static Future<void> showConversionErrorNotification({
    required String errorMessage,
  }) async {
    final AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
          'conversion_channel',
          'Video Conversion',
          channelDescription: 'Notifications for video conversion errors',
          importance: Importance.high,
          priority: Priority.high,
          showWhen: true,
          enableVibration: true,
          playSound: true,
          enableLights: true,
          color: const Color(0xFFFF5722),
          visibility: NotificationVisibility.public,
          fullScreenIntent: false,
          ongoing: false,
          autoCancel: true,
          category: AndroidNotificationCategory.error,
          channelShowBadge: true,
          icon: '@drawable/push_icon',
          largeIcon: const DrawableResourceAndroidBitmap('@drawable/push_icon'),
        );

    final NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
    );

    await _notificationsPlugin.show(
      1, // 알림 ID
      '❌ Conversion Failed',
      'Video conversion failed: $errorMessage',
      platformChannelSpecifics,
      payload: 'conversion_error',
    );
  }
}
