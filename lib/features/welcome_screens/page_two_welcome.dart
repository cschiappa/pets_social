import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:pets_social/core/utils/language.g.dart';

class WelcomePageTwo extends StatelessWidget {
  const WelcomePageTwo({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(image: AssetImage("assets/images/artboard_2.png"), fit: BoxFit.fill),
      ),
      child: Padding(
        padding: const EdgeInsets.all(60.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              LocaleKeys.welcomeInfo3.tr(),
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 20,
            ),
            Text(
              LocaleKeys.welcomeInfo4.tr(),
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, fontFamily: 'Lemon'),
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 20,
            ),
            Text(
              LocaleKeys.welcomeInfo5.tr(),
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
