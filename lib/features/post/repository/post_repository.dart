import 'dart:async';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pets_social/core/utils/language.g.dart';
import 'package:pets_social/models/account.dart';
import 'package:pets_social/models/comment.dart';
import 'package:pets_social/models/feedback.dart';
import 'package:pets_social/features/notification/repository/notification_repository.dart';
import 'package:pets_social/core/constants/firebase_constants.dart';
import 'package:pets_social/core/providers/storage_methods.dart';
import 'package:pets_social/models/prize.dart';
import 'package:pets_social/models/report.dart';

import 'package:uuid/uuid.dart';
import '../../../models/post.dart';
import '../../../models/profile.dart';

class PostRepository {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;
  final StorageRepository _storageRepository;
  final NotificationRepository _notificationRepository;
  PostRepository({
    required FirebaseFirestore firestore,
    required FirebaseAuth auth,
    required StorageRepository storageRepository,
    required NotificationRepository notificationRepository,
  })  : _firestore = firestore,
        _auth = auth,
        _storageRepository = storageRepository,
        _notificationRepository = notificationRepository;

  //UPLOAD POST
  Future<void> uploadPost(
    String uid,
    String? description,
    Uint8List file,
    String profileUid,
    String username,
    String profImage,
    String fileType,
    Uint8List thumbnail,
  ) async {
    String postId = const Uuid().v1();

    String photoUrl = await _storageRepository.uploadImageToStorage('posts', file, postId);

    String videoThumbnail = await _storageRepository.uploadImageToStorage('videoThumbnails', thumbnail, postId);

    final String postPath = FirestorePath.post(postId);

    ModelPost post = ModelPost(
      uid: uid,
      description: description ?? "",
      profileUid: profileUid,
      postId: postId,
      datePublished: DateTime.now(),
      postUrl: photoUrl,
      fileType: fileType,
      videoThumbnail: videoThumbnail,
    );

    _firestore.doc(postPath).set(post.toJson());

    _firestore.doc(postPath).collection('prizes').doc('like').set({'quantity': 0, 'contributors': []});
  }

  //GIVE PRIZE
  Future<void> givePrize(String postId, String profileUid, String prizeType, String notificationType) async {
    final postPath = FirestorePath.post(postId);

    final prizesCollection = _firestore.doc(postPath).collection('prizes');
    DocumentSnapshot prizeSnapshot = await prizesCollection.doc(prizeType).get();

    if (prizeSnapshot.exists) {
      final contributors = prizeSnapshot.get('contributors');

      if (contributors.contains(profileUid)) {
        await prizesCollection.doc(prizeType).update({
          'quantity': FieldValue.increment(-1),
          'contributors': FieldValue.arrayRemove([profileUid]),
        });
      } else {
        await prizesCollection.doc(prizeType).update({
          'quantity': FieldValue.increment(1),
          'contributors': FieldValue.arrayUnion([profileUid]),
        });
        _notificationRepository.notificationMethod(postId, profileUid, LocaleKeys.gavePrize.tr());
      }
    } else {
      // Prize type doesn't exist, create a new entry
      await prizesCollection.doc(prizeType).set({
        'quantity': 1,
        'contributors': [profileUid],
      });
      _notificationRepository.notificationMethod(postId, profileUid, LocaleKeys.gavePrize.tr());
    }

    //delete prize document if quantity is zero
    final user = _auth.currentUser!.uid;
    final userPath = FirestorePath.user(user);

    final userCollection = _firestore.doc(userPath);
    DocumentSnapshot userPrizeSnapshot = await userCollection.collection('purchasedPrizes').doc(prizeType).get();

    if (userPrizeSnapshot.exists) {
      final prizeQuantity = userPrizeSnapshot.get('quantity');
      if (prizeQuantity == 0) {
        await userCollection.collection('purchasedPrizes').doc(prizeType).delete();
      }
    }
  }

  Future<List<ModelPrize>> getPrizes() async {
    final querySnapshot = await _firestore.collection('prizes').orderBy('position').get();

    return querySnapshot.docs.map((doc) => ModelPrize.fromSnap(doc)).toList();
  }

