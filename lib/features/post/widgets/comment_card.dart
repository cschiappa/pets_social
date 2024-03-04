import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:pets_social/features/prize/widgets/prize_animation.dart';
import 'package:pets_social/features/post/controller/post_controller.dart';
import 'package:pets_social/features/profile/controller/profile_controller.dart';
import 'package:pets_social/models/comment.dart';
import 'package:pets_social/router.dart';

import '../../../models/profile.dart';

class CommentCard extends ConsumerStatefulWidget {
  final ModelComment comment;
  const CommentCard({super.key, required this.comment});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CommentCardState();
}

class _CommentCardState extends ConsumerState<CommentCard> {
  @override
  Widget build(BuildContext context) {
    final ModelProfile? profile = ref.watch(userProvider);

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
      child: Row(children: [
        GestureDetector(
          onTap: () {
            String profileUid = widget.comment.profileUid;

            context.goNamed(
              AppRouter.profileFromFeed.name,
              pathParameters: {
                'profileUid': profileUid,
              },
            );
          },
          child: CircleAvatar(
            backgroundImage: NetworkImage(widget.comment.photoUrl),
            radius: 18,
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(left: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                //USERNAME AND COMMENT
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        String profileUid = widget.comment.profileUid;

                        context.goNamed(
                          AppRouter.profileFromFeed.name,
                          pathParameters: {
                            'profileUid': profileUid,
                          },
                        );
                      },
                      child: RichText(
                        text: TextSpan(text: widget.comment.username, style: const TextStyle(fontWeight: FontWeight.bold)),
                      ),
                    ),
                    RichText(
                      text: TextSpan(
                        text: ' ${widget.comment.text}',
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(
                    DateFormat.yMMMd().format(widget.comment.datePublished),
                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
                  ),
                )
              ],
            ),
          ),
        ),
        Consumer(builder: (context, ref, child) {
          final postRepository = ref.read(postRepositoryProvider);
          return PrizeAnimation(
            isAnimating: widget.comment.likes.contains(profile!.profileUid),
            smallLike: true,
            child: InkWell(
              onTap: () async {
                await postRepository.likeComment(widget.comment.postId, widget.comment.commentId, profile.profileUid, widget.comment.likes);
              },
              child: Image.asset(
                (widget.comment.likes.contains(profile.profileUid)) ? 'assets/images/like.png' : 'assets/images/like_border.png',
                width: 14,
                height: 14,
              ),
            ),
          );
        }),
      ]),
    );
  }
}
