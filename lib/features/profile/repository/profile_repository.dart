import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:pets_social/core/constants/firebase_constants.dart';
import 'package:pets_social/core/providers/storage_methods.dart';
import 'package:pets_social/features/notification/repository/notification_repository.dart';
import 'package:pets_social/models/profile.dart';
import 'package:uuid/uuid.dart';

class ProfileRepository {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;
  final StorageRepository _storageRepository;
  final NotificationRepository _notificationRepository;
  ProfileRepository({
    required FirebaseFirestore firestore,
    required FirebaseAuth auth,
    required StorageRepository storageRepository,
    required NotificationRepository notificationRepository,
  })  : _firestore = firestore,
        _auth = auth,
        _storageRepository = storageRepository,
        _notificationRepository = notificationRepository;

  //GET PROFILE DETAILS
  Future<ModelProfile> getProfileDetails(String? profileUid) async {
    User currentUser = _auth.currentUser!;
    DocumentSnapshot snap;

    if (profileUid != null) {
      final String profilePath = FirestorePath.profile(currentUser.uid, profileUid);
      snap = await _firestore.doc(profilePath).get();
    } else {
      final String userPath = FirestorePath.user(currentUser.uid);
      QuerySnapshot querySnapshot = await _firestore.doc(userPath).collection('profiles').limit(1).get();

      if (querySnapshot.docs.isNotEmpty) {
        snap = querySnapshot.docs.first;
      } else {
        throw Exception('No profiles found.');
      }
    }
    return ModelProfile.fromSnap(snap);
  }

  // GET PROFILE DATA
  Stream<ModelProfile> getProfileData(String profileUid) {
    return _firestore.collectionGroup('profiles').where('profileUid', isEqualTo: profileUid).snapshots().map((querySnapshot) {
      return ModelProfile.fromSnap(querySnapshot.docs.first);
    });
  }

  //GET PROFILES FROM CURRENT USER
  Stream<QuerySnapshot<Map<String, dynamic>>> getAccountProfiles() {
    final String userPath = FirestorePath.user(_auth.currentUser!.uid);
    return _firestore.doc(userPath).collection('profiles').snapshots();
  }

  //GET PROFILE FROM POST
  Future<ModelProfile> getProfileFromPost(String profileUid) async {
    QuerySnapshot querySnapshot = await _firestore.collectionGroup('profiles').where('profileUid', isEqualTo: profileUid).get();

    return ModelProfile.fromSnap(querySnapshot.docs.first);
  }

  //FOLLOW AND UNFOLLOW USER
  Future<void> followProfile(String profileUid, String followId) async {
    final String profilePath = FirestorePath.profile(_auth.currentUser!.uid, profileUid);

    DocumentSnapshot snap = await _firestore.doc(profilePath).get();
    List following = (snap.data()! as dynamic)['following'];

    if (following.contains(followId)) {
      final profileSnap = await _firestore.collectionGroup('profiles').where('profileUid', isEqualTo: followId).get();
      DocumentSnapshot profileDoc = profileSnap.docs.first;
      profileDoc.reference.update({
        'followers': FieldValue.arrayRemove([profileUid])
      });

      await _firestore.doc(profilePath).update({
        'following': FieldValue.arrayRemove([followId])
      });
    } else {
      final profileSnap = await _firestore.collectionGroup('profiles').where('profileUid', isEqualTo: followId).get();
      DocumentSnapshot profileDoc = profileSnap.docs.first;
      profileDoc.reference.update({
        'followers': FieldValue.arrayUnion([profileUid])
      });

      await _firestore.doc(profilePath).update({
        'following': FieldValue.arrayUnion([followId])
      });

      _notificationRepository.followNotificationMethod(followId, profileUid);
    }
  }

