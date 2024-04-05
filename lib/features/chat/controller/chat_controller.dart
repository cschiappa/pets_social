import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pets_social/core/providers/firebase_providers.dart';
import 'package:pets_social/features/profile/controller/profile_controller.dart';
import 'package:pets_social/models/profile.dart';
import 'package:pets_social/features/chat/repository/chat_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'chat_controller.g.dart';

@Riverpod(keepAlive: true)
ChatRepository chatRepository(ChatRepositoryRef ref) {
  return ChatRepository(
    firestore: ref.read(firestoreProvider),
    auth: ref.read(authProvider),
  );
}

//NUMBER OF UNREAD MESSAGES
@riverpod
Stream<int> numberOfUnreadChats(NumberOfUnreadChatsRef ref) {
  final profile = ref.watch(userProvider)!;
  final repository = ref.watch(chatRepositoryProvider);
  return repository.numberOfUnreadChats(profile.profileUid);
}

//GET CHAT LIST
@riverpod
Future<List<DocumentSnapshot>> getChatsList(GetChatsListRef ref) {
  final profile = ref.watch(userProvider)!;
  final repository = ref.watch(chatRepositoryProvider);
  return repository.getChatsList(profile);
}

//GET MESSAGES
@riverpod
Stream<QuerySnapshot> getMessages(GetMessagesRef ref, String userUid, String otherUserUid) {
  final repository = ref.watch(chatRepositoryProvider);
  return repository.getMessages(userUid, otherUserUid);
}

//UPDATE MESSAGE READ VALUE
@riverpod
Future<void> messageRead(MessageReadRef ref, String profileUid, String receiverUid) {
  final repository = ref.watch(chatRepositoryProvider);
  return repository.messageRead(profileUid, receiverUid);
}

//CHECK UNREAD MESSAGES
@riverpod
Stream<List<Map<String, dynamic>>> getLastMessage(GetLastMessageRef ref, String receiverUid, String senderUid) {
  final repository = ref.watch(chatRepositoryProvider);
  return repository.getLastMessage(receiverUid, senderUid);
}

//CHAT CONTROLLER
@riverpod
class ChatController extends _$ChatController {
  @override
  FutureOr<void> build() async {}

  Future<void> sendMessage(String receiverProfileUid, String receiverUsername, String receiverUserUid, String message, ModelProfile? profile) async {
    final chatRepository = ref.watch(chatRepositoryProvider);
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => chatRepository.sendMessage(receiverProfileUid, receiverUsername, receiverUserUid, message, profile));
  }
}
