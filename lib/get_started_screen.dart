import 'package:flutter/material.dart';
import 'package:holidays_calendar/app_functions/custom_button.dart';
import 'package:holidays_calendar/next_screen.dart';
import 'package:holidays_calendar/provider/theme_changer_privider.dart';
import 'package:provider/provider.dart';

class GetStartedScreen extends StatefulWidget {
  const GetStartedScreen({super.key});

  @override
  State<GetStartedScreen> createState() => _GetStartedScreenState();
}

class _GetStartedScreenState extends State<GetStartedScreen> {
  @override
  Widget build(BuildContext context) {
    final themeChanger = Provider.of<ThemeChanger>(context);
    return  Scaffold(
      backgroundColor: themeChanger.themeMode == ThemeMode.dark ? Colors.grey[800] : const Color(0xffEDFDFE),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset("assets/holidayy.png"),
            const SizedBox(height: 10,),
            const Text("Find Your Perfect Holiday And Vacation",style: TextStyle(
              fontSize: 35,
              fontWeight: FontWeight.w600,
            ),textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30,),
            CustomButton(
              width: 222,
                height: 42,
                buttonText: "Get Started",
                onPressed: (){
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => const NextScreen()));
                }),
          ],

        ),
      ),
    );
  }
}
