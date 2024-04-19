import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:holidays_calendar/app_functions/custom_drawer.dart';
import 'package:holidays_calendar/app_functions/yearly_calendar.dart';
import 'package:holidays_calendar/provider/theme_changer_privider.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

import 'holiday_model.dart';

class HoliDaysScreen extends StatefulWidget {
  const HoliDaysScreen({super.key});

  @override
  State<HoliDaysScreen> createState() => _HoliDaysScreenState();
}

class _HoliDaysScreenState extends State<HoliDaysScreen> {
  late Future<HolidaysModel> _futureHolidays;
  late Map<DateTime, List<dynamic>> events;
  late CalendarFormat calendarFormat;
  late DateTime focusedDay;
  late DateTime selectedDay;
  String? chooseCalendar;
  List<String> monthlyYearly = [
    'Monthly',
    'Yearly',
  ];
  String? chooseHoliDaysList;
  List<String> holiDaysList = [
    "All",
    "Holidays",
    "observance days",
  ];
  String? chooseCalendarList;
  List<String> calendarList = [
    "2024",
    "2025",
    "2026",
    "2027",
    "2028",
  ];

  @override
  void initState() {
    _futureHolidays = fetchHolidays();
    chooseHoliDaysList = holiDaysList.first;
    chooseCalendarList = calendarList.first;
    chooseCalendar = monthlyYearly.first;
    calendarFormat = CalendarFormat.month;
    events = getEvents();

    focusedDay = DateTime.now();
    selectedDay = DateTime.now();
    super.initState();
  }

  HolidaysModel parseHolidaysModel(String responseBody) {
    final parsed = jsonDecode(responseBody);
    return HolidaysModel.fromJson(parsed);
  }

  Future<HolidaysModel> fetchHolidays() async {
    final response = await http.get(Uri.parse(
        'https://calendarific.com/api/v2/holidays?api_key=YOUR_API_KEY&country=PK&year=2024'));

    if (response.statusCode == 200) {
      return parseHolidaysModel(response.body);
    } else {
      throw Exception('Failed to load holidays');
    }
  }

  Map<DateTime, List<dynamic>> getEvents() {
    // Populate events map with holidays and important days
    Map<DateTime, List<dynamic>> events = {};

    // Add holidays
    events[DateTime.utc(2024, 1, 1)] = ['New Year'];
    events[DateTime.utc(2024, 7, 4)] = ['Independence Day'];
    events[DateTime.utc(2024, 12, 25)] = ['Christmas'];
    events[DateTime.utc(2024, 3, 23)] = ['Pakistan Resolution Day'];

    // Add important days
    events[DateTime.utc(2024, 2, 14)] = ['Valentine\'s Day'];
    events[DateTime.utc(2024, 5, 12)] = ['Mother\'s Day'];
    events[DateTime.utc(2024, 6, 16)] = ['Father\'s Day'];

    return events;
  }

