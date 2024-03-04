import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pets_social/features/post/controller/post_controller.dart';
import 'package:pets_social/models/prize.dart';

class PrizesList extends StatefulWidget {
  final List<ModelPrize?> prizes;
  final String profileUid;
  final String postId;
  const PrizesList({super.key, required this.prizes, required this.profileUid, required this.postId});

  @override
  State<PrizesList> createState() => _PrizesListState();
}

class _PrizesListState extends State<PrizesList> {
  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        return SizedBox(
          height: 20,
          width: double.infinity,
          child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: widget.prizes.length,
              itemBuilder: (context, index) {
                ModelPrize prize = widget.prizes[index]!;
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
                          Text(postPrizeData.get('quantity').toString()),
                          const SizedBox(
                            width: 10,
                          ),
                        ],
                      )
                    : const SizedBox();
              }),
        );
      },
    );
  }
}
