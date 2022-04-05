import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/data/latest_all.dart' as tz;
// import 'package:timezone/standalone.dart' as tz2;
import 'package:timezone/timezone.dart' as tz;
// import 'package:timezone/browser.dart' as tz;
// import 'package:time_machine/src/time_machine_internal.dart';
// import 'package:time_machine/time_machine.dart';

class NotificationService {
  //NotificationService a singleton object
  static final NotificationService _notificationService =
      NotificationService._internal();

  factory NotificationService() {
    return _notificationService;
  }

  NotificationService._internal();

  static const channelId = '123';

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    final AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    final IOSInitializationSettings initializationSettingsIOS =
        IOSInitializationSettings(
      requestSoundPermission: false,
      requestBadgePermission: false,
      requestAlertPermission: false,
    );

    final InitializationSettings initializationSettings =
        InitializationSettings(
            android: initializationSettingsAndroid,
            iOS: initializationSettingsIOS,
            macOS: null);

    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: selectNotification);
  }

  AndroidNotificationDetails _androidNotificationDetails =
      AndroidNotificationDetails(
    'channel ID',
    'channel name',
    playSound: true,
    priority: Priority.high,
    importance: Importance.high,
  );

  Future<void> showNotifications() async {
    await flutterLocalNotificationsPlugin.show(
      0,
      "Notification Title",
      "This is the Notification Body!",
      NotificationDetails(android: _androidNotificationDetails),
    );
  }

  Future<void> scheduleNotifications() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    tz.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation('America/Detroit'));
    var detroit = tz.getLocation('America/Detroit');
    tz.setLocalLocation(detroit);
    var hospital = prefs.getString("orderHospital");
    var fileNumber = prefs.getString("orderFileNumber");
    await flutterLocalNotificationsPlugin.zonedSchedule(
        0,
        "ننبيه",
        "هل تم التبرع ل ${hospital} رقم الملف : ${fileNumber}",
        tz.TZDateTime.now(detroit) //.now(tz.getLocation("UTC")).
            .add(const Duration(hours: 12)),
        NotificationDetails(android: _androidNotificationDetails),
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime);
  }

  Future<void> cancelNotifications(int id) async {
    await flutterLocalNotificationsPlugin.cancel(id);
  }

  Future<void> cancelAllNotifications() async {
    await flutterLocalNotificationsPlugin.cancelAll();
  }
}

Future<void> selectNotification(String? payload) async {
  //handle your logic here
}

// extension LocalDateTimeExtensions on LocalDateTime {
//   DateTime toDateTime() {
//     final isUTC = DateTimeZone.local.id == 'UTC';

//     if (Platform.isWeb) {
//       if (isUTC) {
//         return DateTime.utc(
//           year,
//           monthOfYear,
//           dayOfMonth,
//           hourOfDay,
//           minuteOfHour,
//           secondOfMinute,
//           millisecondOfSecond,
//         ).toLocal();
//       }

//       return DateTime(
//         year,
//         monthOfYear,
//         dayOfMonth,
//         hourOfDay,
//         minuteOfHour,
//         secondOfMinute,
//         millisecondOfSecond,
//       );
//     } else {
//       if (isUTC) {
//         return DateTime.utc(
//           year,
//           monthOfYear,
//           dayOfMonth,
//           hourOfDay,
//           minuteOfHour,
//           secondOfMinute,
//           0,
//           microsecondOfSecond,
//         ).toLocal();
//       }

//       return DateTime(
//         year,
//         monthOfYear,
//         dayOfMonth,
//         hourOfDay,
//         minuteOfHour,
//         secondOfMinute,
//         0,
//         microsecondOfSecond,
//       );
//     }
//   }
// }
