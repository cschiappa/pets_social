import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pets_social/core/constants/constants.dart';
import 'package:pets_social/features/auth/controller/auth_controller.dart';

class AppStartupWidget extends ConsumerWidget {
  const AppStartupWidget({super.key, required this.onLoaded});
  final WidgetBuilder onLoaded;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appStartupState = ref.watch(appStartupProvider);
    return appStartupState.when(
      data: (_) => EasyLocalization(
        supportedLocales: supportedLocales,
        path: 'assets/l10n',
        fallbackLocale: const Locale('en', 'GB'),
        child: onLoaded(context),
      ),
      loading: () => const InitialLoading(),
      error: (e, st) => InitialError(
        message: e.toString(),
        onRetry: () => ref.invalidate(appStartupProvider),
      ),
    );
  }
}

class InitialLoading extends StatelessWidget {
  const InitialLoading({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: CircularProgressIndicator(color: theme.colorScheme.secondary),
        ),
      ),
    );
  }
}

class InitialError extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;
  const InitialError({super.key, required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(message, style: Theme.of(context).textTheme.headlineSmall),
              //gapH16,
              ElevatedButton(
                onPressed: onRetry,
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
