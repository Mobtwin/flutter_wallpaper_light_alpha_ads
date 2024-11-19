import 'dart:convert';

// import 'package:device_preview_plus/device_preview_plus.dart';
import 'package:facebook_audience_network/facebook_audience_network.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:unity_ads_plugin/unity_ads_plugin.dart';
import 'package:wallpapers/model/data.dart';
import 'package:wallpapers/model_view/data_provider.dart';
import 'package:wallpapers/model_view/menu_provider.dart';
import 'package:wallpapers/view/Splash.dart';
import 'package:wallpapers/view/brand.dart';
import 'package:wallpapers/view/menu/menu.dart';
import 'package:wallpapers/view/onboarding/onboarding.dart';
import 'package:wallpapers/view/profile/profile.dart';

enum AdNetwork { admob, facebook, unity, applovin }

AdNetwork selectedAdNetwork = AdNetwork.facebook;

//this for package info
PackageInfo? packageInfo = PackageInfo(
  appName: 'Unknown',
  packageName: 'Unknown',
  version: 'Unknown',
  buildNumber: 'Unknown',
);
Data data = Data();
bool firstTime = false;

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();

    //read json file from assets
  final json = await rootBundle.loadString('assets/db.json');
  final config = jsonDecode(json);
  data = Data.fromJson(config);

  await Future.wait([
    MobileAds.instance.initialize(),
    FacebookAudienceNetwork.init(testingId: "6d16c699-ab79-463d-8849-0df5ae827953"),
    UnityAds.init(
      gameId: selectedAdNetwork == AdNetwork.unity ? data.adConfig?.first.appId ?? '' : '',
      testMode: true,
      onComplete: () {},
      onFailed: (error, message) {},
    ),
  ]);

  packageInfo = await PackageInfo.fromPlatform();


  SharedPreferences prefs = await SharedPreferences.getInstance();
  firstTime = (prefs.getBool('isfirsttime') ?? false);
  if (!firstTime) {
    prefs.setBool('isfirsttime', true);
  }
  // for testing multiple devices
  // runApp(DevicePreview(
  //   enabled: true,
  //   builder: (context) => const MyApp(),
  // ));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => DataProvider()),
        ChangeNotifierProvider(create: (context) => MenuProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
          scaffoldBackgroundColor: const Color(0xffFFFCFC),
          useMaterial3: true,
        ),
        initialRoute: '/brand',
        routes: {
          '/': (context) => const SplashScreen(),
          '/brand': (context) => const BrandScreen(),
          '/onboarding': (context) => const OnboardingScreen(),
          '/profile': (context) => const Profile(),
          '/menu': (context) => const MenuPage(),
        },
      ),
    );
  }
}
