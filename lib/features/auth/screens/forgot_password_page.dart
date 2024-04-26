import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pets_social/core/utils/extensions.dart';
import 'package:pets_social/core/utils/language.g.dart';
import 'package:pets_social/core/utils/utils.dart';
import 'package:pets_social/core/utils/validators.dart';
import 'package:pets_social/core/widgets/button.dart';
import 'package:pets_social/features/auth/controller/auth_controller.dart';
import 'package:pets_social/responsive/responsive_layout_screen.dart';
import 'package:pets_social/core/widgets/text_field_input.dart';

class ForgotPasswordPage extends ConsumerStatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends ConsumerState<ForgotPasswordPage> {
  final TextEditingController _emailController = TextEditingController();
  //final bool _isLoading = false;
  final GlobalKey<FormState> _formKeySendEmailLink = GlobalKey();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
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
      appBar: AppBar(
        backgroundColor: theme.appBarTheme.backgroundColor,
      ),
      body: Padding(
        padding: ResponsiveLayout.isWeb(context) ? EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width / 3) : const EdgeInsets.symmetric(horizontal: 32),
        child: Form(
          key: _formKeySendEmailLink,
          child: Column(
            children: [
              Text(LocaleKeys.resetLink.tr()),
              const SizedBox(
                height: 24,
              ),
              //email textfield
              TextFieldInput(
                textEditingController: _emailController,
                labelText: LocaleKeys.email.tr(),
                textInputType: TextInputType.emailAddress,
                validator: emptyField,
              ),
              const SizedBox(
                height: 24,
              ),
              //SEND BUTTON
              InkWell(
                onTap: state.isLoading
                    ? null
                    : () async {
                        if (_formKeySendEmailLink.currentState!.validate()) {
                          await ref.read(authControllerProvider.notifier).passwordLinkToEmail(_emailController.text.trim()).then((value) => showSnackBar(LocaleKeys.ifEmailExistsResetLink.tr(), context));
                        }
                      },
                child: Button(
                  state: state,
                  text: LocaleKeys.send.tr(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