  Stream<DocumentSnapshot?> getPostPrizeData(String postId, String prizeType) {
    final documentReference = _firestore.collection('posts').doc(postId).collection('prizes').doc(prizeType);

    return documentReference.snapshots().map((documentSnapshot) {
      if (documentSnapshot.exists) {
        return documentSnapshot;
      } else {
        return null;
      }
    });
  }

//GET PRIZES FROM POST
  Future<List<ModelPrize>> getPrizesFromPost(String postId) async {
    final prizesCollection = _firestore.collection('prizes');
    final postPrizesCollection = _firestore.collection('posts').doc(postId).collection('prizes');

    final prizesQuerySnapshot = await prizesCollection.get();
    final postPrizesQuerySnapshot = await postPrizesCollection.get();

    final List<String> postPrizeIds = postPrizesQuerySnapshot.docs.map((doc) => doc.id).toList();

    // Filter prizes based on the post's prize IDs
    final List<ModelPrize> filteredPrizes = prizesQuerySnapshot.docs.where((doc) => postPrizeIds.contains(doc.id)).map((doc) => ModelPrize.fromSnap(doc)).toList();

    return filteredPrizes;
  }

  //GET POST COMMENTS
  Future<int> getCommentsNumber(String postId) async {
    final postPath = FirestorePath.post(postId);
    QuerySnapshot snap = await _firestore.doc(postPath).collection('comments').get();

    final commentLen = snap.docs.length;

    return commentLen;
  }

  //POST COMMENT
  Future<void> postComment(ModelComment comment) async {
    try {
      //String commentId = const Uuid().v1();
      final commentPath = FirestorePath.comment(comment.postId, comment.commentId);
      if (comment.text.isNotEmpty) {
        await _firestore.doc(commentPath).set(comment.toJson());
      } else {
        debugPrint('text is empty');
      }
    } catch (e) {
      debugPrint(
        e.toString(),
      );
    }
  }

