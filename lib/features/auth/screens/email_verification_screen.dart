import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pets_social/core/providers/firebase_providers.dart';
import 'package:pets_social/core/utils/extensions.dart';
import 'package:pets_social/core/utils/language.g.dart';
import 'package:pets_social/core/widgets/button.dart';
import 'package:pets_social/features/auth/controller/auth_controller.dart';
import 'package:pets_social/responsive/responsive_layout_screen.dart';
import 'package:pets_social/router.dart';

class EmailVerificationScreen extends ConsumerStatefulWidget {
  final String? email;
  const EmailVerificationScreen({super.key, this.email});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _EmailVerificationScreenState();
}

class _EmailVerificationScreenState extends ConsumerState<EmailVerificationScreen> {
  bool isEmailVerified = false;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    final user = ref.read(authProvider);
    timer = Timer.periodic(const Duration(seconds: 2), (_) {
      user.currentUser?.reload();
      ref.read(isEmailVerifiedProvider);

      if (user.currentUser?.emailVerified == true) {
        ref.invalidate(isEmailVerifiedProvider);
        ref.read(isEmailVerifiedProvider);
        timer?.cancel();
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    timer?.cancel;
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(isEmailVerifiedProvider);
    ref.listen<AsyncValue>(
      authControllerProvider,
      (_, state) => state.showSnackbarOnError(context),
    );
    final AsyncValue<void> state = ref.watch(authControllerProvider);

    return Scaffold(
      body: Container(
        padding: ResponsiveLayout.isWeb(context) ? EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width / 3) : const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(LocaleKeys.verifyEmail.tr(), style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, fontFamily: 'Lemon')),
            const SizedBox(
              height: 50,
            ),
            Text(
              LocaleKeys.reachedLastStep.tr(),
            ),
            const SizedBox(
              height: 50,
            ),
            Text(
              LocaleKeys.weSentYouVerificationLink.tr(),
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Text(
              LocaleKeys.checkYourInbox.tr(),
              textAlign: TextAlign.center,
            ),
            Text(
              LocaleKeys.checkYourSpamFolder.tr(),
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 50,
            ),
            Text(LocaleKeys.tryAgainLinkText.tr()),
            const SizedBox(
              height: 15,
            ),
            InkWell(
              onTap: () => ref.read(authControllerProvider.notifier).sendEmailVerification(),
              child: Button(state: state, text: LocaleKeys.resendLink.tr()),
            ),
            const SizedBox(
              height: 30,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(LocaleKeys.somethingWrongBackToLogin.tr()),
                InkWell(
                  onTap: () async {
                    await ref.read(authControllerProvider.notifier).signOut().then((value) => context.goNamed(AppRouter.login.name));
                  },
                  child: Text(
                    LocaleKeys.logIn.tr(),
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
