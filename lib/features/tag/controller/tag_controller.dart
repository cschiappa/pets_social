import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pets_social/core/providers/firebase_providers.dart';
import 'package:pets_social/features/tag/repository/tag_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'tag_controller.g.dart';

//PROFILE REPOSITORY PROVIDER
@Riverpod(keepAlive: true)
TagRepository tagRepository(TagRepositoryRef ref) {
  return TagRepository(
    firestore: ref.watch(firestoreProvider),
    auth: ref.read(authProvider),
  );
}

@riverpod
Future<List<String>> getPetTagsCollection(GetPetTagsCollectionRef ref) async {
  final repository = ref.watch(tagRepositoryProvider);
  return repository.getPetTagsCollection();
}

//GET USER TAGS
@Riverpod(keepAlive: true)
Stream<List<String>?> getUserTags(GetUserTagsRef ref, String tags) {
  final repository = ref.watch(tagRepositoryProvider);
  return repository.getUserTags(tags);
}

//SELECTED TAGS FAMILY PROVIDER
final selectedTagsProvider = StateProvider.family<List<String>, String>((ref, key) {
  final userTags = ref.read(getUserTagsProvider(key)).valueOrNull;
  return userTags ?? [];
});

//TAGS CONTROLLER
@riverpod
class TagController extends _$TagController {
  @override
  FutureOr<void> build() async {}

  //UPDATE TAGS
  Future<void> updateTags(String tagsId, List<String> tagsArray) async {
    final tagsRepository = ref.watch(tagRepositoryProvider);
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => tagsRepository.updateTags(tagsId, tagsArray));
  }
}
