import 'dart:io';
import 'dart:typed_data';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pets_social/core/constants/constants.dart';
import 'package:pets_social/core/utils/extensions.dart';
import 'package:pets_social/core/utils/language.g.dart';
import 'package:pets_social/core/utils/validators.dart';
import 'package:pets_social/core/widgets/follow_button.dart';
import 'package:pets_social/core/widgets/liquid_pull_refresh.dart';
import 'package:pets_social/core/widgets/text_field_input.dart';
import 'package:pets_social/features/post/controller/post_controller.dart';
import 'package:pets_social/features/prize/controller/prize_controller.dart';
import 'package:pets_social/features/prize/widgets/prize_list_profile.dart';
import 'package:pets_social/features/profile/controller/profile_controller.dart';
import 'package:pets_social/models/profile.dart';
import 'package:pets_social/router.dart';
import 'package:pets_social/models/post.dart';
import 'package:pets_social/responsive/responsive_layout_screen.dart';
import 'package:pets_social/core/utils/utils.dart';
import 'package:pets_social/core/widgets/bottom_sheet.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  final String? profileUid;
  final dynamic snap;

  const ProfileScreen({super.key, this.profileUid, this.snap});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  final GlobalKey<FormState> formKey = GlobalKey();
  late String userId = "";
  Uint8List? _image;
  String? _imagePath;
  final bool _isLoading = false;
  final TextEditingController _summaryController = TextEditingController();

  //SELECT IMAGE
  void selectImage() async {
    Uint8List im;
    String filePath;
    (im, _, _, filePath) = await pickImage(ImageSource.gallery);
    setState(() {
      _image = im;
      _imagePath = filePath;
      ref.read(temporaryPicture.notifier).state = filePath;
    });
  }

  //REFRESH PROFILE
  Future<void> _handleRefresh() async {
    await ref.read(userProvider.notifier).getProfileDetails();
    ref.invalidate(getProfilePrizesProvider(userId));
    ref.read(getProfilePrizesProvider(userId));
    return await Future.delayed(const Duration(milliseconds: 500));
  }

  @override
  Widget build(BuildContext context) {
    final ModelProfile? profile = ref.watch(userProvider);
    final ThemeData theme = Theme.of(context);
    userId = widget.profileUid ?? profile!.profileUid;
    final profileData = ref.watch(getProfileDataProvider(userId));
    final profilePosts = ref.watch(getProfilePostsProvider(userId));

    final List<String> settingsOptions = [LocaleKeys.savedPosts.tr(), LocaleKeys.settings.tr(), if (userId != profile!.profileUid) LocaleKeys.reportProfile.tr()];

    ref.listen<AsyncValue>(
      postControllerProvider,
      (_, state) => state.showSnackbarOnError(context),
    );
    final AsyncValue<void> state = ref.watch(postControllerProvider);

    return profileData.when(
      error: (error, stackTrace) => Text('Error: $error'),
      loading: () => Center(
        child: CircularProgressIndicator(
          color: theme.colorScheme.secondary,
        ),
      ),
      data: (profileData) {
        return Scaffold(
          appBar: _appBar(theme, profileData.username, profile, settingsOptions, state),
          body: LiquidPullRefresh(
            key: LiquidKeys.liquidKey3,
            onRefresh: _handleRefresh,
            child: Container(
              padding: ResponsiveLayout.isWeb(context) ? EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width / 3) : const EdgeInsets.symmetric(horizontal: 0),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Stack(
                      children: [
                        //GRADIENT CONTAINER
                        Container(
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(10.0),
                              bottomRight: Radius.circular(10.0),
                            ),
                            gradient: LinearGradient(
                              colors: [
                                Color.fromARGB(255, 157, 110, 157), // Start color
                                Color.fromARGB(255, 240, 177, 136), // End color
                              ],
                            ),
                          ),
                          height: 60,
                        ),
                        //PROFILE PIC
                        Container(
                          margin: const EdgeInsets.only(top: 10),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: theme.colorScheme.background,
                              width: 5.0,
                            ),
                          ),
                          child: CircleAvatar(
                            backgroundImage: NetworkImage(
                              profileData.photoUrl ?? '',
                            ),
                            radius: 40,
                          ),
                        ),
                      ],
                    ),
                    //USERNAME
                    Text(
                      profileData.username,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    //DESCRIPTION
                    Text(
                      profileData.bio ?? '',
                    ),
                    //PROFILE STATS ROW
                    //profileStats(profileData.followers.length),
                    SizedBox(
                      height: 50,
                      child: ProfilePrizeList(
                        userId: userId,
                      ),
                    ),
                    //SIGN OUT/FOLLOW BUTTON AND SETTINGS WHEEL
                    signOutButtonAndSettingsRow(profile, theme, profileData),
                    const Divider(),
                    //PICTURES GRID
                    profilePosts.when(
                        error: (error, stacktrace) => Text('error: $error'),
                        loading: () => Center(
                              child: CircularProgressIndicator(
                                color: theme.colorScheme.secondary,
                              ),
                            ),
                        data: (profilePosts) {
                          return GridView.builder(
                            shrinkWrap: true,
                            itemCount: profilePosts.docs.length,
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, crossAxisSpacing: 5, mainAxisSpacing: 1.5, childAspectRatio: 1),
                            itemBuilder: (context, index) {
                              ModelPost post = ModelPost.fromSnap(profilePosts.docs[index]);

                              Widget mediaWidget;
                              final String contentType = getContentTypeFromUrl(post.fileType);
                              //return video
                              if (contentType == 'video') {
                                mediaWidget = ClipRRect(
                                  borderRadius: BorderRadius.circular(10.0),
                                  child: Image(
                                    image: NetworkImage(post.videoThumbnail),
                                    fit: BoxFit.cover,
                                  ),
                                );
                              } else {
                                // return image
                                mediaWidget = ClipRRect(
                                  borderRadius: BorderRadius.circular(10.0),
                                  child: Image(
                                    image: NetworkImage(post.postUrl),
                                    fit: BoxFit.cover,
                                  ),
                                );
                              }
                              return GestureDetector(
                                onTap: () {
                                  post.profileUid == profile.profileUid
                                      ? context.goNamed(
                                          AppRouter.openPostFromProfile.name,
                                          pathParameters: {
                                            'postId': post.postId,
                                            'profileUid': post.profileUid,
                                            'username': profileData.username,
                                          },
                                        )
                                      : context.goNamed(
                                          AppRouter.openPostFromFeed.name,
                                          pathParameters: {
                                            'postId': post.postId,
                                            'profileUid': post.profileUid,
                                            'username': profileData.username,
                                          },
                                        );
                                },
                                child: mediaWidget,
                              );
                            },
                          );
                        })
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  //PROFILE STATS ROW
  Widget profileStats(followers) {
    final likes = ref.watch(fetchProfilePrizeQuantityProvider(userId, "like")).value;
    final fish = ref.watch(fetchProfilePrizeQuantityProvider(userId, "fish")).value;
    final bones = ref.watch(fetchProfilePrizeQuantityProvider(userId, "bone")).value;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        buildStatColumn(likes, LocaleKeys.likes.tr()),
        buildStatColumn(fish, LocaleKeys.fish.tr()),
        buildStatColumn(bones, LocaleKeys.bones.tr()),
        buildStatColumn(followers, LocaleKeys.followers.tr()),
      ],
    );
  }

  //SIGNOUT/FOLLOW BUTTON AND SETTINGS WHEEL
  Widget signOutButtonAndSettingsRow(ModelProfile? profile, ThemeData theme, ModelProfile profileData) {
    bool isFollowing = profileData.followers.contains(profile!.profileUid);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        profile.profileUid == userId
            ? FollowButton(
                text: LocaleKeys.editProfile.tr(),
                backgroundColor: theme.colorScheme.background,
                textColor: theme.colorScheme.tertiary,
                borderColor: Colors.grey,
                function: () {
                  _profileBottomSheet(context);
                },
              )
            : isFollowing
                ? FollowButton(
                    text: LocaleKeys.unfollow.tr(),
                    backgroundColor: Colors.white,
                    textColor: Colors.black,
                    borderColor: Colors.grey,
                    function: () async {
                      ref.watch(userProvider.notifier).updateFollowProfiles(profile.profileUid, profileData.profileUid);
                    },
                  )
                : FollowButton(
                    text: LocaleKeys.follow.tr(),
                    backgroundColor: theme.colorScheme.secondary,
                    textColor: Colors.white,
                    borderColor: theme.colorScheme.secondary,
                    function: () async {
                      ref.watch(userProvider.notifier).updateFollowProfiles(profile.profileUid, profileData.profileUid);
                    },
                  ),
      ],
    );
  }

  //PROFILE STATS FUNCTION
  Column buildStatColumn(int? num, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: const EdgeInsets.only(top: 10),
          child: Text(
            num.toString(),
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }

  //EDIT PROFILE BOTTOM SHEET
  _profileBottomSheet(BuildContext context) {
    final profile = ref.watch(userProvider)!;
    final ThemeData theme = Theme.of(context);
    String defaultPicture = 'https://i.pinimg.com/474x/eb/bb/b4/ebbbb41de744b5ee43107b25bd27c753.jpg';

    return CustomBottomSheet.show(
      context: context,
      listWidget: [
        StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Form(
              key: formKey,
              child: Consumer(builder: (context, ref, child) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Stack(
                      children: [
                        ref.watch(temporaryPicture) != null
                            ? CircleAvatar(
                                radius: 40,
                                backgroundImage: ref.watch(temporaryPicture) != defaultPicture
                                    ? FileImage(
                                        File(_imagePath ?? defaultPicture),
                                      )
                                    : NetworkImage(defaultPicture) as ImageProvider)
                            : CircleAvatar(
                                radius: 40,
                                backgroundImage: NetworkImage(profile.photoUrl ?? ''),
                              ),
                        Positioned(
                          top: 40,
                          left: 40,
                          child: IconButton(
                            iconSize: 20,
                            onPressed: () => selectImage(),
                            icon: const Icon(
                              Icons.add_a_photo,
                            ),
                          ),
                        ),
                      ],
                    ),
                    if (ref.watch(temporaryPicture) != defaultPicture)
                      InkWell(
                        onTap: () => ref.read(temporaryPicture.notifier).state = defaultPicture,
                        child: Text(
                          LocaleKeys.removePicture.tr(),
                          style: const TextStyle(fontSize: 10),
                        ),
                      ),
                    const SizedBox(
                      height: 20,
                    ),
                    //USERNAME
                    TextFieldInput(
                      labelText: LocaleKeys.username.tr(),
                      textCapitalization: TextCapitalization.words,
                      inputFormatters: [UpperCaseTextFormatter(), NoSpaceFormatter()],
                      textInputType: TextInputType.text,
                      initialValue: profile.username,
                      onChanged: ref.read(userProvider.notifier).updateUsername,
                      validator: (value) {
                        final isAvailable = ref.watch(isUsernameAvailableProvider(value));
                        if (isAvailable.value == false) {
                          return LocaleKeys.usernameNotAvailable.tr();
                        }

                        String? validate = usernameValidator(value);
                        if (validate != null) {
                          return validate;
                        }

                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextFieldInput(
                      labelText: LocaleKeys.bio.tr(),
                      textInputType: TextInputType.text,
                      initialValue: profile.bio,
                      onChanged: ref.read(userProvider.notifier).updateBio,
                      validator: bioValidator,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    InkWell(
                      onTap: () async {
                        if (formKey.currentState!.validate()) {
                          final ModelProfile? profile = ref.read(userProvider);

                          await ref.read(profileControllerProvider.notifier).updateProfile(profileUid: profile!.profileUid, file: _image, newUsername: profile.username, newBio: profile.bio!).then((value) {
                            context.pop();
                            showSnackBar(LocaleKeys.profileUpdated.tr(), context);
                          });
                        }
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
                        child: _isLoading
                            ? Center(
                                child: CircularProgressIndicator(
                                  color: theme.colorScheme.primary,
                                ),
                              )
                            : Text(LocaleKeys.updateProfile.tr()),
                      ),
                    ),
                  ],
                );
              }),
            );
          },
        ),
      ],
    );
  }

  PreferredSizeWidget? _appBar(ThemeData theme, text, ModelProfile profile, List<String> settingsOptions, state) {
    return AppBar(
      backgroundColor: theme.appBarTheme.backgroundColor,
      //APPBAR ROW
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(text),
          IconButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => Dialog(
                  child: ListView(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shrinkWrap: true,
                    children: settingsOptions
                        .map(
                          (e) => InkWell(
                            onTap: () {
                              if (e == LocaleKeys.savedPosts.tr()) {
                                Navigator.pop(context);

                                context.goNamed(AppRouter.savedPosts.name, extra: widget.snap);
                              } else if (e == LocaleKeys.settings.tr()) {
                                Navigator.pop(context);

                                context.goNamed(AppRouter.settings.name);
                              } else if (e == LocaleKeys.reportProfile.tr()) {
                                _showReportBottomSheet(context, state);
                              }
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                              child: Text(e),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ),
              );
            },
            icon: const Icon(Icons.more_vert),
          ),
        ],
      ),
      centerTitle: false,
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
                    Text(LocaleKeys.reportProfileInfo.tr()),
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
                        await ref.read(postControllerProvider.notifier).reportPost('profiles', userId, '', _summaryController.text).then((value) {
                          Navigator.of(context).pop();
                          Navigator.of(context).pop();
                          showSnackBar(LocaleKeys.reportSent.tr(), context);
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
