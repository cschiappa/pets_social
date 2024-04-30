import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pets_social/core/utils/extensions.dart';
import 'package:pets_social/core/utils/language.g.dart';
import 'package:pets_social/core/utils/utils.dart';
import 'package:pets_social/core/utils/validators.dart';
import 'package:pets_social/features/auth/controller/auth_controller.dart';
import 'package:pets_social/router.dart';
import 'package:pets_social/core/widgets/text_field_input.dart';

class AccountSettingsPage extends ConsumerStatefulWidget {
  const AccountSettingsPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AccountSettingsPageState();
}

class _AccountSettingsPageState extends ConsumerState<ConsumerStatefulWidget> {
  final TextEditingController _currentPasswordController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  bool passEnable = true;

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _passwordController.dispose();
    _newPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final GlobalKey<FormState> formKey = GlobalKey();
    final ThemeData theme = Theme.of(context);

    ref.listen<AsyncValue>(
      authControllerProvider,
      (_, state) => state.showSnackbarOnError(context),
    );

    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.appBarTheme.backgroundColor,
        title: Row(
          children: [
            Text(LocaleKeys.accountsSettings.tr()),
          ],
        ),
      ),
      body: ListView(
        children: [
          //PROFILE SETTINGS
          ListTile(
            leading: const Icon(Icons.groups),
            title: Text(LocaleKeys.profiles.tr()),
            onTap: () => context.goNamed(AppRouter.profileSettings.name),
          ),
          //PERSONAL DETAILS
          ListTile(
            leading: const Icon(Icons.info),
            title: Text(LocaleKeys.personalDetails.tr()),
            onTap: () => context.goNamed(AppRouter.personalDetails.name),
          ),
          //PREFERED PET TAGS
          ListTile(
            leading: const Icon(Icons.tag),
            title: Text(LocaleKeys.petTagSettings.tr()),
            onTap: () => context.goNamed(AppRouter.petTagsSettings.name),
          ),
          //CHANGE PASSWORD
          ListTile(
            leading: const Icon(Icons.lock),
            title: Text(LocaleKeys.changePassword.tr()),
            onTap: () async => _changePassword(formKey),
          ),
          //DELETE ACCOUNT
          ListTile(
            leading: const Icon(Icons.delete),
            title: Text(LocaleKeys.deleteAccount.tr()),
            onTap: () => _deleteAccount(theme, formKey),
          ),
        ],
      ),
    );
  }

  _changePassword(GlobalKey<FormState> formKey) {
    return showDialog(
      context: context,
      builder: ((context) {
        return AlertDialog(
          title: Text(LocaleKeys.changePassword.tr()),
          content: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                children: [
                  const SizedBox(
                    height: 30,
                  ),
                  //Current password
                  TextFieldInput(
                    textEditingController: _currentPasswordController,
                    isPass: passEnable,
                    labelText: LocaleKeys.currentPassword.tr(),
                    textInputType: TextInputType.text,
                    validator: emptyField,
                    suffixIcon: true,
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  //Enter new password

                  TextFieldInput(
                    textEditingController: _passwordController,
                    isPass: passEnable,
                    labelText: LocaleKeys.newPassword.tr(),
                    textInputType: TextInputType.text,
                    validator: passwordValidator,
                    suffixIcon: true,
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  //Repeat Password

                  TextFieldInput(
                      textEditingController: _newPasswordController,
                      isPass: passEnable,
                      labelText: LocaleKeys.repeatPassword.tr(),
                      textInputType: TextInputType.text,
                      suffixIcon: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return LocaleKeys.pleaseEnterField.tr();
                        }
                        if (value != _passwordController.text) {
                          return LocaleKeys.passwordNotMatch.tr();
                        }
                        return null;
                      }),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () async {
                if (formKey.currentState!.validate()) {
                  String currentPassword = _currentPasswordController.text;
                  String newPassword = _passwordController.text;
                  String newPasswordConfirmation = _newPasswordController.text;

                  final bool verifyPassword = await ref.read(authControllerProvider.notifier).verifyCurrentPassword(currentPassword);

                  if (verifyPassword == true) {
                    if (isPasswordValid(newPassword)) {
                      if (newPassword == newPasswordConfirmation) {
                        await ref.read(authControllerProvider.notifier).changePassword(newPassword).then((value) {
                          _currentPasswordController.clear();
                          _newPasswordController.clear();
                          _passwordController.clear();
                          context.pop();
                        });
                      }
                    }
                  }
                }
              },
              child: Text(LocaleKeys.save.tr()),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _currentPasswordController.clear();
                _newPasswordController.clear();
                _passwordController.clear();
              },
              child: Text(LocaleKeys.cancel.tr()),
            ),
          ],
        );
      }),
    );
  }

  _deleteAccount(ThemeData theme, GlobalKey<FormState> formKey) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(LocaleKeys.sureYouWantToDeleteAccount.tr()),
          content: Text(LocaleKeys.sureYouWantToDeleteAccount2.tr()),
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
                      content: Form(
                        key: formKey,
                        child: Column(
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
                      ),
                      actions: [
                        TextButton(
                          onPressed: () async {
                            if (formKey.currentState!.validate()) {
                              String currentPassword = _passwordController.text;

                              final bool verifyPassword = await ref.read(authControllerProvider.notifier).verifyCurrentPassword(currentPassword);

                              if (verifyPassword == true) {
                                await ref.read(authControllerProvider.notifier).deleteUser();
                              }
                            }
                          },
                          child: Text(LocaleKeys.deleteAccount.tr()),
                        ),
                        TextButton(
                          onPressed: () {
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
                style: TextStyle(fontSize: 16, color: theme.colorScheme.tertiary),
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
