
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:holidays_calendar/get_started_screen.dart';
import 'package:holidays_calendar/provider/theme_changer_privider.dart';
import 'package:provider/provider.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();
  await GetStorage.init();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  loadads();

  runApp(const MyApp());
}
AppOpenAd? appOpenAd;

loadads() {
  AppOpenAd.load(
    adUnitId: 'ca-app-pub-3940256099942544/9257395921',
      request: const AdRequest(),
      adLoadCallback: AppOpenAdLoadCallback(
        onAdLoaded: (ad) {
          appOpenAd = ad;
          appOpenAd!.show();
        },
        onAdFailedToLoad: (error) {
          debugPrint(',,,,,,,,,,Error $error');
          },), orientation: 1,
      );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeChanger()),
      ],
      child: Builder(
        builder: (BuildContext context) {
          return  const MaterialApp(
            home:   GetStartedScreen(),
          );
        },
      ),
    );
  }
}
