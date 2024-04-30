import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:holidays_calendar/app_functions/custom_button.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart' as picker;
import '../provider/Provier.dart';

class AddAlarm extends StatefulWidget {
  const AddAlarm({super.key});

  @override
  State<AddAlarm> createState() => _AddAlaramState();
}

class _AddAlaramState extends State<AddAlarm> {
  late TextEditingController controller;

  String? dateTime;
  bool repeat = false;

  DateTime? notificationtime;

  String? name = "none";
  int? Milliseconds;

  @override
  void initState() {
    controller = TextEditingController();
    context.read<AlarmProvider>().getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffEDFDFE),
      appBar: AppBar(
        backgroundColor: Color(0xffEDFDFE),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Icon(Icons.check),
          )
        ],
        automaticallyImplyLeading: true,
        title: const Text(
          'Add Alarm',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.3,
            width: MediaQuery.of(context).size.width,
            child: Center(
                // child: picker.DatePicker.showDatePicker(
                //   context,
                //   dateFormat: 'dd MMMM yyyy HH:mm',
                //   initialDateTime: DateTime.now(),
                //   minDateTime: DateTime(2000),
                //   maxDateTime: DateTime(3000),
                //   onMonthChangeStartWithFirstDate: true,
                //   onConfirm: (dateTime, List<int> index) {
                //     DateTime selectdate = dateTime;
                //     final selIOS = DateFormat('dd-MMM-yyyy - HH:mm').format(selectdate);
                //     print(selIOS);
                //   },
                // )

               child: CupertinoDatePicker(
              showDayOfWeek: true,
              minimumDate: DateTime.now(),
              dateOrder: DatePickerDateOrder.dmy,
              onDateTimeChanged: (va) {
                dateTime = DateFormat().add_jms().format(va);
                Milliseconds = va.microsecondsSinceEpoch;
                notificationtime = va;
                print(dateTime);
              },
            )
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
                width: MediaQuery.of(context).size.width,
                child: CupertinoTextField(
                  placeholder: "Add Label",
                  controller: controller,
                )),
          ),
          SizedBox(height: 10,),
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(" Repeat daily"),
              ),
              CupertinoSwitch(
                value: repeat,
                onChanged: (bool value) {
                  repeat = value;
                  if (repeat == false) {
                    name = notificationtime.toString();
                  } else {
                    name = "Everyday";
                  }

                  setState(() {});
                },
              ),
            ],
          ),
          SizedBox(height: 10,),
          CustomButton(
            buttonText: "Set Alarm",
              onPressed: () {
                if (repeat == false) {
                  final timeFormat = DateFormat.yMMMMEEEEd();
                  name = timeFormat.format(notificationtime!);
                } else {
                  name = "Everyday";
                }
                print('............$notificationtime');
                Random random = Random();
                int randomNumber = random.nextInt(100);

                context.read<AlarmProvider>().setAlarm(controller.text,
                    dateTime!, true, name!, randomNumber, Milliseconds!);
                context.read<AlarmProvider>().setData();

                context
                    .read<AlarmProvider>()
                    .scheduleNotification(notificationtime!, randomNumber, controller.text.toString());

                Navigator.pop(context);
              },
           ),
        ],
      ),
    );
  }
}
