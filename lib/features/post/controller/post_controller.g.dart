// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$postRepositoryHash() => r'4bbd5074119f8c0acb16127ee14e58cf3add80ff';

/// See also [postRepository].
@ProviderFor(postRepository)
final postRepositoryProvider = Provider<PostRepository>.internal(
  postRepository,
  name: r'postRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$postRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef PostRepositoryRef = ProviderRef<PostRepository>;
String _$getPostsDescendingHash() =>
    r'5fa11a5247308ba2beba252475871a78c9df86d9';

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

/// See also [getPostsDescending].
@ProviderFor(getPostsDescending)
const getPostsDescendingProvider = GetPostsDescendingFamily();

/// See also [getPostsDescending].
class GetPostsDescendingFamily extends Family<AsyncValue<List<ModelPost>>> {
  /// See also [getPostsDescending].
  const GetPostsDescendingFamily();

  /// See also [getPostsDescending].
  GetPostsDescendingProvider call(
    ModelAccount account,
    ModelProfile profile,
  ) {
    return GetPostsDescendingProvider(
      account,
      profile,
    );
  }

  @override
  GetPostsDescendingProvider getProviderOverride(
    covariant GetPostsDescendingProvider provider,
  ) {
    return call(
      provider.account,
      provider.profile,
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
  String? get name => r'getPostsDescendingProvider';
}

/// See also [getPostsDescending].
class GetPostsDescendingProvider
    extends AutoDisposeFutureProvider<List<ModelPost>> {
  /// See also [getPostsDescending].
  GetPostsDescendingProvider(
    ModelAccount account,
    ModelProfile profile,
  ) : this._internal(
          (ref) => getPostsDescending(
            ref as GetPostsDescendingRef,
            account,
            profile,
          ),
          from: getPostsDescendingProvider,
          name: r'getPostsDescendingProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$getPostsDescendingHash,
          dependencies: GetPostsDescendingFamily._dependencies,
          allTransitiveDependencies:
              GetPostsDescendingFamily._allTransitiveDependencies,
          account: account,
          profile: profile,
        );

  GetPostsDescendingProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.account,
    required this.profile,
  }) : super.internal();

  final ModelAccount account;
  final ModelProfile profile;

  @override
  Override overrideWith(
    FutureOr<List<ModelPost>> Function(GetPostsDescendingRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: GetPostsDescendingProvider._internal(
        (ref) => create(ref as GetPostsDescendingRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        account: account,
        profile: profile,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<ModelPost>> createElement() {
    return _GetPostsDescendingProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is GetPostsDescendingProvider &&
        other.account == account &&
        other.profile == profile;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, account.hashCode);
    hash = _SystemHash.combine(hash, profile.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin GetPostsDescendingRef on AutoDisposeFutureProviderRef<List<ModelPost>> {
  /// The parameter `account` of this provider.
  ModelAccount get account;

  /// The parameter `profile` of this provider.
  ModelProfile get profile;
}

class _GetPostsDescendingProviderElement
    extends AutoDisposeFutureProviderElement<List<ModelPost>>
    with GetPostsDescendingRef {
  _GetPostsDescendingProviderElement(super.provider);

  @override
  ModelAccount get account => (origin as GetPostsDescendingProvider).account;
  @override
  ModelProfile get profile => (origin as GetPostsDescendingProvider).profile;
}

String _$getFeedPostsHash() => r'c5002a5c60e4513acaf641a0d4bc7140a6fe8cd6';

/// See also [getFeedPosts].
@ProviderFor(getFeedPosts)
const getFeedPostsProvider = GetFeedPostsFamily();

/// See also [getFeedPosts].
class GetFeedPostsFamily extends Family<AsyncValue<List<DocumentSnapshot>>> {
  /// See also [getFeedPosts].
  const GetFeedPostsFamily();

  /// See also [getFeedPosts].
  GetFeedPostsProvider call(
    ModelProfile? profile,
  ) {
    return GetFeedPostsProvider(
      profile,
    );
  }

  @override
  GetFeedPostsProvider getProviderOverride(
    covariant GetFeedPostsProvider provider,
  ) {
    return call(
      provider.profile,
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
  String? get name => r'getFeedPostsProvider';
}

/// See also [getFeedPosts].
class GetFeedPostsProvider
    extends AutoDisposeStreamProvider<List<DocumentSnapshot>> {
  /// See also [getFeedPosts].
  GetFeedPostsProvider(
    ModelProfile? profile,
  ) : this._internal(
          (ref) => getFeedPosts(
            ref as GetFeedPostsRef,
            profile,
          ),
          from: getFeedPostsProvider,
          name: r'getFeedPostsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$getFeedPostsHash,
          dependencies: GetFeedPostsFamily._dependencies,
          allTransitiveDependencies:
              GetFeedPostsFamily._allTransitiveDependencies,
          profile: profile,
        );

  GetFeedPostsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.profile,
  }) : super.internal();

  final ModelProfile? profile;

  @override
  Override overrideWith(
    Stream<List<DocumentSnapshot>> Function(GetFeedPostsRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: GetFeedPostsProvider._internal(
        (ref) => create(ref as GetFeedPostsRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        profile: profile,
      ),
    );
  }

  @override
  AutoDisposeStreamProviderElement<List<DocumentSnapshot>> createElement() {
    return _GetFeedPostsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is GetFeedPostsProvider && other.profile == profile;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, profile.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin GetFeedPostsRef on AutoDisposeStreamProviderRef<List<DocumentSnapshot>> {
  /// The parameter `profile` of this provider.
  ModelProfile? get profile;
}

class _GetFeedPostsProviderElement
    extends AutoDisposeStreamProviderElement<List<DocumentSnapshot>>
    with GetFeedPostsRef {
  _GetFeedPostsProviderElement(super.provider);

  @override
  ModelProfile? get profile => (origin as GetFeedPostsProvider).profile;
}

String _$getSavedPostsHash() => r'ff9bfc01bf414b17653aea9fc1668fc6c95f4fd9';

/// See also [getSavedPosts].
@ProviderFor(getSavedPosts)
const getSavedPostsProvider = GetSavedPostsFamily();

/// See also [getSavedPosts].
class GetSavedPostsFamily extends Family<AsyncValue<List<ModelPost>>> {
  /// See also [getSavedPosts].
  const GetSavedPostsFamily();

  /// See also [getSavedPosts].
  GetSavedPostsProvider call(
    List<dynamic> savedPosts,
  ) {
    return GetSavedPostsProvider(
      savedPosts,
    );
  }

  @override
  GetSavedPostsProvider getProviderOverride(
    covariant GetSavedPostsProvider provider,
  ) {
    return call(
      provider.savedPosts,
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
  String? get name => r'getSavedPostsProvider';
}

/// See also [getSavedPosts].
class GetSavedPostsProvider extends AutoDisposeStreamProvider<List<ModelPost>> {
  /// See also [getSavedPosts].
  GetSavedPostsProvider(
    List<dynamic> savedPosts,
  ) : this._internal(
          (ref) => getSavedPosts(
            ref as GetSavedPostsRef,
            savedPosts,
          ),
          from: getSavedPostsProvider,
          name: r'getSavedPostsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$getSavedPostsHash,
          dependencies: GetSavedPostsFamily._dependencies,
          allTransitiveDependencies:
              GetSavedPostsFamily._allTransitiveDependencies,
          savedPosts: savedPosts,
        );

  GetSavedPostsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.savedPosts,
  }) : super.internal();

  final List<dynamic> savedPosts;

  @override
  Override overrideWith(
    Stream<List<ModelPost>> Function(GetSavedPostsRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: GetSavedPostsProvider._internal(
        (ref) => create(ref as GetSavedPostsRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        savedPosts: savedPosts,
      ),
    );
  }

  @override
  AutoDisposeStreamProviderElement<List<ModelPost>> createElement() {
    return _GetSavedPostsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is GetSavedPostsProvider && other.savedPosts == savedPosts;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, savedPosts.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin GetSavedPostsRef on AutoDisposeStreamProviderRef<List<ModelPost>> {
  /// The parameter `savedPosts` of this provider.
  List<dynamic> get savedPosts;
}

class _GetSavedPostsProviderElement
    extends AutoDisposeStreamProviderElement<List<ModelPost>>
    with GetSavedPostsRef {
  _GetSavedPostsProviderElement(super.provider);

  @override
  List<dynamic> get savedPosts => (origin as GetSavedPostsProvider).savedPosts;
}

String _$savedPostsStreamHash() => r'159f3ebaafa3fd1de41e12c93d74410e1a24ca7f';

/// See also [savedPostsStream].
@ProviderFor(savedPostsStream)
final savedPostsStreamProvider = AutoDisposeStreamProvider<List>.internal(
  savedPostsStream,
  name: r'savedPostsStreamProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$savedPostsStreamHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef SavedPostsStreamRef = AutoDisposeStreamProviderRef<List>;
String _$getCommentsHash() => r'668fe25707d6871b1032112b8cc3809787539ad1';

/// See also [getComments].
@ProviderFor(getComments)
const getCommentsProvider = GetCommentsFamily();

/// See also [getComments].
class GetCommentsFamily extends Family<AsyncValue<List<ModelComment>>> {
  /// See also [getComments].
  const GetCommentsFamily();

  /// See also [getComments].
  GetCommentsProvider call(
    String postId,
  ) {
    return GetCommentsProvider(
      postId,
    );
  }

  @override
  GetCommentsProvider getProviderOverride(
    covariant GetCommentsProvider provider,
  ) {
    return call(
      provider.postId,
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
  String? get name => r'getCommentsProvider';
}

/// See also [getComments].
class GetCommentsProvider
    extends AutoDisposeStreamProvider<List<ModelComment>> {
  /// See also [getComments].
  GetCommentsProvider(
    String postId,
  ) : this._internal(
          (ref) => getComments(
            ref as GetCommentsRef,
            postId,
          ),
          from: getCommentsProvider,
          name: r'getCommentsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$getCommentsHash,
          dependencies: GetCommentsFamily._dependencies,
          allTransitiveDependencies:
              GetCommentsFamily._allTransitiveDependencies,
          postId: postId,
        );

  GetCommentsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.postId,
  }) : super.internal();

  final String postId;

  @override
  Override overrideWith(
    Stream<List<ModelComment>> Function(GetCommentsRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: GetCommentsProvider._internal(
        (ref) => create(ref as GetCommentsRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        postId: postId,
      ),
    );
  }

  @override
  AutoDisposeStreamProviderElement<List<ModelComment>> createElement() {
    return _GetCommentsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is GetCommentsProvider && other.postId == postId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, postId.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin GetCommentsRef on AutoDisposeStreamProviderRef<List<ModelComment>> {
  /// The parameter `postId` of this provider.
  String get postId;
}

class _GetCommentsProviderElement
    extends AutoDisposeStreamProviderElement<List<ModelComment>>
    with GetCommentsRef {
  _GetCommentsProviderElement(super.provider);

  @override
  String get postId => (origin as GetCommentsProvider).postId;
}

String _$getProfilePostsHash() => r'9a64973b1d64b402ec369074ada9b62e6c5abe4a';

/// See also [getProfilePosts].
@ProviderFor(getProfilePosts)
const getProfilePostsProvider = GetProfilePostsFamily();

/// See also [getProfilePosts].
class GetProfilePostsFamily
    extends Family<AsyncValue<QuerySnapshot<Map<String, dynamic>>>> {
  /// See also [getProfilePosts].
  const GetProfilePostsFamily();

  /// See also [getProfilePosts].
  GetProfilePostsProvider call(
    String profileUid,
  ) {
    return GetProfilePostsProvider(
      profileUid,
    );
  }

  @override
  GetProfilePostsProvider getProviderOverride(
    covariant GetProfilePostsProvider provider,
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
  String? get name => r'getProfilePostsProvider';
}

/// See also [getProfilePosts].
class GetProfilePostsProvider
    extends AutoDisposeStreamProvider<QuerySnapshot<Map<String, dynamic>>> {
  /// See also [getProfilePosts].
  GetProfilePostsProvider(
    String profileUid,
  ) : this._internal(
          (ref) => getProfilePosts(
            ref as GetProfilePostsRef,
            profileUid,
          ),
          from: getProfilePostsProvider,
          name: r'getProfilePostsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$getProfilePostsHash,
          dependencies: GetProfilePostsFamily._dependencies,
          allTransitiveDependencies:
              GetProfilePostsFamily._allTransitiveDependencies,
          profileUid: profileUid,
        );

  GetProfilePostsProvider._internal(
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
    Stream<QuerySnapshot<Map<String, dynamic>>> Function(
            GetProfilePostsRef provider)
        create,
  ) {
    return ProviderOverride(
      origin: this,
      override: GetProfilePostsProvider._internal(
        (ref) => create(ref as GetProfilePostsRef),
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
  AutoDisposeStreamProviderElement<QuerySnapshot<Map<String, dynamic>>>
      createElement() {
    return _GetProfilePostsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is GetProfilePostsProvider && other.profileUid == profileUid;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, profileUid.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin GetProfilePostsRef
    on AutoDisposeStreamProviderRef<QuerySnapshot<Map<String, dynamic>>> {
  /// The parameter `profileUid` of this provider.
  String get profileUid;
}

class _GetProfilePostsProviderElement extends AutoDisposeStreamProviderElement<
    QuerySnapshot<Map<String, dynamic>>> with GetProfilePostsRef {
  _GetProfilePostsProviderElement(super.provider);

  @override
  String get profileUid => (origin as GetProfilePostsProvider).profileUid;
}

String _$getPrizesFromPostHash() => r'2019223660be89323c544ed6921d5b64c759c58f';

/// See also [getPrizesFromPost].
@ProviderFor(getPrizesFromPost)
const getPrizesFromPostProvider = GetPrizesFromPostFamily();

/// See also [getPrizesFromPost].
class GetPrizesFromPostFamily extends Family<AsyncValue<List<ModelPrize>>> {
  /// See also [getPrizesFromPost].
  const GetPrizesFromPostFamily();

  /// See also [getPrizesFromPost].
  GetPrizesFromPostProvider call(
    String postId,
  ) {
    return GetPrizesFromPostProvider(
      postId,
    );
  }

  @override
  GetPrizesFromPostProvider getProviderOverride(
    covariant GetPrizesFromPostProvider provider,
  ) {
    return call(
      provider.postId,
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
  String? get name => r'getPrizesFromPostProvider';
}

/// See also [getPrizesFromPost].
class GetPrizesFromPostProvider
    extends AutoDisposeFutureProvider<List<ModelPrize>> {
  /// See also [getPrizesFromPost].
  GetPrizesFromPostProvider(
    String postId,
  ) : this._internal(
          (ref) => getPrizesFromPost(
            ref as GetPrizesFromPostRef,
            postId,
          ),
          from: getPrizesFromPostProvider,
          name: r'getPrizesFromPostProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$getPrizesFromPostHash,
          dependencies: GetPrizesFromPostFamily._dependencies,
          allTransitiveDependencies:
              GetPrizesFromPostFamily._allTransitiveDependencies,
          postId: postId,
        );

  GetPrizesFromPostProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.postId,
  }) : super.internal();

  final String postId;

  @override
  Override overrideWith(
    FutureOr<List<ModelPrize>> Function(GetPrizesFromPostRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: GetPrizesFromPostProvider._internal(
        (ref) => create(ref as GetPrizesFromPostRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        postId: postId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<ModelPrize>> createElement() {
    return _GetPrizesFromPostProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is GetPrizesFromPostProvider && other.postId == postId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, postId.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin GetPrizesFromPostRef on AutoDisposeFutureProviderRef<List<ModelPrize>> {
  /// The parameter `postId` of this provider.
  String get postId;
}

class _GetPrizesFromPostProviderElement
    extends AutoDisposeFutureProviderElement<List<ModelPrize>>
    with GetPrizesFromPostRef {
  _GetPrizesFromPostProviderElement(super.provider);

  @override
  String get postId => (origin as GetPrizesFromPostProvider).postId;
}

String _$getPostByIdHash() => r'c8f1f44aac38da3bf567706b92a32af92dc6d7b6';

/// See also [getPostById].
@ProviderFor(getPostById)
const getPostByIdProvider = GetPostByIdFamily();

/// See also [getPostById].
class GetPostByIdFamily extends Family<AsyncValue<ModelPost>> {
  /// See also [getPostById].
  const GetPostByIdFamily();

  /// See also [getPostById].
  GetPostByIdProvider call(
    String postId,
  ) {
    return GetPostByIdProvider(
      postId,
    );
  }

  @override
  GetPostByIdProvider getProviderOverride(
    covariant GetPostByIdProvider provider,
  ) {
    return call(
      provider.postId,
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
  String? get name => r'getPostByIdProvider';
}

/// See also [getPostById].
class GetPostByIdProvider extends AutoDisposeStreamProvider<ModelPost> {
  /// See also [getPostById].
  GetPostByIdProvider(
    String postId,
  ) : this._internal(
          (ref) => getPostById(
            ref as GetPostByIdRef,
            postId,
          ),
          from: getPostByIdProvider,
          name: r'getPostByIdProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$getPostByIdHash,
          dependencies: GetPostByIdFamily._dependencies,
          allTransitiveDependencies:
              GetPostByIdFamily._allTransitiveDependencies,
          postId: postId,
        );

  GetPostByIdProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.postId,
  }) : super.internal();

  final String postId;

  @override
  Override overrideWith(
    Stream<ModelPost> Function(GetPostByIdRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: GetPostByIdProvider._internal(
        (ref) => create(ref as GetPostByIdRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        postId: postId,
      ),
    );
  }

  @override
  AutoDisposeStreamProviderElement<ModelPost> createElement() {
    return _GetPostByIdProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is GetPostByIdProvider && other.postId == postId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, postId.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin GetPostByIdRef on AutoDisposeStreamProviderRef<ModelPost> {
  /// The parameter `postId` of this provider.
  String get postId;
}

class _GetPostByIdProviderElement
    extends AutoDisposeStreamProviderElement<ModelPost> with GetPostByIdRef {
  _GetPostByIdProviderElement(super.provider);

  @override
  String get postId => (origin as GetPostByIdProvider).postId;
}

String _$getPrizesHash() => r'817d2b37529b079087b2c2648ef09b3dd5fb2906';

/// See also [getPrizes].
@ProviderFor(getPrizes)
final getPrizesProvider = FutureProvider<List<ModelPrize>>.internal(
  getPrizes,
  name: r'getPrizesProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$getPrizesHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef GetPrizesRef = FutureProviderRef<List<ModelPrize>>;
String _$getPostPrizeDataHash() => r'7e09e8ce257486c63643eb44a95ae319565673f4';

/// See also [getPostPrizeData].
@ProviderFor(getPostPrizeData)
const getPostPrizeDataProvider = GetPostPrizeDataFamily();

/// See also [getPostPrizeData].
class GetPostPrizeDataFamily extends Family<AsyncValue<DocumentSnapshot?>> {
  /// See also [getPostPrizeData].
  const GetPostPrizeDataFamily();

  /// See also [getPostPrizeData].
  GetPostPrizeDataProvider call(
    String postId,
    String prizeType,
  ) {
    return GetPostPrizeDataProvider(
      postId,
      prizeType,
    );
  }

  @override
  GetPostPrizeDataProvider getProviderOverride(
    covariant GetPostPrizeDataProvider provider,
  ) {
    return call(
      provider.postId,
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
  String? get name => r'getPostPrizeDataProvider';
}

/// See also [getPostPrizeData].
class GetPostPrizeDataProvider
    extends AutoDisposeStreamProvider<DocumentSnapshot?> {
  /// See also [getPostPrizeData].
  GetPostPrizeDataProvider(
    String postId,
    String prizeType,
  ) : this._internal(
          (ref) => getPostPrizeData(
            ref as GetPostPrizeDataRef,
            postId,
            prizeType,
          ),
          from: getPostPrizeDataProvider,
          name: r'getPostPrizeDataProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$getPostPrizeDataHash,
          dependencies: GetPostPrizeDataFamily._dependencies,
          allTransitiveDependencies:
              GetPostPrizeDataFamily._allTransitiveDependencies,
          postId: postId,
          prizeType: prizeType,
        );

  GetPostPrizeDataProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.postId,
    required this.prizeType,
  }) : super.internal();

  final String postId;
  final String prizeType;

  @override
  Override overrideWith(
    Stream<DocumentSnapshot?> Function(GetPostPrizeDataRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: GetPostPrizeDataProvider._internal(
        (ref) => create(ref as GetPostPrizeDataRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        postId: postId,
        prizeType: prizeType,
      ),
    );
  }

  @override
  AutoDisposeStreamProviderElement<DocumentSnapshot?> createElement() {
    return _GetPostPrizeDataProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is GetPostPrizeDataProvider &&
        other.postId == postId &&
        other.prizeType == prizeType;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, postId.hashCode);
    hash = _SystemHash.combine(hash, prizeType.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin GetPostPrizeDataRef on AutoDisposeStreamProviderRef<DocumentSnapshot?> {
  /// The parameter `postId` of this provider.
  String get postId;

  /// The parameter `prizeType` of this provider.
  String get prizeType;
}

class _GetPostPrizeDataProviderElement
    extends AutoDisposeStreamProviderElement<DocumentSnapshot?>
    with GetPostPrizeDataRef {
  _GetPostPrizeDataProviderElement(super.provider);

  @override
  String get postId => (origin as GetPostPrizeDataProvider).postId;
  @override
  String get prizeType => (origin as GetPostPrizeDataProvider).prizeType;
}

String _$getCommentsNumberHash() => r'67ef9f273739dedbad403386d8218a2a7779ce66';

/// See also [getCommentsNumber].
@ProviderFor(getCommentsNumber)
const getCommentsNumberProvider = GetCommentsNumberFamily();

/// See also [getCommentsNumber].
class GetCommentsNumberFamily extends Family<AsyncValue<int>> {
  /// See also [getCommentsNumber].
  const GetCommentsNumberFamily();

  /// See also [getCommentsNumber].
  GetCommentsNumberProvider call(
    String postId,
  ) {
    return GetCommentsNumberProvider(
      postId,
    );
  }

  @override
  GetCommentsNumberProvider getProviderOverride(
    covariant GetCommentsNumberProvider provider,
  ) {
    return call(
      provider.postId,
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
  String? get name => r'getCommentsNumberProvider';
}

/// See also [getCommentsNumber].
class GetCommentsNumberProvider extends AutoDisposeFutureProvider<int> {
  /// See also [getCommentsNumber].
  GetCommentsNumberProvider(
    String postId,
  ) : this._internal(
          (ref) => getCommentsNumber(
            ref as GetCommentsNumberRef,
            postId,
          ),
          from: getCommentsNumberProvider,
          name: r'getCommentsNumberProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$getCommentsNumberHash,
          dependencies: GetCommentsNumberFamily._dependencies,
          allTransitiveDependencies:
              GetCommentsNumberFamily._allTransitiveDependencies,
          postId: postId,
        );

  GetCommentsNumberProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.postId,
  }) : super.internal();

  final String postId;

  @override
  Override overrideWith(
    FutureOr<int> Function(GetCommentsNumberRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: GetCommentsNumberProvider._internal(
        (ref) => create(ref as GetCommentsNumberRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        postId: postId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<int> createElement() {
    return _GetCommentsNumberProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is GetCommentsNumberProvider && other.postId == postId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, postId.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin GetCommentsNumberRef on AutoDisposeFutureProviderRef<int> {
  /// The parameter `postId` of this provider.
  String get postId;
}

class _GetCommentsNumberProviderElement
    extends AutoDisposeFutureProviderElement<int> with GetCommentsNumberRef {
  _GetCommentsNumberProviderElement(super.provider);

  @override
  String get postId => (origin as GetCommentsNumberProvider).postId;
}

String _$postControllerHash() => r'9f7e8401714a90abad196a3911fb6cbafa48e0b4';

/// See also [PostController].
@ProviderFor(PostController)
final postControllerProvider =
    AutoDisposeAsyncNotifierProvider<PostController, void>.internal(
  PostController.new,
  name: r'postControllerProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$postControllerHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$PostController = AutoDisposeAsyncNotifier<void>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
