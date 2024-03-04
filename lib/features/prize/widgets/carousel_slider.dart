import 'package:carousel_slider/carousel_slider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pets_social/core/utils/language.g.dart';
import 'package:pets_social/features/post/controller/post_controller.dart';
import 'package:pets_social/features/prize/widgets/prize_animation.dart';
import 'package:pets_social/features/prize/controller/prize_controller.dart';
import 'package:pets_social/models/prize.dart';
import 'package:pets_social/router.dart';

class PrizesCarouselSlider extends StatefulWidget {
  final List<ModelPrize?> prizes;
  final String profileUid;
  final String postId;
  final CarouselController controller;
  const PrizesCarouselSlider({
    super.key,
    required this.prizes,
    required this.profileUid,
    required this.postId,
    required this.controller,
  });

  @override
  State<PrizesCarouselSlider> createState() => _PrizesCarouselSliderState();
}

class _PrizesCarouselSliderState extends State<PrizesCarouselSlider> {
  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Consumer(
      builder: (context, ref, child) {
        return Padding(
          padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width / 4.5,
          ),
          child: Container(
            padding: const EdgeInsets.all(2.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              color: const Color.fromARGB(100, 0, 0, 0),
            ),
            child: Row(
              children: [
                //ARROW LEFT SWIPE
                InkWell(
                  onTap: () {
                    widget.controller.previousPage();
                  },
                  child: Icon(
                    Icons.arrow_left,
                    color: theme.colorScheme.primary,
                  ),
                ),
                Expanded(
                  child: CarouselSlider.builder(
                    itemCount: widget.prizes.length,
                    itemBuilder: (BuildContext context, int index, int pageViewIndex) {
                      final ModelPrize? prize = widget.prizes[index];
                      final postPrizeData = ref.watch(getPostPrizeDataProvider(widget.postId, prize!.type)).valueOrNull;
                      final userPrizes = ref.watch(getUserPrizeDataProvider(prize.type)).valueOrNull;

                      return prize.isPaid == true && userPrizes == null
                          ? InkWell(
                              onTap: () => context.goNamed(AppRouter.prizesScreen.name),
                              child: Stack(children: [
                                Image.network(prize.iconDeactivated),
                                Image.asset('assets/images/lock.png'),
                              ]),
                            )
                          : PrizeAnimation(
                              isAnimating: postPrizeData == null ? false : postPrizeData['contributors'].contains(widget.profileUid),
                              smallLike: true,
                              child: InkWell(
                                onTap: () async => await ref.read(postControllerProvider.notifier).givePrize(
                                      widget.postId,
                                      widget.profileUid,
                                      prize.type,
                                      LocaleKeys.gavePrize.tr(),
                                    ),
                                child: Image.network(postPrizeData == null
                                    ? prize.iconDeactivated
                                    : postPrizeData['contributors'].contains(widget.profileUid)
                                        ? prize.iconActivated
                                        : prize.iconDeactivated),
                              ),
                            );
                    },
                    options: CarouselOptions(
                      viewportFraction: 0.4,
                      aspectRatio: 4,
                      enableInfiniteScroll: true,
                      initialPage: 3,
                      enlargeCenterPage: true,
                      enlargeFactor: 0.5,
                      enlargeStrategy: CenterPageEnlargeStrategy.zoom,
                    ),
                  ),
                ),
                //ARROW RIGHT SWIPE
                InkWell(
                  onTap: () {
                    widget.controller.nextPage();
                  },
                  child: Icon(Icons.arrow_right, color: theme.colorScheme.primary),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
