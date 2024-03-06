// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$profileRepositoryHash() => r'280e9d77aec88e38cf462ad0d6d94f9744700822';

/// See also [profileRepository].
@ProviderFor(profileRepository)
final profileRepositoryProvider = Provider<ProfileRepository>.internal(
  profileRepository,
  name: r'profileRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$profileRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef ProfileRepositoryRef = ProviderRef<ProfileRepository>;
String _$getProfileDataHash() => r'6b9eed477734b7f203bd15c6cd9049c02a1a51b2';

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

/// See also [getProfileData].
@ProviderFor(getProfileData)
const getProfileDataProvider = GetProfileDataFamily();

/// See also [getProfileData].
class GetProfileDataFamily extends Family<AsyncValue<ModelProfile>> {
  /// See also [getProfileData].
  const GetProfileDataFamily();

  /// See also [getProfileData].
  GetProfileDataProvider call(
    String profileUid,
  ) {
    return GetProfileDataProvider(
      profileUid,
    );
  }

  @override
  GetProfileDataProvider getProviderOverride(
    covariant GetProfileDataProvider provider,
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
  String? get name => r'getProfileDataProvider';
}

/// See also [getProfileData].
class GetProfileDataProvider extends AutoDisposeStreamProvider<ModelProfile> {
  /// See also [getProfileData].
  GetProfileDataProvider(
    String profileUid,
  ) : this._internal(
          (ref) => getProfileData(
            ref as GetProfileDataRef,
            profileUid,
          ),
          from: getProfileDataProvider,
          name: r'getProfileDataProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$getProfileDataHash,
          dependencies: GetProfileDataFamily._dependencies,
          allTransitiveDependencies:
              GetProfileDataFamily._allTransitiveDependencies,
          profileUid: profileUid,
        );

  GetProfileDataProvider._internal(
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
    Stream<ModelProfile> Function(GetProfileDataRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: GetProfileDataProvider._internal(
        (ref) => create(ref as GetProfileDataRef),
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
  AutoDisposeStreamProviderElement<ModelProfile> createElement() {
    return _GetProfileDataProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is GetProfileDataProvider && other.profileUid == profileUid;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, profileUid.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin GetProfileDataRef on AutoDisposeStreamProviderRef<ModelProfile> {
  /// The parameter `profileUid` of this provider.
  String get profileUid;
}

class _GetProfileDataProviderElement
    extends AutoDisposeStreamProviderElement<ModelProfile>
    with GetProfileDataRef {
  _GetProfileDataProviderElement(super.provider);

  @override
  String get profileUid => (origin as GetProfileDataProvider).profileUid;
}

String _$getBlockedProfilesHash() =>
    r'fbc0968fae200c66bf455abc626ddbaa99de4b46';

/// See also [getBlockedProfiles].
@ProviderFor(getBlockedProfiles)
const getBlockedProfilesProvider = GetBlockedProfilesFamily();

/// See also [getBlockedProfiles].
class GetBlockedProfilesFamily
    extends Family<AsyncValue<QuerySnapshot<Map<String, dynamic>>>> {
  /// See also [getBlockedProfiles].
  const GetBlockedProfilesFamily();

  /// See also [getBlockedProfiles].
  GetBlockedProfilesProvider call(
    List<dynamic>? blockedProfiles,
  ) {
    return GetBlockedProfilesProvider(
      blockedProfiles,
    );
  }

  @override
  GetBlockedProfilesProvider getProviderOverride(
    covariant GetBlockedProfilesProvider provider,
  ) {
    return call(
      provider.blockedProfiles,
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
  String? get name => r'getBlockedProfilesProvider';
}

/// See also [getBlockedProfiles].
class GetBlockedProfilesProvider
    extends AutoDisposeStreamProvider<QuerySnapshot<Map<String, dynamic>>> {
  /// See also [getBlockedProfiles].
  GetBlockedProfilesProvider(
    List<dynamic>? blockedProfiles,
  ) : this._internal(
          (ref) => getBlockedProfiles(
            ref as GetBlockedProfilesRef,
            blockedProfiles,
          ),
          from: getBlockedProfilesProvider,
          name: r'getBlockedProfilesProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$getBlockedProfilesHash,
          dependencies: GetBlockedProfilesFamily._dependencies,
          allTransitiveDependencies:
              GetBlockedProfilesFamily._allTransitiveDependencies,
          blockedProfiles: blockedProfiles,
        );

  GetBlockedProfilesProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.blockedProfiles,
  }) : super.internal();

  final List<dynamic>? blockedProfiles;

  @override
  Override overrideWith(
    Stream<QuerySnapshot<Map<String, dynamic>>> Function(
            GetBlockedProfilesRef provider)
        create,
  ) {
    return ProviderOverride(
      origin: this,
      override: GetBlockedProfilesProvider._internal(
        (ref) => create(ref as GetBlockedProfilesRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        blockedProfiles: blockedProfiles,
      ),
    );
  }

  @override
  AutoDisposeStreamProviderElement<QuerySnapshot<Map<String, dynamic>>>
      createElement() {
    return _GetBlockedProfilesProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is GetBlockedProfilesProvider &&
        other.blockedProfiles == blockedProfiles;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, blockedProfiles.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin GetBlockedProfilesRef
    on AutoDisposeStreamProviderRef<QuerySnapshot<Map<String, dynamic>>> {
  /// The parameter `blockedProfiles` of this provider.
  List<dynamic>? get blockedProfiles;
}

class _GetBlockedProfilesProviderElement
    extends AutoDisposeStreamProviderElement<
        QuerySnapshot<Map<String, dynamic>>> with GetBlockedProfilesRef {
  _GetBlockedProfilesProviderElement(super.provider);

  @override
  List<dynamic>? get blockedProfiles =>
      (origin as GetBlockedProfilesProvider).blockedProfiles;
}

String _$getAccountProfilesHash() =>
    r'01c8c432fae31a20c0ffd93bb831045567f9a93a';

/// See also [getAccountProfiles].
@ProviderFor(getAccountProfiles)
final getAccountProfilesProvider =
    AutoDisposeStreamProvider<QuerySnapshot<Map<String, dynamic>>>.internal(
  getAccountProfiles,
  name: r'getAccountProfilesProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$getAccountProfilesHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef GetAccountProfilesRef
    = AutoDisposeStreamProviderRef<QuerySnapshot<Map<String, dynamic>>>;
String _$getProfileFromPostHash() =>
    r'97475f8e5664f934d6b0416297a5d5a071b79949';

/// See also [getProfileFromPost].
@ProviderFor(getProfileFromPost)
const getProfileFromPostProvider = GetProfileFromPostFamily();

/// See also [getProfileFromPost].
class GetProfileFromPostFamily extends Family<AsyncValue<ModelProfile>> {
  /// See also [getProfileFromPost].
  const GetProfileFromPostFamily();

  /// See also [getProfileFromPost].
  GetProfileFromPostProvider call(
    String profileUid,
  ) {
    return GetProfileFromPostProvider(
      profileUid,
    );
  }

  @override
  GetProfileFromPostProvider getProviderOverride(
    covariant GetProfileFromPostProvider provider,
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
  String? get name => r'getProfileFromPostProvider';
}

/// See also [getProfileFromPost].
class GetProfileFromPostProvider
    extends AutoDisposeFutureProvider<ModelProfile> {
  /// See also [getProfileFromPost].
  GetProfileFromPostProvider(
    String profileUid,
  ) : this._internal(
          (ref) => getProfileFromPost(
            ref as GetProfileFromPostRef,
            profileUid,
          ),
          from: getProfileFromPostProvider,
          name: r'getProfileFromPostProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$getProfileFromPostHash,
          dependencies: GetProfileFromPostFamily._dependencies,
          allTransitiveDependencies:
              GetProfileFromPostFamily._allTransitiveDependencies,
          profileUid: profileUid,
        );

  GetProfileFromPostProvider._internal(
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
    FutureOr<ModelProfile> Function(GetProfileFromPostRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: GetProfileFromPostProvider._internal(
        (ref) => create(ref as GetProfileFromPostRef),
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
  AutoDisposeFutureProviderElement<ModelProfile> createElement() {
    return _GetProfileFromPostProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is GetProfileFromPostProvider &&
        other.profileUid == profileUid;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, profileUid.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin GetProfileFromPostRef on AutoDisposeFutureProviderRef<ModelProfile> {
  /// The parameter `profileUid` of this provider.
  String get profileUid;
}

class _GetProfileFromPostProviderElement
    extends AutoDisposeFutureProviderElement<ModelProfile>
    with GetProfileFromPostRef {
  _GetProfileFromPostProviderElement(super.provider);

  @override
  String get profileUid => (origin as GetProfileFromPostProvider).profileUid;
}

String _$isUsernameAvailableHash() =>
    r'020cda3d5583ebc340a38ca87aa80c1223401556';

/// See also [isUsernameAvailable].
@ProviderFor(isUsernameAvailable)
const isUsernameAvailableProvider = IsUsernameAvailableFamily();

/// See also [isUsernameAvailable].
class IsUsernameAvailableFamily extends Family<AsyncValue<bool>> {
  /// See also [isUsernameAvailable].
  const IsUsernameAvailableFamily();

  /// See also [isUsernameAvailable].
  IsUsernameAvailableProvider call(
    String? username,
  ) {
    return IsUsernameAvailableProvider(
      username,
    );
  }

  @override
  IsUsernameAvailableProvider getProviderOverride(
    covariant IsUsernameAvailableProvider provider,
  ) {
    return call(
      provider.username,
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
  String? get name => r'isUsernameAvailableProvider';
}

/// See also [isUsernameAvailable].
class IsUsernameAvailableProvider extends AutoDisposeFutureProvider<bool> {
  /// See also [isUsernameAvailable].
  IsUsernameAvailableProvider(
    String? username,
  ) : this._internal(
          (ref) => isUsernameAvailable(
            ref as IsUsernameAvailableRef,
            username,
          ),
          from: isUsernameAvailableProvider,
          name: r'isUsernameAvailableProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$isUsernameAvailableHash,
          dependencies: IsUsernameAvailableFamily._dependencies,
          allTransitiveDependencies:
              IsUsernameAvailableFamily._allTransitiveDependencies,
          username: username,
        );

  IsUsernameAvailableProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.username,
  }) : super.internal();

  final String? username;

  @override
  Override overrideWith(
    FutureOr<bool> Function(IsUsernameAvailableRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: IsUsernameAvailableProvider._internal(
        (ref) => create(ref as IsUsernameAvailableRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        username: username,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<bool> createElement() {
    return _IsUsernameAvailableProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is IsUsernameAvailableProvider && other.username == username;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, username.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin IsUsernameAvailableRef on AutoDisposeFutureProviderRef<bool> {
  /// The parameter `username` of this provider.
  String? get username;
}

class _IsUsernameAvailableProviderElement
    extends AutoDisposeFutureProviderElement<bool> with IsUsernameAvailableRef {
  _IsUsernameAvailableProviderElement(super.provider);

  @override
  String? get username => (origin as IsUsernameAvailableProvider).username;
}

String _$isEmailAvailableHash() => r'bc19dbbbc349f8ed3c7d2488c718e39f339297a9';

/// See also [isEmailAvailable].
@ProviderFor(isEmailAvailable)
const isEmailAvailableProvider = IsEmailAvailableFamily();

/// See also [isEmailAvailable].
class IsEmailAvailableFamily extends Family<AsyncValue<bool>> {
  /// See also [isEmailAvailable].
  const IsEmailAvailableFamily();

  /// See also [isEmailAvailable].
  IsEmailAvailableProvider call(
    String? email,
  ) {
    return IsEmailAvailableProvider(
      email,
    );
  }

  @override
  IsEmailAvailableProvider getProviderOverride(
    covariant IsEmailAvailableProvider provider,
  ) {
    return call(
      provider.email,
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
  String? get name => r'isEmailAvailableProvider';
}

/// See also [isEmailAvailable].
class IsEmailAvailableProvider extends AutoDisposeFutureProvider<bool> {
  /// See also [isEmailAvailable].
  IsEmailAvailableProvider(
    String? email,
  ) : this._internal(
          (ref) => isEmailAvailable(
            ref as IsEmailAvailableRef,
            email,
          ),
          from: isEmailAvailableProvider,
          name: r'isEmailAvailableProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$isEmailAvailableHash,
          dependencies: IsEmailAvailableFamily._dependencies,
          allTransitiveDependencies:
              IsEmailAvailableFamily._allTransitiveDependencies,
          email: email,
        );

  IsEmailAvailableProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.email,
  }) : super.internal();

  final String? email;

  @override
  Override overrideWith(
    FutureOr<bool> Function(IsEmailAvailableRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: IsEmailAvailableProvider._internal(
        (ref) => create(ref as IsEmailAvailableRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        email: email,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<bool> createElement() {
    return _IsEmailAvailableProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is IsEmailAvailableProvider && other.email == email;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, email.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin IsEmailAvailableRef on AutoDisposeFutureProviderRef<bool> {
  /// The parameter `email` of this provider.
  String? get email;
}

class _IsEmailAvailableProviderElement
    extends AutoDisposeFutureProviderElement<bool> with IsEmailAvailableRef {
  _IsEmailAvailableProviderElement(super.provider);

  @override
  String? get email => (origin as IsEmailAvailableProvider).email;
}

String _$fetchProfilePrizeQuantityHash() =>
    r'eb26f4ede1ebbf5b54fa7b90bd522f4cbf2b3ce4';

/// See also [fetchProfilePrizeQuantity].
@ProviderFor(fetchProfilePrizeQuantity)
const fetchProfilePrizeQuantityProvider = FetchProfilePrizeQuantityFamily();

/// See also [fetchProfilePrizeQuantity].
class FetchProfilePrizeQuantityFamily extends Family<AsyncValue<int>> {
  /// See also [fetchProfilePrizeQuantity].
  const FetchProfilePrizeQuantityFamily();

  /// See also [fetchProfilePrizeQuantity].
  FetchProfilePrizeQuantityProvider call(
    String profileUid,
    String prizeType,
  ) {
    return FetchProfilePrizeQuantityProvider(
      profileUid,
      prizeType,
    );
  }

  @override
  FetchProfilePrizeQuantityProvider getProviderOverride(
    covariant FetchProfilePrizeQuantityProvider provider,
  ) {
    return call(
      provider.profileUid,
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
  String? get name => r'fetchProfilePrizeQuantityProvider';
}

/// See also [fetchProfilePrizeQuantity].
class FetchProfilePrizeQuantityProvider extends AutoDisposeFutureProvider<int> {
  /// See also [fetchProfilePrizeQuantity].
  FetchProfilePrizeQuantityProvider(
    String profileUid,
    String prizeType,
  ) : this._internal(
          (ref) => fetchProfilePrizeQuantity(
            ref as FetchProfilePrizeQuantityRef,
            profileUid,
            prizeType,
          ),
          from: fetchProfilePrizeQuantityProvider,
          name: r'fetchProfilePrizeQuantityProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$fetchProfilePrizeQuantityHash,
          dependencies: FetchProfilePrizeQuantityFamily._dependencies,
          allTransitiveDependencies:
              FetchProfilePrizeQuantityFamily._allTransitiveDependencies,
          profileUid: profileUid,
          prizeType: prizeType,
        );

  FetchProfilePrizeQuantityProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.profileUid,
    required this.prizeType,
  }) : super.internal();

  final String profileUid;
  final String prizeType;

  @override
  Override overrideWith(
    FutureOr<int> Function(FetchProfilePrizeQuantityRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: FetchProfilePrizeQuantityProvider._internal(
        (ref) => create(ref as FetchProfilePrizeQuantityRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        profileUid: profileUid,
        prizeType: prizeType,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<int> createElement() {
    return _FetchProfilePrizeQuantityProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is FetchProfilePrizeQuantityProvider &&
        other.profileUid == profileUid &&
        other.prizeType == prizeType;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, profileUid.hashCode);
    hash = _SystemHash.combine(hash, prizeType.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin FetchProfilePrizeQuantityRef on AutoDisposeFutureProviderRef<int> {
  /// The parameter `profileUid` of this provider.
  String get profileUid;

  /// The parameter `prizeType` of this provider.
  String get prizeType;
}

class _FetchProfilePrizeQuantityProviderElement
    extends AutoDisposeFutureProviderElement<int>
    with FetchProfilePrizeQuantityRef {
  _FetchProfilePrizeQuantityProviderElement(super.provider);

  @override
  String get profileUid =>
      (origin as FetchProfilePrizeQuantityProvider).profileUid;
  @override
  String get prizeType =>
      (origin as FetchProfilePrizeQuantityProvider).prizeType;
}

String _$profileControllerHash() => r'03a98e0fda6741dd6e7ec8904a8b1e056529d001';

/// See also [ProfileController].
@ProviderFor(ProfileController)
final profileControllerProvider =
    AutoDisposeAsyncNotifierProvider<ProfileController, void>.internal(
  ProfileController.new,
  name: r'profileControllerProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$profileControllerHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$ProfileController = AutoDisposeAsyncNotifier<void>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
