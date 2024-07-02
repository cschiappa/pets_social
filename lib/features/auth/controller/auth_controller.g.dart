// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$authRepositoryHash() => r'd05f1f285ede032163f828de5b1ab7b5db962875';

/// See also [authRepository].
@ProviderFor(authRepository)
final authRepositoryProvider = Provider<AuthRepository>.internal(
  authRepository,
  name: r'authRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$authRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef AuthRepositoryRef = ProviderRef<AuthRepository>;
String _$appStartupHash() => r'29ad813e770d03f4926e19f66112ea5d46ae822f';

/// See also [appStartup].
@ProviderFor(appStartup)
final appStartupProvider = FutureProvider<void>.internal(
  appStartup,
  name: r'appStartupProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$appStartupHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef AppStartupRef = FutureProviderRef<void>;
String _$authStateChangeHash() => r'530ee52cf17fe0763096e50fc7227853f5f6d34b';

/// See also [authStateChange].
@ProviderFor(authStateChange)
final authStateChangeProvider = StreamProvider<User?>.internal(
  authStateChange,
  name: r'authStateChangeProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$authStateChangeHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef AuthStateChangeRef = StreamProviderRef<User?>;
String _$isLoggedInHash() => r'4d1b182680b5e7f4703ce527e1ddcf4860c60f2a';

/// See also [isLoggedIn].
@ProviderFor(isLoggedIn)
final isLoggedInProvider = Provider<bool>.internal(
  isLoggedIn,
  name: r'isLoggedInProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$isLoggedInHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef IsLoggedInRef = ProviderRef<bool>;
String _$isEmailVerifiedHash() => r'93d1ef14e08d04eb3b302a695e4835bb78a48af2';

/// See also [isEmailVerified].
@ProviderFor(isEmailVerified)
final isEmailVerifiedProvider = Provider<bool?>.internal(
  isEmailVerified,
  name: r'isEmailVerifiedProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$isEmailVerifiedHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef IsEmailVerifiedRef = ProviderRef<bool?>;
String _$getAccountProfilesHash() =>
    r'2705b4014e3b3917b793b6779d7c1ce849bef7f4';

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

/// See also [getAccountProfiles].
@ProviderFor(getAccountProfiles)
const getAccountProfilesProvider = GetAccountProfilesFamily();

/// See also [getAccountProfiles].
class GetAccountProfilesFamily
    extends Family<AsyncValue<QuerySnapshot<Map<String, dynamic>>>> {
  /// See also [getAccountProfiles].
  const GetAccountProfilesFamily();

  /// See also [getAccountProfiles].
  GetAccountProfilesProvider call(
    String uid,
  ) {
    return GetAccountProfilesProvider(
      uid,
    );
  }

  @override
  GetAccountProfilesProvider getProviderOverride(
    covariant GetAccountProfilesProvider provider,
  ) {
    return call(
      provider.uid,
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
  String? get name => r'getAccountProfilesProvider';
}

/// See also [getAccountProfiles].
class GetAccountProfilesProvider
    extends AutoDisposeStreamProvider<QuerySnapshot<Map<String, dynamic>>> {
  /// See also [getAccountProfiles].
  GetAccountProfilesProvider(
    String uid,
  ) : this._internal(
          (ref) => getAccountProfiles(
            ref as GetAccountProfilesRef,
            uid,
          ),
          from: getAccountProfilesProvider,
          name: r'getAccountProfilesProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$getAccountProfilesHash,
          dependencies: GetAccountProfilesFamily._dependencies,
          allTransitiveDependencies:
              GetAccountProfilesFamily._allTransitiveDependencies,
          uid: uid,
        );

  GetAccountProfilesProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.uid,
  }) : super.internal();

  final String uid;

  @override
  Override overrideWith(
    Stream<QuerySnapshot<Map<String, dynamic>>> Function(
            GetAccountProfilesRef provider)
        create,
  ) {
    return ProviderOverride(
      origin: this,
      override: GetAccountProfilesProvider._internal(
        (ref) => create(ref as GetAccountProfilesRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        uid: uid,
      ),
    );
  }

  @override
  AutoDisposeStreamProviderElement<QuerySnapshot<Map<String, dynamic>>>
      createElement() {
    return _GetAccountProfilesProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is GetAccountProfilesProvider && other.uid == uid;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, uid.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin GetAccountProfilesRef
    on AutoDisposeStreamProviderRef<QuerySnapshot<Map<String, dynamic>>> {
  /// The parameter `uid` of this provider.
  String get uid;
}

class _GetAccountProfilesProviderElement
    extends AutoDisposeStreamProviderElement<
        QuerySnapshot<Map<String, dynamic>>> with GetAccountProfilesRef {
  _GetAccountProfilesProviderElement(super.provider);

  @override
  String get uid => (origin as GetAccountProfilesProvider).uid;
}

String _$authControllerHash() => r'4dd12ea3530041ed3344ee13b7b86cc63d484661';

/// See also [AuthController].
@ProviderFor(AuthController)
final authControllerProvider =
    AutoDisposeAsyncNotifierProvider<AuthController, void>.internal(
  AuthController.new,
  name: r'authControllerProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$authControllerHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$AuthController = AutoDisposeAsyncNotifier<void>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
