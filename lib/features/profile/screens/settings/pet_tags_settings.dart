import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pets_social/core/utils/extensions.dart';
import 'package:pets_social/core/utils/language.g.dart';
import 'package:pets_social/core/utils/utils.dart';
import 'package:pets_social/core/widgets/button.dart';
import 'package:pets_social/features/tag/controller/tag_controller.dart';
import 'package:pets_social/features/tag/widgets/tag_textfield.dart';
import 'package:pets_social/responsive/responsive_layout_screen.dart';

class PetTagsSettings extends ConsumerStatefulWidget {
  const PetTagsSettings({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _PetTagsSettingsState();
}

class _PetTagsSettingsState extends ConsumerState<ConsumerStatefulWidget> {
  @override
  Widget build(BuildContext context) {
    final petTags = ref.watch(getPetTagsCollectionProvider);
    final ThemeData theme = Theme.of(context);

    final preferedTags = ref.watch(selectedTagsProvider('preferedTags'));
    final blockedTags = ref.watch(selectedTagsProvider('blockedTags'));

    ref.listen<AsyncValue>(
      tagControllerProvider,
      (_, state) => state.showSnackbarOnError(context),
    );

    final AsyncValue<void> state = ref.watch(tagControllerProvider);

    return petTags.when(
      error: (error, stackTrace) => Text('Error: $error'),
      loading: () => Center(
        child: CircularProgressIndicator(
          color: theme.colorScheme.secondary,
        ),
      ),
      data: (petTags) {
        return Scaffold(
          appBar: AppBar(
            title: Text(LocaleKeys.petTagSettings.tr()),
          ),
          body: Container(
            padding: ResponsiveLayout.isWeb(context) ? EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width / 3) : const EdgeInsets.symmetric(horizontal: 25),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //SELECT PREFERED PETS TAGS
                  Text(LocaleKeys.preferedPetsQuestion.tr(), style: theme.textTheme.titleMedium),
                  const SizedBox(
                    height: 10,
                  ),
                  TagTextField(
                    selectedTagsProvider: selectedTagsProvider('preferedTags'),
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  //SELECT BLOCKED PETS TAGS
                  Text(LocaleKeys.blockedPetsQuestion.tr(), style: theme.textTheme.titleMedium),
                  const SizedBox(
                    height: 10,
                  ),
                  TagTextField(
                    selectedTagsProvider: selectedTagsProvider('blockedTags'),
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  //SIGN IN BUTTON
                  InkWell(
                    onTap: state.isLoading
                        ? null
                        : () async {
                            ref.read(tagControllerProvider.notifier).updateTags('preferedTags', preferedTags);
                            ref.read(tagControllerProvider.notifier).updateTags('blockedTags', blockedTags).then((value) => showSnackBar(LocaleKeys.tagsUpdatedSuccessfully.tr(), context));
                          },
                    child: Button(
                      state: state,
                      text: LocaleKeys.save.tr(),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
