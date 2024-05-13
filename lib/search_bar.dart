import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:holidays_calendar/provider/theme_changer_privider.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'Screen/Add_Alarm.dart';
import 'app_functions/custom_button.dart';
import 'holiday_model.dart';

class SearchBarr extends StatefulWidget {
  final String selectedCountryId;

  const SearchBarr({Key? key, required this.selectedCountryId})
      : super(key: key);

  @override
  State<SearchBarr> createState() => _SearchBarrState();
}

class _SearchBarrState extends State<SearchBarr> {
  late TextEditingController _searchController;
  List<Holidays> holidays = [];
  List<Holidays> filteredHolidays = [];
  bool _isLoading = false;
  dynamic size, height, width;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    //loadBannerAd();
    loadHolidayData();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> loadHolidayData() async {
    setState(() {
      _isLoading = true;
    });
    try {
      String data = await rootBundle
          .loadString('assets/country/${widget.selectedCountryId}.json');
      final jsonResult = json.decode(data);
      List<dynamic> holidayList = jsonResult['response']['holidays'];
      setState(() {
        holidays = holidayList.map((json) => Holidays.fromJson(json)).toList();
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _filterHolidays(String query) {
    setState(() {
      filteredHolidays = holidays.where((holiday) {
        return holiday.name!.toLowerCase().contains(query.toLowerCase());
      }).toList();
    });
  }

  // BannerAd? bannerAd;
  //
  // Future<void> loadBannerAd() async {
  //   bannerAd = BannerAd(
  //     adUnitId: 'ca-app-pub-3940256099942544/6300978111',
  //     size: AdSize.banner,
  //     request: const AdRequest(),
  //     listener: BannerAdListener(
  //       onAdLoaded: (_) {
  //         setState(() {});
  //       },
  //       onAdFailedToLoad: (ad, error) {
  //         ad.dispose();
  //       },
  //     ),
  //   )..load();
  // }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    height = size.height;
    width = size.width;
    final themeChanger = Provider.of<ThemeChanger>(context);
    return Scaffold(
      backgroundColor: const Color(0xffEDFDFE),
      // bottomNavigationBar: Container(
      //   height: 50,
      //   width: MediaQuery.of(context).size.width,
      //   child: bannerAd != null ? AdWidget(ad: bannerAd!) : SizedBox(),
      // ),
      appBar: AppBar(
        backgroundColor: const Color(0xffEDFDFE),
        title: const Text(
          'Search Holidays',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  TextFormField(
                    controller: _searchController,
                    onChanged: _filterHolidays,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.all(15),
                      labelText: 'Search',
                      fillColor: Colors.white,
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25.0),
                        borderSide: const BorderSide(),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25.0),
                        borderSide: const BorderSide(),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: Scrollbar(
                      scrollbarOrientation: ScrollbarOrientation.right,
                      radius: const Radius.circular(20),
                      thumbVisibility: true,
                      trackVisibility: true,
                      interactive: true,
                      thickness: 5,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ListView.builder(
                          itemCount: 1,
                          itemBuilder: (context, index) {
                            final holidaysByMonth =
                                groupHolidaysByMonth(filteredHolidays);
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: holidaysByMonth.keys.map((month) {
                                return Column(
                                  children: [
                                    Container(
                                      height: height / 20,
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        border: Border.all(width: 1.0),
                                        borderRadius: const BorderRadius.only(
                                            bottomLeft: Radius.circular(15),
                                            bottomRight: Radius.circular(15)),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            _getMonthName(month) ?? '',
                                            style: const TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold),
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
                                                  fontWeight: FontWeight.bold)),
                                        ],
                                      ),
                                    ),
                                    ...filteredHolidays.map((holiday) {
                                      return Column(
                                        children: [
                                          Container(
                                            margin: EdgeInsets.only(top: 10),
                                            height: 35,
                                            width: 250,
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: Colors.black),
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                            ),
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 15, right: 15),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Center(
                                                    child: Text(
                                                        DateFormat('E').format(
                                                          DateTime.parse(holiday
                                                              .date!.iso
                                                              .toString()),
                                                        ),
                                                        style: TextStyle(
                                                            fontSize:
                                                                width / 30,
                                                            color: const Color(
                                                                0xff0720FB))),
                                                  ),
                                                  Center(
                                                    child: Text(
                                                        holiday.date?.datetime
                                                                ?.day
                                                                .toString() ??
                                                            '',
                                                        style: TextStyle(
                                                            fontSize:
                                                                width / 30,
                                                            color: const Color(
                                                                0xffFD0707))),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          SizedBox(
                                            width: 200,
                                            child: Text(
                                              holiday.name.toString(),
                                              style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                fontSize: width / 22,
                                                color: holiday.type?.contains(
                                                            "Observance") ??
                                                        false
                                                    ? themeChanger
                                                        .importantDayColor
                                                    : themeChanger.holidayColor,
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              InkWell(
                                                child: Container(
                                                    height: height / 30,
                                                    width: width / 4,
                                                    decoration: BoxDecoration(
                                                      color: Color(0xffE25E2A),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              15),
                                                    ),
                                                    child: Center(
                                                      child: Text(
                                                        "Detail",
                                                        style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: width / 30,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                    )),
                                                onTap: () {
                                                  showDialog(
                                                    context: context,
                                                    builder:
                                                        (BuildContext context) {
                                                      return AlertDialog(
                                                        backgroundColor:
                                                            const Color(
                                                                0xffEDFDFE),
                                                        title: Text(holiday.name
                                                            .toString()),
                                                        content: Text(holiday
                                                                .description ??
                                                            'No description available'),
                                                        actions: <Widget>[
                                                          Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              CustomButton(
                                                                onPressed: () {
                                                                  Navigator.of(
                                                                          context)
                                                                      .pop();
                                                                },
                                                                buttonText:
                                                                    'Close',
                                                              ),
                                                              CustomButton(
                                                                onPressed: () {
                                                                  DateTime
                                                                      selectedDate =
                                                                      DateTime.parse(holiday
                                                                          .date!
                                                                          .iso
                                                                          .toString());

                                                                  if (selectedDate
                                                                      .isAfter(
                                                                          DateTime
                                                                              .now())) {
                                                                    Navigator
                                                                        .push(
                                                                      context,
                                                                      MaterialPageRoute(
                                                                        builder:
                                                                            (context) =>
                                                                                AddAlarm(
                                                                          dayOfWeek:
                                                                              DateFormat('E').format(selectedDate),
                                                                          dayOfMonth:
                                                                              selectedDate.day,
                                                                          month:
                                                                              _getMonthName(selectedDate.month),
                                                                        ),
                                                                      ),
                                                                    );
                                                                  } else {
                                                                    ScaffoldMessenger.of(
                                                                            context)
                                                                        .showSnackBar(
                                                                      SnackBar(
                                                                        content:
                                                                            Text('Cannot add event for past dates'),
                                                                      ),
                                                                    );
                                                                  }
                                                                },
                                                                buttonText:
                                                                    'Add Events',
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      );
                                                    },
                                                  );
                                                },
                                              ),
                                              SizedBox(height: 2),
                                              InkWell(
                                                child: Container(
                                                  height: height / 30,
                                                  width: width / 4,
                                                  decoration: BoxDecoration(
                                                    color: isFutureDate(holiday
                                                            .date!.iso
                                                            .toString())
                                                        ? Color(0xffE25E2A)
                                                        : Colors.grey,
                                                    // Change color if date is in the past
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15),
                                                  ),
                                                  child: Center(
                                                    child: Text(
                                                      "Add Event",
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: width / 30,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                onTap: () {
                                                  DateTime selectedDate =
                                                      DateTime.parse(holiday
                                                          .date!.iso
                                                          .toString());

                                                  if (selectedDate.isAfter(
                                                      DateTime.now())) {
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) =>
                                                            AddAlarm(
                                                          dayOfWeek: DateFormat(
                                                                  'E')
                                                              .format(
                                                                  selectedDate),
                                                          dayOfMonth:
                                                              selectedDate.day,
                                                          month: _getMonthName(
                                                              selectedDate
                                                                  .month),
                                                        ),
                                                      ),
                                                    );
                                                  } else {
                                                    ScaffoldMessenger.of(
                                                            context)
                                                        .showSnackBar(
                                                      SnackBar(
                                                        content: Text(
                                                            'Cannot add event for past dates'),
                                                      ),
                                                    );
                                                  }
                                                },
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          const Divider(),
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
                    ),
                  ),
                ],
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

  String getWeekDayFromISODate(String isoDate) {
    DateTime dateTime = DateTime.parse(isoDate);
    return DateFormat('E').format(dateTime);
  }

  bool isFutureDate(String date) {
    DateTime selectedDate = DateTime.parse(date);
    return selectedDate.isAfter(DateTime.now());
  }
}
