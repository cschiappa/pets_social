import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pets_social/core/utils/extensions.dart';
import 'package:pets_social/core/utils/language.g.dart';
import 'package:pets_social/core/utils/validators.dart';
import 'package:pets_social/core/widgets/button.dart';
import 'package:pets_social/features/auth/controller/auth_controller.dart';
import 'package:pets_social/router.dart';
import 'package:pets_social/responsive/responsive_layout_screen.dart';

import 'package:pets_social/core/widgets/text_field_input.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<ConsumerStatefulWidget> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<AsyncValue>(
      authControllerProvider,
      (_, state) => state.showSnackbarOnError(context),
    );
    final AsyncValue<void> state = ref.watch(authControllerProvider);

    final ThemeData theme = Theme.of(context);
    return Scaffold(
      body: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: SafeArea(
          child: Container(
            padding: ResponsiveLayout.isWeb(context) ? EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width / 3) : const EdgeInsets.symmetric(horizontal: 32),
            width: double.infinity,
            child: Center(
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Flexible(flex: 2, fit: FlexFit.loose, child: Container()),
                      //LOGO
                      Image.asset(
                        'assets/images/logo.png',
                        color: theme.colorScheme.primary,
                        scale: 3,
                      ),
                      const SizedBox(height: 40),

                      //EMAIL
                      TextFieldInput(
                        labelText: LocaleKeys.email.tr(),
                        textInputType: TextInputType.emailAddress,
                        textEditingController: _emailController,
                        validator: emptyField,
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
                        validator: emptyField,
                        suffixIcon: true,
                      ),

                      InkWell(
                        onTap: () => context.pushNamed(AppRouter.recoverPassword.name),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            vertical: 15,
                          ),
                          child: Text(
                            LocaleKeys.forgotPassword.tr(),
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),

                      //LOGIN BUTTON
                      InkWell(
                        onTap: state.isLoading
                            ? null
                            : () async {
                                if (_formKey.currentState!.validate()) {
                                  await ref.read(authControllerProvider.notifier).logIn(_emailController.text, _passwordController.text);
                                }
                              },
                        child: Button(
                          state: state,
                          text: LocaleKeys.logIn.tr(),
                        ),
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              vertical: 8,
                            ),
                            child: Text(LocaleKeys.dontHaveAccount.tr()),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          InkWell(
                            onTap: () => context.goNamed(AppRouter.welcomePage.name),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                vertical: 8,
                              ),
                              child: Text(
                                LocaleKeys.signUp.tr(),
                                style: const TextStyle(fontWeight: FontWeight.bold),
                              ),
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
      ),
    );
  }
}
