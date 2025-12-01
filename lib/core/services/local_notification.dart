import 'dart:async';
import 'dart:developer';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_application_api_bloc/core/helper/sharedpreferences.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter_timezone/flutter_timezone.dart';

class LocalNotificationService {
  static FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  static final streamController =
      StreamController<NotificationResponse>.broadcast();

  // static StreamController<NotificationResponse> streamController =
  //     StreamController();
  static onTap(NotificationResponse notificationResponse) {
    // log(notificationResponse.id!.toString());
    // log(notificationResponse.payload!.toString());
    streamController.add(notificationResponse);
    // Navigator.push(context, route);
  }

  static Future init() async {
    InitializationSettings settings = const InitializationSettings(
      android: AndroidInitializationSettings('notificationtasky'),
      iOS: DarwinInitializationSettings(),
    );
    flutterLocalNotificationsPlugin.initialize(
      settings,
      onDidReceiveNotificationResponse: onTap,
      onDidReceiveBackgroundNotificationResponse: onTap,
    );
  }

  //basic Notification
  static void showBasicNotification(
    RemoteMessage message,
  ) async {
    // final http.Response image = await http
    //     .get(Uri.parse(message.notification?.android?.imageUrl ?? ''));
    // BigPictureStyleInformation bigPictureStyleInformation =
    //     BigPictureStyleInformation(
    //   ByteArrayAndroidBitmap.fromBase64String(
    //     base64Encode(image.bodyBytes),
    //   ),
    //   largeIcon: ByteArrayAndroidBitmap.fromBase64String(
    //     base64Encode(image.bodyBytes),
    //   ),
    // );
    AndroidNotificationDetails android = AndroidNotificationDetails(
      'channel_id',
      'channel_name',
      importance: Importance.max,
      priority: Priority.high,
      // styleInformation: bigPictureStyleInformation,
      playSound: true,
      sound: RawResourceAndroidNotificationSound(
          'notification_sound_2.wav'.split('.').first),
    );
    NotificationDetails details = NotificationDetails(
      android: android,
    );
    await flutterLocalNotificationsPlugin.show(
      0,
      message.notification?.title,
      message.notification?.body,
      details,
    );
  }

  static void showRepeatedNotification() async {
    const AndroidNotificationDetails android = AndroidNotificationDetails(
      'id 2',
      'repeated notification',
      importance: Importance.max,
      priority: Priority.high,
    );
    NotificationDetails details = const NotificationDetails(
      android: android,
    );
    await flutterLocalNotificationsPlugin.periodicallyShow(
        1, 'Reapated Notification', 'body', RepeatInterval.everyMinute, details,
        payload: "Payload Data",
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle);
  }

  static void cancelNotification(int id) async {
    await flutterLocalNotificationsPlugin.cancel(id);
  }

  //showSchduledNotification
  static void showSchduledNotification() async {
    String? saved = CacheHelper.getData(key: "selectedDateTime");
    if (saved == null) return;
    DateTime selected = DateTime.parse(saved);
    const AndroidNotificationDetails android = AndroidNotificationDetails(
      'schduled notification',
      'id 3',
      icon: 'notificationtasky', // بدون .png,
      importance: Importance.max,
      priority: Priority.high,
    );
    NotificationDetails details = const NotificationDetails(
      android: android,
    );
    tz.initializeTimeZones();
    log(tz.local.name);
    log("Before ${tz.TZDateTime.now(tz.local).hour}");
    final String currentTimeZone = await FlutterTimezone.getLocalTimezone();
    log(currentTimeZone);
    tz.setLocalLocation(tz.getLocation(currentTimeZone));
    log(tz.local.name);
    log("After ${tz.TZDateTime.now(tz.local).hour}");
    await flutterLocalNotificationsPlugin.zonedSchedule(
      2,
      'Last Remeber',
      'Do Task Before You Miss It',
      // tz.TZDateTime.now(tz.local).add(const Duration(seconds: 10)),
      tz.TZDateTime(
        tz.local,
        selected.year,
        selected.month,
        selected.day,
        selected.hour,
        selected.minute,
      ).subtract(
        const Duration(hours: 1),
      ),
      details,
      payload: 'zonedSchedule',
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    );
  }

  static Future<void> showDailySchduledNotification() async {
    const AndroidNotificationDetails android = AndroidNotificationDetails(
      'daily schduled notification',
      'id 4',
      importance: Importance.max,
      priority: Priority.high,
    );
    NotificationDetails details = const NotificationDetails(
      android: android,
    );
    tz.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation('Africa/Cairo'));
    var currentTime = tz.TZDateTime.now(tz.local);
    log("currentTime.year:${currentTime.year}");
    log("currentTime.month:${currentTime.month}");
    log("currentTime.day:${currentTime.day}");
    log("currentTime.hour:${currentTime.hour}");
    log("currentTime.minute:${currentTime.minute}");
    log("currentTime.second:${currentTime.second}");
    var scheduleTime = tz.TZDateTime(
      tz.local,
      currentTime.year,
      currentTime.month,
      currentTime.day,
      9,
    );
    log("scheduledTime.year:${scheduleTime.year}");
    log("scheduledTime.month:${scheduleTime.month}");
    log("scheduledTime.day:${scheduleTime.day}");
    log("scheduledTime.hour:${scheduleTime.hour}");
    log("scheduledTime.minute:${scheduleTime.minute}");
    log("scheduledTime.second:${scheduleTime.second}");
    if (scheduleTime.isBefore(currentTime)) {
      scheduleTime = scheduleTime.add(const Duration(days: 1));
      log("AfterAddedscheduledTime.year:${scheduleTime.year}");
      log("AfterAddedscheduledTime.month:${scheduleTime.month}");
      log("AfterAddedscheduledTime.day:${scheduleTime.day}");
      log("AfterAddedscheduledTime.hour:${scheduleTime.hour}");
      log("AfterAddedscheduledTime.minute:${scheduleTime.minute}");
      log("AfterAddedscheduledTime.second:${scheduleTime.second}");
      log('Added Duration to scheduled time');
    }
    await flutterLocalNotificationsPlugin.zonedSchedule(
      3,
      'Lets Go ',
      'Do Some Tasks ',
      // tz.TZDateTime.now(tz.local).add(const Duration(seconds: 10)),
      scheduleTime,
      details,
      payload: 'zonedSchedule',
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }
}
