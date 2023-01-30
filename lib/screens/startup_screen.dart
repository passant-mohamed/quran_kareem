import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:quran_kareem/components/components.dart';
import 'package:quran_kareem/cubit/cubit.dart';
import 'package:quran_kareem/cubit/states.dart';
import 'package:quran_kareem/screens/asmaa_allah_screen.dart';
import 'package:quran_kareem/screens/azkar_hadeeth_screen.dart';
import 'package:quran_kareem/screens/home_screen.dart';
import 'package:quran_kareem/screens/prayer_times_screen.dart';
import 'package:quran_kareem/screens/surah_screen.dart';
import '../components/constants.dart';

class StartUpScreen extends StatelessWidget {
  const StartUpScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (surahNameFromSharedPref != null) {
      Future.delayed(
          const Duration(milliseconds: 150),
              () => {
            AwesomeDialog(
              barrierColor: Colors.black.withOpacity(0.5),
              context: context,
              dialogType: DialogType.noHeader,
              animType: AnimType.scale,
              title: 'هل تود الانتقال الي العلامة؟',
              btnOkOnPress: () {
                navigateTo(
                    context,
                    SurahScreen(
                      surahNumber: surahNumFromSharedPref,
                    ));
              },
              btnOkText: 'نعم',
              customHeader: Icon(
                Icons.bookmark,
                color: defaultColor,
                size: 50,
              ),
              btnOkColor: defaultColor,
              btnCancelOnPress: () {},
              btnCancelText: 'لا',
              btnCancelColor: Colors.red,
            )..show()
          });
    }

    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {

        return SafeArea(
          child: Scaffold(
              body: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Color(0xff2E144B), Colors.black87]),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Center(
                        child: Image(
                          image: const AssetImage('assets/images/quran_logo.png'),
                          width: Adaptive.w(50),
                        )),
                    //Text("وقف لله تعالي",style: TextStyle(fontSize: 50,color: Colors.amber),),
                    Container(
                      height: Adaptive.h(18),
                      padding: EdgeInsets.symmetric(horizontal: Adaptive.w(5)),
                      child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          physics: const BouncingScrollPhysics(),
                          itemBuilder: (context, index) =>
                              buildAzkarItem(azkarList[index], index, context),
                          separatorBuilder: (context, index) => SizedBox(
                            width: Adaptive.w(4),
                          ),
                          itemCount: azkarList.length),
                    ),

                    homeItem(context, 'الفهرس', const HomeScreen()),
                    homeItem(context,'مواقيت الصلاة', const PrayerTimes()),
                    homeItem(context, 'أسماء الله الحسنى', const AsmaaAllahScreen()),
                    const Text("صدقة جارية للمرحومة ريمية العتيبي",style: TextStyle(fontSize: 15,color: Colors.amber,wordSpacing: 3.5),),
                    //Text("",style: TextStyle(fontSize: 20,color: Colors.amber),),
                  ],
                ),
              )),
        );
      },
    );
  }

  Widget buildAzkarItem(azkarList, index, context) => InkWell(
        onTap: () {
          navigateTo(context, AzkarAndHadeethScreen(index: index));
        },
        child: Stack(
          alignment: AlignmentDirectional.bottomCenter,
          children: [
            Image(
              image: AssetImage(azkarList.img),
              fit: BoxFit.cover,
              width: Adaptive.w(27),
              height: Adaptive.h(13),
            ),
            Container(
                width: Adaptive.w(27),
                color: Colors.black.withOpacity(.7),
                child: defaultText(
                    text: azkarList.text,
                    textColor: Colors.white,
                    fontsize: 17,
                    textAlign: TextAlign.center,
                    fontWeight: FontWeight.bold)),
          ],
        ),
      );
}
