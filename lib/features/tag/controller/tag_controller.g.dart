// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tag_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$tagRepositoryHash() => r'df6d35b184dd8f18660dc11bbd754800da840a5c';

/// See also [tagRepository].
@ProviderFor(tagRepository)
final tagRepositoryProvider = Provider<TagRepository>.internal(
  tagRepository,
  name: r'tagRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$tagRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef TagRepositoryRef = ProviderRef<TagRepository>;
String _$getPetTagsCollectionHash() =>
    r'f14fb214d541756cd1984e77bd22aa3a5cdad41a';

/// See also [getPetTagsCollection].
@ProviderFor(getPetTagsCollection)
final getPetTagsCollectionProvider =
    AutoDisposeFutureProvider<List<String>>.internal(
  getPetTagsCollection,
  name: r'getPetTagsCollectionProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$getPetTagsCollectionHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef GetPetTagsCollectionRef = AutoDisposeFutureProviderRef<List<String>>;
String _$getUserTagsHash() => r'24c3c91d237e1cf7787c769a7631371f5f81582a';

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

/// See also [getUserTags].
@ProviderFor(getUserTags)
const getUserTagsProvider = GetUserTagsFamily();

/// See also [getUserTags].
class GetUserTagsFamily extends Family<AsyncValue<List<String>?>> {
  /// See also [getUserTags].
  const GetUserTagsFamily();

  /// See also [getUserTags].
  GetUserTagsProvider call(
    String tags,
  ) {
    return GetUserTagsProvider(
      tags,
    );
  }

  @override
  GetUserTagsProvider getProviderOverride(
    covariant GetUserTagsProvider provider,
  ) {
    return call(
      provider.tags,
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
  String? get name => r'getUserTagsProvider';
}

/// See also [getUserTags].
class GetUserTagsProvider extends StreamProvider<List<String>?> {
  /// See also [getUserTags].
  GetUserTagsProvider(
    String tags,
  ) : this._internal(
          (ref) => getUserTags(
            ref as GetUserTagsRef,
            tags,
          ),
          from: getUserTagsProvider,
          name: r'getUserTagsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$getUserTagsHash,
          dependencies: GetUserTagsFamily._dependencies,
          allTransitiveDependencies:
              GetUserTagsFamily._allTransitiveDependencies,
          tags: tags,
        );

  GetUserTagsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.tags,
  }) : super.internal();

  final String tags;

  @override
  Override overrideWith(
    Stream<List<String>?> Function(GetUserTagsRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: GetUserTagsProvider._internal(
        (ref) => create(ref as GetUserTagsRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        tags: tags,
      ),
    );
  }

  @override
  StreamProviderElement<List<String>?> createElement() {
    return _GetUserTagsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is GetUserTagsProvider && other.tags == tags;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, tags.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin GetUserTagsRef on StreamProviderRef<List<String>?> {
  /// The parameter `tags` of this provider.
  String get tags;
}

class _GetUserTagsProviderElement extends StreamProviderElement<List<String>?>
    with GetUserTagsRef {
  _GetUserTagsProviderElement(super.provider);

  @override
  String get tags => (origin as GetUserTagsProvider).tags;
}

String _$tagControllerHash() => r'2e30a1c2353db11d0c7f3952d18e38caddf11edf';

/// See also [TagController].
@ProviderFor(TagController)
final tagControllerProvider =
    AutoDisposeAsyncNotifierProvider<TagController, void>.internal(
  TagController.new,
  name: r'tagControllerProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$tagControllerHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$TagController = AutoDisposeAsyncNotifier<void>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
