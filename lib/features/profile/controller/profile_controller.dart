import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pets_social/core/providers/firebase_providers.dart';
import 'package:pets_social/core/providers/storage_methods.dart';
import 'package:pets_social/features/auth/controller/auth_controller.dart';
import 'package:pets_social/features/auth/repository/auth_repository.dart';
import 'package:pets_social/features/notification/controller/notification_controller.dart';
import 'package:pets_social/features/profile/repository/profile_repository.dart';
import 'package:pets_social/models/profile.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'profile_controller.g.dart';

//PROFILE REPOSITORY PROVIDER
@Riverpod(keepAlive: true)
ProfileRepository profileRepository(ProfileRepositoryRef ref) {
  return ProfileRepository(
    firestore: ref.watch(firestoreProvider),
    auth: ref.read(authProvider),
    storageRepository: ref.read(storageRepositoryProvider),
    notificationRepository: ref.read(notificationRepositoryProvider),
  );
}

// //GET PROFIILE DATA
@riverpod
Stream<ModelProfile> getProfileData(GetProfileDataRef ref, String profileUid) {
  final repository = ref.watch(profileRepositoryProvider);
  return repository.getProfileData(profileUid);
}

//GET BLOCKED PROFILES
@riverpod
Stream<QuerySnapshot<Map<String, dynamic>>> getBlockedProfiles(GetBlockedProfilesRef ref, List<dynamic>? blockedProfiles) {
  final repository = ref.watch(profileRepositoryProvider);
  return repository.getBlockedProfiles(blockedProfiles);
}

//GET ACCOUNT PROFILES
@riverpod
Stream<QuerySnapshot<Map<String, dynamic>>> getAccountProfiles(GetAccountProfilesRef ref) {
  final repository = ref.watch(profileRepositoryProvider);
  return repository.getAccountProfiles();
}

//GET PROFILE FROM POST
@riverpod
Future<ModelProfile> getProfileFromPost(GetProfileFromPostRef ref, String profileUid) {
  final repository = ref.watch(profileRepositoryProvider);
  return repository.getProfileFromPost(profileUid);
}

//IS USERNAME AVAILABLE
@riverpod
Future<bool> isUsernameAvailable(IsUsernameAvailableRef ref, String? username) {
  final repository = ref.watch(profileRepositoryProvider);
  return repository.isUsernameAvailable(username);
}

//PROFILE PRIZE QUANTITY
@riverpod
Future<int> fetchProfilePrizeQuantity(FetchProfilePrizeQuantityRef ref, String profileUid, String prizeType) async {
  final repository = ref.watch(profileRepositoryProvider);
  return repository.fetchProfilePrizeQuantity(profileUid, prizeType);
}

//PROFILE CONTROLLER
@riverpod
class ProfileController extends _$ProfileController {
  @override
  FutureOr<void> build() async {}

  //CREATE NEW PROFILE
  Future<void> createProfile({
    required String uid,
    required String username,
    required List<String> petTag,
    String? bio,
    Uint8List? file,
    String? photoUrl,
  }) async {
    final profileRepository = ref.read(profileRepositoryProvider);
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => profileRepository.createProfile(uid: uid, username: username, petTag: petTag, bio: bio, file: file, photoUrl: photoUrl));
  }

  //FOLLOW FUNCTION
  Future<void> followProfile(String profileUid, String followId) async {
    final profileRepository = ref.read(profileRepositoryProvider);
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => profileRepository.followProfile(profileUid, followId));
  }

  //BLOCK USER
  Future<void> blockProfile(String profileUid, String blockedId) async {
    final profileRepository = ref.read(profileRepositoryProvider);
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => profileRepository.blockProfile(profileUid, blockedId));
  }

  //DELETE PROFILE
  Future<void> deleteProfile(String profileUid) async {
    final profileRepository = ref.read(profileRepositoryProvider);
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => profileRepository.deleteProfile(profileUid));
  }

  //UPDATE PROFILE
  Future<void> updateProfile({
    required String profileUid,
    Uint8List? file,
    required String newUsername,
    required String newBio,
  }) async {
    final profileRepository = ref.read(profileRepositoryProvider);
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => profileRepository.updateProfile(profileUid: profileUid, file: file, newUsername: newUsername, newBio: newBio));
  }
}

final userProvider = StateNotifierProvider<UserProvider, ModelProfile?>((ref) {
  return UserProvider(
    authRepository: ref.watch(authRepositoryProvider),
    profileRepository: ref.watch(profileRepositoryProvider),
    profileController: ref.read(profileControllerProvider.notifier),
  );
});

class UserProvider extends StateNotifier<ModelProfile?> {
  final ProfileRepository _profileRepository;
  final ProfileController _profileController;

  UserProvider({
    required AuthRepository authRepository,
    required ProfileRepository profileRepository,
    required ProfileController profileController,
  })  : _profileRepository = profileRepository,
        _profileController = profileController,
        super(null);

  // GET PROFILE DETAILS
  Future<ModelProfile> getProfileDetails({String? profileUid}) async {
    ModelProfile profile = await _profileRepository.getProfileDetails(profileUid ?? state?.profileUid);
    state = profile;
    return profile;
  }

  // DISPOSE PROFILE
  void disposeProfile() {
    state = null;
  }

  //UPDATE PROFILE DATA INDIVIDUALLY
  void updateUsername(String username) => state = state!.copyWith(username: username);
  void updateBio(String bio) => state = state!.copyWith(bio: bio);

  //UPDATE BLOCKED PROFILES ON FIRESTORE
  Future<void> updateBlockedProfiles(String blockedId) async {
    if (state != null) {
      await _profileController.blockProfile(state!.profileUid, blockedId);
      state = state!.copyWith(blockedUsers: state!.blockedUsers);
    }
  }

  // UNBLOCK PROFILE
  void unblockProfile(String blockedId) async {
    if (state != null) {
      state!.blockedUsers.remove(blockedId);
      await updateBlockedProfiles(blockedId);
    }
  }

  // BLOCK PROFILE
  void blockProfile(String blockedId) async {
    if (state != null) {
      state!.blockedUsers.add(blockedId);
      await updateBlockedProfiles(blockedId);
    }
  }

  //UPDATE FOLLOWING/FOLLOWERS ON FIRESTORE
  Future<void> updateFollowProfiles(String profileUid, String followId) async {
    if (state != null) {
      await _profileController.followProfile(state!.profileUid, followId);
      state = state!.copyWith(following: state!.following);
      state = state!.copyWith(followers: state!.followers);
    }
  }
}
