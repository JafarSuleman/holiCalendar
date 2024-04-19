import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_storage/get_storage.dart';
import 'package:holidays_calendar/app_functions/custom_button.dart';
import 'package:holidays_calendar/app_functions/custom_drawer.dart';
import 'package:holidays_calendar/app_functions/yearly_calendar.dart';
import 'package:holidays_calendar/provider/theme_changer_privider.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

import 'app_functions/add_Dialogue_box.dart';
import 'holiday_model.dart';

class HoliDaysScreen extends StatefulWidget {
  final String? selectedCountryId;
  final String selectedCountryName;
  const HoliDaysScreen({super.key, this.selectedCountryId, required this.selectedCountryName,});

  @override
  State<HoliDaysScreen> createState() => _HoliDaysScreenState();
}

class _HoliDaysScreenState extends State<HoliDaysScreen> with SingleTickerProviderStateMixin {
  late Map<DateTime, List<dynamic>> events;
  late String selectedCountryId;
  late CalendarFormat calendarFormat;
  late DateTime focusedDay;

  Future<Map<String, dynamic>> loadJsonFromAssets(String filePath) async {
    String jsonString = await rootBundle.loadString(filePath);
    return jsonDecode(jsonString);
  }

  late Map<String, dynamic> jsonData;
  String? name;


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
  late TabController _tabController;

  late List<Holidays> holidays = [];
  List<String> eventsList = [];
  @override
  void initState() {
    super.initState();
    chooseHoliDaysList = holiDaysList.first;
    chooseCalendarList = calendarList.first;
    chooseCalendar = monthlyYearly.first;
    calendarFormat = CalendarFormat.month;
    selectedCountryId = widget.selectedCountryId ?? "";
    events = getEvents();
    focusedDay = DateTime.now();
    selectedDay = DateTime.now();
    _tabController = TabController(length: 3, vsync: this,);
    _tabController.addListener(_handleTabSelection);
    loadHolidayData();
    favourites = (storage.read('events') as List?)?.cast<Map<String, dynamic>>() ?? [];
  }
  void _handleTabSelection() {
    setState(() {}); // Update the state to rebuild the widget tree
  }
  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  final storage = GetStorage();
   List<Map<String, dynamic>>? favourites;

  Future<void> loadHolidayData() async {
    try {
      String data = await rootBundle.loadString('assets/country/$selectedCountryId.json');
      final jsonResult = json.decode(data);
      List<dynamic> holidayList = jsonResult['response']['holidays'];
      setState(() {
        holidays = holidayList.map((json) => Holidays.fromJson(json)).toList();
      });
    } catch (e) {
      print('Error loading holiday data: $e');

    }
  }


