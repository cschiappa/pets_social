import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pets_social/features/auth/controller/auth_controller.dart';
import 'package:pets_social/features/auth/screens/login_screen.dart';

class LoadingScreen extends ConsumerWidget {
  const LoadingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ThemeData theme = Theme.of(context);

    final auth = ref.watch(authStateChangeProvider);
    return auth.when(
      data: (data) => data != null ? const SizedBox() : const LoginScreen(),
      error: (error, stacktrace) => Text('error: $error'),
      loading: () => Center(
        child: CircularProgressIndicator(
          color: theme.colorScheme.secondary,
        ),
      ),
    );
  }
}
