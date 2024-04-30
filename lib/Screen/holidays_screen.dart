import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:holidays_calendar/app_functions/custom_button.dart';
import 'package:holidays_calendar/app_functions/custom_drawer.dart';
import 'package:holidays_calendar/provider/theme_changer_privider.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../calender_tab.dart';
import '../event_tab.dart';
import '../holiday_model.dart';

class HoliDaysScreen extends StatefulWidget {
  final String? selectedCountryId;
  final String selectedCountryName;

  const HoliDaysScreen({
    super.key,
    this.selectedCountryId,
    required this.selectedCountryName,
  });

  @override
  State<HoliDaysScreen> createState() => _HoliDaysScreenState();
}

class _HoliDaysScreenState extends State<HoliDaysScreen>
    with SingleTickerProviderStateMixin {
  dynamic size, height, width;
  final ScrollController scrollController = ScrollController();
  late Map<DateTime, List<dynamic>> events;
  late String selectedCountryId;
  late Map<String, dynamic> jsonData;

  String? chooseHoliDaysList;
  List<String> holiDaysList = [
    "All",
    "National holiday",
    "Observance day",
  ];
  String? chooseCalendarList;
  List<String> calendarList = [
    "2024",
  ];
  Map<DateTime, List<dynamic>> holidayEvents = {};
  late TabController _tabController;

  late List<Holidays> holidays = [];
  List<String> eventsList = [];
  List<DateTime>? reminderTime;

  @override
  void initState() {
    super.initState();
    chooseHoliDaysList = holiDaysList.first;
    chooseCalendarList = calendarList.first;
    selectedCountryId = widget.selectedCountryId ?? "";
    loadBannerAd();
    _tabController = TabController(
      length: 3,
      vsync: this,
    );
    _tabController.addListener(_handleTabSelection);
    loadHolidayData();
  }

  void _handleTabSelection() {
    setState(() {});
  }

  @override
  void dispose() {
    bannerAd?.dispose();
    _tabController.dispose();
    super.dispose();
  }

  BannerAd? bannerAd;

  Future<void> loadBannerAd() async {
    bannerAd = BannerAd(
      adUnitId: 'ca-app-pub-3940256099942544/6300978111',
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (_) {
          setState(() {});
        },
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
        },
      ),
    )..load();
  }

  Future<Map<String, dynamic>> loadJsonFromAssets(String filePath) async {
    String jsonString = await rootBundle.loadString(filePath);
    return jsonDecode(jsonString);
  }

  Future<void> loadHolidayData() async {
    try {
      String data =
          await rootBundle.loadString('assets/country/$selectedCountryId.json');
      final jsonResult = json.decode(data);
      List<dynamic> holidayList = jsonResult['response']['holidays'];
      setState(() {
        print('JSON Result: $jsonResult');

        holidays = holidayList.map((json) => Holidays.fromJson(json)).toList();
      });
    } catch (e) {
      print('Error loading holiday data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    height = size.height;
    width = size.width;
    final themeChanger = Provider.of<ThemeChanger>(context);
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        bottomNavigationBar: bannerAd != null
            ? Container(
                margin: const EdgeInsets.only(bottom: 10),
                height: 50,
                width: double.infinity,
                child: AdWidget(ad: bannerAd!),
              )
            : const SizedBox(),
        backgroundColor: const Color(0xffEDFDFE),
        appBar: AppBar(
            backgroundColor: const Color(0xffEDFDFE),
            toolbarHeight: 30,
            centerTitle: true,
            title: Text(
              _getAppBarTitle(),
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            )),
        drawer: CustomDrawer(
          selectedCountryId: widget.selectedCountryId.toString(),
          selectedCountryName: widget.selectedCountryName,
        ),
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
                child: TabBarView(controller: _tabController, children: [
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.only(left: 10),
                              height: height / 15,
                              width: chooseHoliDaysList == holiDaysList.first
                                  ? width / 5
                                  : width / 2.4,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(
                                  color: Colors.black,
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: DropdownButton(
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.black,
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
                              height: height / 15,
                              width: width / 5,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(
                                  color: Colors.black,
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: DropdownButton(
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.black,
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
                      Expanded(
                        child: Scrollbar(
                          controller: scrollController,
                          scrollbarOrientation: ScrollbarOrientation.right,
                          radius: const Radius.circular(20),
                          thumbVisibility: true,
                          trackVisibility: true,
                          interactive: true,
                          thickness: 5,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ListView.builder(
                              controller: scrollController,
                              itemCount: 1,
                              itemBuilder: (context, index) {
                                final holidaysByMonth =
                                    groupHolidaysByMonth(holidays);
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: holidaysByMonth.keys.map((month) {
                                    final monthHolidays =
                                        holidaysByMonth[month];
                                    if (monthHolidays != null &&
                                        monthHolidays.isNotEmpty) {
                                      final filteredHolidays =
                                          monthHolidays.where((holiday) {
                                        if (chooseHoliDaysList ==
                                            holiDaysList.first) {
                                          return true;
                                        } else if (chooseHoliDaysList ==
                                            holiDaysList[1]) {
                                          return holiday.type?.contains(
                                                  "National holiday") ??
                                              false;
                                        } else if (chooseHoliDaysList ==
                                            holiDaysList[2]) {
                                          return holiday.type
                                                  ?.contains("Observance") ??
                                              false;
                                        }
                                        return false;
                                      }).toList();
                                      if (filteredHolidays.isNotEmpty) {
                                        return Column(
                                          children: [
                                            Container(
                                              height: height / 20,
                                              width: double.infinity,
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                border: Border.all(width: 1.0),
                                                borderRadius:
                                                    const BorderRadius.only(
                                                        bottomLeft:
                                                            Radius.circular(15),
                                                        bottomRight:
                                                            Radius.circular(
                                                                15)),
                                              ),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    _getMonthName(month) ?? '',
                                                    style: const TextStyle(
                                                        fontSize: 20,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  const SizedBox(
                                                    width: 5,
                                                  ),
                                                  Text(
                                                      holidays[index]
                                                              .date
                                                              ?.datetime
                                                              ?.year
                                                              .toString() ??
                                                          '',
                                                      style: const TextStyle(
                                                          fontSize: 20,
                                                          fontWeight:
                                                              FontWeight.bold)),
                                                ],
                                              ),
                                            ),
                                            ...filteredHolidays.map((holiday) {
                                              return Column(
                                                children: [
                                                  ListTile(
                                                    title: Row(
                                                      children: [
                                                        Container(
                                                          height: height / 20,
                                                          width: width / 9,
                                                          decoration:
                                                              BoxDecoration(
                                                            shape:
                                                                BoxShape.circle,
                                                            color: Colors.white,
                                                            border: Border.all(
                                                                width: 1.0,
                                                                color: const Color(
                                                                    0xffE25E2A)),
                                                          ),
                                                          child: Center(
                                                            child: Text(
                                                                DateFormat('E')
                                                                    .format(
                                                                  DateTime.parse(
                                                                      holiday
                                                                          .date!
                                                                          .iso
                                                                          .toString()),
                                                                ),
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        width /
                                                                            30,
                                                                    color: const Color(
                                                                        0xff0720FB))),
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                          width: 2,
                                                        ),
                                                        Container(
                                                          height: height / 20,
                                                          width: width / 9,
                                                          decoration:
                                                              BoxDecoration(
                                                            shape:
                                                                BoxShape.circle,
                                                            color: Colors.white,
                                                            border: Border.all(
                                                                width: 1.0,
                                                                color: const Color(
                                                                    0xffE25E2A)),
                                                          ),
                                                          child: Center(
                                                            child: Text(
                                                                holiday
                                                                        .date
                                                                        ?.datetime
                                                                        ?.day
                                                                        .toString() ??
                                                                    '',
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        width /
                                                                            30,
                                                                    color: Color(
                                                                        0xff0720FB))),
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                          width: 1,
                                                        ),
                                                        Expanded(
                                                          flex: 1,
                                                          child: Text(
                                                            holiday.name
                                                                    .toString() ??
                                                                '',
                                                            style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                              fontSize:
                                                                  width / 26,
                                                              color: holiday
                                                                          .type
                                                                          ?.contains(
                                                                              "Observance") ??
                                                                      false
                                                                  ? themeChanger
                                                                      .importantDayColor
                                                                  : themeChanger
                                                                      .holidayColor,
                                                            ),
                                                            textAlign: TextAlign
                                                                .center,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    trailing: InkWell(
                                                      child: Image.asset(
                                                          'assets/discription.png',
                                                          scale: 4),
                                                      onTap: () {
                                                        showDialog(
                                                          context: context,
                                                          builder: (BuildContext
                                                              context) {
                                                            return AlertDialog(
                                                              backgroundColor: themeChanger
                                                                          .themeMode ==
                                                                      ThemeMode
                                                                          .dark
                                                                  ? Colors
                                                                      .grey[800]
                                                                  : const Color(
                                                                      0xffEDFDFE),
                                                              title: Text(holiday
                                                                  .name
                                                                  .toString()),
                                                              content: Text(holiday
                                                                      .description ??
                                                                  'No description available'),
                                                              actions: <Widget>[
                                                                CustomButton(
                                                                  onPressed:
                                                                      () {
                                                                    Navigator.of(
                                                                            context)
                                                                        .pop();
                                                                  },
                                                                  buttonText:
                                                                      'Close',
                                                                ),
                                                              ],
                                                            );
                                                          },
                                                        );
                                                      },
                                                    ),
                                                  ),
                                                  const Divider(),
                                                ],
                                              );
                                            }).toList(),
                                          ],
                                        );
                                      } else {
                                        return const SizedBox();
                                      }
                                    } else {
                                      return const SizedBox();
                                    }
                                  }).toList(),
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const EventsTAb(),
                  const CalenderTab(),
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
