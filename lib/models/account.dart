import 'package:cloud_firestore/cloud_firestore.dart';

class ModelAccount {
  final String email;
  final String uid;
  final int lizzyCoins;
  final List tags;
  final List preferedTags;
  final List blockedTags;
  final List savedPosts;

  const ModelAccount({
    required this.email,
    required this.uid,
    required this.lizzyCoins,
    required this.tags,
    required this.preferedTags,
    required this.blockedTags,
    required this.savedPosts,
  });

  ModelAccount copyWith({
    String? email,
    String? uid,
    int? lizzyCoins,
    List? tags,
    List? preferedTags,
    List? blockedTags,
    List? savedPosts,
  }) {
    return ModelAccount(
      email: email ?? this.email,
      uid: uid ?? this.uid,
      lizzyCoins: lizzyCoins ?? this.lizzyCoins,
      tags: tags ?? this.tags,
      preferedTags: preferedTags ?? this.preferedTags,
      blockedTags: blockedTags ?? this.blockedTags,
      savedPosts: savedPosts ?? this.savedPosts,
    );
  }

  Map<String, dynamic> toJson() => {
        "email": email,
        "uid": uid,
        "lizzyCoins": lizzyCoins,
        "tags": tags,
        "preferedTags": preferedTags,
        "blockedTags": blockedTags,
        "savedPosts": savedPosts,
      };

  static ModelAccount fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return ModelAccount(
      email: snapshot['email'],
      uid: snapshot['uid'],
      lizzyCoins: snapshot['lizzyCoins'],
      tags: snapshot['tags'] ?? [],
      preferedTags: snapshot['preferedTags'] ?? [],
      blockedTags: snapshot['blockedTags'] ?? [],
      savedPosts: snapshot['savedPosts'] ?? [],
    );
  }
}
