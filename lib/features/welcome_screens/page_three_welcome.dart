import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:pets_social/core/utils/language.g.dart';

class WelcomePageThree extends StatelessWidget {
  const WelcomePageThree({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(image: AssetImage("assets/images/artboard_3.png"), fit: BoxFit.fill),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            LocaleKeys.welcomeInfo6.tr(),
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(
            height: 20,
          ),
          Text(
            LocaleKeys.welcomeInfo7.tr(),
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(
            height: 20,
          ),
          Text(
            LocaleKeys.welcomeInfo8.tr(),
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, fontFamily: 'Lemon'),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
