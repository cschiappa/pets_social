import 'package:cloud_firestore/cloud_firestore.dart';

class ModelProfile {
  final String email;
  final String uid;
  final String profileUid;
  final String? photoUrl;
  final String username;
  final List petTag;
  final String? bio;
  final List followers;
  final List following;
  final List blockedUsers;

  const ModelProfile({
    required this.email,
    required this.uid,
    required this.profileUid,
    this.photoUrl,
    required this.username,
    required this.petTag,
    this.bio,
    required this.followers,
    required this.following,
    required this.blockedUsers,
  });

  ModelProfile copyWith({
    String? email,
    String? uid,
    String? profileUid,
    String? photoUrl,
    String? username,
    List? petTag,
    String? bio,
    List? followers,
    List? following,
    List? blockedUsers,
  }) {
    return ModelProfile(
      email: email ?? this.email,
      uid: uid ?? this.uid,
      profileUid: profileUid ?? this.profileUid,
      photoUrl: photoUrl ?? this.photoUrl,
      username: username ?? this.username,
      petTag: petTag ?? this.petTag,
      bio: bio ?? this.bio,
      followers: followers ?? this.followers,
      following: following ?? this.following,
      blockedUsers: blockedUsers ?? this.blockedUsers,
    );
  }

  Map<String, dynamic> toJson() => {
        "username": username,
        "uid": uid,
        "profileUid": profileUid,
        "email": email,
        "photoUrl": photoUrl ?? 'https://i.pinimg.com/474x/eb/bb/b4/ebbbb41de744b5ee43107b25bd27c753.jpg',
        "petTag": petTag,
        "bio": bio ?? "",
        "followers": followers,
        "following": following,
        "blockedUsers": blockedUsers,
      };

  static ModelProfile fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return ModelProfile(
      username: snapshot['username'],
      uid: snapshot['uid'],
      profileUid: snapshot['profileUid'],
      email: snapshot['email'],
      photoUrl: snapshot['photoUrl'],
      petTag: snapshot['petTag'],
      bio: snapshot['bio'],
      followers: snapshot['followers'] ?? [],
      following: snapshot['following'] ?? [],
      blockedUsers: snapshot['blockedUsers'] ?? [],
    );
  }
}
