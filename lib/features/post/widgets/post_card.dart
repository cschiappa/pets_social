import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pets_social/core/utils/extensions.dart';
import 'package:pets_social/core/utils/language.g.dart';
import 'package:pets_social/core/utils/utils.dart';
import 'package:pets_social/features/post/widgets/open_menu_animation.dart';
import 'package:pets_social/features/prize/widgets/prize_animation.dart';
import 'package:pets_social/features/prize/widgets/prize_list.dart';
import 'package:pets_social/features/post/controller/post_controller.dart';
import 'package:pets_social/features/profile/controller/profile_controller.dart';
import 'package:pets_social/models/post.dart';
import 'package:pets_social/router.dart';
import 'package:pets_social/models/profile.dart';
import 'package:pets_social/responsive/responsive_layout_screen.dart';
import 'package:pets_social/features/prize/widgets/carousel_slider.dart';
import 'package:pets_social/core/widgets/text_field_input.dart';
import 'package:pets_social/features/post/widgets/video_player.dart';

import 'package:share_plus/share_plus.dart';
import 'package:video_player/video_player.dart';

class PostCard extends ConsumerStatefulWidget {
  final ModelPost post;
  const PostCard({super.key, required this.post});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _PostCardState();
}

class _PostCardState extends ConsumerState<PostCard> {
  late VideoPlayerController _videoController;
  bool isLikeAnimating = false;
  final CarouselController _controller = CarouselController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _summaryController = TextEditingController();
  //bool isMenuOpen = false;

  @override
  void initState() {
    super.initState();
    final videoUri = Uri.parse(widget.post.postUrl);
    _videoController = VideoPlayerController.networkUrl(videoUri)
      ..initialize().then((_) {
        setState(() {});
      });
    _descriptionController.text = widget.post.description!;
  }

