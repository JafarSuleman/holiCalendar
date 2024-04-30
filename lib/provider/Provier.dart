import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/timezone.dart' as tz;

import '../Model/Model.dart';
import '../app_functions/table_calendar.dart';

class AlarmProvider extends ChangeNotifier {
  late SharedPreferences preferences;

  List<Model> modelist = [];

  List<String> listofstring = [];

  FlutterLocalNotificationsPlugin? flutterLocalNotificationsPlugin;

  late BuildContext context;

  setAlarm(String label, String dateTime, bool check, String repeat, int id,
      int milliseconds) {
    modelist.add(Model(
        label: label,
        dateTime: dateTime,
        check: check,
        when: repeat,
        id: id,
        milliseconds: milliseconds));
    notifyListeners();
  }

  void deleteAlarm(int id) {
    modelist.removeWhere((alarm) => alarm.id == id);
    setData(); // Save the updated alarm list to SharedPreferences
    cancelNotification(id);
    notifyListeners(); // Notify listeners about the change
  }

  void editSwitch(int index, bool check) {
    modelist[index].check = check;
    notifyListeners();
  }

  void getData() async {
    preferences = await SharedPreferences.getInstance();

    List<String>? cominglist = await preferences.getStringList("data");

    if (cominglist == null) {
    } else {
      modelist = cominglist.map((e) => Model.fromJson(json.decode(e))).toList();
      notifyListeners();
    }
  }

  void setData() {
    listofstring = modelist.map((e) => json.encode(e.toJson())).toList();
    preferences.setStringList("data", listofstring);

    notifyListeners();
  }

  void initialize(con) async {
    context = con;
    var androidInitilize =
        new AndroidInitializationSettings('@mipmap/ic_launcher');
    var iOSinitilize = new DarwinInitializationSettings();
    var initilizationsSettings =
        InitializationSettings(android: androidInitilize, iOS: iOSinitilize);
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    await flutterLocalNotificationsPlugin!.initialize(initilizationsSettings,
        onDidReceiveNotificationResponse: onDidReceiveNotificationResponse);
  }

  void onDidReceiveNotificationResponse(
      NotificationResponse notificationResponse) async {
    final String? payload = notificationResponse.payload;
    if (notificationResponse.payload != null) {
      debugPrint('notification payload: $payload');
    }
    await Navigator.push(
        context, MaterialPageRoute<void>(builder: (context) => MyApp()));
  }

  void showNotification() async {
    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
      'your channel id',
      'your channel name',
      channelDescription: 'your channel description',
      importance: Importance.high,
      priority: Priority.high,
      ticker: 'ticker',
    );

    const NotificationDetails notificationDetails =
        NotificationDetails(android: androidNotificationDetails);
    await flutterLocalNotificationsPlugin!.show(
        0, 'plain title', 'plain body', notificationDetails,
        payload: 'item x');
  }

  void scheduleNotification(
      DateTime datetim, int randomNumber, String label) async {
    int newTime =
        datetim.millisecondsSinceEpoch - DateTime.now().millisecondsSinceEpoch;
    // print(datetim.millisecondsSinceEpoch);
    // print(DateTime.now().millisecondsSinceEpoch);
    // print(newTime);
    await flutterLocalNotificationsPlugin!.zonedSchedule(
        randomNumber,
        'Alarm Clock',
        label == '' ? "No label" :  "$label",
        tz.TZDateTime.now(tz.local).add(Duration(milliseconds: newTime)),
        const NotificationDetails(
            android: AndroidNotificationDetails(
                'your channel id', 'your channel name',
                channelDescription: 'your channel description',
                category: AndroidNotificationCategory.alarm,
                // ongoing: true,
                autoCancel: true,
                sound: RawResourceAndroidNotificationSound("alarm"),
                playSound: true,
                importance: Importance.high,
                priority: Priority.high)),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime);
  }

  void cancelNotification(int notificationId) async {
    await flutterLocalNotificationsPlugin!.cancel(notificationId);
  }
}
