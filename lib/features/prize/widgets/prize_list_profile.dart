import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pets_social/features/post/controller/post_controller.dart';
import 'package:pets_social/features/prize/controller/prize_controller.dart';
import 'package:pets_social/models/prize.dart';

class ProfilePrizeList extends StatelessWidget {
  final String userId;
  const ProfilePrizeList({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final profilePrizes = ref.watch(getProfilePrizesProvider(userId));
        final prizesCollection = ref.watch(getPrizesProvider);

        return prizesCollection.when(
            loading: () => const SizedBox(),
            error: (error, stackTrace) => Center(child: Text('Error: $error')),
            data: (prizes) {
              return Align(
                alignment: Alignment.center,
                child: ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemCount: prizes.length,
                    itemBuilder: (context, index) {
                      ModelPrize prize = prizes[index];

                      return profilePrizes.when(
                        data: (profilePrizes) {
                          if (profilePrizes.isEmpty) {
                            return const SizedBox();
                          }
                          List<Widget> prizeListTiles = profilePrizes.entries.map((entry) {
                            String prizeType = entry.key;
                            int quantity = entry.value;
                            if (prizeType == prize.type) {
                              return Row(children: [
                                Image.network(
                                  prize.iconDeactivated,
                                  scale: 2,
                                ),
                                const SizedBox(width: 5),
                                Text(quantity.toString()),
                              ]);
                            }
                            return const SizedBox();
                          }).toList();

                          return Padding(
                            padding: const EdgeInsets.all(5),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: prizeListTiles,
                            ),
                          );
                        },
                        loading: () => const SizedBox(),
                        error: (error, stackTrace) => Center(child: Text('Error: $error')),
                      );
                    }),
              );
            });
      },
    );
  }
}
