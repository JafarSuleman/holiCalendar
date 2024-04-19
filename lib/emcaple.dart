import 'package:flutter/material.dart';
import 'package:intl/intl.dart';


class YearlyCalendar extends StatefulWidget {
  const YearlyCalendar({Key? key}) : super(key: key);

  @override
  _YearlyCalendarState createState() => _YearlyCalendarState();
}

class _YearlyCalendarState extends State<YearlyCalendar> {
  late int _currentYear;
  late int _currentMonth;
  late List<int> _months;

  @override
  void initState() {
    super.initState();
    var now = DateTime.now();
    _currentYear = now.year;
    _currentMonth = now.month; // Initialize _currentMonth
    _months = List.generate(12, (index) => index + 1);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.chevron_left),
                  onPressed: () {
                    setState(() {
                      _currentYear--;
                    });
                  },
                ),
                Text(
                  '$_currentYear',
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: const Icon(Icons.chevron_right),
                  onPressed: () {
                    setState(() {
                      _currentYear++;
                    });
                  },
                ),
              ],
            ),
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.all(8),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 9,
                  mainAxisSpacing: 0,
                ),
                itemCount: _months.length,
                itemBuilder: (context, index) {
                  int month = _months[index];
                  return _buildMonthCell(month);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMonthCell(int month) {
    String monthName = DateFormat.MMMM().format(DateTime(_currentYear, month));
    List<DateTime> daysOfMonth = _getDaysOfMonth(_currentYear, month);
    final weekdays = [
      'Su',
      'Mo',
      'Tu',
      'We',
      'Th',
      'Fr',
      'Sa',
    ];

    // Calculate starting weekday for the month
    final firstDay = DateTime(_currentYear, month, 1);
    final weekdayIndex = firstDay.weekday - 1; // Adjust for Monday as 0

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          monthName,
          style: const TextStyle(fontSize: 8, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10,),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: weekdays.map((day) => Text(day, style: const TextStyle(fontSize: 5, fontWeight: FontWeight.bold))).toList(),
        ),
        const SizedBox(height: 5),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 9,
                crossAxisSpacing: 4,
                mainAxisSpacing: 2,
              ),
              itemCount: daysOfMonth.length + weekdayIndex, // Add weekdays
              itemBuilder: (context, index) {
                if (index < weekdayIndex) {
                  // Display empty cells for days before the 1st
                  return Container(
                    color: Colors.transparent,
                  );
                }

                final day = daysOfMonth[index - weekdayIndex];
                return Text(
                  day.day.toString(),
                  style: TextStyle(
                    fontSize: 4,
                    color: _currentMonth == month && day.day == DateTime.now().day
                        ? Colors.red // Highlight current day of current month
                        : Colors.black,
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  List<DateTime> _getDaysOfMonth(int year, int month) {
    int daysInMonth = DateTime(year, month + 1, 0).day;
    List<DateTime> days = [];
    for (int i = 1; i <= daysInMonth; i++) {
      days.add(DateTime(year, month, i));
    }
    return days;
  }
}
