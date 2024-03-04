import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pets_social/core/utils/extensions.dart';
import 'package:pets_social/core/utils/language.g.dart';
import 'package:pets_social/core/utils/utils.dart';
import 'package:pets_social/core/utils/validators.dart';
import 'package:pets_social/core/widgets/text_field_input.dart';
import 'package:pets_social/features/auth/controller/auth_controller.dart';

import 'package:pets_social/features/profile/controller/profile_controller.dart';

class ProfileSettings extends ConsumerStatefulWidget {
  const ProfileSettings({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ProfileSettingsState();
}

class _ProfileSettingsState extends ConsumerState<ProfileSettings> {
  final TextEditingController _passwordController = TextEditingController();

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
        title: Text(LocaleKeys.profiles.tr()),
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
      trailing: hasMultipleProfiles
          ? TextButton(
              child: Text(LocaleKeys.delete.tr()),
              onPressed: () => _deleteProfile(data),
            )
          : null,
    );
  }

  _deleteProfile(Map<String, dynamic> data) {
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
                style: const TextStyle(fontSize: 16, color: Colors.red),
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
                                ref.read(userProvider.notifier).disposeProfile();
                                _passwordController.clear();
                                context.pop();
                                context.pop();
                              });
                            } else {
                              showSnackBar(LocaleKeys.incorrectPassword.tr(), context);
                            }
                          },
                          child: Text(LocaleKeys.delete.tr()),
                        ),
                        TextButton(
                          onPressed: () {
                            _passwordController.clear();
                            context.pop();
                            context.pop();
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
                Navigator.of(context).pop();
              },
            )
          ],
        );
      },
    );
  }
}
