import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:holidays_calendar/app_functions/custom_button.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../provider/Provier.dart';

class AddAlarmDaily extends StatefulWidget {
  const AddAlarmDaily({super.key});

  @override
  State<AddAlarmDaily> createState() => _AddAlaramState();
}

class _AddAlaramState extends State<AddAlarmDaily> {
  late TextEditingController controller;
  late GlobalKey<FormState> formKey;

  String? dateTime;
  bool repeat = false;

  DateTime? notificationtime;

  String? name = "none";
  int? Milliseconds;
  dynamic size, height, width;

  @override
  void initState() {
    controller = TextEditingController();
    context.read<AlarmProvider>().getData();
    notificationtime = DateTime.now();
    formKey = GlobalKey<FormState>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    height = size.height;
    width = size.width;
    return Scaffold(
      backgroundColor: const Color(0xffEDFDFE),
      appBar: AppBar(
        backgroundColor: const Color(0xffEDFDFE),
        automaticallyImplyLeading: true,
        title: const Text(
          'Add Event',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.3,
                  width: MediaQuery.of(context).size.width,
                  child: Center(
                    child: CupertinoDatePicker(
                      dateOrder: DatePickerDateOrder.mdy,
                      onDateTimeChanged: (va) {
                        dateTime = DateFormat().add_jms().format(va);
                        Milliseconds = va.microsecondsSinceEpoch;
                        notificationtime = va;
                        print(dateTime);
                      },
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: TextFormField(
                      maxLines: 10,
                      controller: controller,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter some text';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Enter Event',
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(" Repeat daily"),
                    ),
                    CupertinoSwitch(
                      value: repeat,
                      onChanged: (bool value) {
                        repeat = value;
                        // if (repeat == false) {
                        //   name = notificationtime.toString();
                        // } else {
                        //   name = "Everyday";
                        // }

                        setState(() {});
                      },
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                CustomButton(
                    buttonText: "Set Reminder",
                    width: width / 1.7,
                    height: height / 20,
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        if (repeat == false) {
                          final timeFormat = DateFormat.yMEd();
                          name = timeFormat.format(notificationtime!);
                        } else {
                          name = "Everyday";
                        }
                        print('............$notificationtime');
                        Random random = Random();
                        int randomNumber = random.nextInt(100);

                        context.read<AlarmProvider>().setAlarm(
                              controller.text,
                              dateTime!,
                              true,
                              name!,
                              randomNumber,
                              Milliseconds!,
                            );
                        context.read<AlarmProvider>().setData();

                        context.read<AlarmProvider>().scheduleNotification(
                              notificationtime!,
                              randomNumber,
                              controller.text.toString(),
                            );
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Event added'),
                          ),
                        );

                        Navigator.pop(context);
                      }
                    }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
