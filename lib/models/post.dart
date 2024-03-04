import 'package:cloud_firestore/cloud_firestore.dart';

class ModelPost {
  final String uid;
  final String? description;
  final String profileUid;
  final String postId;
  final DateTime datePublished;
  final String postUrl;
  final String fileType;
  final String videoThumbnail;

  ModelPost({
    required this.uid,
    this.description,
    required this.profileUid,
    required this.postId,
    required this.datePublished,
    required this.postUrl,
    required this.fileType,
    required this.videoThumbnail,
  });

  ModelPost copyWith({
    String? uid,
    String? description,
    String? profileUid,
    String? postId,
    DateTime? datePublished,
    String? postUrl,
    String? fileType,
    String? videoThumbnail,
  }) {
    return ModelPost(
      uid: uid ?? this.uid,
      description: description ?? this.description,
      profileUid: profileUid ?? this.profileUid,
      postId: postId ?? this.postId,
      datePublished: datePublished ?? this.datePublished,
      postUrl: postUrl ?? this.postUrl,
      fileType: fileType ?? this.fileType,
      videoThumbnail: videoThumbnail ?? this.videoThumbnail,
    );
  }

  Map<String, dynamic> toJson() => {
        "uid": uid,
        "description": description ?? "",
        "profileUid": profileUid,
        "postId": postId,
        "datePublished": datePublished,
        "postUrl": postUrl,
        "fileType": fileType,
        "videoThumbnail": videoThumbnail,
      };

  static ModelPost fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return ModelPost(
      uid: snapshot['uid'],
      description: snapshot['description'],
      profileUid: snapshot['profileUid'],
      postId: snapshot['postId'],
      datePublished: snapshot['datePublished'].toDate(),
      postUrl: snapshot['postUrl'],
      fileType: snapshot['fileType'],
      videoThumbnail: snapshot['videoThumbnail'],
    );
  }
}
