import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:holidays_calendar/provider/theme_changer_privider.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

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
    size = MediaQuery.of(context).size;
    height = size.height;
    width = size.width;
    final themeChanger = Provider.of<ThemeChanger>(context);
    return Scaffold(
      backgroundColor: const Color(0xffEDFDFE),
      appBar: AppBar(
        backgroundColor:  const Color(0xffEDFDFE),
        title: const Text('Search Holidays',style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w700,
        ),),
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
                      trackVisibility:true ,
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      height: height/20,
                                      width: double.infinity,
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
                                                    height: height/20,
                                                    width: width/9,
                                                    decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      color: Colors.white,
                                                      border: Border.all(width: 1.0,color: const Color(0xffE25E2A)),
                                                    ),
                                                    child: Center(child: Text(getWeekDayFromISODate(holiday.date?.iso.toString() ?? ''), style: const TextStyle(fontSize: 10,color: Color(0xff0720FB))))),
                                                const SizedBox(width: 2,),
                                                Container(
                                                    height: height/20,
                                                    width: width/9,
                                                    decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      color: Colors.white,
                                                      border: Border.all(width: 1.0,color: const Color(0xffE25E2A)),
                                                    ),
                                                    child: Center(child: Text(holiday.date?.datetime?.day.toString() ?? '', style: const TextStyle(fontSize: 10,color: Color(0xff0720FB))))),
                                                const SizedBox(width:1,),
                                                Expanded(
                                                  flex: 1,
                                                  child: Text(
                                                    holiday.name.toString() ?? '',
                                                    style:  TextStyle(fontWeight: FontWeight.w600,fontSize: 15,
                                                      color: holiday.type?.contains("Observance") ?? false ? themeChanger.importantDayColor : themeChanger.holidayColor,
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
                                                        backgroundColor: themeChanger.themeMode == ThemeMode.dark ? Colors.grey[800] : const Color(0xffEDFDFE),
                                                        title:  Text(holiday.name.toString()),
                                                        content: Text(holiday.description?? 'No description available'),
                                                        actions: <Widget>[
                                                           CustomButton(
                                                            onPressed: () {
                                                              Navigator.of(context).pop();
                                                            }, buttonText: 'Close',

                                                          ),
                                                        ],
                                                      );
                                                    },
                                                  );
                                                },
                                              )
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
