import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pets_social/models/chat_room.dart';
import 'package:pets_social/models/message.dart';
import 'package:pets_social/core/constants/firebase_constants.dart';

import '../../../models/profile.dart';

class ChatRepository {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;
  ChatRepository({
    required FirebaseFirestore firestore,
    required FirebaseAuth auth,
  })  : _auth = auth,
        _firestore = firestore;

  //SEND MESSAGE
  Future<void> sendMessage(String receiverProfileUid, String receiverUsername, String receiverUserUid, String message, ModelProfile? profile) async {
    final Timestamp timestamp = Timestamp.now();
    final currentUser = _auth.currentUser!.uid;

    ModelChatRoom chatRoom = ModelChatRoom(
      users: [currentUser, receiverUserUid],
      profileUids: [profile!.profileUid, receiverProfileUid],
      lastMessage: null,
    );

    ModelMessage newMessage = ModelMessage(
      senderUid: profile.profileUid,
      receiverUid: receiverProfileUid,
      timestamp: timestamp,
      message: message,
      senderUsername: profile.username,
      receiverUsername: receiverUsername,
      read: false,
    );

    //CHAT ROOM ID
    List<String> ids = [profile.profileUid, receiverProfileUid];
    ids.sort();
    String chatRoomId = ids.join("_"); //COMBINE IDS

    //CREATE COLLECTION
    final batch = _firestore.batch();
    //PATH
    final String chatPath = FirestorePath.chat(chatRoomId);

    batch.set(_firestore.doc(chatPath), chatRoom.toJson());

    var messageCollection = _firestore.doc(chatPath).collection('messages').doc();

    batch.set(messageCollection, newMessage.toJson());

    await batch.commit();

    //GET LAST MESSAGE
    final lastMessageQuery = await _firestore.doc(chatPath).collection('messages').orderBy('timestamp', descending: true).get();

    //SAVE USERS AND LAST MESSAGE TO CHAT ROOM ID
    if (lastMessageQuery.docs.isNotEmpty) {
      final lastMessage = lastMessageQuery.docs.first.data();
      await _firestore.doc(chatPath).update(
        {
          "lastMessage": lastMessage,
        },
      );
    }
  }

  //GET MESSAGES
  Stream<QuerySnapshot> getMessages(String userUid, String otherUserUid) {
    List<String> ids = [userUid, otherUserUid];
    ids.sort();
    String chatRoomId = ids.join("_");
    final String chatPath = FirestorePath.chat(chatRoomId);

    return _firestore.doc(chatPath).collection('messages').orderBy('timestamp', descending: true).snapshots();
  }

  //UPDATE MESSAGE READ VALUE
  Future<void> messageRead(String profileUid, String receiverUiD) async {
    final QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('chats').where('lastMessage.receiverUid', isEqualTo: profileUid).where('lastMessage.senderUid', isEqualTo: receiverUiD).where('lastMessage.read', isEqualTo: false).get();

    if (querySnapshot.docs.isNotEmpty) {
      await querySnapshot.docs.first.reference.update({
        'lastMessage': {
          ...querySnapshot.docs.first['lastMessage'],
          'read': true,
        },
      });
    }
  }

  //CHECK UNREAD MESSAGES
  Stream<List<Map<String, dynamic>>> getLastMessage(String receiverUid, String senderUid) {
    final Query<Map<String, dynamic>> query = FirebaseFirestore.instance.collection('chats').where('lastMessage.receiverUid', isEqualTo: receiverUid).where('lastMessage.senderUid', isEqualTo: senderUid);

    return query.snapshots().map((querySnapshot) {
      return querySnapshot.docs.map((doc) => doc['lastMessage'] as Map<String, dynamic>).toList();
    });
  }

  //GET NUMBER OF CHATS
  Stream<int> numberOfUnreadChats(String profileUid) {
    final Query<Map<String, dynamic>> query = FirebaseFirestore.instance.collection('chats').where('lastMessage.receiverUid', isEqualTo: profileUid).where('lastMessage.read', isEqualTo: false);

    return query.snapshots().map((querySnapshot) {
      return querySnapshot.docs.length;
    });
  }

  //GET CHAT LIST
  Future<List<DocumentSnapshot>> getChatsList(ModelProfile? profile) async {
    QuerySnapshot<Map<String, dynamic>> snapshot = await _firestore.collection('chats').orderBy('lastMessage.timestamp', descending: true).where('profileUids', arrayContains: profile!.profileUid).get();

    List<String> profileUidList = [];

    for (var doc in snapshot.docs) {
      List<dynamic> profileUids = doc['profileUids'];

      for (var profileUid in profileUids) {
        if (profileUid != profile.profileUid) {
          profileUidList.add(profileUid);
        }
      }
    }

    List<Future<DocumentSnapshot>> futures = profileUidList.map(
      (profileUid) {
        return _firestore.collectionGroup('profiles').where('profileUid', isEqualTo: profileUid).get().then((querySnapshot) => querySnapshot.docs.first);
      },
    ).toList();

    return await Future.wait(futures);
  }
}
