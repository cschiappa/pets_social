import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:pets_social/core/utils/language.g.dart';

class WelcomePageOne extends StatelessWidget {
  const WelcomePageOne({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(image: AssetImage("assets/images/artboard_1.png"), fit: BoxFit.fill),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            LocaleKeys.welcome.tr(),
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, fontFamily: 'Lemon'),
            textAlign: TextAlign.center,
          ),
          const SizedBox(
            height: 20,
          ),
          Text(
            LocaleKeys.welcomeInfo1.tr(),
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          // Padding(
          //   padding: const EdgeInsets.only(right: 60),
          //   child: CachedNetworkImage(imageUrl: 'https://i.gifer.com/5Xyv.gif'),
          // ),
        ],
      ),
    );
  }
}
