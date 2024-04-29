import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pets_social/core/utils/extensions.dart';
import 'package:pets_social/core/utils/language.g.dart';
import 'package:pets_social/core/utils/utils.dart';
import 'package:pets_social/core/utils/validators.dart';
import 'package:pets_social/core/widgets/info_bubble/show_info_bubble.dart';
import 'package:pets_social/core/widgets/text_field_input.dart';
import 'package:pets_social/features/auth/controller/auth_controller.dart';

import 'package:pets_social/features/profile/controller/profile_controller.dart';
import 'package:pets_social/models/profile.dart';

class ProfileSettings extends ConsumerStatefulWidget {
  const ProfileSettings({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ProfileSettingsState();
}

class _ProfileSettingsState extends ConsumerState<ProfileSettings> {
  final TextEditingController _passwordController = TextEditingController();
  final bubbleKey2 = GlobalKey();

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(LocaleKeys.profiles.tr()),
            IconButton(
              onPressed: () {
                showInfoBubble(LocaleKeys.whyCantIDeleteTheCurrentProfile.tr(), LocaleKeys.youCanDeleteTheCurrentProfileIf.tr(), bubbleKey2, Colors.pink.shade300);
              },
              icon: Icon(
                Icons.info_outline,
                size: 20,
                key: bubbleKey2,
              ),
            ),
          ],
        ),
        backgroundColor: theme.appBarTheme.backgroundColor,
      ),
      body: _buildProfileList(),
    );
  }

  //USER'S PROFILES LIST
  Widget _buildProfileList() {
    final ThemeData theme = Theme.of(context);
    final accountProfiles = ref.watch(getAccountProfilesProvider);
    return accountProfiles.when(
        error: (error, stackTrace) => Text('Error: $error'),
        loading: () => LinearProgressIndicator(
              color: theme.colorScheme.secondary,
            ),
        data: (accountProfiles) {
          final hasMultipleProfiles = accountProfiles.docs.length > 1;

          return ListView(
            children: accountProfiles.docs.map<Widget>((doc) => _buildProfileListItem(doc, hasMultipleProfiles)).toList(),
          );
        });
  }

  //USER'S PROFILES LIST ITEMS
  Widget _buildProfileListItem(DocumentSnapshot document, bool hasMultipleProfiles) {
    Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
    final ModelProfile? profile = ref.watch(userProvider);
    final ThemeData theme = Theme.of(context);

    ref.listen<AsyncValue>(
      authControllerProvider,
      (_, state) => state.showSnackbarOnError(context),
    );

    return ListTile(
      leading: CircleAvatar(
        radius: 15,
        backgroundImage: NetworkImage(data['photoUrl']),
      ),
      title: Text(data['username']),
      trailing: hasMultipleProfiles && data['profileUid'] != profile!.profileUid
          ? TextButton(
              child: Text(LocaleKeys.delete.tr(), style: TextStyle(fontSize: 16, color: theme.colorScheme.error)),
              onPressed: () => _deleteProfile(data),
            )
          : null,
    );
  }

  _deleteProfile(Map<String, dynamic> data) {
    final ThemeData theme = Theme.of(context);

    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(LocaleKeys.sureYouWantToDeleteProfile.tr()),
          content: Text(LocaleKeys.sureYouWantToDeleteProfile2.tr()),
          actions: [
            TextButton(
              child: Text(
                LocaleKeys.delete.tr(),
                style: TextStyle(fontSize: 16, color: theme.colorScheme.error),
              ),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: ((context) {
                    return AlertDialog(
                      title: Text(LocaleKeys.introducePassword.tr()),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          //text field unput for password
                          TextFieldInput(
                            labelText: LocaleKeys.currentPassword.tr(),
                            textInputType: TextInputType.text,
                            textEditingController: _passwordController,
                            isPass: true,
                            validator: emptyField,
                            suffixIcon: true,
                          ),
                          const SizedBox(
                            height: 24,
                          ),
                        ],
                      ),
                      actions: [
                        TextButton(
                          onPressed: () async {
                            String currentPassword = _passwordController.text;

                            final bool verifyPassword = await ref.read(authControllerProvider.notifier).verifyCurrentPassword(currentPassword);

                            if (verifyPassword == true) {
                              await ref.read(profileControllerProvider.notifier).deleteProfile(data['profileUid']).then((value) {
                                _passwordController.clear();
                                Navigator.of(context).pop();
                                Navigator.of(context).pop();
                              });
                            } else {
                              showSnackBar(LocaleKeys.incorrectPassword.tr(), context);
                            }
                          },
                          child: Text(LocaleKeys.delete.tr(), style: TextStyle(fontSize: 16, color: theme.colorScheme.error)),
                        ),
                        TextButton(
                          onPressed: () {
                            _passwordController.clear();
                            Navigator.of(context).pop();
                            Navigator.of(context).pop();
                          },
                          child: Text(LocaleKeys.cancel.tr()),
                        ),
                      ],
                    );
                  }),
                );
              },
            ),
            TextButton(
              child: Text(
                LocaleKeys.cancel.tr(),
                style: const TextStyle(fontSize: 16),
              ),
              onPressed: () {
                context.pop();
              },
            )
          ],
        );
      },
    );
  }
}
