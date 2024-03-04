import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pets_social/core/constants/constants.dart';
import 'package:pets_social/core/utils/extensions.dart';
import 'package:pets_social/core/utils/language.g.dart';
import 'package:pets_social/features/auth/controller/auth_controller.dart';
import 'package:pets_social/features/post/controller/post_controller.dart';
import 'package:pets_social/router.dart';
import 'package:pets_social/theme/theme_provider.dart';
import 'package:pets_social/core/widgets/bottom_sheet.dart';
import 'package:pets_social/core/widgets/text_field_input.dart';

class SettingsPage extends ConsumerStatefulWidget {
  const SettingsPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SettingsPageState();
}

class _SettingsPageState extends ConsumerState<SettingsPage> {
  final TextEditingController _problemSummaryController = TextEditingController();
  final TextEditingController _problemDetailsController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    ref.listen<AsyncValue>(
      postControllerProvider,
      (_, state) => state.showSnackbarOnError(context),
    );
    final AsyncValue<void> state = ref.watch(postControllerProvider);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.appBarTheme.backgroundColor,
        title: Row(
          children: [
            Text(LocaleKeys.settings.tr()),
          ],
        ),
      ),
      body: ListView(
        children: [
          //ACCOUNTS SETTINGS
          ListTile(
            leading: const Icon(Icons.person),
            title: Text(LocaleKeys.accountsSettings.tr()),
            onTap: () => context.goNamed(AppRouter.accountSettings.name),
          ),
          //DARK MODE
          ListTile(
            leading: const Icon(Icons.dark_mode),
            title: Text(LocaleKeys.darkMode.tr()),
            onTap: () => context.goNamed(AppRouter.blockedAccounts.name),
            trailing: Switch(
              value: ref.watch(themeProvider).themeData.brightness == Brightness.dark,
              onChanged: (value) {
                ref.read(themeProvider).toggleTheme();
              },
            ),
          ),
          //NOTIFICATIONS
          ListTile(
            leading: const Icon(Icons.notifications),
            title: Text(LocaleKeys.notifications.tr()),
            onTap: () => context.goNamed(AppRouter.notifications.name),
          ),
          //BLOCKED ACCOUNTS
          ListTile(
            leading: const Icon(Icons.person_off),
            title: Text(LocaleKeys.blockedAccounts.tr()),
            onTap: () => context.goNamed(AppRouter.blockedAccounts.name),
          ),
          //LANGUAGE
          ListTile(
            leading: const Icon(Icons.language),
            title: Text(LocaleKeys.language.tr()),
            onTap: () => _languageBottomSheet(context),
          ),
          //REPORT A PROBLEM
          ListTile(
            leading: const Icon(Icons.report_problem),
            title: Text(LocaleKeys.reportAProblem.tr()),
            onTap: () {
              _feedbackBottomSheet(context, state);
            },
          ),
          //LOG OUT
          ListTile(
            title: Text(
              LocaleKeys.signOut.tr(),
              style: const TextStyle(color: Colors.red),
            ),
            leading: const Icon(
              Icons.cancel,
              size: 20,
              color: Colors.red,
            ),
            onTap: () => ref.read(authControllerProvider.notifier).signOut(),
          )
        ],
      ),
    );
  }

  //LANGUAGE BOTTOMSHEET
  _languageBottomSheet(BuildContext context) {
    return CustomBottomSheet.show(context: context, listWidget: [
      SingleChildScrollView(
        child: SizedBox(
          height: 500,
          child: ListView.builder(
            itemCount: languagesOriginal.length,
            itemBuilder: (context, index) {
              return _buildLanguageTile(context, supportedLocales[index], languagesOriginal[index], languagesTranslated[index]);
            },
          ),
        ),
      ),
    ]);
  }

  //LANGUAGE LIST TILE
  ListTile _buildLanguageTile(BuildContext context, Locale locale, String language, String subtitle) {
    final ThemeData theme = Theme.of(context);
    return ListTile(
      title: Text(language),
      subtitle: Text(subtitle).tr(),
      selected: context.locale == locale,
      selectedTileColor: theme.colorScheme.secondary,
      onTap: () {
        context.setLocale(locale);
      },
    );
  }

  //FEEDBACK BOTTOMSHEET
  _feedbackBottomSheet(BuildContext context, AsyncValue<void> state) {
    final ThemeData theme = Theme.of(context);
    return CustomBottomSheet.show(context: context, listWidget: [
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(LocaleKeys.reportAProblem.tr()),
          const SizedBox(
            height: 20,
          ),
          TextFieldInput(
            textEditingController: _problemSummaryController,
            labelText: LocaleKeys.summary.tr(),
            textInputType: TextInputType.text,
          ),
          const SizedBox(
            height: 20,
          ),
          TextField(
            controller: _problemDetailsController,
            decoration: InputDecoration(
              border: const OutlineInputBorder(),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: theme.colorScheme.secondary),
              ),
              labelText: LocaleKeys.problemDescription.tr(),
              alignLabelWithHint: true,
            ),
            maxLines: 6,
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              OutlinedButton(
                onPressed: () => context.pop(),
                child: Text(
                  LocaleKeys.cancel.tr(),
                  style: TextStyle(color: theme.colorScheme.tertiary),
                ),
              ),
              const SizedBox(
                width: 20,
              ),
              FilledButton.tonal(
                onPressed: state.isLoading
                    ? null
                    : () async => await ref.read(postControllerProvider.notifier).uploadFeedback(_problemSummaryController.text, _problemDetailsController.text).then(
                          (value) {
                            context.pop();
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(LocaleKeys.feedbackSent.tr()),
                              ),
                            );
                          },
                        ),
                child: Text(LocaleKeys.send.tr()),
              ),
            ],
          )
        ],
      )
    ]);
  }
}
