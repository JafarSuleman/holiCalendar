import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get_storage/get_storage.dart';
import 'package:holidays_calendar/app_functions/custom_button.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';


class AddDialogue extends StatefulWidget {
  final Function()? onEventAdded;
  const AddDialogue({Key? key, this.onEventAdded});

  @override
  State<AddDialogue> createState() => _AddDialogueState();
}

class _AddDialogueState extends State<AddDialogue> {
  late DateTime focusedDay;
  late DateTime selectedDay;
  late CalendarFormat calendarFormat;
  TimeOfDay? selectedTime;
  late TextEditingController eventNameController;
  dynamic size, height, width;
  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  late DateTime selectedDateTime;
  @override
  void initState() {
    eventNameController = TextEditingController();
    focusedDay = DateTime.now();
    selectedDay = DateTime.now();
    calendarFormat = CalendarFormat.month;
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    _initializeNotifications();
    super.initState();
  }
  @override
  void dispose() {
    eventNameController.dispose();
    super.dispose();
  }



  void _initializeNotifications() {
    final initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher');
    final initializationSettings =
    InitializationSettings(android: initializationSettingsAndroid);
    flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  void _setAlarm() {
    final DateTime scheduledDateTime = DateTime.now().add(Duration(seconds: 5));
      // selectedDay.year,
      // selectedDay.month,
      // selectedDay.day,
      // selectedTime!.hour,
      // selectedTime!.minute,
    // );
    AndroidAlarmManager.oneShotAt(
      scheduledDateTime,
      0,
      _onAlarm,
      exact: true,
      wakeup: true,
    );
  }

  static void _onAlarm() {
    // Handle the alarm when it triggers
    _showNotification();
  }

  static void _showNotification() async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
    AndroidNotificationDetails(
      'your_channel_id', // Change this value for your own channel
      'Channel Name', // Change this value for your own channel
      importance: Importance.max,
      priority: Priority.high,
    );
    const NotificationDetails platformChannelSpecifics =
    NotificationDetails(android: androidPlatformChannelSpecifics);
    await FlutterLocalNotificationsPlugin().show(
      0,
      'Alarm',
      'Time to wake up!', // Change this message to your notification content
      platformChannelSpecifics,
    );
  }



  @override
  Widget build(BuildContext context) {

    size = MediaQuery.of(context).size;
    height = size.height;
    width = size.width;
    return Container(
      height: height*0.66,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Add Event',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                StatefulBuilder(
                  builder: (context, setSateSB) {
                    return CustomButton(
                      onPressed: () {
                        final storage = GetStorage();
                        List<dynamic> events = storage.read('events') ?? [];
                        events.add({
                          'date': selectedDay.toString(),
                          'event': eventNameController.text,
                          'reminder': selectedTime != null ? selectedTime!.format(context) : '',
                        });
                        storage.write('events', events);
                        setState(() {});
                        _setAlarm();
                        if (widget.onEventAdded != null) {
                          widget.onEventAdded!();
                        }
                      },
                      buttonText: 'Save',
                    );
                  }
                ),

              ],
            ),
          ),
           Padding(
            padding: const EdgeInsets.all(10),
            child: TextField(
              controller: eventNameController,
              enabled: true,
              decoration: const InputDecoration(
                hintText: 'Event',
                border: InputBorder.none,
              ),
            ),
          ),
          Expanded(child: Container()),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: height/8,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: const Color(0xffFAF9F6),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          InkWell(
                            onTap: () {
                              _showCalendar(context);
                            },
                            child: const Icon(Icons.calendar_month_outlined, color: Colors.deepOrange),
                          ),
                          Text(
                            DateFormat('yyyy-MM-dd').format(selectedDay),
                            style: const TextStyle(fontSize: 16),
                          ),
                          InkWell(
                            onTap: (){
                              _selectTime(context);
                            },
                            child: Container(
                              height: height/20,
                              width: width/2.5,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child:  Center(child: Text(selectedTime != null ? selectedTime!.format(context) : "Set Reminder",
                              style: TextStyle(fontSize: width/25),
                              ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: CustomButton(
              width: 100,
              onPressed: () {
                Navigator.of(context).pop();
              },
              buttonText: 'Close',

            ),
          ),
        ],
      ),
    );
  }

  void _showCalendar(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SizedBox(
          height: 600,
          child: TableCalendar(
            headerStyle: const HeaderStyle(
              titleCentered: true,
            ),
            firstDay: DateTime.utc(2021, 1, 1),
            lastDay: DateTime.utc(2030, 12, 31),
            focusedDay: focusedDay,
            calendarFormat: calendarFormat,
            availableCalendarFormats: const {
              CalendarFormat.month: 'Month',
            },
            calendarStyle: const CalendarStyle(
              weekNumberTextStyle: TextStyle(color: Colors.red),
              weekendTextStyle: TextStyle(color: Colors.red),
            ),
            onFormatChanged: (format) {
              setState(() {
                calendarFormat = format;
              });
            },
            onPageChanged: (focusedDay) {
              setState(() {
                this.focusedDay = focusedDay;
              });
            },
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                this.selectedDay = selectedDay;
                this.focusedDay = focusedDay;
              });
              Navigator.pop(context);
            },
            selectedDayPredicate: (day) {
              return isSameDay(selectedDay, day);
            },
          ),
        );
      },
    );
  }
  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (pickedTime != null) {
      setState(() {
        selectedTime = pickedTime;
      });
    }
  }
}