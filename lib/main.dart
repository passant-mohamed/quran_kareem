import 'dart:convert';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:quran_kareem/cubit/cubit.dart';
import 'package:quran_kareem/models/asmaa_allah_elhosna.dart';
import 'package:quran_kareem/models/azkar&Tsabeeh.dart';
import 'package:quran_kareem/shared/cache_helper.dart';
import 'package:quran_kareem/shared/network/dio.dart';
import 'package:quran_kareem/screens/startup_screen.dart';
import 'components/components.dart';
import 'components/constants.dart';
import 'package:flutter/services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DioHelper.init();
  await DioHelper.initHadeeth();
  Map<String, dynamic> json1 = jsonDecode(azkar);
  AzkarAndTsabeeh.fromJson(json1);
  Map<String, dynamic> json2 = jsonDecode(asmaaAllahElHosna);
  AsmaaAllahElHosna.fromJson(json2);
  await CacheHelper.init();
  surahNameFromSharedPref = CacheHelper.getData(key: "surahName");
  surahNumFromSharedPref = CacheHelper.getData(key: "surahNumber");
  pageNumberFromSharedPref = CacheHelper.getData(key: "pageNumber");
  print(surahNameFromSharedPref);
  print(surahNumFromSharedPref);
  print(pageNumberFromSharedPref);

  runApp(BlocProvider(
      create: (context) => AppCubit(),
      child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    checkInternetConnection(AppCubit.get(context));

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return ResponsiveSizer(
      builder: (p0, p1, p2) {
        return MaterialApp(
          theme: ThemeData(
            appBarTheme: AppBarTheme(backgroundColor: HexColor('22211f')),
            scaffoldBackgroundColor: HexColor('fefbec'),
            fontFamily: 'QuranFont',
          ),
          debugShowCheckedModeBanner: false,
          home: (AnimatedSplashScreen(
              splash: splash(),
              centered: true,
              splashIconSize: 900,
              nextScreen: const StartUpScreen())),
        );
      },
    );
  }
}

Widget splash() {
  return Container(
    width: double.infinity,
    decoration: const BoxDecoration(
      gradient: LinearGradient(colors: [Color(0xff2E144B), Colors.black]),
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Image(
          image: AssetImage('assets/images/logo1.png'),
          width: 360,
        ),
        defaultText(
            text: 'القرأن الكريم',
            fontsize: 53,
            textColor: Colors.white,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.7)
      ],
    ),
  );
  //Image.asset();
}