  //BLOCK USER
  Future<void> blockProfile(String profileUid, String blockedId) async {
    final String profilePath = FirestorePath.profile(_auth.currentUser!.uid, profileUid);

    DocumentSnapshot snap = await _firestore.doc(profilePath).get();
    List blockedUsers = (snap.data()! as dynamic)['blockedUsers'];

    if (blockedUsers.contains(blockedId)) {
      await _firestore.doc(profilePath).update(
        {
          'blockedUsers': FieldValue.arrayRemove([blockedId])
        },
      );
    } else {
      await _firestore.doc(profilePath).update(
        {
          'blockedUsers': FieldValue.arrayUnion([blockedId]),
          'following': FieldValue.arrayRemove([blockedId]),
          'followers': FieldValue.arrayRemove([blockedId]),
        },
      );
    }
  }

  //CREATE NEW PROFILE
  Future<void> createProfile({
    required String uid,
    required String username,
    required List<String> petTag,
    String? bio,
    Uint8List? file,
    String? photoUrl,
  }) async {
    if (username.isNotEmpty) {
      String profileUid = const Uuid().v1();

      if (file != null) {
        photoUrl = await _storageRepository.uploadImageToStorage('profilePics', file, profileUid, profileUid);
      } else {
        photoUrl = 'https://i.pinimg.com/474x/eb/bb/b4/ebbbb41de744b5ee43107b25bd27c753.jpg';
      }

      ModelProfile profile = ModelProfile(
        username: username,
        uid: _auth.currentUser!.uid,
        profileUid: profileUid,
        email: _auth.currentUser!.email.toString(),
        bio: bio ?? "",
        photoUrl: photoUrl,
        petTag: petTag,
        following: [],
        followers: [],
        blockedUsers: [],
      );

      final String profilePath = FirestorePath.profile(uid, profile.profileUid);

      await _firestore.doc(profilePath).set(profile.toJson());
    }
  }

  //DELETE PROFILE
  Future<void> deleteProfile(String profileUid) async {
    final String profilePath = FirestorePath.profile(_auth.currentUser!.uid, profileUid);
    await _firestore.doc(profilePath).delete();
  }

  //UPDATE PROFILE
  Future<void> updateProfile({
    required String profileUid,
    Uint8List? file,
    required String newUsername,
    required String newBio,
  }) async {
    final String profilePath = FirestorePath.profile(_auth.currentUser!.uid, profileUid);
    final String photoUrl;
    if (newUsername.length <= 15 && newBio.length <= 150) {
      if (file != null) {
        photoUrl = await _storageRepository.uploadImageToStorage('profilePics', file, profileUid, profileUid);

        await _firestore.doc(profilePath).update({
          'username': newUsername,
          'bio': newBio,
          'photoUrl': photoUrl,
        });
      } else {
        // Update the user's profile without changing the image URL
        await _firestore.doc(profilePath).update({
          'username': newUsername,
          'bio': newBio,
        });
      }
    }
  }

  //GET BLOCKED PROFILES DATA
  Stream<QuerySnapshot<Map<String, dynamic>>> getBlockedProfiles(List<dynamic>? blockedProfiles) {
    return _firestore.collectionGroup('profiles').where('profileUid', whereIn: blockedProfiles).snapshots();
  }

  //USERNAME AVAILABLE
  Future<bool> isUsernameAvailable(String? username) async {
    final query = await _firestore.collectionGroup('profiles').where('username', isEqualTo: username).get();

    return query.docs.isEmpty;
  }

  //EMAIL AVAILABLE
  Future<bool> isEmailAvailable(String? email) async {
    final query = await _firestore.collectionGroup('profiles').where('email', isEqualTo: email).get();

    return query.docs.isEmpty;
  }

  //FETCH PROFILE PRIZES QUANTITY
  Future<int> fetchProfilePrizeQuantity(String profileUid, String prizeType) async {
    QuerySnapshot postsQuery = await _firestore.collection('posts').where('profileUid', isEqualTo: profileUid).get();

    for (QueryDocumentSnapshot postDoc in postsQuery.docs) {
      final DocumentSnapshot prizesDoc = await postDoc.reference.collection('prizes').doc(prizeType).get();

      if (prizesDoc.exists) {
        int quantity = prizesDoc['quantity'] ?? 0;
        return quantity;
      }
    }
    return 0;
  }
}
