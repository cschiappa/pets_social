import 'dart:io';
import 'dart:typed_data';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pets_social/core/utils/extensions.dart';
import 'package:pets_social/core/utils/language.g.dart';
import 'package:pets_social/core/widgets/button.dart';
import 'package:pets_social/features/post/controller/post_controller.dart';
import 'package:pets_social/features/post/widgets/video_player.dart';
import 'package:pets_social/features/profile/controller/profile_controller.dart';
import 'package:pets_social/models/profile.dart';
import 'package:pets_social/responsive/responsive_layout_screen.dart';
import 'package:pets_social/core/utils/utils.dart';
import 'package:pets_social/router.dart';

class AddPostScreen extends ConsumerStatefulWidget {
  const AddPostScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends ConsumerState<AddPostScreen> {
  Uint8List? _file;
  String? _fileType;
  Uint8List? _thumbnail;
  String? _filePath;
  final TextEditingController _descriptionController = TextEditingController();

  //SELECT IMAGE
  _selectImage(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            title: Text(LocaleKeys.createPost.tr()),
            children: [
              if (ResponsiveLayout.isMobile(context))
                SimpleDialogOption(
                  padding: const EdgeInsets.all(20),
                  child: Text(LocaleKeys.takePhoto.tr()),
                  onPressed: () async {
                    Navigator.of(context).pop();
                    Uint8List file;
                    String fileType;
                    Uint8List thumbnail;
                    String filePath;
                    (file, fileType, thumbnail, filePath) = await pickImage(
                      ImageSource.camera,
                    );
                    setState(() {
                      _file = file;
                      _fileType = fileType;
                      _thumbnail = thumbnail;
                      _filePath = filePath;
                    });
                  },
                ),
              if (ResponsiveLayout.isMobile(context))
                SimpleDialogOption(
                  padding: const EdgeInsets.all(20),
                  child: Text(LocaleKeys.takeVideo.tr()),
                  onPressed: () async {
                    Navigator.of(context).pop();
                    Uint8List file;
                    String fileType;
                    Uint8List thumbnail;
                    String filePath;
                    (file, fileType, thumbnail, filePath) = await pickVideo(
                      ImageSource.camera,
                    );
                    setState(() {
                      _file = file;
                      _fileType = fileType;
                      _thumbnail = thumbnail;
                      _filePath = filePath;
                    });
                  },
                ),
              SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child: Text(LocaleKeys.choosePhoto.tr()),
                onPressed: () async {
                  Navigator.of(context).pop();
                  Uint8List file;
                  String fileType;
                  Uint8List thumbnail;
                  String filePath;
                  (file, fileType, thumbnail, filePath) = await pickImage(
                    ImageSource.gallery,
                  );
                  setState(() {
                    _file = file;
                    _fileType = fileType;
                    _thumbnail = thumbnail;
                    _filePath = filePath;
                  });
                },
              ),
              SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child: Text(LocaleKeys.chooseVideo.tr()),
                onPressed: () async {
                  Navigator.of(context).pop();
                  Uint8List file;
                  String fileType;
                  Uint8List thumbnail;
                  String filePath;
                  (file, fileType, thumbnail, filePath) = await pickVideo(
                    ImageSource.gallery,
                  );
                  setState(() {
                    _file = file;
                    _fileType = fileType;
                    _thumbnail = thumbnail;
                    _filePath = filePath;
                  });
                },
              ),
              SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child: Text(LocaleKeys.cancel.tr()),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    final ModelProfile? profile = ref.watch(userProvider);
    final ThemeData theme = Theme.of(context);

    ref.listen<AsyncValue>(
      postControllerProvider,
      (_, state) => state.showSnackbarOnError(context),
    );
    final AsyncValue<void> state = ref.watch(postControllerProvider);

    return _file == null
        ? Center(
            child: IconButton(
              icon: const Icon(Icons.upload),
              iconSize: 50,
              onPressed: () => _selectImage(context),
            ),
          )
        : Scaffold(
            appBar: AppBar(
              backgroundColor: theme.appBarTheme.backgroundColor,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(title: Text(LocaleKeys.areYouSureYouWantToDoThis.tr()), content: Text(LocaleKeys.ifYouLeaveEverythingWillBeLost.tr()), actions: [
                          TextButton(
                            onPressed: () => context.pop(),
                            child: Text(
                              LocaleKeys.cancel.tr(),
                              style: const TextStyle(color: Colors.red),
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              context.pop();
                              clearImage();
                            },
                            child: Text(
                              LocaleKeys.confirm.tr(),
                            ),
                          ),
                        ]);
                      });
                },
              ),
              title: Text(LocaleKeys.postTo.tr()),
              actions: [
                TextButton(
                    onPressed: () async {
                      await ref.read(postControllerProvider.notifier).uploadPost(
                            FirebaseAuth.instance.currentUser!.uid,
                            _descriptionController.text,
                            _file!,
                            profile!.profileUid,
                            profile.username,
                            profile.photoUrl ?? "",
                            _fileType!,
                            _thumbnail!,
                          );
                      clearImage();
                    },
                    child: Text(LocaleKeys.post.tr(),
                        style: TextStyle(
                          color: theme.colorScheme.secondary,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        )))
              ],
            ),
            body: SingleChildScrollView(
              child: Column(children: [
                state.isLoading
                    ? LinearProgressIndicator(
                        color: theme.colorScheme.secondary,
                      )
                    : const Padding(
                        padding: EdgeInsets.only(top: 0),
                      ),
                const Divider(),
                SizedBox(
                    child: _file![0] == 255
                        ? Container(
                            width: double.infinity,
                            constraints: const BoxConstraints(maxHeight: 550),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20.0),
                              color: Colors.black,
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20.0),
                              child: Image.file(
                                File(_filePath!),
                                fit: BoxFit.fitWidth,
                              ),
                            ),
                          )
                        : Container(
                            //width: double.infinity,
                            constraints: const BoxConstraints(maxHeight: 600),
                            // decoration: BoxDecoration(
                            //   borderRadius: BorderRadius.circular(20.0),
                            //   color: Colors.black,
                            // ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20.0),
                              child: () {
                                return VideoPlayerWidget(videoUrl: Uri.parse(_filePath!));
                              }(),
                            ),
                          )),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        backgroundImage: (profile != null && profile.photoUrl != null) ? NetworkImage(profile.photoUrl!) : const AssetImage('assets/images/default_pic') as ImageProvider<Object>,
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      Expanded(
                        child: TextField(
                          controller: _descriptionController,
                          decoration: InputDecoration(
                            hintText: LocaleKeys.writeCaption.tr(),
                            border: InputBorder.none,
                          ),
                          maxLines: 8,
                        ),
                      ),
                    ],
                  ),
                )
              ]),
            ),
          );
  }

  //   //CLEAR IMAGE AFTER POSTING
  void clearImage() {
    setState(() {
      _file = null;
      _descriptionController.clear();
    });
    context.goNamed(AppRouter.feedScreen.name);
  }
}
