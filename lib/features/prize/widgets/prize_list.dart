import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pets_social/features/post/controller/post_controller.dart';
import 'package:pets_social/features/profile/controller/profile_controller.dart';
import 'package:pets_social/models/prize.dart';

class PrizesList extends ConsumerStatefulWidget {
  final String profileUid;
  final String postId;
  const PrizesList({super.key, required this.profileUid, required this.postId});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _PrizesListState();
}

class _PrizesListState extends ConsumerState<PrizesList> {
  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final prizes = ref.watch(getPrizesFromPostProvider(widget.postId));

        return SizedBox(
          height: 20,
          width: double.infinity,
          child: prizes.when(
              error: (error, stackTrace) => Text('Error: $error'),
              loading: () => const LinearProgressIndicator(),
              data: (prizes) {
                return ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: prizes.length,
                    itemBuilder: (context, index) {
                      ModelPrize prize = prizes[index];
                      final postPrizeData = ref.watch(getPostPrizeDataProvider(widget.postId, prize.type)).valueOrNull;

                      return postPrizeData != null
                          ? Row(
                              children: [
                                Image.network(
                                  prize.iconDeactivated,
                                ),
                                const SizedBox(
                                  width: 3,
                                ),
                                Text(
                                  postPrizeData.get('quantity').toString(),
                                  style: const TextStyle(color: Colors.white),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                              ],
                            )
                          : const SizedBox();
                    });
              }),
        );
      },
    );
  }
}
