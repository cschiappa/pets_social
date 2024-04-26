import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:go_router/go_router.dart';
import 'package:pets_social/core/constants/constants.dart';
import 'package:pets_social/core/utils/language.g.dart';
import 'package:pets_social/core/utils/utils.dart';
import 'package:pets_social/core/widgets/liquid_pull_refresh.dart';
import 'package:pets_social/features/auth/controller/auth_controller.dart';
import 'package:pets_social/features/post/controller/post_controller.dart';
import 'package:pets_social/features/profile/controller/profile_controller.dart';
import 'package:pets_social/models/account.dart';
import 'package:pets_social/router.dart';
import 'package:pets_social/models/profile.dart';

import 'package:pets_social/responsive/responsive_layout_screen.dart';
import '../../models/post.dart';

class SearchScreen extends ConsumerStatefulWidget {
  final dynamic snap;
  const SearchScreen({super.key, this.snap});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final TextEditingController searchController = TextEditingController();
  bool isShowUsers = false;
  List<ModelProfile> profiles = [];
  List<ModelProfile> profilesFiltered = [];

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback(
      (_) async {
        QuerySnapshot<Map<String, dynamic>> usersSnapshot = await FirebaseFirestore.instance.collectionGroup('profiles').get();

        for (QueryDocumentSnapshot doc in usersSnapshot.docs) {
          ModelProfile profile = ModelProfile.fromSnap(doc);

          profiles.add(profile);
        }
      },
    );
  }

  //REFRESH PROFILE
  Future<void> _handleRefresh() async {
    await ref.read(userProvider.notifier).getProfileDetails();
    return await Future.delayed(const Duration(milliseconds: 500));
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    ModelProfile profile = ref.watch(userProvider)!;
    ModelAccount account = ref.watch(accountProvider)!;
    final postsState = ref.watch(getPostsDescendingProvider(account, profile));

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        //SEARCHBAR
        appBar: AppBar(
          backgroundColor: theme.appBarTheme.backgroundColor,
          title: TextFormField(
            controller: searchController,
            decoration: InputDecoration(
              labelText: LocaleKeys.search.tr(),
              labelStyle: TextStyle(color: theme.colorScheme.secondary),
              suffixIcon: isShowUsers
                  ? TextButton(
                      onPressed: () {
                        setState(
                          () {
                            searchController.clear();
                            isShowUsers = false;
                          },
                        );
                      },
                      child: Text(LocaleKeys.cancel.tr()))
                  : const Icon(Icons.search),
            ),
            onChanged: (value) {
              setState(
                () {
                  isShowUsers = true;

                  profilesFiltered = profiles.where((element) => element.username.toLowerCase().contains(value.toLowerCase())).toList();
                },
              );
            },
          ),
        ),
        body: isShowUsers
            //SEARCHING FOR PROFILES
            ? ListView.builder(
                itemCount: profilesFiltered.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      context.goNamed(
                        AppRouter.profileFromSearch.name,
                        pathParameters: {
                          'profileUid': profilesFiltered[index].profileUid,
                        },
                      );
                    },
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(profilesFiltered[index].photoUrl!),
                      ),
                      title: Text(profilesFiltered[index].username),
                    ),
                  );
                },
              )
            //POST GRID
            : LiquidPullRefresh(
                key: LiquidKeys.liquidKey2,
                onRefresh: _handleRefresh,
                child: Container(
                  padding: ResponsiveLayout.isWeb(context) ? const EdgeInsets.symmetric(horizontal: 200) : const EdgeInsets.symmetric(horizontal: 0),
                  child: postsState.when(
                    loading: () => Center(
                      child: CircularProgressIndicator(color: theme.colorScheme.secondary),
                    ),
                    error: (error, stackTrace) => Text('Error: $error'),
                    data: (postsState) {
                      if (postsState.isEmpty) {
                        return Center(
                          child: Text(LocaleKeys.noPostsFound.tr()),
                        );
                      }

                      return MasonryGridView.builder(
                        itemCount: postsState.length,
                        cacheExtent: 3000,
                        itemBuilder: (context, index) {
                          ModelPost postIndex = postsState[index];
                          final getProfiles = ref.watch(getProfileFromPostProvider(postsState[index].profileUid));

                          return getProfiles.when(
                              loading: () => const SizedBox(),
                              error: (error, stackTrace) => Text('Error: $error'),
                              data: (getProfiles) {
                                Widget mediaWidget;
                                final String contentType = getContentTypeFromUrl(postIndex.fileType);
                                //return video
                                if (contentType == 'video') {
                                  mediaWidget = ClipRRect(
                                    borderRadius: BorderRadius.circular(10.0),
                                    child: CachedNetworkImage(
                                      imageUrl: postIndex.videoThumbnail,
                                      fit: BoxFit.fitWidth,
                                      placeholder: (context, url) => const SizedBox(),
                                    ),
                                  );
                                  //return image
                                } else if (contentType == 'image') {
                                  mediaWidget = ClipRRect(
                                    borderRadius: BorderRadius.circular(10.0),
                                    child: CachedNetworkImage(
                                      imageUrl: postIndex.postUrl,
                                      fit: BoxFit.fitWidth,
                                      placeholder: (context, url) => const SizedBox(),
                                    ),
                                  );
                                } else {
                                  mediaWidget = const Text('file format not available');
                                }

                                // Fetch username
                                String username = getProfiles.username;

                                return GestureDetector(
                                  onTap: () {
                                    String profileUid = postIndex.profileUid;
                                    String postId = postIndex.postId;

                                    context.pushNamed(
                                      AppRouter.openPostFromSearch.name,
                                      pathParameters: {
                                        'postId': postId,
                                        'profileUid': profileUid,
                                        'username': username,
                                      },
                                    );
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(2.0),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20.0),
                                        color: Colors.black,
                                      ),
                                      width: double.infinity,
                                      constraints: const BoxConstraints(maxHeight: 300),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(12),
                                        child: mediaWidget,
                                      ),
                                    ),
                                  ),
                                );
                              });
                        },
                        gridDelegate: ResponsiveLayout.isWeb(context) ? const SliverSimpleGridDelegateWithFixedCrossAxisCount(crossAxisCount: 6) : const SliverSimpleGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
                      );
                    },
                  ),
                ),
              ),
      ),
    );
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }
}
