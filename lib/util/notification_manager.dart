import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationManager {
  static late FlutterLocalNotificationsPlugin notificationInstance;
  static const AndroidNotificationChannel androidChannel = AndroidNotificationChannel(
    'gbpn_notification_channel', // id
    'High Importance Notifications', // title
    description: 'This channel is used for important notifications.', // description
    importance: Importance.high,
  );

  static void configureNotification({required Function(String?) onSelectNotification}) {
    notificationInstance = FlutterLocalNotificationsPlugin();
    var settingsAndroid = const AndroidInitializationSettings('@mipmap/ic_launcher');
    var settingsIOS = IOSInitializationSettings(
        requestSoundPermission: true,
        defaultPresentSound: true,
        onDidReceiveLocalNotification: (id, title, body, payload) {
          if (kDebugMode) {
            print('[onDidReceiveLocalNotification]: $id::$title::$body::$payload');
          }
        });
    var initSettings = InitializationSettings(android: settingsAndroid, iOS: settingsIOS);
    notificationInstance.initialize(initSettings, onSelectNotification: onSelectNotification);
  }

  static Future<void> showNotification({required int id, required String title, required String body}) async {
    await notificationInstance.show(
        id,
        title,
        body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            androidChannel.id,
            androidChannel.name,
            channelDescription: androidChannel.description,
            icon: '@mipmap/ic_launcher'
          ),
          iOS: const IOSNotificationDetails(
            presentAlert: true,
            presentSound: true,
            sound: 'default'
          )
        ));
  }
}
