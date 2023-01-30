import 'package:flutter/material.dart';
import 'package:quran_kareem/models/asmaa_allah_elhosna.dart';
import '../components/components.dart';
import '../components/constants.dart';

class AsmaaAllahScreen extends StatelessWidget {
  const AsmaaAllahScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (!joinedAsmaaAllahScreenBefore) {
      Future.delayed(
        const Duration(milliseconds: 150),
        () =>
            {
              onScreenOpen(context),
            });
      joinedAsmaaAllahScreenBefore = true;
    }

    return Scaffold(
      appBar: defaultAppBar(text: "أسماء الله الحسنى"),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: GridView.count(
          crossAxisCount: 3,
          crossAxisSpacing: 5,
          mainAxisSpacing: 5,
          children: List.generate(
              AsmaaAllahElHosna.name.length,
              (index) => InkWell(
                    onTap: () {
                      awesomeDialog(context, AsmaaAllahElHosna.name[index],
                          AsmaaAllahElHosna.meaning[index]);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          gradient: const LinearGradient(
                              begin: Alignment.bottomCenter,
                              tileMode: TileMode.mirror,
                              end: Alignment.center,
                              colors: [Color(0xffe19800), Color(0xffffdfb0)]),
                          border: Border.all(
                            color: const Color(0xfffff4df),
                            width: 5,
                          ),
                          boxShadow: const [
                            BoxShadow(
                                color: Colors.black45,
                                offset: Offset(3, 3),
                                blurRadius: 7)
                          ]),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          defaultText(
                              text: AsmaaAllahElHosna.name[index],
                              fontsize: 30,
                              fontWeight: FontWeight.bold,
                              txtDirection: TextDirection.rtl),
                        ],
                      ),
                    ),
                  )),
        ),
      ),
    );
  }
}
