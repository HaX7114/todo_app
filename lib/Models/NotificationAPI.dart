import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:todo_app/main.dart';
import 'package:timezone/timezone.dart' as tz;

class NotificationAPI {

  static const int repeatInMorning = 6;
  static const int repeatInAfternoon = 11;
  static const int repeatInEvening = 16;
  static const int repeatInNight = 18;

  static Future<void> repeatNotification(index,String title,String content,repeatInterval) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
    AndroidNotificationDetails(
      'repeating channel id', 'repeating channel name',
      channelDescription: 'repeating description',
    );
    const NotificationDetails platformChannelSpecifics =
    NotificationDetails(android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.periodicallyShow(
      index,
      title,
      content,
      repeatInterval,
      platformChannelSpecifics,
      androidAllowWhileIdle: true,
    );
  }

  static Future<void> scheduleDailyWithTime(time,notiIndex,String title,String content,) async {
    print('Notification has been set at $time');
    await flutterLocalNotificationsPlugin.zonedSchedule(
        notiIndex,
        title,
        content,
        _determineTime(time),
        const NotificationDetails(
          android: AndroidNotificationDetails('daily notification channel id',
              'daily notification channel name',
              channelDescription: 'daily notification description'),
        ),
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
        UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.time
    );
  }

  static tz.TZDateTime _determineTime(int time) {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    print(now.hour);
    tz.TZDateTime scheduledDate =
    tz.TZDateTime(tz.local, now.year, now.month, now.day, time);
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    return scheduledDate;
  }

  static Future<void> cancelNotification(int id) async {
    await flutterLocalNotificationsPlugin.cancel(id);
  }

}