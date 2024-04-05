import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pets_social/core/utils/utils.dart';
import 'package:pets_social/models/account.dart';
import 'package:pets_social/models/profile.dart';
import 'package:pets_social/core/constants/firebase_constants.dart';
import 'package:pets_social/core/providers/storage_methods.dart';
import 'package:uuid/uuid.dart';
import '../../notification/repository/notification_repository.dart';

class AuthRepository {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;
  final StorageRepository _storageRepository;
  final NotificationRepository _notificationRepository;
  AuthRepository({
    required FirebaseFirestore firestore,
    required FirebaseAuth auth,
    required StorageRepository storageRepository,
    required NotificationRepository notificationRepository,
  })  : _auth = auth,
        _firestore = firestore,
        _storageRepository = storageRepository,
        _notificationRepository = notificationRepository;

  //GET AUTHENTICATION CHANGES
  Stream<User?> get authStateChange => _auth.authStateChanges();

  //GET ACCOUNT DETAILS
  Future<ModelAccount> getAccountDetails() async {
    User currentUser = _auth.currentUser!;

    final String userPath = FirestorePath.user(currentUser.uid);

    final DocumentSnapshot documentSnapshot = await _firestore.doc(userPath).get();

    return ModelAccount.fromSnap(documentSnapshot);
  }

  //SIGN UP
  Future<void> signUp({
    required String email,
    required String password,
    required String username,
    required List petTag,
    List? preferedTags,
    List? blockedTags,
    String? bio,
    Uint8List? file,
    String? photoUrl,
  }) async {
    UserCredential cred = await _auth.createUserWithEmailAndPassword(email: email, password: password);

    String profileUid = const Uuid().v1();

    if (file != null) {
      photoUrl = await _storageRepository.uploadImageToStorage('profilePics', file, profileUid);
    } else {
      photoUrl = 'https://i.pinimg.com/474x/eb/bb/b4/ebbbb41de744b5ee43107b25bd27c753.jpg';
    }

    ModelAccount account = ModelAccount(
      email: email,
      uid: cred.user!.uid,
      lizzyCoins: 0,
      tags: [],
      preferedTags: preferedTags ?? [],
      blockedTags: blockedTags ?? [],
      savedPosts: [],
    );

    ModelProfile profile = ModelProfile(
      username: username,
      uid: _auth.currentUser!.uid,
      profileUid: profileUid,
      email: email,
      petTag: petTag,
      bio: bio,
      photoUrl: photoUrl,
      following: [],
      followers: [],
      blockedUsers: [],
    );

    final String userPath = FirestorePath.user(cred.user!.uid);
    final String profilePath = FirestorePath.profile(cred.user!.uid, profileUid);

    final batch = _firestore.batch();
    var accountCollection = _firestore.doc(userPath);
    batch.set(accountCollection, account.toJson());

    var profileCollection = _firestore.doc(profilePath);
    batch.set(profileCollection, profile.toJson());

    await batch.commit();

    _firestore.doc(userPath).collection('purchasedPrizes').doc().set({'text': ''});

    await _notificationRepository.initNotifications();
  }

  //LOG IN
  Future<void> loginUser({required String email, required String password}) async {
    await _auth.signInWithEmailAndPassword(email: email, password: password);
    _notificationRepository.initNotifications();
  }

  //SEND EMAIL VERIFICATION
  Future<void> sendEmailVerification() async {
    User? user = _auth.currentUser;
    if (user != null) {
      await _auth.currentUser!.sendEmailVerification();
    }
  }

  //SIGN OUT
  Future<void> signOut() async {
    await _notificationRepository.removeTokenFromDatabase();
    await _auth.signOut();
  }

  //DELETE ACCOUNT
  Future<void> deleteUser() async {
    final User? user = _auth.currentUser;

    if (user != null) {
      final userPath = FirestorePath.user(user.uid);
      // Delete the user's account from Firebase Authentication
      await user.delete();

      //Delete the user's account from Firestore collection
      await _firestore.doc(userPath).delete();
    }
  }

  //CHANGE PASSWORD
  Future<void> changePassword(String newPassword) async {
    final User? user = _auth.currentUser;
    if (isPasswordValid(newPassword)) {
      await user!.updatePassword(newPassword);
    }
  }

  //AUTHENTICATION
  Future<UserCredential> verifyCurrentPassword(String currentPassword) async {
    final User user = _auth.currentUser!;
    AuthCredential credential = EmailAuthProvider.credential(email: user.email!, password: currentPassword);
    return await user.reauthenticateWithCredential(credential);
  }
}
