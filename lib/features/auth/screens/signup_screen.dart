import 'dart:typed_data';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pets_social/core/utils/extensions.dart';
import 'package:pets_social/core/utils/language.g.dart';
import 'package:pets_social/core/utils/validators.dart';
import 'package:pets_social/core/widgets/button.dart';
import 'package:pets_social/core/widgets/text_field_input.dart';
import 'package:pets_social/features/auth/controller/auth_controller.dart';
import 'package:pets_social/features/profile/controller/profile_controller.dart';
import 'package:pets_social/features/tag/controller/tag_controller.dart';
import 'package:pets_social/features/tag/widgets/tag_textfield.dart';
import 'package:pets_social/router.dart';
import 'package:pets_social/responsive/responsive_layout_screen.dart';
import 'package:pets_social/core/utils/utils.dart';

class SignupScreen extends ConsumerStatefulWidget {
  const SignupScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SignupScreenState();
}

class _SignupScreenState extends ConsumerState<ConsumerStatefulWidget> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();

  Uint8List? _image;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _bioController.dispose();
    _usernameController.dispose();
    super.dispose();
  }

  //SELECT IMAGE
  void selectImage() async {
    Uint8List im;
    (im, _, _, _) = await pickImage(ImageSource.gallery);
    setState(() {
      _image = im;
    });
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    ref.listen<AsyncValue>(
      authControllerProvider,
      (_, state) => state.showSnackbarOnError(context),
    );
    final AsyncValue<void> state = ref.watch(authControllerProvider);
    return Scaffold(
      body: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Container(
          padding: ResponsiveLayout.isWeb(context) ? EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width / 3) : const EdgeInsets.symmetric(horizontal: 32),
          child: Center(
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    //LOGO
                    Padding(
                      padding: const EdgeInsets.only(top: 60.0),
                      child: Image.asset(
                        'assets/images/logo.png',
                        color: theme.colorScheme.primary,
                        scale: 3,
                      ),
                    ),
                    const SizedBox(height: 40),
                    //SELECT IMAGE
                    Stack(
                      children: [
                        _image != null
                            ? CircleAvatar(
                                radius: 45,
                                backgroundImage: MemoryImage(_image!),
                              )
                            : const CircleAvatar(
                                radius: 45,
                                backgroundImage: NetworkImage(
                                  'https://i.pinimg.com/474x/eb/bb/b4/ebbbb41de744b5ee43107b25bd27c753.jpg',
                                )),
                        Positioned(
                          bottom: -5,
                          left: 50,
                          child: IconButton(
                            onPressed: selectImage,
                            icon: const Icon(
                              Icons.add_a_photo,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                    //USERNAME
                    TextFieldInput(
                      labelText: LocaleKeys.username.tr(),
                      textCapitalization: TextCapitalization.words,
                      inputFormatters: [UpperCaseTextFormatter(), NoSpaceFormatter()],
                      textInputType: TextInputType.text,
                      textEditingController: _usernameController,
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
                      height: 24,
                    ),
                    //EMAIL
                    TextFieldInput(
                      labelText: LocaleKeys.email.tr(),
                      textInputType: TextInputType.emailAddress,
                      textEditingController: _emailController,
                      validator: (value) {
                        final isAvailable = ref.watch(isEmailAvailableProvider(value));
                        if (isAvailable.value == false) {
                          return LocaleKeys.emailNotAvailable.tr();
                        }
                        String? validate = emailValidator(value);
                        if (validate != null) {
                          return validate;
                        }

                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                    //PASSWORD
                    TextFieldInput(
                      labelText: LocaleKeys.password.tr(),
                      textInputType: TextInputType.text,
                      textEditingController: _passwordController,
                      isPass: true,
                      validator: passwordValidator,
                      suffixIcon: true,
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                    //BIO
                    TextFieldInput(
                      labelText: LocaleKeys.bio.tr(),
                      textInputType: TextInputType.text,
                      textEditingController: _bioController,
                      validator: bioValidator,
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                    //SIGN IN BUTTON
                    InkWell(
                      onTap: state.isLoading
                          ? null
                          : () {
                              if (_formKey.currentState!.validate()) {
                                ref.read(temporaryUserDataProvider.notifier).update((state) => TemporaryUserData(
                                      email: _emailController.text,
                                      username: _usernameController.text,
                                      password: _passwordController.text,
                                      bio: _bioController.text,
                                      image: _image,
                                    ));
                                context.pushNamed(AppRouter.signupTwo.name);
                              }
                            },
                      child: Button(
                        state: state,
                        text: LocaleKeys.next.tr(),
                      ),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(LocaleKeys.alreadyHaveAccount.tr()),
                        const SizedBox(
                          width: 5,
                        ),
                        GestureDetector(
                          onTap: () => context.goNamed(AppRouter.login.name),
                          child: Text(
                            LocaleKeys.logIn.tr(),
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class SignupScreenTwo extends ConsumerStatefulWidget {
  const SignupScreenTwo({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SignupScreenTwoState();
}

class _SignupScreenTwoState extends ConsumerState<ConsumerStatefulWidget> {
  final GlobalKey<FormState> formKeyTwo = GlobalKey();

  @override
  Widget build(BuildContext context) {
    final temporaryData = ref.watch(temporaryUserDataProvider);
    final petTags = ref.watch(getPetTagsCollectionProvider);
    final ThemeData theme = Theme.of(context);

    final selectedPetTag = ref.watch(selectedTagsProvider('petTag'));
    final selectedPreferedPetTags = ref.watch(selectedTagsProvider('preferedTags'));
    final selectedBlockedPetTags = ref.watch(selectedTagsProvider('blockedTags'));

    ref.listen<AsyncValue>(
      authControllerProvider,
      (_, state) => state.showSnackbarOnError(context),
    );

    final AsyncValue<void> state = ref.watch(authControllerProvider);

    return petTags.when(
      error: (error, stackTrace) => Text('Error: $error'),
      loading: () => Center(
        child: CircularProgressIndicator(
          color: theme.colorScheme.secondary,
        ),
      ),
      data: (petTags) {
        return Scaffold(
          appBar: AppBar(),
          body: Container(
            padding: ResponsiveLayout.isWeb(context) ? EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width / 3) : const EdgeInsets.symmetric(horizontal: 25),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //TITLE
                  Text(
                    LocaleKeys.choosePreferences.tr(),
                    style: theme.textTheme.headlineLarge,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(LocaleKeys.quickQuestions.tr(), style: theme.textTheme.titleMedium),
                  const SizedBox(
                    height: 40,
                  ),
                  //SELECT PROFILE PET TAG
                  Text(LocaleKeys.petTagQuestion.tr(), style: theme.textTheme.titleMedium),
                  const SizedBox(
                    height: 10,
                  ),
                  TagTextField(
                    tag: 'petTag',
                    helper: LocaleKeys.chooseOnlyOneTag.tr(),
                    formKeyTwo: formKeyTwo,
                    validator: (value) {
                      final bool isLocked = ref.watch(selectedTagsProvider('petTag')).length == 1;
                      if (isLocked == false) {
                        return LocaleKeys.pleaseChooseOnePetTag.tr();
                      }

                      String? validate = emptyField(value);
                      if (validate != null) {
                        return validate;
                      }

                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  //SELECT PREFERED PETS TAGS
                  Text(LocaleKeys.preferedPetsQuestion.tr(), style: theme.textTheme.titleMedium),
                  const SizedBox(
                    height: 10,
                  ),
                  TagTextField(
                    tag: 'preferedTags',
                    helper: LocaleKeys.canChangeLater.tr(),
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
                    tag: 'blockedTags',
                    helper: LocaleKeys.canChangeLater.tr(),
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  //SIGN IN BUTTON
                  InkWell(
                    onTap: state.isLoading
                        ? null
                        : () async {
                            if (formKeyTwo.currentState!.validate()) {
                              await ref.read(authControllerProvider.notifier).signUp(
                                    email: temporaryData.email,
                                    password: temporaryData.password,
                                    username: temporaryData.username,
                                    petTag: selectedPetTag,
                                    preferedTags: selectedPreferedPetTags,
                                    blockedTags: selectedBlockedPetTags,
                                    bio: temporaryData.bio,
                                    file: temporaryData.image,
                                  );
                            }
                          },
                    child: Button(
                      state: state,
                      text: LocaleKeys.signUp.tr(),
                    ),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(LocaleKeys.alreadyHaveAccount.tr()),
                      const SizedBox(
                        width: 5,
                      ),
                      GestureDetector(
                        onTap: () => context.goNamed(AppRouter.login.name),
                        child: Text(
                          LocaleKeys.logIn.tr(),
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