  @override
  Widget build(BuildContext context) {
    final themeChanger = Provider.of<ThemeChanger>(context);
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: themeChanger.themeMode == ThemeMode.dark ? Colors.grey[800] : const Color(0xffEDFDFE),
        appBar: AppBar(
          backgroundColor: themeChanger.themeMode == ThemeMode.dark ? Colors.grey[800] : const Color(0xffEDFDFE),
          actions: <Widget>[
            IconButton(
              icon: const Icon(
                Icons.add,
                weight: 10,
              ),
              onPressed: () {},
            )
          ],
          centerTitle: true,
          title: const Text(
            "HoliDays",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
          ),
        ),
        drawer: const CustomDrawer(),

        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              TabBar(
                  indicatorPadding: const EdgeInsets.all(7),
                  dividerHeight: 0,
                  indicatorSize: TabBarIndicatorSize.tab,
                  labelColor: Colors.grey,
                  indicator: BoxDecoration(
                    color: const Color(0xffD9D9D9),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  tabs: [
                    Tab(
                      iconMargin: const EdgeInsets.all(5),
                      text: 'Holidays',
                      icon: Image.asset(
                        "assets/holiidays.png",
                        scale: 4,
                      ),
                    ),
                    Tab(
                      iconMargin: const EdgeInsets.all(5),
                      text: 'Events',
                      icon: Image.asset(
                        "assets/Event.png",
                        scale: 4,
                      ),
                    ),
                    Tab(
                      iconMargin: const EdgeInsets.all(5),
                      text: 'Calendar',
                      icon: Image.asset(
                        "assets/calendar.png",
                        scale: 4,
                      ),
                    ),
                  ]),
              const SizedBox(
                height: 20,
              ),
              Expanded(
                child: TabBarView(children: [
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.only(left: 10),
                              height: 50,
                              width: 70,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(
                                  color: Colors.black,
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: DropdownButton(
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w400,
                                  color: themeChanger.themeMode == ThemeMode.dark ? Colors.grey : Colors.black,
                                ),
                                underline: const SizedBox(),
                                isExpanded: true,
                                value: chooseHoliDaysList,
                                onChanged: (newvalue) {
                                  setState(() {
                                    chooseHoliDaysList = newvalue;
                                  });
                                },
                                items: holiDaysList.map((e) {
                                  return DropdownMenuItem(
                                    value: e,
                                    child: Text(e),
                                  );
                                }).toList(),
                              ),
                            ),
                            const SizedBox(
                              width: 20,
                            ),
                            Container(
                              padding: const EdgeInsets.only(left: 10),
                              height: 50,
                              width: 110,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(
                                  color: Colors.black,
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: DropdownButton(
                                style: TextStyle(

                                  fontSize: 15,
                                  fontWeight: FontWeight.w400,
                                  color: themeChanger.themeMode == ThemeMode.dark ? Colors.grey : Colors.black,
                                ),
                                underline: const SizedBox(),
                                isExpanded: true,
                                value: chooseCalendarList,
                                onChanged: (newvalue) {
                                  setState(() {
                                    chooseCalendarList = newvalue;
                                  });
                                },
                                items: calendarList.map((e) {
                                  return DropdownMenuItem(
                                    value: e,
                                    child: Text(e),
                                  );
                                }).toList(),
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (chooseHoliDaysList == holiDaysList.first)
                        if (chooseCalendarList == calendarList.first)
                          buildFutureBuilder('all'),
                      if (chooseCalendarList == calendarList[1])
                        buildFutureBuilder('holidays'),
                      if (chooseCalendarList == calendarList[2])
                        buildFutureBuilder('observance'),
                    ],
                  ),

                  Center(
                    child: Column(
                      children: [
                        Image.asset('assets/eventpic.png'),
                        const Text(
                          "No Events",
                          style: TextStyle(fontSize: 30),
                        ),
                      ],
                    ),
                  ),
                  Center(
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.only(left: 10),
                              height: 50,
                              width: 100,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: DropdownButton(
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w400,
                                  color: themeChanger.themeMode == ThemeMode.dark ? Colors.grey : Colors.black,

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
                            headerStyle: const HeaderStyle(
                              titleCentered: true,
                            ),
                            firstDay: DateTime.utc(2021, 1, 1),
                            lastDay: DateTime.utc(2030, 12, 31),
                            focusedDay: focusedDay,
                            eventLoader: getEventsForDay,
                            calendarFormat: CalendarFormat.month,
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
                  ),
                ]),
              ),
            ],
          ),
        ),
      ),
    );
  }

  FutureBuilder<HolidaysModel> buildFutureBuilder(String primaryType) {
    return FutureBuilder<HolidaysModel>(
      future: fetchHolidays(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (snapshot.hasData) {
          final List<Holidays>? holidays = snapshot.data!.response?.holidays;
          if (holidays == null || holidays.isEmpty) {
            return const Center(child: Text('No holidays found.'));
          } else {
            // Filter holidays based on the selected type
            List<Holidays> filteredHolidays = [];
            if (primaryType == 'all') {
              filteredHolidays = holidays;
            } else {
              filteredHolidays = holidays
                  .where((holiday) => holiday.primaryType == 'Observance')
                  .toList();
            }

            // Group holidays by month
            Map<String, List<dynamic>> holidaysByMonth = {};
            for (var holiday in filteredHolidays) {
              String monthYear =
                  getMonthYearFromISODate(holiday.date!.iso.toString());
              if (!holidaysByMonth.containsKey(monthYear)) {
                holidaysByMonth[monthYear] = [];
              }
              holidaysByMonth[monthYear]!.add(holiday);
            }

            // Build UI based on filtered holidays
            return Expanded(
              child: ListView.builder(
                itemCount: holidaysByMonth.length,
                itemBuilder: (BuildContext context, int index) {
                  String monthYear = holidaysByMonth.keys.toList()[index];
                  List<dynamic> holidays = holidaysByMonth[monthYear]!;
                  return _buildMonthHolidays(monthYear, holidays);
                },
              ),
            );
          }
        } else {
          return const Center(child: Text('No data available.'));
        }
      },
    );
  }

  List<dynamic> getEventsForDay(DateTime day) {
    return events[day] ?? [];
  }

  Widget _buildMonthHolidays(String monthYear, List<dynamic> holidays) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            height: 41,
            width: 393,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.only(
                  bottomRight: Radius.circular(15),
                  bottomLeft: Radius.circular(15)),
              border: Border.all(
                width: 1.0,
              ),
            ),
            child: Center(
              child: Text(
                monthYear,
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
        Column(
          children: holidays.map<Widget>((holiday) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: _buildHoliday(holiday),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildHoliday(Holidays holiday) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
                height: 39,
                width: 39,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.deepOrange, width: 0.3),
                ),
                child: Center(child: Text(getWeekDayFromISODate(holiday.date!.iso!)))),
            Container(
                height: 39,
                width: 39,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.deepOrange, width: 0.3),
                ),
                child: Center(
                    child: Text(
                  getDayFromISODate(holiday.date!.iso!),
                  style: const TextStyle(color: Color(0xff0720FB)),
                ))),
            Text(
              holiday.name!,
              style: const TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: Color(0xffE25E2A),
              ),
            ),
            const Divider(),
            InkWell(
              onTap: () {
                showDescriptionDialog(holiday.name!, holiday.description!);
              },
              child: Image.asset(
                'assets/discription.png',
                scale: 4,
              ),
            ),
          ],
        ),
        const Divider(),
      ],
    );
  }

  void showDescriptionDialog(String name, String description) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('$name ?'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Description:'),
            const SizedBox(height: 8),
            Text(description),
          ],
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  String getMonthYearFromISODate(String isoDate) {
    DateTime dateTime = DateTime.parse(isoDate);
    return DateFormat('MMMM yyyy').format(dateTime);
  }

  String getDayFromISODate(String isoDate) {
    DateTime dateTime = DateTime.parse(isoDate);
    return DateFormat('d').format(dateTime);
  }

  String getWeekDayFromISODate(String isoDate) {
    DateTime dateTime = DateTime.parse(isoDate);
    return DateFormat('E').format(dateTime);
  }
}
