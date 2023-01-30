import 'dart:async';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:quran_kareem/components/components.dart';
import 'package:quran_kareem/components/constants.dart';
import 'package:quran_kareem/cubit/cubit.dart';
import 'package:quran_kareem/cubit/states.dart';
import 'package:quran_kareem/screens/elazan_screen.dart';

class PrayerWidget {
  String? imageIcon;
  String? elSala;
  String? time;
  bool morning = false;

  PrayerWidget(
      {required this.imageIcon,
      required this.time,
      required this.elSala,
      required this.morning});
}

class PrayerTimes extends StatelessWidget {
  const PrayerTimes({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var cubit = AppCubit.get(context);
    if (!internetConnection && !cubit.gotPrayerTimes) {
      defaultFlutterToast(msg: "يرجي الاتصال بالانترنت");
      Future.delayed(
        const Duration(seconds: 3),
        () => {
          Navigator.pop(context),
        },
      );
    }
    checkLocationPermission().then((value) {
      if (!locationPermission && !cubit.gotPrayerTimes) {
        defaultFlutterToast(msg: "يرجي تفعيل ال Location");
        Future.delayed(
          const Duration(seconds: 3),
          () => {
            Navigator.pop(context),
          },
        );
      } else if (locationPermission &&
          internetConnection &&
          !cubit.gotPrayerTimes) {
        cubit.getPrayerTime();
      }
    });

    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return ConditionalBuilder(
          condition: cubit.gotPrayerTimes,
          builder: (context) {
            List<PrayerWidget> prayerList = [
              PrayerWidget(
                  imageIcon: 'assets/images/salahIcon.png',
                  time: cubit.prayerTimesModel!.Fajr!.substring(0, 5),
                  elSala: 'الفجر',
                  morning: true),
              PrayerWidget(
                  imageIcon: 'assets/images/salahIcon.png',
                  time: cubit.prayerTimesModel!.Dhuhr!.substring(0, 5),
                  elSala: 'الظهر',
                  morning: true),
              PrayerWidget(
                  imageIcon: 'assets/images/salahIcon.png',
                  time: '${cubit.elAsrHours - 12}'
                      ":"
                      '${cubit.prayerTimesModel!.Asr!.substring(3, 5)}',
                  elSala: 'العصر',
                  morning: false),
              PrayerWidget(
                  imageIcon: 'assets/images/salahIcon.png',
                  time: '${cubit.elMaghribHours - 12}'
                      ":"
                      '${cubit.prayerTimesModel!.Maghrib!.substring(3, 5)}',
                  elSala: 'المغرب',
                  morning: false),
              PrayerWidget(
                  imageIcon: 'assets/images/salahIcon.png',
                  elSala: 'العشاء',
                  time: '${cubit.elIshaHours - 12}'
                      ":"
                      '${cubit.prayerTimesModel!.Isha!.substring(3, 5)}',
                  morning: false),
            ];
            // Azan only works when app is on
            Timer.periodic(const Duration(seconds: 1), (timer) {
              if (((DateTime.now().hour == cubit.elAsrHours) &&
                  (DateTime.now().minute == cubit.elAsrMins))) {
                cubit.azanElAsr = true;
              } else if (((DateTime.now().hour == cubit.elDuhrHours) &&
                  (DateTime.now().minute == cubit.elDuhrMins))) {
                cubit.azanElDuhr = true;
              } else if (((DateTime.now().hour == cubit.elIshaHours) &&
                  (DateTime.now().minute == cubit.elIshaMins))) {
                cubit.azanElIsha = true;
              } else if (((DateTime.now().hour == cubit.elMaghribHours) &&
                  (DateTime.now().minute == cubit.elMaghribMins))) {
                cubit.azanElMaghrib = true;
              } else if (((DateTime.now().hour == cubit.elFajrHours) &&
                  (DateTime.now().minute == cubit.elFajrMins))) {
                cubit.azanElFajr = true;
              }
              if (cubit.azanElFajr ||
                  cubit.azanElIsha ||
                  cubit.azanElMaghrib ||
                  cubit.azanElAsr ||
                  cubit.azanElDuhr) {
                cubit.setUrlAzanSoundSrc();
                navigateTo(context, const elAzanScreen());

                timer.cancel();
              }
            });

            return Scaffold(
              appBar: defaultAppBar(text: "مواقيتُ الصَّلاة"),
              body: Container(
                margin: EdgeInsets.only(top: Adaptive.h(3)),
                decoration: const BoxDecoration(
                    image: DecorationImage(
                  alignment: AlignmentDirectional.bottomCenter,
                  opacity: .8,
                  image: AssetImage('assets/images/MasjidElnabwy.png'),
                )),
                child: ListView.separated(
                    itemBuilder: (context, index) => Container(
                          margin: EdgeInsets.symmetric(
                              horizontal: Adaptive.w(8),
                              vertical: Adaptive.h(3)),
                          height: Adaptive.h(8.3),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(23),
                            boxShadow: [
                              BoxShadow(
                                  color: defaultColor,
                                  offset: const Offset(3, 3),
                                  blurRadius: 6)
                            ],
                          ),
                          child: Padding(
                            padding:
                                EdgeInsets.symmetric(horizontal: Adaptive.w(4)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                defaultText(
                                    text: prayerList[index].morning ? 'AM' : 'PM',
                                    fontsize: 19),
                                SizedBox(
                                  width: Adaptive.w(2),
                                ),
                                defaultText(
                                  text: prayerList[index].time!,
                                  fontsize: 27,
                                ),
                                const Spacer(),
                                defaultText(
                                    text: prayerList[index].elSala!,
                                    fontsize: 30),
                                SizedBox(
                                  width: Adaptive.w(2),
                                ),
                                ImageIcon(
                                  AssetImage(
                                    prayerList[index].imageIcon!,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                    separatorBuilder: (context, index) => myDivider(),
                    itemCount: prayerList.length),
              ),
            );
          },
          fallback: (context) => Center(
            child: CircularProgressIndicator(color: defaultColor),
          ),
        );
      },
    );
  }
}
