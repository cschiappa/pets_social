import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pets_social/core/constants/firebase_constants.dart';
import 'package:pets_social/models/prize.dart';

class PrizeRepository {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;
  PrizeRepository({
    required FirebaseFirestore firestore,
    required FirebaseAuth auth,
  })  : _firestore = firestore,
        _auth = auth;

  //BUY LIZZY COINS
  Future<void> buyLizzyCoins(int quantity) async {
    final user = _auth.currentUser!.uid;
    final userPath = FirestorePath.user(user);

    await _firestore.doc(userPath).update({
      'lizzyCoins': FieldValue.increment(quantity),
    });
  }

  //BUY PRIZE
  Future<void> buyPrize(String prizeType, int quantity, int price) async {
    final user = _auth.currentUser!.uid;
    final userPath = FirestorePath.user(user);

    final userCollection = _firestore.doc(userPath);
    final prizesCollection = _firestore.doc(userPath).collection('purchasedPrizes');
    DocumentSnapshot prizeSnapshot = await prizesCollection.doc(prizeType).get();

    if (prizeSnapshot.exists) {
      await prizesCollection.doc(prizeType).update({
        'quantity': FieldValue.increment(quantity),
      });
      await userCollection.update({
        'lizzyCoins': FieldValue.increment(-price),
      });
    } else {
      await prizesCollection.doc(prizeType).set({
        'quantity': quantity,
      });
      await userCollection.update({
        'lizzyCoins': FieldValue.increment(-price),
      });
    }
  }

  //GET USER PURCHASED PRIZE DATA
  Stream<DocumentSnapshot?> getUserPrizeData(String prizeType) {
    final user = _auth.currentUser!.uid;
    final documentReference = _firestore.collection('users').doc(user).collection('purchasedPrizes').doc(prizeType);

    return documentReference.snapshots().map((documentSnapshot) {
      if (documentSnapshot.exists) {
        return documentSnapshot;
      } else {
        return null;
      }
    });
  }

  //GET PAID PRIZES
  Future<List<ModelPrize>> getPaidPrizes() async {
    final querySnapshot = await _firestore.collection('prizes').where('isPaid', isEqualTo: true).get();

    return querySnapshot.docs.map((doc) => ModelPrize.fromSnap(doc)).toList();
  }

  //GET EVERY PRIZE THE PROFILE HAS RECEIVED
  Future<Map<String, int>> getProfilePrizes(String profileUid) async {
    QuerySnapshot postsSnapshot = await _firestore.collection('posts').where('profileUid', isEqualTo: profileUid).get();

    // Map to store the count of each prize
    Map<String, int> prizeCounts = {};

    for (QueryDocumentSnapshot postDoc in postsSnapshot.docs) {
      CollectionReference prizesCollection = postDoc.reference.collection('prizes');

      QuerySnapshot prizesSnapshot = await prizesCollection.get();

      for (QueryDocumentSnapshot prizeDoc in prizesSnapshot.docs) {
        String prizeType = prizeDoc.id;
        int quantity = prizeDoc['quantity'];

        prizeCounts[prizeType] = (prizeCounts[prizeType] ?? 0) + quantity;
      }
    }
    return prizeCounts;
  }
}
