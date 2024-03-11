import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pets_social/core/constants/firebase_constants.dart';

class TagRepository {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;
  TagRepository({
    required FirebaseFirestore firestore,
    required FirebaseAuth auth,
  })  : _firestore = firestore,
        _auth = auth;

  Future<List<String>> getPetTagsCollection() async {
    final petTags = await _firestore.collection('pet-tags').get();

    // Extract document IDs from the QuerySnapshot
    List<String> documentIds = petTags.docs.map((doc) => doc.id).toList();

    return documentIds;
  }

  //GET USER TAGS
  Stream<List<String>?> getUserTags(String tagsId) {
    final user = _auth.currentUser;

    if (user == null) {
      return const Stream.empty(); // or return null, depending on your use case
    }

    final String userPath = FirestorePath.user(user.uid);

    return _firestore.doc(userPath).snapshots().map(
      (snapshot) {
        if (snapshot.exists) {
          List<String> tagsArray = List<String>.from(snapshot.data()?[tagsId] ?? []);
          return tagsArray;
        } else {
          return null;
        }
      },
    );
  }

  //UPDATE TAGS
  Future<void> updateTags(String tagsId, List<String> tagsArray) async {
    final String userPath = FirestorePath.user(_auth.currentUser!.uid);

    final snapshot = await _firestore.doc(userPath).get();

    if (snapshot.exists) {
      await _firestore.doc(userPath).update({
        tagsId: tagsArray,
      });
    }
  }
}
