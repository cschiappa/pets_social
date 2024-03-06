import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pets_social/core/providers/firebase_providers.dart';
import 'package:pets_social/core/providers/storage_methods.dart';
import 'package:pets_social/features/auth/controller/auth_controller.dart';
import 'package:pets_social/features/notification/controller/notification_controller.dart';
import 'package:pets_social/features/profile/controller/profile_controller.dart';
import 'package:pets_social/models/account.dart';
import 'package:pets_social/models/comment.dart';
import 'package:pets_social/models/post.dart';
import 'package:pets_social/models/prize.dart';
import 'package:pets_social/models/profile.dart';
import 'package:pets_social/features/post/repository/post_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';

part 'post_controller.g.dart';

//POST REPOSITORY PROVIDER
@Riverpod(keepAlive: true)
PostRepository postRepository(PostRepositoryRef ref) {
  return PostRepository(
    firestore: ref.watch(firestoreProvider),
    auth: ref.read(authProvider),
    storageRepository: ref.read(storageRepositoryProvider),
    notificationRepository: ref.read(notificationRepositoryProvider),
  );
}

//SHOW/HIDE DESCRIPTION
final showDescriptionProvider = StateProvider<bool>((ref) => false);

//GET ALL POSTS IN DESCENDING
@riverpod
Future<List<ModelPost>> getPostsDescending(GetPostsDescendingRef ref, ModelAccount account, ModelProfile profile) {
  final repository = ref.watch(postRepositoryProvider);
  return repository.getPostsDescending(account, profile);
}

//GET FEED POSTS
@riverpod
Stream<List<DocumentSnapshot>> getFeedPosts(GetFeedPostsRef ref, ModelProfile? profile) {
  final repository = ref.watch(postRepositoryProvider);
  return repository.getFeedPosts(profile);
}

//GET SAVED POSTS
@riverpod
Stream<List<ModelPost>> getSavedPosts(GetSavedPostsRef ref, List<dynamic> savedPosts) {
  final repository = ref.watch(postRepositoryProvider);
  return repository.getSavedPosts(savedPosts);
}

//REAL TIME SAVED POSTS STREAM
@riverpod
Stream<List> savedPostsStream(SavedPostsStreamRef ref) {
  final repository = ref.watch(postRepositoryProvider);
  return repository.savedPostsStream();
}

//GET COMMENTS
@riverpod
Stream<List<ModelComment>> getComments(GetCommentsRef ref, String postId) {
  final repository = ref.watch(postRepositoryProvider);
  return repository.getComments(postId);
}

//GET PROFILE POSTS
@riverpod
Stream<QuerySnapshot<Map<String, dynamic>>> getProfilePosts(GetProfilePostsRef ref, String profileUid) {
  final repository = ref.watch(postRepositoryProvider);
  return repository.getProfilePosts(profileUid);
}

//GET PRIZES FROM POST
@riverpod
Future<List<ModelPrize>> getPrizesFromPost(GetPrizesFromPostRef ref, String postId) async {
  final repository = ref.watch(postRepositoryProvider);
  return repository.getPrizesFromPost(postId);
}

//GET POST BY ID
@riverpod
Stream<ModelPost> getPostById(GetPostByIdRef ref, String postId) {
  final repository = ref.watch(postRepositoryProvider);
  return repository.getPostById(postId);
}

//GET PRIZES COLLECTION
@Riverpod(keepAlive: true)
Future<List<ModelPrize>> getPrizes(GetPrizesRef ref) async {
  final repository = ref.watch(postRepositoryProvider);
  return repository.getPrizes();
}

//GET POST PRIZE DATA
@riverpod
Stream<DocumentSnapshot?> getPostPrizeData(GetPostPrizeDataRef ref, String postId, String prizeType) {
  final repository = ref.watch(postRepositoryProvider);
  return repository.getPostPrizeData(postId, prizeType);
}

//GET POST COMMENTS
@riverpod
Future<int> getCommentsNumber(GetCommentsNumberRef ref, String postId) async {
  final repository = ref.watch(postRepositoryProvider);
  return repository.getCommentsNumber(postId);
}

@riverpod
class PostController extends _$PostController {
  @override
  FutureOr<void> build() async {}

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
    final postRepository = ref.read(postRepositoryProvider);
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => postRepository.uploadPost(uid, description, file, profileUid, username, profImage, fileType, thumbnail));
  }

  //GIVE PRIZE
  Future<void> givePrize(String postId, String profileUid, String prizeType, String notificationType) async {
    final postRepository = ref.read(postRepositoryProvider);
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => postRepository.givePrize(postId, profileUid, prizeType, notificationType));
  }

  //DELETE POST
  Future<void> deletePost(String postId) async {
    final postRepository = ref.read(postRepositoryProvider);
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => postRepository.deletePost(postId));
  }

  //SAVE AND UNSAVE POST
  Future<void> savePost(String postId, List savedPosts) async {
    final postRepository = ref.read(postRepositoryProvider);
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => postRepository.savePost(postId, savedPosts));
  }

  Future<void> updatePost(String postId, String newDescription) async {
    final postRepository = ref.read(postRepositoryProvider);
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => postRepository.updatePost(postId: postId, newDescription: newDescription));
  }

  Future<void> uploadFeedback(String summary, String description) async {
    final postRepository = ref.read(postRepositoryProvider);
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => postRepository.uploadFeedback(summary, description));
  }

  Future<void> postComment(String text, ModelPost post) async {
    final postRepository = ref.read(postRepositoryProvider);

    final profile = ref.read(userProvider)!;
    String commentId = const Uuid().v1();

    ModelComment comment = ModelComment(commentId: commentId, profileUid: profile.profileUid, text: text, datePublished: DateTime.now(), postId: post.postId, username: profile.username, photoUrl: profile.photoUrl!, likes: []);

    state = const AsyncLoading();
    state = await AsyncValue.guard(() => postRepository.postComment(comment));
  }
}

final postProvider = StateNotifierProvider<PostProvider, ModelPost?>((ref) {
  return PostProvider();
});

class PostProvider extends StateNotifier<ModelPost?> {
  PostProvider() : super(null);

  updateDescription(String description) => state = state!.copyWith(description: description);
}
