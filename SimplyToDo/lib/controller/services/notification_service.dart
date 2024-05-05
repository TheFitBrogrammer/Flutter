// import 'dart:developer';

// import 'package:awesome_notifications/awesome_notifications.dart';
// import 'package:flutter/material.dart';

// class NotificationService {
//   Future<void> initNotifications() async {
//     AwesomeNotifications().initialize(
//       null,
//       [
//         NotificationChannel(
//           channelKey: 'task_reminder_channel',
//           channelName: 'Task Reminders',
//           channelDescription: 'Notification channel for todo items',
//           defaultColor: const Color(0xFF1c1c5e),
//           ledColor: Colors.orange,
//           channelShowBadge: true,
//           importance: NotificationImportance.Default,
//         )
//       ],
//     );
//     log("Notification initialized");
//   }

//   Future<void> scheduleNotification(
//       int id, DateTime scheduledDate, String itemTitle) async {
//     try {
//       await AwesomeNotifications().createNotification(
//         content: NotificationContent(
//           id: id,
//           channelKey: 'task_reminder_channel',
//           title: 'Reminder',
//           body: 'You have an item scheduled for today: $itemTitle',
//         ),
//         schedule: NotificationCalendar.fromDate(
//             date: DateTime.now().add(Duration(minutes: 1))),
//         // schedule: NotificationCalendar.fromDate(date: scheduledDate),
//       );
//     } catch (e) {
//       log("Failed to create notification: $e");
//     }
//   }

//   Future<void> cancelNotification(int id) async {
//     await AwesomeNotifications().cancel(id);
//   }
// }

// // class NotificationService {
// //   final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
// //       FlutterLocalNotificationsPlugin();

// //   Future<void> cancelNotification(int id) async {
// //     await flutterLocalNotificationsPlugin.cancel(id);
// //     log("Notification for item ID# $id cancelled successfully.");
// //   }

// //   Future<void> initNotifications() async {
// //     const AndroidInitializationSettings initializationSettingsAndroid =
// //         AndroidInitializationSettings('@mipmap/ic_launcher');

// //     const DarwinInitializationSettings initializationSettingsDarwin =
// //         DarwinInitializationSettings();
// //     const InitializationSettings initializationSettings =
// //         InitializationSettings(
// //       android: initializationSettingsAndroid,
// //       iOS: initializationSettingsDarwin,
// //     );
// //     await flutterLocalNotificationsPlugin.initialize(
// //       initializationSettings,
// //       onDidReceiveNotificationResponse: onDidReceiveNotificationResponse,
// //     );
// //     _configureLocalTimeZone();

// //     const AndroidNotificationChannel channel = AndroidNotificationChannel(
// //       'task_reminder_channel', // Channel ID
// //       'Task Reminders', // Channel Name
// //       description:
// //           'Channel for task reminder notifications', // Channel Description
// //       importance: Importance.high, // Channel importance
// //     );

// //     await flutterLocalNotificationsPlugin
// //         .resolvePlatformSpecificImplementation<
// //             AndroidFlutterLocalNotificationsPlugin>()
// //         ?.createNotificationChannel(channel);
// //   }

// //   Future<void> _configureLocalTimeZone() async {
// //     tz.initializeTimeZones();
// //     final String timeZoneName = await FlutterTimezone.getLocalTimezone();
// //     tz.setLocalLocation(tz.getLocation(timeZoneName));
// //   }

// //   void onDidReceiveNotificationResponse(
// //       NotificationResponse notificationResponse) async {
// //     if (notificationResponse.payload != null) {
// //       // await Navigator.pushNamed(context, '/calendar_screen');
// //       log('Notification payload: ${notificationResponse.payload}');
// //     }
// //   }

// // // ************** FOR TESTING **************
// //   Future<void> scheduleNotification(
// //       int id, DateTime scheduledDate, String itemTitle) async {
// //     final tz.TZDateTime now = tz.TZDateTime.now(tz.local);

// //     // For testing, add 5 minutes to the current time
// //     final tz.TZDateTime testScheduledTZDate =
// //         now.add(const Duration(minutes: 5));

// //     const AndroidNotificationDetails androidNotificationDetails =
// //         AndroidNotificationDetails(
// //       'task_reminder_channel',
// //       'Task Reminders',
// //       importance: Importance.high,
// //       priority: Priority.high,
// //     );
// //     const NotificationDetails notificationDetails = NotificationDetails(
// //       android: androidNotificationDetails,
// //     );

// //     await flutterLocalNotificationsPlugin.zonedSchedule(
// //       id,
// //       'Reminder',
// //       'You have a task due today: $itemTitle',
// //       testScheduledTZDate,
// //       notificationDetails,
// //       uiLocalNotificationDateInterpretation:
// //           UILocalNotificationDateInterpretation.absoluteTime,
// //       matchDateTimeComponents: DateTimeComponents.time,
// //       payload: itemTitle,
// //     );
// //   }

//   // Future<void> scheduleNotification(
//   //     int id, DateTime scheduledDate, String itemTitle) async {
//   //   final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
//   //   final tz.TZDateTime scheduledTZDate =
//   //       tz.TZDateTime.from(scheduledDate, tz.local);

//   //   // Check if the scheduled date is in the future
//   //   if (scheduledTZDate.isAfter(now)) {
//   //     const AndroidNotificationDetails androidNotificationDetails =
//   //         AndroidNotificationDetails(
//   //       'task_reminder_channel', // Channel ID
//   //       'Task Reminders', // Channel Name
//   //       importance: Importance.high,
//   //       priority: Priority.high,
//   //     );
//   //     const NotificationDetails notificationDetails = NotificationDetails(
//   //       android: androidNotificationDetails,
//   //     );

//   //     await flutterLocalNotificationsPlugin.zonedSchedule(
//   //       id,
//   //       'Reminder',
//   //       'You have a task due today: $itemTitle',
//   //       scheduledTZDate,
//   //       notificationDetails,
//   //       uiLocalNotificationDateInterpretation:
//   //           UILocalNotificationDateInterpretation.absoluteTime,
//   //       matchDateTimeComponents: DateTimeComponents.time,
//   //       payload: itemTitle,
//   //     );
//   //   }
//   // }
// // }
