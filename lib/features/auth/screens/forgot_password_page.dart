import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pets_social/core/utils/language.g.dart';
import 'package:pets_social/responsive/responsive_layout_screen.dart';
import 'package:pets_social/core/widgets/text_field_input.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final TextEditingController _emailController = TextEditingController();
  final bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  //PASSWORD RESET TO EMAIL
  Future passwordLinkToEmail() async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: _emailController.text.trim());
      if (!mounted) return;
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              content: Text(LocaleKeys.ifEmailExistsResetLink.tr()),
            );
          });
    } on FirebaseAuthException catch (e) {
      debugPrint(e.toString());
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Text(LocaleKeys.ifEmailExistsResetLink.tr()),
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.appBarTheme.backgroundColor,
      ),
      body: Padding(
        padding: ResponsiveLayout.isWeb(context) ? EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width / 3) : const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          children: [
            Text(LocaleKeys.resetLink.tr()),
            const SizedBox(
              height: 24,
            ),
            //email textfield
            TextFieldInput(textEditingController: _emailController, labelText: LocaleKeys.email.tr(), textInputType: TextInputType.emailAddress),
            const SizedBox(
              height: 24,
            ),
            //SEND BUTTON
            InkWell(
              onTap: () {
                passwordLinkToEmail();
                _emailController.clear();
              },
              child: Container(
                width: double.infinity,
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: ShapeDecoration(
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(4)),
                  ),
                  color: theme.colorScheme.secondary,
                ),
                child: _isLoading
                    ? Center(
                        child: CircularProgressIndicator(
                          color: theme.colorScheme.primary,
                        ),
                      )
                    : Text(LocaleKeys.send.tr()),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
