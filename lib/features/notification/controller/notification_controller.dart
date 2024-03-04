import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pets_social/core/providers/firebase_providers.dart';
import 'package:pets_social/features/notification/repository/notification_repository.dart';
import 'package:pets_social/router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'notification_controller.g.dart';

//NOTIFICATION REPOSITORY PROVIDER
@Riverpod(keepAlive: true)
NotificationRepository notificationRepository(NotificationRepositoryRef ref) {
  return NotificationRepository(
    firestore: ref.watch(firestoreProvider),
    auth: ref.read(authProvider),
    messaging: ref.read(messagingProvider),
    router: ref.watch(goRouterProvider),
  );
}

//GET NOTIFICATIONS
@riverpod
Stream<List<DocumentSnapshot>> getNotifications(GetNotificationsRef ref, String profileUid) {
  final repository = ref.watch(notificationRepositoryProvider);
  return repository.getNotifications(profileUid);
}
