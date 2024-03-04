import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pets_social/core/utils/extensions.dart';
import 'package:pets_social/core/utils/language.g.dart';
import 'package:pets_social/features/auth/controller/auth_controller.dart';
import 'package:pets_social/features/prize/widgets/grey_card.dart';
import 'package:pets_social/features/prize/widgets/store_prize_card.dart';
import 'package:pets_social/features/notification/controller/notification_controller.dart';
import 'package:pets_social/features/prize/controller/prize_controller.dart';
import 'package:pets_social/features/profile/controller/profile_controller.dart';
import 'package:pets_social/models/account.dart';
import 'package:pets_social/models/prize.dart';
import 'package:pets_social/router.dart';
import 'package:pets_social/models/notification.dart';
import 'package:pets_social/responsive/responsive_layout_screen.dart';
import 'package:timeago/timeago.dart' as timeago;
import '../../../models/profile.dart';

class PrizesScreen extends ConsumerStatefulWidget {
  const PrizesScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _PrizesScreenState();
}

class _PrizesScreenState extends ConsumerState<PrizesScreen> {
  @override
  Widget build(BuildContext context) {
    final ModelProfile profile = ref.watch(userProvider)!;
    final ThemeData theme = Theme.of(context);
    final profileData = ref.watch(getProfileDataProvider(profile.profileUid));

    ref.listen<AsyncValue>(
      prizeControllerProvider,
      (_, state) => state.showSnackbarOnError(context),
    );
    final AsyncValue<void> state = ref.watch(prizeControllerProvider);

    return profileData.when(
        error: (error, stackTrace) => Text('Error: $error'),
        loading: () => Center(
              child: CircularProgressIndicator(
                color: theme.colorScheme.secondary,
              ),
            ),
        data: (profileData) {
          return Scaffold(
              body: SingleChildScrollView(
            padding: ResponsiveLayout.isWeb(context) ? EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width / 3) : const EdgeInsets.symmetric(horizontal: 0),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                children: [
                  const SizedBox(
                    height: 50,
                  ),
                  //HEADER
                  _header(profile),
                  const SizedBox(
                    height: 20,
                  ),
                  _availableLizzyCoins(),
                  const SizedBox(
                    height: 20,
                  ),
                  //NOTIFICATIONS
                  _notificationCard(profile),
                  const SizedBox(
                    height: 20,
                  ),
                  //STATS
                  _statsCard(profile),
                  const SizedBox(
                    height: 20,
                  ),
                  _storeCard(theme, state),
                ],
              ),
            ),
          ));
        });
  }

  Widget _header(ModelProfile profile) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          padding: const EdgeInsets.all(15),
          child: RichText(
            text: TextSpan(
              style: DefaultTextStyle.of(context).style,
              children: <TextSpan>[
                TextSpan(
                  text: LocaleKeys.helloUser.tr(namedArgs: {"profile": profile.username}),
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, fontFamily: 'Lemon'),
                ),
                TextSpan(
                  text: LocaleKeys.mood.tr(),
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(20),
          child: CircleAvatar(
            backgroundImage: (profile.photoUrl != null) ? NetworkImage(profile.photoUrl!) : const AssetImage('assets/images/default_pic') as ImageProvider<Object>,
          ),
        ),
      ],
    );
  }

  Widget _availableLizzyCoins() {
    final ModelAccount? user = ref.watch(accountProvider);
    final int lizzyCoins = user!.lizzyCoins;
    return Container(
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.0),
          gradient: const LinearGradient(
            colors: [
              Color.fromARGB(255, 157, 110, 157), // Start color
              Color.fromARGB(255, 240, 177, 136), // End color
            ],
          ),
        ),
        child: ListTile(
          leading: const Icon(Icons.monetization_on),
          title: Text('$lizzyCoins Lizzy Coins'),
          trailing: FilledButton(
            onPressed: () {},
            child: Text(LocaleKeys.buyMore.tr()),
          ),
        ));
  }

  Widget _notificationCard(ModelProfile profile) {
    final ScrollController scrollController = ScrollController();
    final notificationData = ref.watch(getNotificationsProvider(profile.profileUid));

    return GreyCard(
      title: LocaleKeys.notifications.tr(),
      icon: Icons.notification_add,
      height: 200,
      body: notificationData.when(
          error: (error, stacktrace) => Text('error: $error'),
          loading: () => Container(),
          data: (notificationData) {
            return Expanded(
              child: Scrollbar(
                controller: scrollController,
                thumbVisibility: true,
                child: ListView.builder(
                    controller: scrollController,
                    itemCount: notificationData.length,
                    itemBuilder: (context, index) {
                      ModelNotification notification = ModelNotification.fromSnap(notificationData[index]);
                      final DateTime timeAgo = notification.datePublished;

                      return GestureDetector(
                        onTap: () {
                          notification.postId == ""
                              ? context.goNamed(AppRouter.profileFromPrizes.name, pathParameters: {'profileUid': notification.sender})
                              : context.goNamed(
                                  AppRouter.openPostFromPrizes.name,
                                  pathParameters: {
                                    'postId': notification.postId!,
                                    'profileUid': notification.receiver,
                                    'username': profile.username,
                                  },
                                );
                        },
                        child: ListTile(
                          leading: Text(
                            notification.body,
                            style: const TextStyle(fontSize: 15),
                          ),
                          trailing: Text(timeago.format(timeAgo).toString()),
                        ),
                      );
                    }),
              ),
            );
          }),
    );
  }

  Widget _statsCard(ModelProfile profile) {
    return GreyCard(
        title: LocaleKeys.stats.tr(),
        icon: Icons.query_stats,
        body: Column(
          children: [
            Text(LocaleKeys.followersNumber.tr(namedArgs: {"int": profile.followers.length.toString()}), style: const TextStyle(fontSize: 15)),
            Text(LocaleKeys.followingNumber.tr(namedArgs: {"int": profile.following.length.toString()}), style: const TextStyle(fontSize: 15)),
          ],
        ));
  }

  Widget _storeCard(ThemeData theme, state) {
    final prizes = ref.watch(getPaidPrizesProvider);
    return Container(
      alignment: Alignment.topLeft,
      child: Column(
        children: [
          Text(
            LocaleKeys.store.tr(),
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, fontFamily: 'Lemon'),
          ),
          prizes.when(
            error: (error, stacktrace) => Text('error: $error'),
            loading: () => Center(
              child: CircularProgressIndicator(
                color: theme.colorScheme.secondary,
              ),
            ),
            data: (prizes) {
              return GridView.builder(
                shrinkWrap: true,
                itemCount: prizes.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 20,
                  mainAxisSpacing: 20,
                ),
                itemBuilder: (context, index) {
                  final ModelPrize prize = prizes[index];
                  return StorePrizeCard(
                    title: prize.type,
                    prizeDeactivated: prize.iconDeactivated,
                    prizeActivated: prize.iconActivated,
                    prizePrice: prize.price,
                    state: state,
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
