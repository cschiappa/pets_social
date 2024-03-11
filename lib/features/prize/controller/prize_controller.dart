import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pets_social/core/providers/firebase_providers.dart';
import 'package:pets_social/features/post/controller/post_controller.dart';
import 'package:pets_social/features/prize/repository/prize_repository.dart';
import 'package:pets_social/models/prize.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'prize_controller.g.dart';

//PRIZE REPOSITORY PROVIDER
@Riverpod(keepAlive: true)
PrizeRepository prizeRepository(PrizeRepositoryRef ref) {
  return PrizeRepository(
    firestore: ref.read(firestoreProvider),
    auth: ref.read(authProvider),
  );
}

final quantityProvider = StateProvider<int>((ref) {
  return 1;
});

final totalPriceProvider = ProviderFamily<int, int>((ref, price) {
  int quantity = ref.watch(quantityProvider);
  int totalPrice = quantity * price;
  return totalPrice;
});

//GET USER PRIZE DATA
@riverpod
Stream<DocumentSnapshot?> getUserPrizeData(GetUserPrizeDataRef ref, String prizeType) {
  final repository = ref.watch(prizeRepositoryProvider);
  return repository.getUserPrizeData(prizeType);
}

//GET PAID PRIZES
@riverpod
Future<List<ModelPrize>> getPaidPrizes(GetPaidPrizesRef ref) async {
  final repository = ref.watch(prizeRepositoryProvider);
  return repository.getPaidPrizes();
}

//GET EVERY PRIZE THE PROFILE HAS RECEIVED
@riverpod
Future<Map<String, int>> getProfilePrizes(GetProfilePrizesRef ref, String profileUid) async {
  final repository = ref.watch(prizeRepositoryProvider);
  return repository.getProfilePrizes(profileUid);
}

@riverpod
class PrizeController extends _$PrizeController {
  @override
  FutureOr<void> build() async {}

  //GIVE PRIZE
  Future<void> buyLizzyCoins(int quantity) async {
    final prizeRepository = ref.read(prizeRepositoryProvider);
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => prizeRepository.buyLizzyCoins(quantity));
  }

  //GIVE PRIZE
  Future<void> buyPrize(String prizeType, int quantity, int price) async {
    final prizeRepository = ref.read(prizeRepositoryProvider);
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => prizeRepository.buyPrize(prizeType, quantity, price));
  }
}