  @override
  void dispose() {
    _videoController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final videoUri = Uri.parse(widget.post.postUrl);
    final ModelProfile? profile = ref.watch(userProvider);
    final ThemeData theme = Theme.of(context);
    final String contentType = getContentTypeFromUrl(widget.post.fileType);
    final bool isBlocked = profile!.blockedUsers.contains(widget.post.profileUid);
    final profileFromPost = ref.watch(getProfileFromPostProvider(widget.post.profileUid)).value;
    final commentsNumber = ref.watch(getCommentsNumberProvider(widget.post.postId));
    final savedPostsStream = ref.watch(savedPostsStreamProvider);

    bool isMenuOpen = ref.watch(isMenuOpenProvider);

    ref.listen<AsyncValue>(
      postControllerProvider,
      (_, state) => state.showSnackbarOnError(context),
    );
    final AsyncValue<void> state = ref.watch(postControllerProvider);

    final prizes = ref.watch(getPrizesProvider);
    final prizesFromPost = ref.watch(getPrizesFromPostProvider(widget.post.postId));

    return prizes.when(
        error: (error, stackTrace) => Text('Error: $error'),
        loading: () => LinearProgressIndicator(color: theme.colorScheme.secondary),
        data: (prizes) {
          return Container(
            decoration: BoxDecoration(
              //border: Border.all(color: Colors.pink.shade100),
              borderRadius: BorderRadius.circular(20.0),
              gradient: const LinearGradient(
                colors: [
                  Color.fromARGB(255, 157, 110, 157),
                  Color.fromARGB(255, 240, 177, 136),
                ],
              ),
            ),
            padding: const EdgeInsets.only(bottom: 10),
            margin: const EdgeInsets.symmetric(vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  alignment: AlignmentDirectional.topEnd,
                  children: [
                    //DOUBLE TAP FOR LIKE
                    GestureDetector(
                      onDoubleTap: () async {
                        await ref.read(postControllerProvider.notifier).givePrize(widget.post.postId, profile.profileUid, 'like', LocaleKeys.gavePrize.tr());
                        setState(() {
                          isLikeAnimating = true;
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(20.0), color: Colors.black),
                        width: double.infinity,
                        constraints: const BoxConstraints(maxHeight: 550),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(20.0),
                              child: () {
                                if (contentType == 'image') {
                                  return SizedBox(
                                    width: double.infinity,
                                    child: CachedNetworkImage(
                                      imageUrl: widget.post.postUrl,
                                      placeholder: (context, url) => const SizedBox(),
                                      fit: BoxFit.fitWidth,
                                    ),
                                  );
                                } else if (contentType == 'video') {
                                  return VideoPlayerWidget(videoUrl: videoUri);
                                } else if (contentType == 'unknown') {
                                  return const SizedBox.shrink(
                                    child: Center(child: Text('unknown format')),
                                  );
                                } else {
                                  return const SizedBox.shrink();
                                }
                              }(),
                            ),
                            AnimatedOpacity(
                              duration: const Duration(milliseconds: 200),
                              opacity: isLikeAnimating ? 1 : 0,
                              child: PrizeAnimation(
                                isAnimating: isLikeAnimating,
                                duration: const Duration(
                                  milliseconds: 400,
                                ),
                                onEnd: () {
                                  setState(() {
                                    isLikeAnimating = false;
                                  });
                                },
                                child: Icon(Icons.favorite, color: theme.colorScheme.primary, size: 120),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    //POST HEADER
                    Padding(
                      padding: const EdgeInsets.all(5),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            decoration: const BoxDecoration(
                              color: Color.fromARGB(100, 0, 0, 0),
                              borderRadius: BorderRadius.all(Radius.circular(20)),
                            ),
                            padding: const EdgeInsets.all(5),
                            child: Row(
                              children: [
                                //AVATAR
                                GestureDetector(
                                  onTap: () {
                                    String profileUid = widget.post.profileUid;
                                    profileUid == profile.profileUid
                                        ? context.goNamed(
                                            AppRouter.profileScreen.name,
                                          )
                                        : context.pushNamed(
                                            AppRouter.navigateToProfile.name,
                                            pathParameters: {
                                              'profileUid': profileUid,
                                            },
                                          );
                                  },
                                  child: Container(
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: Colors.pink.shade300,
                                        width: 1.0,
                                      ),
                                    ),
                                    child: CircleAvatar(
                                        radius: 15,
                                        backgroundImage: profileFromPost != null
                                            ? NetworkImage(
                                                profileFromPost.photoUrl!,
                                              )
                                            : null),
                                  ),
                                ),
                                //USERNAME
                                Padding(
                                  padding: const EdgeInsets.only(left: 8),
                                  child: GestureDetector(
                                    onTap: () {
                                      String profileUid = widget.post.profileUid;

                                      profileUid == profile.profileUid
                                          ? context.goNamed(
                                              AppRouter.profileScreen.name,
                                            )
                                          : context.pushNamed(
                                              AppRouter.navigateToProfile.name,
                                              pathParameters: {
                                                'profileUid': profileUid,
                                              },
                                            );
                                    },
                                    child: Text(
                                      //widget.snap['username'],
                                      profileFromPost == null ? "" : profileFromPost.username,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: theme.colorScheme.primary,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          //ICONS MENU
                          Row(
                            children: [
                              //DOUBLE ARROW FOR CLOSE MENU
                              if (isMenuOpen)
                                GestureDetector(
                                  onTap: () => ref.read(isMenuOpenProvider.notifier).state = !isMenuOpen,
                                  child: Padding(
                                    padding: const EdgeInsets.all(5),
                                    child: Container(
                                      decoration: const BoxDecoration(
                                        color: Color.fromARGB(100, 0, 0, 0),
                                        borderRadius: BorderRadius.all(Radius.circular(20)),
                                      ),
                                      padding: const EdgeInsets.all(2),
                                      child: const Icon(
                                        Icons.double_arrow_rounded,
                                        size: 12,
                                      ),
                                    ),
                                  ),
                                ),
                              //MENU
                              Container(
                                decoration: const BoxDecoration(
                                  color: Color.fromARGB(100, 0, 0, 0),
                                  borderRadius: BorderRadius.all(Radius.circular(20)),
                                ),
                                padding: const EdgeInsets.all(5),
                                child: isMenuOpen == false
                                    //DOUBLE ARROW TO OPEN MENU
                                    ? GestureDetector(
                                        onTap: () => ref.read(isMenuOpenProvider.notifier).state = !isMenuOpen,
                                        child: Transform.flip(
                                          flipX: true,
                                          child: const Icon(Icons.double_arrow_rounded),
                                        ),
                                      )
                                    : Row(
                                        children: [
                                          //COMMENT
                                          Padding(
                                            padding: const EdgeInsets.all(5),
                                            child: InkWell(
                                              onTap: () => context.pushNamed(
                                                AppRouter.commentsFromFeed.name,
                                                extra: widget.post,
                                                pathParameters: {
                                                  'postId': widget.post.postId,
                                                  'profileUid': widget.post.profileUid,
                                                  'username': profileFromPost!.username,
                                                },
                                              ),
                                              child: Image.asset(
                                                'assets/images/comment.png',
                                                width: 24,
                                                height: 24,
                                              ),
                                            ),
                                          ),
                                          //SHARE
                                          InkWell(
                                            onTap: () async {
                                              String path = 'cschiappa.github.io/search/post/${widget.post.postId}/${widget.post.profileUid}/${profileFromPost!.username}';
                                              await Share.share(path, subject: 'Pets Social Link'
                                                  //sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size,
                                                  );
                                            },
                                            child: Icon(
                                              Icons.share,
                                              color: theme.colorScheme.primary,
                                            ),
                                          ),
                                          //BOOKMARK
                                          savedPostsStream.when(
                                            error: (error, stackTrace) => Text('Error: $error'),
                                            loading: () => const SizedBox(),
                                            data: (savedPosts) {
                                              return Padding(
                                                padding: const EdgeInsets.symmetric(horizontal: 8),
                                                child: InkWell(
                                                  onTap: () async {
                                                    await ref.read(postControllerProvider.notifier).savePost(widget.post.postId, savedPosts);
                                                  },
                                                  child: Icon(
                                                    savedPosts.contains(widget.post.postId) ? Icons.bookmark : Icons.bookmark_border,
                                                    color: theme.colorScheme.primary,
                                                  ),
                                                ),
                                              );
                                            },
                                          ),
                                          //3 DOTS
                                          InkWell(
                                            onTap: () {
                                              showDialog(
                                                context: context,
                                                builder: (context) => Padding(
                                                  padding: ResponsiveLayout.isWeb(context) ? EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width / 3) : const EdgeInsets.all(0),
                                                  child: Dialog(
                                                    child: StatefulBuilder(builder: (BuildContext context, StateSetter setState) {
                                                      return ListView(
                                                        padding: const EdgeInsets.symmetric(vertical: 16),
                                                        shrinkWrap: true,
                                                        children: [
                                                          if (widget.post.profileUid == profile.profileUid)
                                                            InkWell(
                                                              onTap: () {
                                                                _editPostBottomSheet(context, state);
                                                              },
                                                              child: Container(
                                                                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                                                                child: Text(
                                                                  LocaleKeys.edit.tr(),
                                                                ),
                                                              ),
                                                            ),
                                                          widget.post.profileUid == profile.profileUid
                                                              //DELETE OPTION FOR USER POST
                                                              ? InkWell(
                                                                  onTap: () async {
                                                                    Navigator.of(context).pop();
                                                                    showDialog(
                                                                      context: context,
                                                                      builder: (context) {
                                                                        return AlertDialog(
                                                                          title: Text(LocaleKeys.sureDeletePost.tr()),
                                                                          content: Text(LocaleKeys.sureDeletePost2.tr()),
                                                                          actions: [
                                                                            TextButton(
                                                                              onPressed: () async {
                                                                                await ref.read(postControllerProvider.notifier).deletePost(widget.post.postId).then((value) => context.pop());
                                                                              },
                                                                              child: Text(LocaleKeys.delete.tr(), style: const TextStyle(fontSize: 16, color: Colors.red)),
                                                                            ),
                                                                            TextButton(
                                                                              onPressed: () {
                                                                                Navigator.of(context).pop();
                                                                              },
                                                                              child: Text(
                                                                                LocaleKeys.cancel.tr(),
                                                                                style: const TextStyle(fontSize: 16),
                                                                              ),
                                                                            )
                                                                          ],
                                                                        );
                                                                      },
                                                                    );
                                                                  },
                                                                  child: Container(
                                                                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                                                                    child: Text(LocaleKeys.delete.tr()),
                                                                  ),
                                                                )
                                                              //BLOCK OPTION FOR OTHER'S POSTS
                                                              : isBlocked
                                                                  ? InkWell(
                                                                      onTap: () async {
                                                                        Navigator.pop(context);
                                                                        ref.watch(userProvider.notifier).unblockProfile(widget.post.profileUid);
                                                                      },
                                                                      child: Container(
                                                                        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                                                                        child: Text(LocaleKeys.unblockProfile.tr()),
                                                                      ),
                                                                    )
                                                                  : InkWell(
                                                                      onTap: () async {
                                                                        Navigator.pop(context);
                                                                        ref.watch(userProvider.notifier).blockProfile(widget.post.profileUid);
                                                                      },
                                                                      child: Container(
                                                                        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                                                                        child: Text(LocaleKeys.blockProfile.tr()),
                                                                      ),
                                                                    ),
                                                          if (widget.post.profileUid != profile.profileUid)
                                                            InkWell(
                                                              onTap: () {
                                                                Navigator.pop(context);
                                                                _showReportBottomSheet(context, state);
                                                              },
                                                              child: Container(
                                                                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                                                                child: Text(LocaleKeys.report.tr()),
                                                              ),
                                                            ),
                                                        ],
                                                      );
                                                    }),
                                                  ),
                                                ),
                                              );
                                            },
                                            child: Icon(
                                              Icons.more_vert,
                                              color: theme.colorScheme.primary,
                                            ),
                                          ),
                                        ],
                                      ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),

                    //CAROUSEL
                    Positioned(
                      bottom: 8,
                      left: 0,
                      right: 0,
                      child: PrizesCarouselSlider(
                        prizes: prizes,
                        profileUid: profile.profileUid,
                        postId: widget.post.postId,
                        controller: _controller,
                      ),
                    )
                  ],
                ),
                //DESCRIPTION AND COMMENTS
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 8,
                      ),
                      prizesFromPost.when(
                          error: (error, stackTrace) => Text('Error: $error'),
                          loading: () => const LinearProgressIndicator(),
                          data: (prizesFromPost) {
                            return PrizesList(
                              prizes: prizesFromPost,
                              profileUid: profile.profileUid,
                              postId: widget.post.postId,
                            );
                          }),

                      //USERNAME
                      Text(
                        profileFromPost == null ? "" : profileFromPost.username,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                      ),
                      //DESCRIPTION
                      if (widget.post.description != '')
                        Container(
                          child: widget.post.description!.length < 20
                              ? Text('${widget.post.description}', style: const TextStyle(fontSize: 15))
                              : ref.watch(showDescriptionProvider) == false
                                  ? Row(
                                      children: [
                                        Text(cropMessage('${widget.post.description}', 20), style: const TextStyle(fontSize: 15)),
                                        GestureDetector(
                                          onTap: () => ref.read(showDescriptionProvider.notifier).state = true,
                                          child: Text(LocaleKeys.showMore.tr()),
                                        ),
                                      ],
                                    )
                                  : Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          '${widget.post.description}',
                                          style: const TextStyle(fontSize: 15),
                                        ),
                                        GestureDetector(
                                          onTap: () => ref.read(showDescriptionProvider.notifier).state = false,
                                          child: Text(LocaleKeys.showLess.tr()),
                                        ),
                                      ],
                                    ),
                        ),

                      // SHOW NUMBER OF COMMENTS
                      InkWell(
                        onTap: () => context.pushNamed(
                          AppRouter.commentsFromFeed.name,
                          extra: widget.post,
                          pathParameters: {
                            'postId': widget.post.postId,
                            'profileUid': widget.post.profileUid,
                            'username': profileFromPost!.username,
                          },
                        ),
                        child: Text(
                          LocaleKeys.viewComments.tr(namedArgs: {'int': commentsNumber.value.toString()}),
                          style: TextStyle(
                            fontSize: 15,
                            color: theme.colorScheme.primary,
                          ),
                        ),
                      ),

                      //DATE PUBLISHED
                      Text(
                        DateFormat.yMMMd().format(widget.post.datePublished),
                        style: TextStyle(fontSize: 12, color: theme.colorScheme.primary),
                      ),
                    ],
                  ),
                )
              ],
            ),
          );
        });
  }

  //EDIT POST BOTTOM SHEET
  void _editPostBottomSheet(BuildContext context, state) {
    final ThemeData theme = Theme.of(context);
    showModalBottomSheet(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      context: context,
      isScrollControlled: true,
      builder: ((context) {
        return Padding(
          padding: ResponsiveLayout.isWeb(context) ? EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width / 3) : EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
            },
            child: Container(
              padding: const EdgeInsets.all(50),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFieldInput(
                    labelText: LocaleKeys.changeDescription.tr(),
                    textInputType: TextInputType.text,
                    textEditingController: _descriptionController,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  InkWell(
                    onTap: () async {
                      await ref.read(postControllerProvider.notifier).updatePost(widget.post.postId, _descriptionController.text).then((value) {
                        context.pop();
                        context.pop();
                      });
                    },
                    child: Container(
                      width: double.infinity,
                      alignment: Alignment.center,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: ShapeDecoration(
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(4)),
                          ),
                          color: theme.colorScheme.secondary),
                      child: state.isLoading
                          ? Center(
                              child: CircularProgressIndicator(
                                color: theme.colorScheme.primary,
                              ),
                            )
                          : Text(LocaleKeys.confirm.tr()),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }

  void _showReportBottomSheet(BuildContext context, state) {
    final ThemeData theme = Theme.of(context);

    showModalBottomSheet(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        context: context,
        isScrollControlled: true,
        builder: ((context) {
          return Padding(
            padding: ResponsiveLayout.isWeb(context) ? EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width / 3) : EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
            child: GestureDetector(
              onTap: () {
                FocusScope.of(context).unfocus();
              },
              child: Container(
                padding: const EdgeInsets.all(50),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(LocaleKeys.reportPostInfo.tr()),
                    const SizedBox(
                      height: 20,
                    ),
                    TextFieldInput(
                      labelText: LocaleKeys.summary.tr(),
                      textInputType: TextInputType.text,
                      textEditingController: _summaryController,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    InkWell(
                      onTap: () async {
                        await ref.read(postControllerProvider.notifier).reportPost('posts', widget.post.profileUid, widget.post.postId, _summaryController.text).then((value) {
                          showSnackBar(LocaleKeys.reportSent.tr(), context);
                          Navigator.of(context).pop();
                        });
                      },
                      child: Container(
                        width: double.infinity,
                        alignment: Alignment.center,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: ShapeDecoration(
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(Radius.circular(4)),
                            ),
                            color: theme.colorScheme.secondary),
                        child: state.isLoading
                            ? Center(
                                child: CircularProgressIndicator(
                                  color: theme.colorScheme.primary,
                                ),
                              )
                            : Text(LocaleKeys.confirm.tr()),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }));
  }
}
