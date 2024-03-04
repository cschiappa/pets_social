// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'prize_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$prizeRepositoryHash() => r'fd53d60e57c6be3b3484f4665162bc60f1b771d7';

/// See also [prizeRepository].
@ProviderFor(prizeRepository)
final prizeRepositoryProvider = Provider<PrizeRepository>.internal(
  prizeRepository,
  name: r'prizeRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$prizeRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef PrizeRepositoryRef = ProviderRef<PrizeRepository>;
String _$getUserPrizeDataHash() => r'0cbfbe411e67e8f2c811fc5db457ac954ca27250';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

/// See also [getUserPrizeData].
@ProviderFor(getUserPrizeData)
const getUserPrizeDataProvider = GetUserPrizeDataFamily();

/// See also [getUserPrizeData].
class GetUserPrizeDataFamily extends Family<AsyncValue<DocumentSnapshot?>> {
  /// See also [getUserPrizeData].
  const GetUserPrizeDataFamily();

  /// See also [getUserPrizeData].
  GetUserPrizeDataProvider call(
    String prizeType,
  ) {
    return GetUserPrizeDataProvider(
      prizeType,
    );
  }

  @override
  GetUserPrizeDataProvider getProviderOverride(
    covariant GetUserPrizeDataProvider provider,
  ) {
    return call(
      provider.prizeType,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'getUserPrizeDataProvider';
}

/// See also [getUserPrizeData].
class GetUserPrizeDataProvider
    extends AutoDisposeStreamProvider<DocumentSnapshot?> {
  /// See also [getUserPrizeData].
  GetUserPrizeDataProvider(
    String prizeType,
  ) : this._internal(
          (ref) => getUserPrizeData(
            ref as GetUserPrizeDataRef,
            prizeType,
          ),
          from: getUserPrizeDataProvider,
          name: r'getUserPrizeDataProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$getUserPrizeDataHash,
          dependencies: GetUserPrizeDataFamily._dependencies,
          allTransitiveDependencies:
              GetUserPrizeDataFamily._allTransitiveDependencies,
          prizeType: prizeType,
        );

  GetUserPrizeDataProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.prizeType,
  }) : super.internal();

  final String prizeType;

  @override
  Override overrideWith(
    Stream<DocumentSnapshot?> Function(GetUserPrizeDataRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: GetUserPrizeDataProvider._internal(
        (ref) => create(ref as GetUserPrizeDataRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        prizeType: prizeType,
      ),
    );
  }

  @override
  AutoDisposeStreamProviderElement<DocumentSnapshot?> createElement() {
    return _GetUserPrizeDataProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is GetUserPrizeDataProvider && other.prizeType == prizeType;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, prizeType.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin GetUserPrizeDataRef on AutoDisposeStreamProviderRef<DocumentSnapshot?> {
  /// The parameter `prizeType` of this provider.
  String get prizeType;
}

class _GetUserPrizeDataProviderElement
    extends AutoDisposeStreamProviderElement<DocumentSnapshot?>
    with GetUserPrizeDataRef {
  _GetUserPrizeDataProviderElement(super.provider);

  @override
  String get prizeType => (origin as GetUserPrizeDataProvider).prizeType;
}

String _$getPaidPrizesHash() => r'a4e584246d825595e7ebba2b9185c439a233b10a';

/// See also [getPaidPrizes].
@ProviderFor(getPaidPrizes)
final getPaidPrizesProvider =
    AutoDisposeFutureProvider<List<ModelPrize>>.internal(
  getPaidPrizes,
  name: r'getPaidPrizesProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$getPaidPrizesHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef GetPaidPrizesRef = AutoDisposeFutureProviderRef<List<ModelPrize>>;
String _$getProfilePrizesHash() => r'271af73bb141ca57355c8cf773e40f6375c8b5ae';

/// See also [getProfilePrizes].
@ProviderFor(getProfilePrizes)
const getProfilePrizesProvider = GetProfilePrizesFamily();

/// See also [getProfilePrizes].
class GetProfilePrizesFamily extends Family<AsyncValue<Map<String, int>>> {
  /// See also [getProfilePrizes].
  const GetProfilePrizesFamily();

  /// See also [getProfilePrizes].
  GetProfilePrizesProvider call(
    String profileUid,
  ) {
    return GetProfilePrizesProvider(
      profileUid,
    );
  }

  @override
  GetProfilePrizesProvider getProviderOverride(
    covariant GetProfilePrizesProvider provider,
  ) {
    return call(
      provider.profileUid,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'getProfilePrizesProvider';
}

/// See also [getProfilePrizes].
class GetProfilePrizesProvider
    extends AutoDisposeFutureProvider<Map<String, int>> {
  /// See also [getProfilePrizes].
  GetProfilePrizesProvider(
    String profileUid,
  ) : this._internal(
          (ref) => getProfilePrizes(
            ref as GetProfilePrizesRef,
            profileUid,
          ),
          from: getProfilePrizesProvider,
          name: r'getProfilePrizesProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$getProfilePrizesHash,
          dependencies: GetProfilePrizesFamily._dependencies,
          allTransitiveDependencies:
              GetProfilePrizesFamily._allTransitiveDependencies,
          profileUid: profileUid,
        );

  GetProfilePrizesProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.profileUid,
  }) : super.internal();

  final String profileUid;

  @override
  Override overrideWith(
    FutureOr<Map<String, int>> Function(GetProfilePrizesRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: GetProfilePrizesProvider._internal(
        (ref) => create(ref as GetProfilePrizesRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        profileUid: profileUid,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<Map<String, int>> createElement() {
    return _GetProfilePrizesProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is GetProfilePrizesProvider && other.profileUid == profileUid;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, profileUid.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin GetProfilePrizesRef on AutoDisposeFutureProviderRef<Map<String, int>> {
  /// The parameter `profileUid` of this provider.
  String get profileUid;
}

class _GetProfilePrizesProviderElement
    extends AutoDisposeFutureProviderElement<Map<String, int>>
    with GetProfilePrizesRef {
  _GetProfilePrizesProviderElement(super.provider);

  @override
  String get profileUid => (origin as GetProfilePrizesProvider).profileUid;
}

String _$prizeControllerHash() => r'95e131c4bb4992e7fb3c5a3426cc3d472b6bf3bb';

/// See also [PrizeController].
@ProviderFor(PrizeController)
final prizeControllerProvider =
    AutoDisposeAsyncNotifierProvider<PrizeController, void>.internal(
  PrizeController.new,
  name: r'prizeControllerProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$prizeControllerHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$PrizeController = AutoDisposeAsyncNotifier<void>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
