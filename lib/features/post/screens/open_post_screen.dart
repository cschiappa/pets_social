import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pets_social/core/utils/language.g.dart';
import 'package:pets_social/features/post/widgets/post_card.dart';
import 'package:pets_social/features/post/controller/post_controller.dart';
import 'package:pets_social/features/profile/controller/profile_controller.dart';
import 'package:pets_social/models/post.dart';
import 'package:pets_social/responsive/responsive_layout_screen.dart';

import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class OpenPost extends ConsumerStatefulWidget {
  const OpenPost({
    super.key,
    required this.postId,
    required this.profileUid,
    required this.username,
  });
  final String postId;
  final String username;
  final String profileUid;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _OpenPostState();
}

class _OpenPostState extends ConsumerState<OpenPost> {
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  final itemController = ItemScrollController();
  bool firstScroll = true;

  //SCROLL
  void scrollToPost(List posts) {
    if (firstScroll) {
      itemController.jumpTo(
        index: posts.indexWhere((element) => element['postId'] == widget.postId),
        alignment: 0,
      );
      firstScroll = false;
    }
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      ref.read(userProvider.notifier).getProfileDetails();
    });
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final ThemeData theme = Theme.of(context);
    final profilePosts = ref.watch(getProfilePostsProvider(widget.profileUid));

    return Scaffold(
      appBar: ResponsiveLayout.isWeb(context)
          ? null
          : AppBar(
              backgroundColor: theme.appBarTheme.backgroundColor,
              centerTitle: false,
              title: Text(LocaleKeys.postFrom.tr(namedArgs: {"profile": widget.username})),
            ),
      body: profilePosts.when(
          error: (error, stacktrace) => Text('error: $error'),
          loading: () => Center(
                child: CircularProgressIndicator(
                  color: theme.colorScheme.secondary,
                ),
              ),
          data: (profilePosts) {
            // POST CARD
            WidgetsBinding.instance.addPostFrameCallback((_) {
              scrollToPost(profilePosts.docs);
            });
            return ScrollablePositionedList.builder(
                initialScrollIndex: profilePosts.docs.indexWhere((element) => element['postId'] == widget.postId),
                itemScrollController: itemController,
                key: _listKey,
                itemCount: profilePosts.docs.length,
                itemBuilder: (context, index) {
                  final ModelPost post = ModelPost.fromSnap(profilePosts.docs[index]);
                  return Container(
                    margin: EdgeInsets.symmetric(
                      horizontal: ResponsiveLayout.isWeb(context) ? width * 0.3 : 0,
                      vertical: ResponsiveLayout.isWeb(context) ? 15 : 0,
                    ),
                    child: PostCard(
                      post: post,
                    ),
                  );
                });
          }),
    );
  }
}
