import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pets_social/core/utils/language.g.dart';
import 'package:pets_social/router.dart';
import 'package:pets_social/features/welcome_screens/page_one_welcome.dart';
import 'package:pets_social/features/welcome_screens/page_three_welcome.dart';
import 'package:pets_social/features/welcome_screens/page_two_welcome.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  final PageController _controller = PageController();
  bool onLastPage = false;
  bool onSecondPage = false;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Scaffold(
      body: Stack(
        children: [
          PageView(
            controller: _controller,
            onPageChanged: (index) {
              setState(() {
                onLastPage = (index == 2);
                onSecondPage = (index == 1);
              });
            },
            children: const [
              WelcomePageOne(),
              WelcomePageTwo(),
              WelcomePageThree(),
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(vertical: 50),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    onSecondPage || onLastPage
                        ? OutlinedButton(
                            onPressed: () => _controller.previousPage(duration: const Duration(milliseconds: 500), curve: Curves.easeIn),
                            style: ButtonStyle(
                              foregroundColor: MaterialStateProperty.resolveWith<Color>(
                                (Set<MaterialState> states) {
                                  return Colors.black;
                                },
                              ),
                              side: MaterialStateProperty.resolveWith<BorderSide>((Set<MaterialState> states) {
                                return const BorderSide(color: Colors.black);
                              }),
                            ),
                            child: Text(LocaleKeys.previous.tr()),
                          )
                        : OutlinedButton(
                            onPressed: () => context.goNamed(AppRouter.signup.name),
                            style: ButtonStyle(
                              foregroundColor: MaterialStateProperty.resolveWith<Color>((Set<MaterialState> states) {
                                return Colors.black; // Change the text color here
                              }),
                              side: MaterialStateProperty.resolveWith<BorderSide>((Set<MaterialState> states) {
                                return const BorderSide(color: Colors.black);
                              }),
                            ),
                            child: Text(LocaleKeys.skip.tr()),
                          ),
                    SmoothPageIndicator(
                      controller: _controller,
                      count: 3,
                      effect: JumpingDotEffect(activeDotColor: theme.colorScheme.secondary),
                    ),
                    onLastPage
                        ? FilledButton(
                            onPressed: () => context.goNamed(AppRouter.signup.name),
                            child: Text(LocaleKeys.done.tr()),
                          )
                        : FilledButton(
                            onPressed: () => _controller.nextPage(duration: const Duration(milliseconds: 500), curve: Curves.easeIn),
                            child: Text(LocaleKeys.next.tr()),
                          )
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
