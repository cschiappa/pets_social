import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pets_social/core/providers/firebase_providers.dart';
import 'package:pets_social/core/providers/storage_methods.dart';
import 'package:pets_social/features/auth/repository/auth_repository.dart';
import 'package:pets_social/features/notification/controller/notification_controller.dart';
import 'package:pets_social/features/profile/controller/profile_controller.dart';
import 'package:pets_social/firebase_options.dart';
import 'package:pets_social/models/account.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_controller.g.dart';

//AUTH REPOSITORY PROVIDER (instance)
@Riverpod(keepAlive: true)
AuthRepository authRepository(AuthRepositoryRef ref) {
  return AuthRepository(
    firestore: ref.read(firestoreProvider),
    auth: ref.read(authProvider),
    storageRepository: ref.read(storageRepositoryProvider),
    notificationRepository: ref.read(notificationRepositoryProvider),
  );
}

final temporaryUserDataProvider = StateProvider<TemporaryUserData>((ref) => TemporaryUserData(
      email: '',
      username: '',
      password: '',
      bio: '',
      image: Uint8List(0),
    ));

class TemporaryUserData {
  TemporaryUserData({required this.email, required this.username, required this.password, required this.bio, required this.image});
  String email;
  String username;
  String password;
  String bio;
  Uint8List? image;
}

//APP START UP -> DATA, ERROR, LOADING
@Riverpod(keepAlive: true)
Future<void> appStartup(AppStartupRef ref) async {
  await Future.wait([
    EasyLocalization.ensureInitialized(),
    Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform),
  ]);
}

//AUTH CHANGES
@Riverpod(keepAlive: true)
Stream<User?> authStateChange(AuthStateChangeRef ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  final auth = ref.read(authProvider);

  if (auth.currentUser != null) {
    ref.read(userProvider.notifier).getProfileDetails();
  }
  return authRepository.authStateChange;
}

//IS LOGGED IN
@Riverpod(keepAlive: true)
bool isLoggedIn(IsLoggedInRef ref) {
  final auth = ref.watch(authStateChangeProvider);
  final profile = ref.watch(userProvider);

  return auth.value != null && profile != null;
}

//AUTH CONTROLLER
@riverpod
class AuthController extends _$AuthController {
  @override
  FutureOr<void> build() async {}

  //LOG IN
  Future<void> logIn(String email, String password) async {
    final authRepository = ref.read(authRepositoryProvider);
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => authRepository.loginUser(email: email, password: password));
    await ref.read(userProvider.notifier).getProfileDetails();
  }

  //SIGN UP
  Future<void> signUp({
    required String email,
    required String password,
    required String username,
    required List petTag,
    required List? preferedTags,
    required List? blockedTags,
    required String? bio,
    required Uint8List? file,
  }) async {
    final authRepository = ref.read(authRepositoryProvider);
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => authRepository.signUp(email: email, password: password, username: username, petTag: petTag, preferedTags: preferedTags, blockedTags: blockedTags, bio: bio, file: file));
    await ref.read(userProvider.notifier).getProfileDetails();
  }

  //SIGN OUT
  Future<void> signOut() async {
    final authRepository = ref.read(authRepositoryProvider);
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => authRepository.signOut());
    await Future.delayed(const Duration(seconds: 2));
    ref.read(userProvider.notifier).disposeProfile();
  }

  //DELETE PROFILE
  Future<void> deleteUser() async {
    final authRepository = ref.read(authRepositoryProvider);
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => authRepository.deleteUser());
  }

  //CHANGE PASSWORD
  Future<void> changePassword(String newPassword) async {
    final authRepository = ref.read(authRepositoryProvider);
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => authRepository.changePassword(newPassword));
  }

  //VERIFY CURRENT PASSWORD
  Future<bool> verifyCurrentPassword(String currentPassword) async {
    final authRepository = ref.read(authRepositoryProvider);
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => authRepository.verifyCurrentPassword(currentPassword));
    return state.hasError == false;
  }
}

final accountProvider = StateNotifierProvider<AccountProvider, ModelAccount?>((ref) {
  return AccountProvider(
    authRepository: ref.watch(authRepositoryProvider),
  );
});

class AccountProvider extends StateNotifier<ModelAccount?> {
  final AuthRepository _authRepository;

  AccountProvider({
    required AuthRepository authRepository,
  })  : _authRepository = authRepository,
        super(null);

  // GET ACCOUNT DETAILS
  Future<ModelAccount> getAccountDetails() async {
    ModelAccount user = await _authRepository.getAccountDetails();
    state = user;
    return user;
  }

  // DISPOSE ACCOUNT
  void disposeAccount() {
    state = null;
  }
}
