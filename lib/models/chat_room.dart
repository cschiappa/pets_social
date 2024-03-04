import 'package:cloud_firestore/cloud_firestore.dart';

class ModelChatRoom {
  final List<String> users;
  final List<String> profileUids;
  final Map? lastMessage;

  const ModelChatRoom({
    required this.users,
    required this.profileUids,
    this.lastMessage,
  });

  Map<String, dynamic> toJson() => {
        "users": users,
        "profileUids": profileUids,
        "lastMessage": lastMessage,
      };

  static ModelChatRoom fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return ModelChatRoom(
      users: snapshot['users'],
      profileUids: snapshot['profileUids'],
      lastMessage: snapshot['lastMessage'],
    );
  }
}
