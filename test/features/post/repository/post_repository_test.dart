import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:pets_social/features/post/repository/post_repository.dart';
import 'package:pets_social/models/comment.dart';
import 'package:uuid/uuid.dart';

class PostRepositoryMock extends Mock implements PostRepository {
  final FakeFirebaseFirestore firestore;

  PostRepositoryMock({required this.firestore});

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
  group('PostRepository', () {
    final mockFirestore = FakeFirebaseFirestore();

    late PostRepositoryMock postRepositoryMock;

    setUp(() {
      postRepositoryMock = PostRepositoryMock(
        firestore: mockFirestore,
      );
    });

    const postCollection = 'posts';
    const postId = 'testPostId';

    group('Add/Remove profileUid to array - ex: Like/Dislike post, Give/Remove prize from post', () {
      test('Add', () async {
        const String collectionPath = postCollection;
        const String documentPath = postId;

        final DocumentReference<Map<String, dynamic>> documentReference = mockFirestore.collection(collectionPath).doc(documentPath);

        // Set initial data with an array
        await documentReference.set({
          'dataArray': ['value1', 'value2', 'value3']
        });

        // Update array data with a string
        final arrayUpdate = {
          'dataArray': FieldValue.arrayUnion(['newValue'])
        };

        await postRepositoryMock.updateDataOnDocument(
          data: arrayUpdate,
          collectionPath: collectionPath,
          documentPath: documentPath,
        );
        // Retrieve the updated document snapshot
        final DocumentSnapshot<Map<String, dynamic>> updatedDocumentSnapshot = await documentReference.get();

        // Extract the actual data from the updated document
        final Map<String, dynamic>? actualData = updatedDocumentSnapshot.data();

        //Expected data
        final Map<String, dynamic> expectedData = {
          'dataArray': ['value1', 'value2', 'value3', 'newValue']
        };

        expect(actualData, expectedData);
      });

      test('Remove', () async {
        const String collectionPath = postCollection;
        const String documentPath = postId;

        final DocumentReference<Map<String, dynamic>> documentReference = mockFirestore.collection(collectionPath).doc(documentPath);

        // Set initial data with an array
        await documentReference.set({
          'dataArray': ['value1', 'value2', 'value3']
        });

        // Update array data with a string
        final arrayUpdate = {
          'dataArray': FieldValue.arrayRemove(['value3'])
        };

        await postRepositoryMock.updateDataOnDocument(
          data: arrayUpdate,
          collectionPath: collectionPath,
          documentPath: documentPath,
        );
        // Retrieve the updated document snapshot
        final DocumentSnapshot<Map<String, dynamic>> updatedDocumentSnapshot = await documentReference.get();

        // Extract the actual data from the updated document
        final Map<String, dynamic>? actualData = updatedDocumentSnapshot.data();

        //Expected data
        final Map<String, dynamic> expectedData = {
          'dataArray': ['value1', 'value2']
        };

        expect(actualData, expectedData);
      });
    });

    group('Add comment to collection', () {
      const String collectionPath = postCollection;
      const String documentPath = postId;

      const String profileUid = 'profileUid';
      const String uid = 'uid';
      const String text = 'text';
      DateTime dataPublished = DateTime.now();
      const String username = 'username';
      const String photoUrl = 'photoUrl';
      const List<String> likes = [];
      String commentId = const Uuid().v1();

      test('Add Comment', () async {
        ModelComment comment = ModelComment(commentId: commentId, profileUid: profileUid, uid: uid, text: text, datePublished: dataPublished, postId: postId, username: username, photoUrl: photoUrl, likes: likes);

        await postRepositoryMock.setDataOnDocument(
          data: comment.toJson(),
          collectionPath: collectionPath,
          documentPath: documentPath,
        );

        final DocumentReference<Map<String, dynamic>> documentReference = mockFirestore.collection(collectionPath).doc(documentPath);

        // Retrieve the updated document snapshot
        final DocumentSnapshot<Map<String, dynamic>> updatedDocumentSnapshot = await documentReference.get();

        // Extract the actual data from the updated document
        final Map<String, dynamic>? actualData = updatedDocumentSnapshot.data();

        // Modifies the expected data with the converted DateTime
        final Map<String, dynamic> expectedData = comment.toJson();

        //Converts expected data from DateTime to Timestamp for comparision
        expectedData['datePublished'] = Timestamp.fromDate(comment.datePublished);

        expect(actualData, expectedData);
      });
    });
  });
}
