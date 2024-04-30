import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:holidays_calendar/Screen/holidays_screen.dart';
import 'package:holidays_calendar/Screen/select_country.dart';
import 'package:holidays_calendar/app_functions/custom_button.dart';

class GetStartedScreen extends StatefulWidget {
  const GetStartedScreen({super.key});

  @override
  State<GetStartedScreen> createState() => _GetStartedScreenState();
}

class _GetStartedScreenState extends State<GetStartedScreen> {
  dynamic size, height, width;

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    height = size.height;
    width = size.width;
    return Scaffold(
      backgroundColor: const Color(0xffEDFDFE),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Image.asset("assets/holidayy.png"),
                const SizedBox(
                  height: 10,
                ),
                const Text(
                  "Find Your Perfect Holiday And Vacation",
                  style: TextStyle(
                    fontSize: 35,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: 30,
                ),
                CustomButton(
                    width: width / 1.7,
                    height: height / 20,
                    buttonText: "Get Started",
                    onPressed: () {
                      final countryInfo = GetStorage();
                      final countryId =
                          countryInfo.read('countryId') as String?;
                      final countryName =
                          countryInfo.read('countryName') as String?;
                      if (countryId == null ||
                          countryId.isEmpty ||
                          countryName == null ||
                          countryName.isEmpty) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const NextScreen()));
                      } else {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => HoliDaysScreen(
                                      selectedCountryName: countryName,
                                      selectedCountryId: countryId,
                                    )));
                      }
                    }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
