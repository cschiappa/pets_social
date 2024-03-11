import 'dart:async';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pets_social/core/constants/constants.dart';
import 'package:pets_social/core/utils/extensions.dart';
import 'package:pets_social/core/utils/language.g.dart';
import 'package:pets_social/core/utils/utils.dart';
import 'package:pets_social/core/utils/validators.dart';
import 'package:pets_social/core/widgets/liquid_pull_refresh.dart';
import 'package:pets_social/core/widgets/responsive_drawer.dart';
import 'package:pets_social/features/auth/controller/auth_controller.dart';
import 'package:pets_social/features/chat/controller/chat_controller.dart';
import 'package:pets_social/features/post/controller/post_controller.dart';
import 'package:pets_social/features/profile/controller/profile_controller.dart';
import 'package:pets_social/features/tag/controller/tag_controller.dart';
import 'package:pets_social/features/tag/widgets/tag_textfield.dart';
import 'package:pets_social/models/post.dart';
import 'package:pets_social/router.dart';
import 'package:pets_social/models/profile.dart';

import 'package:pets_social/responsive/responsive_layout_screen.dart';
import 'package:pets_social/core/widgets/bottom_sheet.dart';

import '../post/widgets/post_card.dart';
import '../../core/widgets/text_field_input.dart';

class FeedScreen extends ConsumerStatefulWidget {
  const FeedScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _FeedScreenState();
}

class _FeedScreenState extends ConsumerState<FeedScreen> {
  final GlobalKey<FormState> formKey = GlobalKey();
  final TextEditingController _bioController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  Uint8List? _image;

