// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
//
// import 'package:flutter_alarm_background_trigger/flutter_alarm_background_trigger.dart';
// import 'package:flutter_alarm_background_trigger/typedefs.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
//
// class AlarmService {
//   static AlarmService? _instance;
//   final FlutterAlarmBackgroundTrigger _flutterAlarmPlugin;
//   AlarmService._(this._flutterAlarmPlugin);
//   static AlarmService get instance =>
//       _instance ??= AlarmService._(FlutterAlarmBackgroundTrigger());
//
//   Future<AlarmItem> addAlarm(DateTime time,
//       {String? uid,
//         Map<String, dynamic>? payload,
//         Duration? screenWakeDuration}) async {
//     return _flutterAlarmPlugin.addAlarm(time,
//         uid: uid, payload: payload, screenWakeDuration: screenWakeDuration);
//   }
//
//   Future<List<AlarmItem>> getAllAlarms() async {
//     return _flutterAlarmPlugin.getAllAlarms();
//   }
//
//   Future<AlarmItem> getAlarm(int id) async {
//     return _flutterAlarmPlugin.getAlarm(id);
//   }
//
//   Future<List<AlarmItem>> getAlarmByUid(String uid) async {
//     return _flutterAlarmPlugin.getAlarmByUid(uid);
//   }
//
//   Future<List<AlarmItem>> getAlarmByTime(DateTime dateTime) async {
//     return _flutterAlarmPlugin.getAlarmByTime(dateTime);
//   }
//
//   Future<List<AlarmItem>> getAlarmByPayload(
//       Map<String, dynamic> payload) async {
//     return _flutterAlarmPlugin.getAlarmByPayload(payload);
//   }
//
//   Future<void> deleteAllAlarms() async {
//     return _flutterAlarmPlugin.deleteAllAlarms();
//   }
//
//   Future<void> deleteAlarm(int id) async {
//     return _flutterAlarmPlugin.deleteAlarm(id);
//   }
//
//   Future<void> deleteAlarmByUid(String uid) async {
//     return _flutterAlarmPlugin.deleteAlarmsByUid(uid);
//   }
//
//   Future<void> deleteAlarmByTime(DateTime dateTime) async {
//     return _flutterAlarmPlugin.deleteAlarmsByTime(dateTime);
//   }
//
//   Future<void> deleteAlarmByPayload(Map<String, dynamic> payload) async {
//     return _flutterAlarmPlugin.deleteAlarmsByPayload(payload);
//   }
//
//   Future<bool> requestPermission() async {
//     return _flutterAlarmPlugin.requestPermission();
//   }
//
//   Future<void> onForegroundAlarmEventHandler(
//       OnForegroundAlarmEvent onAlarmReceive) async {
//     return _flutterAlarmPlugin.onForegroundAlarmEventHandler(onAlarmReceive);
//   }
// }
// final notificationService = NotificationService();
//
// void main() async{
//   WidgetsFlutterBinding.ensureInitialized();
//   FlutterAlarmBackgroundTrigger.initialize();
//   await notificationService.initialize();
//   runApp(const MyApp());
// }
//
//
//
// class NotificationService {
//   final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
//
//   Future<void> initialize() async {
//     const AndroidInitializationSettings initializationSettingsAndroid =
//     AndroidInitializationSettings('@mipmap/ic_launcher'); // Replace with your icon name
//     // const IOSInitializationSettings initializationSettingsIOS =
//     // IOSInitializationSettings();
//     const InitializationSettings initializationSettings = InitializationSettings(
//       android: initializationSettingsAndroid,
//       // iOS: initializationSettingsIOS,
//     );
//     await _flutterLocalNotificationsPlugin.initialize(initializationSettings);
//   }
//
//   Future<void> showNotification(String title, String body) async {
//     const AndroidNotificationDetails androidNotificationDetails =
//     AndroidNotificationDetails('channel_id', 'channel_name',
//         channelDescription: 'your description',
//       priority: Priority.high,
//       importance: Importance.high
//     );
//     // const IOSNotificationDetails iosNotificationDetails = IOSNotificationDetails();
//     const NotificationDetails notificationDetails = NotificationDetails(
//       android: androidNotificationDetails,
//       // iOS: iosNotificationDetails,
//     );
//     await _flutterLocalNotificationsPlugin.show(0, title, body, notificationDetails);
//   }
// }
//
//
// class MyApp extends StatefulWidget {
//   const MyApp({Key? key}) : super(key: key);
//
//   @override
//   State<MyApp> createState() => _MyAppState();
// }
//
// class _MyAppState extends State<MyApp> {
//   AlarmItem? _alarmItem;
//   DateTime? time;
//   List<AlarmItem> alarms = [];
//   FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//   FlutterLocalNotificationsPlugin();
//
//   @override
//   void initState() {
//     super.initState();
//     reloadAlarms();
//     AlarmService.instance.onForegroundAlarmEventHandler((alarmItem) {
//       reloadAlarms();
//     });
//
//     time = DateTime.now().add(Duration(seconds: 5));
//   }
//
//   reloadAlarms() {
//     AlarmService.instance.getAllAlarms().then((alarmsList) => setState(() {
//       alarms = alarmsList;
//     }));
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//         appBar: AppBar(
//           title: const Text('Plugin example app'),
//         ),
//         body: Builder(builder: (context) {
//           return Center(
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 Card(
//                   margin: const EdgeInsets.all(10),
//                   child: Padding(
//                     padding: const EdgeInsets.all(8.0),
//                     child: Row(
//                       children: [
//                         // Expanded(
//                         //     child: DateTimePicker(
//                         //       type: DateTimePickerType.dateTime,
//                         //       initialValue: '',
//                         //       firstDate: DateTime.now(),
//                         //       lastDate:
//                         //       DateTime.now().add(const Duration(days: 365)),
//                         //       dateLabelText: 'Alarm date time',
//                         //       onChanged: (val) => setState(() {
//                         //         time = DateTime.parse(val);
//                         //       }),
//                         //     )),
//                         ElevatedButton(
//                             onPressed: createAlarm,
//                             child: const Text("Set Alarm"))
//                       ],
//                     ),
//                   ),
//                 ),
//                 Expanded(
//                   child: ListView.builder(
//                     itemCount: alarms.length,
//                     itemBuilder: (ctx, idx) => ((AlarmItem alarm) => ListTile(
//                       title: Row(
//                         children: [
//                           Text(alarm.time!.toString()),
//                           const SizedBox(width: 5),
//                           Chip(
//                             padding: EdgeInsets.zero,
//                             label: Text(describeEnum(alarm.status),
//                                 style: TextStyle(
//                                     color: alarm.status == AlarmStatus.DONE
//                                         ? Colors.black
//                                         : Colors.white,
//                                     fontSize: 10)),
//                             backgroundColor:
//                             alarm.status == AlarmStatus.DONE
//                                 ? Colors.greenAccent
//                                 : Colors.redAccent,
//                           )
//                         ],
//                       ),
//                       subtitle: Text(
//                           "ID: ${alarm.id}, UID: ${alarm.uid}, Payload: ${alarm.payload.toString()}"),
//                       trailing: IconButton(
//                           onPressed: () async {
//                             await AlarmService.instance
//                                 .deleteAlarm(alarm.id!);
//                             reloadAlarms();
//                           },
//                           icon:
//                           const Icon(Icons.delete, color: Colors.red)),
//                     ))(alarms[idx]),
//                   ),
//                 )
//               ],
//             ),
//           );
//         }),
//       ),
//     );
//   }
//
//   void createAlarm() async {
//     await AlarmService.instance
//         .addAlarm(time!, uid: "TEST UID", payload: {"holy": "Moly"});
//     reloadAlarms();
//     notificationService.showNotification('Notification Title', 'This is a notification body!');
//
//   }
// }



import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_storage/get_storage.dart';
import 'package:holidays_calendar/get_started_screen.dart';
import 'package:holidays_calendar/provider/theme_changer_privider.dart';
import 'package:provider/provider.dart';

void main() async{
  await GetStorage.init();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeChanger()),
      ],
      child: Builder(
        builder: (BuildContext context) {
          final themeChanger = Provider.of<ThemeChanger>(context);
          return const MaterialApp(
            home:   GetStartedScreen(),
          );
        },
      ),
    );
  }
}
