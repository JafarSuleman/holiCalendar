import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:holidays_calendar/provider/theme_changer_privider.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

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

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
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
      print('Error loading holiday data: $e');
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

  @override
  Widget build(BuildContext context) {
    final themeChanger = Provider.of<ThemeChanger>(context);
    return Scaffold(
      backgroundColor: themeChanger.themeMode == ThemeMode.dark
          ? Colors.grey[800]
          : const Color(0xffEDFDFE),
      appBar: AppBar(
        backgroundColor: themeChanger.themeMode == ThemeMode.dark
            ? Colors.grey[800]
            : const Color(0xffEDFDFE),
        title: const Text('Search Holidays'),
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
                    child: ListView.builder(
                      itemCount: filteredHolidays.length,
                      itemBuilder: (context, index) {
                        final holidaysByMonth =
                            groupHolidaysByMonth(filteredHolidays);
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: holidaysByMonth.keys.map((month) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  height: 41,
                                  width: 392,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: Border.all(width: 1.0),
                                    borderRadius: const BorderRadius.only(
                                        bottomLeft: Radius.circular(15),
                                        bottomRight: Radius.circular(15)),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(_getMonthName(month) ?? ''),
                                      Text(holidays[index]
                                              .date
                                              ?.datetime
                                              ?.year
                                              .toString() ??
                                          ''),
                                    ],
                                  ),
                                ),
                                ...holidaysByMonth[month]!.map((holiday) {
                                  return Column(
                                    children: [
                                      ListTile(
                                        title: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Container(
                                                height: 39,
                                                width: 39,
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                  border: Border.all(
                                                      width: 1.0,
                                                      color: const Color(
                                                          0xffE25E2A)),
                                                ),
                                                child: Center(
                                                    child: Text(
                                                        getWeekDayFromISODate(
                                                            holiday.date?.iso
                                                                    .toString() ??
                                                                ''),
                                                        style: const TextStyle(
                                                            fontSize: 15,
                                                            color: Color(
                                                                0xff0720FB))))),
                                            Container(
                                                height: 39,
                                                width: 39,
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                  border: Border.all(
                                                      width: 1.0,
                                                      color: const Color(
                                                          0xffE25E2A)),
                                                ),
                                                child: Center(
                                                    child: Text(
                                                        holiday.date?.datetime
                                                                ?.day
                                                                .toString() ??
                                                            '',
                                                        style: const TextStyle(
                                                            fontSize: 15,
                                                            color: Color(
                                                                0xff0720FB))))),
                                            Text(holiday.name.toString() ?? '',
                                                style: const TextStyle(
                                                    fontSize: 8,
                                                    color: Color(0xffE25E2A))),
                                            InkWell(
                                              child: Image.asset(
                                                  'assets/discription.png',
                                                  scale: 4),
                                              onTap: () {
                                                showDialog(
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) {
                                                    return AlertDialog(
                                                      title: const Text(
                                                          'Description'),
                                                      content: Text(holiday
                                                              .description ??
                                                          'No description available'),
                                                      actions: <Widget>[
                                                        TextButton(
                                                          onPressed: () {
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                          },
                                                          child: const Text(
                                                              'Close'),
                                                        ),
                                                      ],
                                                    );
                                                  },
                                                );
                                              },
                                            ),
                                          ],
                                        ),
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
}
