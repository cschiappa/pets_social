import 'package:cloud_firestore/cloud_firestore.dart';

class ModelComment {
  final String commentId;
  final String profileUid;
  final String uid;
  final String text;
  final DateTime datePublished;
  final String postId;
  final String username;
  final String photoUrl;
  final List likes;

  const ModelComment({
    required this.commentId,
    required this.profileUid,
    required this.uid,
    required this.text,
    required this.datePublished,
    required this.postId,
    required this.username,
    required this.photoUrl,
    required this.likes,
  });

  Map<String, dynamic> toJson() => {
        "commentId": commentId,
        "profileUid": profileUid,
        "uid": uid,
        "text": text,
        "datePublished": datePublished,
        "postId": postId,
        "username": username,
        "photoUrl": photoUrl,
        "likes": likes,
      };

  static ModelComment fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return ModelComment(
      commentId: snapshot['commentId'],
      profileUid: snapshot['profileUid'],
      uid: snapshot['uid'],
      text: snapshot['text'],
      datePublished: snapshot['datePublished'].toDate(),
      postId: snapshot['postId'],
      username: snapshot['username'],
      photoUrl: snapshot['photoUrl'],
      likes: snapshot['likes'],
    );
  }
}