  Map<DateTime, List<dynamic>> getEvents() {
    Map<DateTime, List<dynamic>> events = {};
    events[DateTime.utc(2024, 1, 1)] = ['New Year'];
    events[DateTime.utc(2024, 7, 4)] = ['Independence Day'];
    events[DateTime.utc(2024, 12, 25)] = ['Christmas'];
    events[DateTime.utc(2024, 3, 23)] = ['Pakistan Resolution Day'];

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
          toolbarHeight: 30,
          backgroundColor: themeChanger.themeMode == ThemeMode.dark ? Colors.grey[800] : const Color(0xffEDFDFE),
          actions: <Widget>[
            IconButton(
              icon: const Icon(
                Icons.add,
                weight: 10,
              ),
              onPressed: () {
                _showAddDialogue(context);
              },
            )
          ],
          centerTitle: true,
          title:    Text(_getAppBarTitle(),style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),)
        ),
        drawer: CustomDrawer(selectedCountryId: widget.selectedCountryId.toString(), selectedCountryName: widget.selectedCountryName,),

        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              TabBar(
                controller: _tabController,
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
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                    children: [
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
                                    style:  TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w400,
                                      color:  themeChanger.themeMode == ThemeMode.dark ? Colors.grey : Colors.black,
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
                                    style:  TextStyle(

                                      fontSize: 15,
                                      fontWeight: FontWeight.w400,
                                      color:  themeChanger.themeMode == ThemeMode.dark ? Colors.grey : Colors.black,
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
                              Expanded(
                                child: ListView.builder(
                                  itemCount: holidays.length,
                                  itemBuilder: (context, index) {
                                    final holidaysByMonth = groupHolidaysByMonth(holidays);
                                    return Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: holidaysByMonth.keys.map((month) {
                                        return Column(
                                          children: [
                                            Container(
                                              height: 41,
                                              width: 392,
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                border: Border.all(width: 1.0),
                                                borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(15), bottomRight: Radius.circular(15)),
                                              ),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  Text(_getMonthName(month) ?? '',style: const TextStyle(
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.bold
                                                  ),),
                                                  const SizedBox(width: 5,),
                                                  Text(holidays[index].date?.datetime?.year.toString() ?? '',style: const TextStyle(
                                                      fontSize: 20,
                                                      fontWeight: FontWeight.bold
                                                  )),
                                                ],
                                              ),
                                            ),
                                            ...holidaysByMonth[month]!.map((holiday) {
                                              return Column(
                                                children: [
                                                  ListTile(
                                                    title: Row(
                                                      children: [
                                                        Container(
                                                            height: 35,
                                                            width: 35,
                                                            decoration: BoxDecoration(
                                                              color: Colors.white,
                                                              borderRadius: BorderRadius.circular(20),
                                                              border: Border.all(width: 1.0,color: const Color(0xffE25E2A)),
                                                            ),
                                                            child: Center(child: Text(getWeekDayFromISODate(holiday.date?.iso.toString() ?? ''), style: const TextStyle(fontSize: 10,color: Color(0xff0720FB))))),
                                                        const SizedBox(width: 2,),
                                                        Container(
                                                            height: 35,
                                                            width: 35,
                                                            decoration: BoxDecoration(
                                                              color: Colors.white,
                                                              borderRadius: BorderRadius.circular(20),
                                                              border: Border.all(width: 1.0,color: const Color(0xffE25E2A)),
                                                            ),
                                                            child: Center(child: Text(holiday.date?.datetime?.day.toString() ?? '', style: const TextStyle(fontSize: 10,color: Color(0xff0720FB))))),
                                                        Expanded( // Add Expanded widget
                                                          flex: 1, // Take up available space
                                                          child: Text(
                                                            holiday.name.toString() ?? '',
                                                            style: const TextStyle(fontWeight: FontWeight.w600,fontSize: 12,color: Color(0xffE25E2A),
                                                            ),
                                                            textAlign: TextAlign.center,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    trailing: InkWell(
                                                      child: Image.asset('assets/discription.png', scale: 4),
                                                      onTap: () {
                                                        showDialog(
                                                          context: context,
                                                          builder: (BuildContext context) {
                                                            return AlertDialog(
                                                              title: const Text('Description'),
                                                              content: Text(holiday.description ?? 'No description available'),
                                                              actions: <Widget>[
                                                                TextButton(
                                                                  onPressed: () {
                                                                    Navigator.of(context).pop();
                                                                  },
                                                                  child: const Text('Close'),
                                                                ),
                                                              ],
                                                            );
                                                          },
                                                        );
                                                      },
                                                    ) ,
                                                  ),
                                                  const Divider(), // Add divider after each holiday
                                                ],
                                              );
                                            }).toList(),
                                          ],
                                        );
                                      }).toList(),
                                    );
                                  },
                                ),
                              ),

                        ],
                      ),

                      Center(
                        child: Stack(
                          children: [
                        favourites!.isEmpty ?
                        Column(
                          children: [
                            Image.asset('assets/eventpic.png',scale: 2,),
                            const SizedBox(height: 10),
                            const Text(
                              "No Events",
                              style: TextStyle(fontSize: 20),
                            ),
                          ],
                        ) : Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SizedBox(
                            width: double.infinity,
                            height: 600,
                            child: ListView.builder(
                                itemCount: favourites?.length,
                                itemBuilder: (context,index){
                                  return ListTile(
                                    title: Column(
                                      children: [
                                        Container(
                                          height: 41,
                                          width: 392,
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            border: Border.all(width: 1.0),
                                            borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(15), bottomRight: Radius.circular(15)),
                                          ),
                                          child: Center(
                                            child: Text(
                                              DateFormat('MMMM yyyy').format(DateTime.parse(favourites![index]['date'].toString())),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    subtitle: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(favourites![index]['reminder'].toString()),
                                        Expanded(
                                            flex: 1,
                                            child: Text(favourites![index]['event'].toString(),textAlign: TextAlign.center,)),
                                        IconButton(
                                          icon: const Icon(Icons.delete),
                                          onPressed: () {
                                            List<dynamic> events = storage.read('events') ?? [];
                                            events.remove(favourites![index]);
                                            storage.write('events', events);
                                            setState(() {
                                              ScaffoldMessenger.of(context).showSnackBar(
                                                const SnackBar(
                                                  content: Text('Event deleted'),
                                                  duration: Duration(seconds: 2),
                                                ),
                                              );
                                            });
                                          },
                                        ),

                                      ],

                                    ),

                                  );
                                }),
                          ),
                        ),
                            Align(
                              alignment: Alignment.bottomRight,
                              child: CustomButton(iconData: Icons.add ,width: 150,buttonText: 'Add Event', onPressed: (){
                                _showAddDialogue(context);
                              }),
                            ),
                      ]
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
                                    style:   TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w400,
                                      color:  themeChanger.themeMode == ThemeMode.dark ? Colors.grey : Colors.black,

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
  Map<int, List<Holidays>> groupHolidaysByMonth(List<Holidays> holidays) {
    Map<int, List<Holidays>> holidaysByMonth = {};
    for (var holiday in holidays) {
      final month = holiday.date?.datetime?.month;
      if (month != null) {
        if (holidaysByMonth.containsKey(month)) {
          holidaysByMonth[month]!.add(holiday);
        } else {
          holidaysByMonth[month] = [holiday];
        }
      }
    }
    return holidaysByMonth;
  }


  String getWeekDayFromISODate(String isoDate) {
    DateTime dateTime = DateTime.parse(isoDate);
    return DateFormat('E').format(dateTime);
  }
  String? _getMonthName(int? month) {
    if (month != null) {
      switch (month) {
        case 1:
          return 'January';
        case 2:
          return 'February';
        case 3:
          return 'March';
        case 4:
          return 'April';
        case 5:
          return 'May';
        case 6:
          return 'June';
        case 7:
          return 'July';
        case 8:
          return 'August';
        case 9:
          return 'September';
        case 10:
          return 'October';
        case 11:
          return 'November';
        case 12:
          return 'December';
        default:
          return null;
      }
    }
    return null;
  }
  void _showAddDialogue(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return AddDialogue(
          onEventAdded: () {
            setState(() {
            });
            Navigator.pop(context);
          },
        );
      },
    );
  }

  List<dynamic> getEventsForDay(DateTime day) {
    return events[day] ?? [];
  }
  String _getAppBarTitle() {
    switch (_tabController.index) {
      case 0:
        return 'Holidays';
      case 1:
        return 'Events';
      case 2:
        return 'Calendar';
      default:
        return '';
    }
  }
}


