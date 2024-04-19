import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class YearlyCalendarGrid extends StatefulWidget {
  const YearlyCalendarGrid({Key? key}) : super(key: key);

  @override
  _YearlyCalendarGridState createState() => _YearlyCalendarGridState();
}

class _YearlyCalendarGridState extends State<YearlyCalendarGrid> {
  late int _currentYear;

  @override
  void initState() {
    super.initState();
    _currentYear = DateTime.now().year;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 450, // Set a fixed height or use MediaQuery
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  setState(() {
                    _currentYear--;
                  });
                },
              ),
              Text(
                '$_currentYear',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.arrow_forward),
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
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisSpacing: 4.0,
                crossAxisSpacing: 15.0,
              ),
              itemCount: 12,
              itemBuilder: (BuildContext context, int index) {
                return MonthCalendar(year: _currentYear, month: index + 1);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class MonthCalendar extends StatelessWidget {
  final int year;
  final int month;

  const MonthCalendar({required this.year, required this.month, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    DateTime today = DateTime(now.year, now.month, now.day);
    DateTime firstDayOfMonth = DateTime(year, month, 1);
    int daysInMonth = DateTime(year, month + 1, 0).day;

    List<String> weekdays = [
      'S',
      'M',
      'T',
      'W',
      'T',
      'F',
      'S',
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              DateFormat.MMMM().format(firstDayOfMonth),
              style: const TextStyle(
                fontSize: 8,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),

        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 7,
          ),
          itemCount: daysInMonth + 7,
          itemBuilder: (BuildContext context, int index) {
            if (index < 7) {
              // Weekday labels
              return Center(
                child: Text(
                  weekdays[index],
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 5
                  ),

                ),
              );
            } else {
              // Days of the month
              DateTime day = DateTime(year, month, index - 6);
              bool isToday = day.isAtSameMomentAs(today);
              bool isCurrentMonth = day.month == now.month;
              bool isWeekend = (index % 7 == 0) || (index % 7 == 6); // Saturday or Sunday

              return Center(
                child: Text(
                  '${day.day}',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: isToday && isCurrentMonth ? Colors.red : (isWeekend ? Colors.red : null),
                      fontSize: 4
                  ),
                ),
              );
            }
          },
        ),
      ],
    );
  }
}