  @override
  void dispose() {
    _bioController.dispose();
    _usernameController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await ref.read(userProvider.notifier).getProfileDetails();
      await ref.read(accountProvider.notifier).getAccountDetails();
    });
  }

  //SELECT IMAGE
  void selectImage(context, setState) async {
    Uint8List im;
    (im, _, _, _) = await pickImage(ImageSource.gallery);
    setState(() {
      _image = im;
    });
  }

  //REFRESH PROFILE
  Future<void> _handleRefresh() async {
    await ref.read(userProvider.notifier).getProfileDetails();
    return await Future.delayed(const Duration(milliseconds: 500));
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final ModelProfile? profile = ref.watch(userProvider);
    final postsState = ref.watch(getFeedPostsProvider(profile));
    final ThemeData theme = Theme.of(context);

    ref.listen<AsyncValue>(
      profileControllerProvider,
      (_, state) => state.showSnackbarOnError(context),
    );
    final AsyncValue<void> state = ref.watch(profileControllerProvider);

    return ResponsiveDrawer(
      appBar: _appBar(),
      drawer: _drawer(state),
      content: LayoutBuilder(builder: (context, constraints) {
        return LiquidPullRefresh(
            key: LiquidKeys.liquidKey1,
            onRefresh: _handleRefresh,
            child: postsState.when(
              loading: () => Center(
                child: CircularProgressIndicator(color: theme.colorScheme.secondary),
              ),
              error: (error, stackTrace) => Text('Error: $error'),
              data: (posts) {
                if (posts.isEmpty) {
                  return SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(minHeight: constraints.maxHeight, minWidth: constraints.maxWidth),
                      child: Center(
                        child: Text(LocaleKeys.followSomeone.tr()),
                      ),
                    ),
                  );
                }

                // POST CARD
                return ListView.builder(
                    itemCount: posts.length,
                    itemBuilder: (context, index) {
                      final ModelPost post = ModelPost.fromSnap(posts[index]);
                      return Container(
                        margin: EdgeInsets.symmetric(
                          horizontal: ResponsiveLayout.isWeb(context) ? width / 3 : 0,
                          vertical: ResponsiveLayout.isWeb(context) ? 15 : 0,
                        ),
                        child: PostCard(
                          post: post,
                        ),
                      );
                    });
              },
            ));
      }),
    );
  }

  //PROFILE LIST FOR DRAWER
  Widget _buildProfileList() {
    final accountProfiles = ref.watch(getAccountProfilesProvider);
    final ThemeData theme = Theme.of(context);

    return accountProfiles.when(
        error: (error, stackTrace) => Text('Error: $error'),
        loading: () => LinearProgressIndicator(
              color: theme.colorScheme.secondary,
            ),
        data: (accountProfiles) {
          return ListView(
            shrinkWrap: true,
            children: accountProfiles.docs.map<Widget>((doc) => _buildProfileListItem(doc)).toList(),
          );
        });
  }

  //PROFILE LIST ITEM FOR DRAWER
  Widget _buildProfileListItem(DocumentSnapshot document) {
    final ThemeData theme = Theme.of(context);
    Map<String, dynamic> data = document.data()! as Map<String, dynamic>;

    return ListTile(
      leading: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white, width: 2),
        ),
        child: CircleAvatar(
          radius: 20,
          backgroundImage: NetworkImage(data['photoUrl'] ?? ""),
        ),
      ),
      title: Text(data['username']),
      selected: ref.read(userProvider)?.profileUid == data['profileUid'],
      selectedTileColor: theme.colorScheme.secondary,
      onTap: () {
        setState(() {
          ref.read(userProvider.notifier).getProfileDetails(profileUid: data['profileUid']);
        });
        Navigator.of(context).pop();
      },
    );
  }

  Widget _drawer(AsyncValue<void> state) {
    final ThemeData theme = Theme.of(context);

    return Drawer(
      backgroundColor: theme.colorScheme.background,
      width: 280,
      child: SafeArea(
        child: Column(
          children: [
            Container(
              height: 65,
              width: double.infinity,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20.0),
                ),
                gradient: LinearGradient(
                  colors: [
                    Color.fromARGB(255, 157, 110, 157), // Start color
                    Color.fromARGB(255, 240, 177, 136), // End color
                  ],
                ),
              ),
              child: Image.asset(
                'assets/images/logo.png',
                color: theme.colorScheme.primary,
                scale: 5,
              ),
            ),
            _buildProfileList(),
            Expanded(
              child: Align(
                  alignment: Alignment.bottomCenter,
                  child: StatefulBuilder(builder: (context, setState) {
                    //print(selectedPetTag);
                    return ListTile(
                      tileColor: Colors.grey[500],
                      title: Text(LocaleKeys.addNewProfile.tr()),
                      trailing: const Icon(Icons.person_add),
                      onTap: () {
                        return _profileBottomSheet(context, state);
                      },
                    );
                  })),
            )
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _appBar() {
    final chatsState = ref.watch(numberOfUnreadChatsProvider);

    final ThemeData theme = Theme.of(context);
    return AppBar(
      leading: Builder(builder: (context) {
        return IconButton(
          onPressed: () {
            Scaffold.of(context).openDrawer();
          },
          icon: const Icon(
            Icons.groups,
            size: 30,
          ),
        );
      }),
      backgroundColor: theme.appBarTheme.backgroundColor,
      centerTitle: true,
      title: Image.asset(
        'assets/images/logo.png',
        color: theme.colorScheme.tertiary,
        scale: 5,
      ),
      actions: [
        IconButton(
          onPressed: () {
            context.goNamed(AppRouter.chatList.name);
          },
          icon: chatsState.when(
            loading: () => Center(
              child: Container(),
            ),
            error: (error, stackTrace) => Text('Error: $error'),
            data: (chats) {
              return chats > 0
                  ? Badge.count(
                      textColor: Colors.white,
                      backgroundColor: theme.colorScheme.secondary,
                      count: chats,
                      child: const Icon(
                        Icons.forum,
                        size: 25,
                      ),
                    )
                  : const Icon(
                      Icons.forum,
                      size: 25,
                    );
            },
          ),
        ),
      ],
    );
  }

  //CREATE PROFILE BOTTOM SHEET
  void _profileBottomSheet(BuildContext context, state) {
    final ThemeData theme = Theme.of(context);
    final selectedPetTag = ref.watch(selectedTagsProvider('petTag'));

    final GlobalKey<FormState> formKeyTwo = GlobalKey();

    return CustomBottomSheet.show(context: context, listWidget: [
      Form(
        key: formKeyTwo,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Stack(
                children: [
                  _image != null
                      ? CircleAvatar(
                          radius: 40,
                          backgroundImage: MemoryImage(_image!),
                        )
                      : const CircleAvatar(radius: 40, backgroundImage: AssetImage('assets/images/default_pic.jpg')),
                  Positioned(
                    top: 40,
                    left: 40,
                    child: IconButton(
                      iconSize: 20,
                      onPressed: () => selectImage(context, setState),
                      icon: const Icon(
                        Icons.add_a_photo,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              //USERNAME
              Consumer(builder: (context, ref, child) {
                return TextFieldInput(
                  labelText: LocaleKeys.username.tr(),
                  textInputType: TextInputType.text,
                  textEditingController: _usernameController,
                  validator: (value) {
                    final isAvailable = ref.watch(isUsernameAvailableProvider(value));
                    if (isAvailable.value == false) {
                      return 'Username not available';
                    }

                    String? validate = usernameValidator(value);
                    if (validate != null) {
                      return validate;
                    }

                    return null;
                  },
                );
              }),
              const SizedBox(
                height: 20,
              ),
              //BIO
              TextFieldInput(
                labelText: LocaleKeys.bio.tr(),
                textInputType: TextInputType.text,
                textEditingController: _bioController,
                validator: bioValidator,
              ),
              const SizedBox(
                height: 20,
              ),
              //SELECT PROFILE PET TAG
              Text(LocaleKeys.petTagQuestion.tr(), style: theme.textTheme.titleMedium),
              const SizedBox(
                height: 10,
              ),
              Consumer(builder: (context, ref, child) {
                ref.watch(getPetTagsCollectionProvider);
                return TagTextField(
                  tag: 'petTag',
                  helper: LocaleKeys.chooseOnlyOneTag.tr(),
                  formKeyTwo: formKey,
                  validator: emptyField,
                );
              }),
              const SizedBox(
                height: 20,
              ),
              InkWell(
                onTap: () async {
                  if (formKey.currentState!.validate() && formKeyTwo.currentState!.validate()) {
                    await ref
                        .read(profileControllerProvider.notifier)
                        .createProfile(
                          username: _usernameController.text,
                          bio: _bioController.text,
                          petTag: selectedPetTag,
                          file: _image,
                          uid: FirebaseAuth.instance.currentUser!.uid,
                        )
                        .then((value) {
                      context.pop();
                      _usernameController.clear();
                      _bioController.clear();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(LocaleKeys.profileCreated.tr()),
                        ),
                      );
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
                  child: state.isLoading
                      ? Center(
                          child: CircularProgressIndicator(
                            color: theme.colorScheme.secondary,
                          ),
                        )
                      : Text(LocaleKeys.confirm.tr()),
                ),
              ),
            ],
          ),
        ),
      )
    ]);
  }
}
