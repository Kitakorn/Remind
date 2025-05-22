import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter_timezone/flutter_timezone.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future initNotification() async {
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()!
        .requestNotificationsPermission();
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings("@mipmap/ic_launcher");
    InitializationSettings initializationSettings =
        const InitializationSettings(android: initializationSettingsAndroid);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  AndroidNotificationDetails androidPlatformChannelSpecifics =
      const AndroidNotificationDetails(
    'Id',
    'Test channel',
    channelDescription: 'Just test bros',
    importance: Importance.max,
  );

  Future showNotification(int id, String body, DateTime notiTime) async {
    tz.initializeTimeZones();
    final String currentTimeZone = await FlutterTimezone.getLocalTimezone();
    final notificationTime =
        tz.TZDateTime.from(notiTime, tz.getLocation(currentTimeZone));
    //debugPrint(notificationTime.toString());
    return await flutterLocalNotificationsPlugin.zonedSchedule(
      id,
      'Schedule Notification',
      body,
      notificationTime,
      matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,
      NotificationDetails(android: androidPlatformChannelSpecifics),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  Future showSimpleNotification() async {
    return await flutterLocalNotificationsPlugin.show(
      0,
      'Schedule Notification',
      'This is just a test notification',
      NotificationDetails(android: androidPlatformChannelSpecifics),
    );
  }

  Future showRepeatNotification() async {
    return await flutterLocalNotificationsPlugin.periodicallyShow(
      0,
      'Schedule Notification',
      'This is just a test notification',
      RepeatInterval.everyMinute,
      NotificationDetails(android: androidPlatformChannelSpecifics),
    );
  }

  Future cancelAllNotification() async {
    return await flutterLocalNotificationsPlugin.cancelAll();
  }

  Future cancelIDNotification(int id) async {
    return await flutterLocalNotificationsPlugin.cancel(id);
  }
}
