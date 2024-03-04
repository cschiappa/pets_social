import 'package:easy_localization/easy_localization.dart';

import 'package:flutter/material.dart';
import 'package:pets_social/core/providers/firebase_providers.dart';
import 'package:pets_social/features/auth/screens/initial_loading.dart';
import 'package:pets_social/features/notification/controller/notification_controller.dart';
import 'package:pets_social/router.dart';
import 'package:pets_social/theme/theme_provider.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    ProviderScope(
      child: AppStartupWidget(
        onLoaded: (context) => const MyApp(),
      ),
    ),
  );
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      bool? notification = prefs.getBool('notification');
      final notificationRepository = ref.read(notificationRepositoryProvider);
      final auth = ref.watch(authProvider);

      if (notification == null) {
        prefs.setBool('notification', true);
        notification = true;
      }

      if (auth.currentUser != null && notification == true) {
        await notificationRepository.initNotifications();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var themeData = ref.watch(themeProvider).themeData;
    final router = ref.watch(goRouterProvider);

    return MaterialApp.router(
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      routerConfig: router,
      debugShowCheckedModeBanner: false,
      title: 'Pet Social',
      theme: themeData,
    );
  }
}
