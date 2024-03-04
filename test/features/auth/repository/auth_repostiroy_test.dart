import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:pets_social/features/auth/repository/auth_repository.dart';

class AuthRepositoryMock extends Mock implements AuthRepository {
  final FakeFirebaseFirestore firestore;
  final MockFirebaseAuth auth;

  AuthRepositoryMock({required this.firestore, required this.auth});

  //UPDATE DATA
  Future<void> updateDataOnDocument({
    required Map<String, dynamic> data,
    required String collectionPath,
    required String documentPath,
  }) async {
    final DocumentReference<Map<String, dynamic>> documentReference = firestore.collection(collectionPath).doc(documentPath);

    await documentReference.update(data);
  }

  //SET DATA
  Future<void> setDataOnDocument({required Map<String, dynamic> data, required String collectionPath, required String documentPath}) {
    return firestore.collection(collectionPath).doc(documentPath).set(data);
  }
}

void main() {
  group('AuthRepository', () {
    final mockFirestore = FakeFirebaseFirestore();
    final mockAuth = MockFirebaseAuth();
    late AuthRepositoryMock authRepositoryMock;

    setUp(() => authRepositoryMock = AuthRepositoryMock(firestore: mockFirestore, auth: mockAuth));

    group('Log in', () {
      test('Log in', () async {
        String email = 'test@example.com';
        String password = 'password';

        final actualData = await mockAuth.signInWithEmailAndPassword(email: email, password: password);

        final expectedData = MockUser(uid: actualData.user!.uid);

        expect(actualData.user, expectedData);
      });
    });
  });
}
