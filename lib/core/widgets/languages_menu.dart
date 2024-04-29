import 'package:country_flags/country_flags.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flag/flag_widget.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pets_social/core/constants/constants.dart';
import 'package:pets_social/core/widgets/bottom_sheet.dart';

class LanguagesMenuSheet {
  void show({
    required BuildContext context,
  }) {
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
      leading: Flag.fromString(
        locale.countryCode ?? '',
        height: 18,
        width: 32,
        borderRadius: 8,
      ),
      title: Text(language),
      subtitle: Text(subtitle).tr(),
      selected: context.locale == locale,
      selectedTileColor: theme.colorScheme.secondary,
      onTap: () {
        context.pop();
        context.setLocale(locale);
      },
    );
  }
}
