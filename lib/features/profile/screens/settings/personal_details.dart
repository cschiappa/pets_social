import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pets_social/core/utils/language.g.dart';
import 'package:pets_social/features/profile/controller/profile_controller.dart';
import 'package:pets_social/models/profile.dart';

class PersonalDetailsPage extends ConsumerWidget {
  const PersonalDetailsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ModelProfile profile = ref.watch(userProvider)!;
    final ThemeData theme = Theme.of(context);
    final DateFormat format = DateFormat("dd/MM/yyyy");

    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.appBarTheme.backgroundColor,
        title: Text(LocaleKeys.personalDetails.tr()),
      ),
      body: ListView(
        children: [
          //USERNAME
          ListTile(
            leading: const Icon(Icons.person),
            title: Text(LocaleKeys.username.tr()),
            subtitle: Text(profile.username),
          ),
          //PET TAG
          ListTile(
            leading: const Icon(Icons.tag),
            title: const Text('Pet Tag'),
            subtitle: Text(profile.petTag.first),
          ),
          //EMAIL
          ListTile(
            leading: const Icon(Icons.mail),
            title: Text(LocaleKeys.email.tr()),
            subtitle: Text(profile.email),
          ),
          //ACCOUNT BIRTHDAY
          ListTile(
            leading: const Icon(Icons.cake),
            title: Text(LocaleKeys.accountBirthday.tr()),
            subtitle: Text(format.format(FirebaseAuth.instance.currentUser!.metadata.creationTime!)),
          ),
        ],
      ),
    );
  }
}