  //LIKE COMMENT
  Future<void> likeComment(String postId, String commentId, String profileUid, List likes) async {
    try {
      final commentPath = FirestorePath.comment(postId, commentId);
      if (likes.contains(profileUid)) {
        await _firestore.doc(commentPath).update({
          'likes': FieldValue.arrayRemove([profileUid]),
        });
      } else {
        await _firestore.doc(commentPath).update({
          'likes': FieldValue.arrayUnion([profileUid]),
        });
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  //DELETE POST
  Future<void> deletePost(String postId) async {
    final postPath = FirestorePath.post(postId);
    final QuerySnapshot<Map<String, dynamic>> notification = await _firestore.collection('notifications').where('postId', isEqualTo: postId).get();

    for (QueryDocumentSnapshot<Map<String, dynamic>> documentSnapshot in notification.docs) {
      await documentSnapshot.reference.delete();
    }
    _firestore.doc(postPath).delete();
  }

  //SAVE AND UNSAVE POST
  Future<void> savePost(String postId, List<dynamic> savedPost) async {
    final userPath = FirestorePath.user(_auth.currentUser!.uid);
    if (savedPost.contains(postId)) {
      await _firestore.doc(userPath).update({
        'savedPosts': FieldValue.arrayRemove([postId]),
      });
    } else {
      await _firestore.doc(userPath).update({
        'savedPosts': FieldValue.arrayUnion([postId]),
      });
    }
  }

  //REAL TIME USER DATA
  Stream<List> savedPostsStream() {
    final userPath = FirestorePath.user(_auth.currentUser!.uid);

    return _firestore.doc(userPath).snapshots().map((snapshot) {
      if (snapshot.exists) {
        final userData = snapshot.data() as Map<String, dynamic>;
        return userData['savedPosts'] ?? [];
      } else {
        return [];
      }
    });
  }

  //GET SAVED POSTS
  // Future<List<ModelPost>> getSavedPosts(List<dynamic> savedPosts) async {
  //   QuerySnapshot querySnapshot = await _firestore.collection('posts').where('postId', whereIn: savedPosts).get();

  //   return querySnapshot.docs.map((doc) => ModelPost.fromSnap(doc)).toList();
  // }

  // GET SAVED POSTS STREAM
  Stream<List<ModelPost>> getSavedPosts(List<dynamic> savedPosts) {
    return _firestore.collection('posts').where('postId', whereIn: savedPosts).snapshots().map((QuerySnapshot querySnapshot) {
      return querySnapshot.docs.map((doc) => ModelPost.fromSnap(doc)).toList();
    });
  }

  //UPDATE POST
  Future<void> updatePost({
    required String postId,
    required String newDescription,
  }) async {
    final postPath = FirestorePath.post(postId);
    if (newDescription.length <= 2000) {
      await _firestore.doc(postPath).update({
        'description': newDescription,
      });
    }
  }

  //UPLOAD FEEDBACK
  Future<void> uploadFeedback(
    String summary,
    String description,
  ) async {
    String feedbackId = const Uuid().v1();
    final String feedbackPath = FirestorePath.feedback(feedbackId);

    ModelFeedback feedback = ModelFeedback(
      summary: summary,
      description: description,
      datePublished: DateTime.now(),
    );

    _firestore.doc(feedbackPath).set(
          feedback.toJson(),
        );
  }

  // //GET ALL POSTS DESCENDING
  // Future<List<ModelPost>> getPostsDescending(ModelProfile profile) async {
  //   QuerySnapshot querySnapshot = await _firestore.collection('posts').orderBy('datePublished', descending: true).get();

  //   return querySnapshot.docs.where((doc) => !profile.blockedUsers.contains(doc['profileUid'])).map((doc) => ModelPost.fromSnap(doc)).toList();
  // }

  //GET SEARCH POSTS (NO BLOCKED PROFILES/NO BLOCKED TAGS)
  Future<List<ModelPost>> getPostsDescending(ModelAccount user, ModelProfile profile) async {
    // Step 1: Retrieve the list of blocked tags
    List blockedTags = user.blockedTags;

    // Step 2: Fetch profilesCollection
    QuerySnapshot profilesSnapshot = await _firestore.collectionGroup('profiles').get();
    List<ModelProfile> profiles = profilesSnapshot.docs.map((doc) => ModelProfile.fromSnap(doc)).toList();

    // Step 3: Fetch posts and filter based on blocked tags
    QuerySnapshot querySnapshot = await _firestore.collection('posts').orderBy('datePublished', descending: true).get();

    List<ModelPost> filteredPosts = querySnapshot.docs.map((postDoc) => ModelPost.fromSnap(postDoc)).where((post) {
      // Check if post.profileUid matches any profiles.profileUid
      bool isProfileMatch = profiles.any((profile) =>
              profile.profileUid == post.profileUid &&
              // Check if the corresponding profile's tag is not in blockedTags
              !blockedTags.any((blockedTag) => profile.petTag.contains(blockedTag))) &&
          !profile.blockedUsers.contains(post.profileUid);

      return isProfileMatch;
    }).toList();

    return filteredPosts;
  }

  //GET FEED POSTS
  Stream<List<DocumentSnapshot>> getFeedPosts(ModelProfile? profile) {
    return _firestore.collection('posts').where('profileUid', whereIn: [...profile!.following, profile.profileUid]).orderBy('datePublished', descending: true).snapshots().map(
          (snapshot) {
            return snapshot.docs.where(
              (doc) {
                return !profile.blockedUsers.contains(doc['profileUid']);
              },
            ).toList();
          },
        );
  }

  //GET COMMENTS
  Stream<List<ModelComment>> getComments(String postId) {
    final String postPath = FirestorePath.post(postId);
    return _firestore.doc(postPath).collection('comments').orderBy('datePublished', descending: true).snapshots().map((QuerySnapshot querySnapshot) {
      List<ModelComment> comments = [];
      for (QueryDocumentSnapshot doc in querySnapshot.docs) {
        comments.add(ModelComment.fromSnap(doc));
      }
      return comments;
    });
  }

  //GET PROFILE'S POSTS DESCENDING
  Stream<QuerySnapshot<Map<String, dynamic>>> getProfilePosts(String profileUid) {
    return _firestore.collection('posts').where('profileUid', isEqualTo: profileUid).orderBy('datePublished', descending: true).snapshots();
  }

  //GET POST BY ID
  Stream<ModelPost> getPostById(String postId) {
    final String postPath = FirestorePath.post(postId);
    return _firestore.doc(postPath).snapshots().map((event) => ModelPost.fromSnap(event));
  }

  //REPORT PROFILE OR POST
  Future<void> reportPost(String reportType, String reportedProfile, String reportedPostId, String summary) async {
    String reportId = const Uuid().v1();
    final String reportsPath = FirestorePath.reports(reportType, reportId);

    ModelReport report = ModelReport(
      reportType: reportType,
      reportId: reportId,
      reportedProfile: reportedProfile,
      reportedPostId: reportedPostId,
      summary: summary,
      datePublished: DateTime.now(),
    );

    _firestore.doc(reportsPath).set(
          report.toJson(),
        );
  }
}
