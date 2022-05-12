import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationAPI {
  static final _notification = FlutterLocalNotificationsPlugin();

  static Future showNotification(
      {int id = 0, String? title, String? body, String? Payload}) async {
    _notification.show(id, title, body, await _notificationDetails(),
        payload: Payload);
  }

  static Future _notificationDetails() async {
    return const NotificationDetails(
      android: AndroidNotificationDetails('channel id', 'channel name',
          channelDescription: 'channel description',
          importance: Importance.max),
      iOS: IOSNotificationDetails(),
    );
  }
}
