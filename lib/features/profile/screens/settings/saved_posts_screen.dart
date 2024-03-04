import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pets_social/core/constants/constants.dart';
import 'package:pets_social/core/utils/language.g.dart';
import 'package:pets_social/core/utils/utils.dart';
import 'package:pets_social/core/widgets/liquid_pull_refresh.dart';
import 'package:pets_social/features/auth/controller/auth_controller.dart';
import 'package:pets_social/features/post/controller/post_controller.dart';
import 'package:pets_social/features/profile/controller/profile_controller.dart';
import 'package:pets_social/models/account.dart';

import 'package:pets_social/models/post.dart';
import 'package:pets_social/router.dart';

class SavedPosts extends ConsumerStatefulWidget {
  final dynamic snap;
  const SavedPosts({super.key, this.snap});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SavedPostsState();
}

class _SavedPostsState extends ConsumerState<SavedPosts> {
  @override
  void initState() {
    super.initState();
    ref.read(accountProvider.notifier).getAccountDetails();
  }

  @override
  Widget build(BuildContext context) {
    final ModelAccount account = ref.watch(accountProvider)!;
    final ThemeData theme = Theme.of(context);
    final savedPosts = ref.watch(getSavedPostsProvider(account.savedPosts));

    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.appBarTheme.backgroundColor,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(LocaleKeys.savedPosts.tr()),
          ],
        ),
      ),
      body: account.savedPosts.isEmpty
          ? Center(
              child: Text(LocaleKeys.noPostsFound.tr()),
            )
          : savedPosts.when(
              error: (error, stacktrace) => Text('error: $error'),
              loading: () => Center(
                child: CircularProgressIndicator(
                  color: theme.colorScheme.secondary,
                ),
              ),
              data: (savedPosts) {
                return GridView.builder(
                  shrinkWrap: true,
                  itemCount: savedPosts.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, crossAxisSpacing: 5, mainAxisSpacing: 1.5, childAspectRatio: 1),
                  itemBuilder: (context, index) {
                    ModelPost postIndex = savedPosts[index];
                    final getProfiles = ref.watch(getProfileFromPostProvider(postIndex.profileUid));

                    return getProfiles.when(
                      error: (error, stacktrace) => Text('error: $error'),
                      loading: () => Container(),
                      data: (getProfiles) {
                        Widget mediaWidget;
                        final String contentType = getContentTypeFromUrl(postIndex.fileType);
                        //return video
                        if (contentType == 'video') {
                          mediaWidget = ClipRRect(
                            borderRadius: BorderRadius.circular(10.0),
                            child: Image(
                              image: NetworkImage(postIndex.videoThumbnail),
                              fit: BoxFit.cover,
                            ),
                          );
                          //return image
                        } else if (contentType == 'image') {
                          mediaWidget = ClipRRect(
                            borderRadius: BorderRadius.circular(10.0),
                            child: Image(
                              image: NetworkImage(postIndex.postUrl),
                              fit: BoxFit.cover,
                            ),
                          );
                        } else {
                          mediaWidget = const Text('file format not available');
                        }

                        return GestureDetector(
                          onTap: () {
                            context.goNamed(
                              AppRouter.openPostFromFeed.name,
                              pathParameters: {
                                'postId': postIndex.postId,
                                'profileUid': postIndex.profileUid,
                                'username': getProfiles.username,
                              },
                            );
                          },
                          child: mediaWidget,
                        );
                      },
                    );
                  },
                );
              },
            ),
    );
  }
}
