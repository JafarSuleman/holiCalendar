import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get_storage/get_storage.dart';
import 'package:holidays_calendar/Screen/get_started_screen.dart';
import 'package:holidays_calendar/provider/Provier.dart';
import 'package:holidays_calendar/provider/theme_changer_privider.dart';
import 'package:provider/provider.dart';
import 'package:timezone/data/latest_all.dart' as tz;

FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(
      widgetsBinding: WidgetsFlutterBinding.ensureInitialized());
  tz.initializeTimeZones();
  flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()!
      .requestNotificationsPermission();

  // MobileAds.instance.initialize();
  await GetStorage.init();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  //loadads();
  runApp(const MyApp());
  FlutterNativeSplash.remove();
}
//
// AppOpenAd? appOpenAd;
//
// loadads() {
//   AppOpenAd.load(
//     adUnitId: 'ca-app-pub-3940256099942544/9257395921',
//     request: const AdRequest(),
//     adLoadCallback: AppOpenAdLoadCallback(
//       onAdLoaded: (ad) {
//         appOpenAd = ad;
//         appOpenAd!.show();
//       },
//       onAdFailedToLoad: (error) {},
//     ),
//     orientation: 1,
//   );
// }

class MyApp extends StatelessWidget {
  const MyApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeChanger()),
        ChangeNotifierProvider(create: (context) => AlarmProvider()),
      ],
      child: Builder(
        builder: (BuildContext context) {
          return const MaterialApp(
            debugShowCheckedModeBanner: false,
            home: GetStartedScreen(),
          );
        },
      ),
    );
  }
}
