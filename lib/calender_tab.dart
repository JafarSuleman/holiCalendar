import 'package:flutter/material.dart';
import 'package:holidays_calendar/provider/theme_changer_privider.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

import 'app_functions/yearly_calendar.dart';

class CalenderTab extends StatefulWidget {
  const CalenderTab({super.key});

  @override
  State<CalenderTab> createState() => _CalenderTabState();
}

class _CalenderTabState extends State<CalenderTab> {
  final ScrollController scrollController = ScrollController();
  late Map<DateTime, List<dynamic>> events;
  late String selectedCountryId;
  late CalendarFormat calendarFormat;
  late DateTime focusedDay;
  late Map<String, dynamic> jsonData;
  late DateTime selectedDay;
  String? chooseCalendar;
  List<String> monthlyYearly = [
    'Monthly',
    'Yearly',
  ];


  @override
  void initState() {
    super.initState();
    chooseCalendar = monthlyYearly.first;
    calendarFormat = CalendarFormat.month;
    focusedDay = DateTime.now();
    selectedDay = DateTime.now();
  }
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    final themeChanger = Provider.of<ThemeChanger>(context);
    return Center(
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.only(left: 10),
                height: height/30,
                width: width/3,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                ),
                child: DropdownButton(
                  style:   const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
                    color: Colors.black,

                  ),
                  underline: const SizedBox(),
                  isExpanded: true,
                  value: chooseCalendar,
                  onChanged: (newvalue) {
                    setState(() {
                      chooseCalendar = newvalue;
                    });
                  },
                  items: monthlyYearly.map((e) {
                    return DropdownMenuItem(
                      value: e,
                      child: Text(e),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
          if (chooseCalendar == monthlyYearly.first)
            TableCalendar(
              startingDayOfWeek: themeChanger.startWeek == StartWeek.monday
                  ? StartingDayOfWeek.monday
                  : StartingDayOfWeek.sunday,
              headerStyle: const HeaderStyle(
                titleCentered: true,
              ),
              firstDay: DateTime.utc(2021, 1, 1),
              lastDay: DateTime.utc(2030, 12, 31),
              focusedDay: focusedDay,
              calendarFormat: CalendarFormat.month,
              availableCalendarFormats: const {
                CalendarFormat.month: 'Month',
              },
              calendarStyle:  CalendarStyle(
                weekNumberTextStyle: const TextStyle(color: Colors.red),
                weekendTextStyle: TextStyle(color: themeChanger.sundayColor),
              ),
              onFormatChanged: (format) {
                setState(() {
                  calendarFormat = format;
                });
              },
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  this.selectedDay = selectedDay;
                  this.focusedDay = focusedDay;
                });
              },
              selectedDayPredicate: (day) {
                return isSameDay(selectedDay, day);
              },
            ),

          // const CalendarPage(),
          if (chooseCalendar != monthlyYearly.first)
            const YearlyCalendarGrid(),
        ],
      ),
    );
  }
}