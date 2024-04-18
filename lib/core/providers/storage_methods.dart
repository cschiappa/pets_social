import "dart:typed_data";

import "package:firebase_auth/firebase_auth.dart";
import "package:firebase_storage/firebase_storage.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:pets_social/core/providers/firebase_providers.dart";

final storageRepositoryProvider = Provider(
  (ref) => StorageRepository(
    firebaseStorage: ref.watch(storageProvider),
  ),
);

class StorageRepository {
  final FirebaseStorage _firebaseStorage;

  StorageRepository({required FirebaseStorage firebaseStorage}) : _firebaseStorage = firebaseStorage;

  final FirebaseAuth _auth = FirebaseAuth.instance;

  //UPLOAD IMAGE TO FIRESTORE
  Future<String> uploadImageToStorage(String childName, Uint8List file, String profileUid, String id) async {
    Reference ref = _firebaseStorage.ref().child(childName).child(_auth.currentUser!.uid).child(profileUid).child(id);

    UploadTask uploadTask = ref.putData(file);

    TaskSnapshot snap = await uploadTask;
    String downloadUrl = await snap.ref.getDownloadURL();
    return downloadUrl;
  }
}
