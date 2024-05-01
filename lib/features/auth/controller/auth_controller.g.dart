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
