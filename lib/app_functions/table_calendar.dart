import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Table Calendar Example'),
        ),
        body: const CalendarPage(),
      ),
    );
  }
}

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  late DateTime focusedDay;
  late DateTime selectedDay;
  late CalendarFormat calendarFormat;

  @override
  void initState() {
    super.initState();
    focusedDay = DateTime.now();
    selectedDay = DateTime.now();
    calendarFormat = CalendarFormat.month;
  }

  Map<DateTime, List<dynamic>> getEventsForDay(DateTime day) {

    return {};
  }

  bool isSameDay(DateTime day1, DateTime day2) {
    return day1.year == day2.year && day1.month == day2.month && day1.day == day2.day;
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: TableCalendar(

          daysOfWeekStyle: const DaysOfWeekStyle(
            weekdayStyle: TextStyle(
              fontSize: 4,
            ),
            weekendStyle: TextStyle(
              fontSize: 4,
            )
          ),
          headerStyle: const HeaderStyle(
            leftChevronPadding: EdgeInsets.only(left: 70),
            rightChevronPadding: EdgeInsets.only(right: 70),
            titleCentered: true,
            headerPadding: EdgeInsets.only(top: 100),
            formatButtonVisible: false,
            titleTextStyle: TextStyle(
              fontSize: 10,
            ),
            // Hide format button
          ),
          calendarStyle: const CalendarStyle(
            tablePadding: EdgeInsets.all(140),
            weekendTextStyle: TextStyle(color: Colors.red,fontSize: 5),
            defaultTextStyle: TextStyle(fontSize: 5),


          ),
          firstDay: DateTime.utc(2021, 1, 1),
          lastDay: DateTime.utc(2030, 12, 31),
          focusedDay: focusedDay,
          calendarFormat: calendarFormat,
          availableCalendarFormats: const {
            CalendarFormat.month: 'Month',
          },
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
      ),
    );
  }
}
