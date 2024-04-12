// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$chatRepositoryHash() => r'8473da0783bbedcb559afbc76c43a819bb9219dc';

/// See also [chatRepository].
@ProviderFor(chatRepository)
final chatRepositoryProvider = Provider<ChatRepository>.internal(
  chatRepository,
  name: r'chatRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$chatRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef ChatRepositoryRef = ProviderRef<ChatRepository>;
String _$numberOfUnreadChatsHash() =>
    r'74b88c72f3363a7043c6b500b161ba67d0b3556b';

/// See also [numberOfUnreadChats].
@ProviderFor(numberOfUnreadChats)
final numberOfUnreadChatsProvider = AutoDisposeStreamProvider<int>.internal(
  numberOfUnreadChats,
  name: r'numberOfUnreadChatsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$numberOfUnreadChatsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef NumberOfUnreadChatsRef = AutoDisposeStreamProviderRef<int>;
String _$getChatsListHash() => r'621d8be553f53a57dd627f32c88b76297d48c6b1';

/// See also [getChatsList].
@ProviderFor(getChatsList)
final getChatsListProvider =
    AutoDisposeFutureProvider<List<DocumentSnapshot>>.internal(
  getChatsList,
  name: r'getChatsListProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$getChatsListHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef GetChatsListRef = AutoDisposeFutureProviderRef<List<DocumentSnapshot>>;
String _$getMessagesHash() => r'9492eac32d0e0f5c965b8842e5e0b00a29098d35';

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

/// See also [getMessages].
@ProviderFor(getMessages)
const getMessagesProvider = GetMessagesFamily();

/// See also [getMessages].
class GetMessagesFamily extends Family<AsyncValue<QuerySnapshot>> {
  /// See also [getMessages].
  const GetMessagesFamily();

  /// See also [getMessages].
  GetMessagesProvider call(
    String userUid,
    String otherUserUid,
  ) {
    return GetMessagesProvider(
      userUid,
      otherUserUid,
    );
  }

  @override
  GetMessagesProvider getProviderOverride(
    covariant GetMessagesProvider provider,
  ) {
    return call(
      provider.userUid,
      provider.otherUserUid,
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
  String? get name => r'getMessagesProvider';
}

/// See also [getMessages].
class GetMessagesProvider extends AutoDisposeStreamProvider<QuerySnapshot> {
  /// See also [getMessages].
  GetMessagesProvider(
    String userUid,
    String otherUserUid,
  ) : this._internal(
          (ref) => getMessages(
            ref as GetMessagesRef,
            userUid,
            otherUserUid,
          ),
          from: getMessagesProvider,
          name: r'getMessagesProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$getMessagesHash,
          dependencies: GetMessagesFamily._dependencies,
          allTransitiveDependencies:
              GetMessagesFamily._allTransitiveDependencies,
          userUid: userUid,
          otherUserUid: otherUserUid,
        );

  GetMessagesProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.userUid,
    required this.otherUserUid,
  }) : super.internal();

  final String userUid;
  final String otherUserUid;

  @override
  Override overrideWith(
    Stream<QuerySnapshot> Function(GetMessagesRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: GetMessagesProvider._internal(
        (ref) => create(ref as GetMessagesRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        userUid: userUid,
        otherUserUid: otherUserUid,
      ),
    );
  }

  @override
  AutoDisposeStreamProviderElement<QuerySnapshot> createElement() {
    return _GetMessagesProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is GetMessagesProvider &&
        other.userUid == userUid &&
        other.otherUserUid == otherUserUid;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, userUid.hashCode);
    hash = _SystemHash.combine(hash, otherUserUid.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin GetMessagesRef on AutoDisposeStreamProviderRef<QuerySnapshot> {
  /// The parameter `userUid` of this provider.
  String get userUid;

  /// The parameter `otherUserUid` of this provider.
  String get otherUserUid;
}

class _GetMessagesProviderElement
    extends AutoDisposeStreamProviderElement<QuerySnapshot>
    with GetMessagesRef {
  _GetMessagesProviderElement(super.provider);

  @override
  String get userUid => (origin as GetMessagesProvider).userUid;
  @override
  String get otherUserUid => (origin as GetMessagesProvider).otherUserUid;
}

String _$messageReadHash() => r'5b68a6737bdebdaa190faf85e300c6b87ca6d59a';

/// See also [messageRead].
@ProviderFor(messageRead)
const messageReadProvider = MessageReadFamily();

/// See also [messageRead].
class MessageReadFamily extends Family<AsyncValue<void>> {
  /// See also [messageRead].
  const MessageReadFamily();

  /// See also [messageRead].
  MessageReadProvider call(
    String profileUid,
    String receiverUid,
  ) {
    return MessageReadProvider(
      profileUid,
      receiverUid,
    );
  }

  @override
  MessageReadProvider getProviderOverride(
    covariant MessageReadProvider provider,
  ) {
    return call(
      provider.profileUid,
      provider.receiverUid,
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
  String? get name => r'messageReadProvider';
}

/// See also [messageRead].
class MessageReadProvider extends AutoDisposeFutureProvider<void> {
  /// See also [messageRead].
  MessageReadProvider(
    String profileUid,
    String receiverUid,
  ) : this._internal(
          (ref) => messageRead(
            ref as MessageReadRef,
            profileUid,
            receiverUid,
          ),
          from: messageReadProvider,
          name: r'messageReadProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$messageReadHash,
          dependencies: MessageReadFamily._dependencies,
          allTransitiveDependencies:
              MessageReadFamily._allTransitiveDependencies,
          profileUid: profileUid,
          receiverUid: receiverUid,
        );

  MessageReadProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.profileUid,
    required this.receiverUid,
  }) : super.internal();

  final String profileUid;
  final String receiverUid;

  @override
  Override overrideWith(
    FutureOr<void> Function(MessageReadRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: MessageReadProvider._internal(
        (ref) => create(ref as MessageReadRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        profileUid: profileUid,
        receiverUid: receiverUid,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<void> createElement() {
    return _MessageReadProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is MessageReadProvider &&
        other.profileUid == profileUid &&
        other.receiverUid == receiverUid;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, profileUid.hashCode);
    hash = _SystemHash.combine(hash, receiverUid.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin MessageReadRef on AutoDisposeFutureProviderRef<void> {
  /// The parameter `profileUid` of this provider.
  String get profileUid;

  /// The parameter `receiverUid` of this provider.
  String get receiverUid;
}

class _MessageReadProviderElement extends AutoDisposeFutureProviderElement<void>
    with MessageReadRef {
  _MessageReadProviderElement(super.provider);

  @override
  String get profileUid => (origin as MessageReadProvider).profileUid;
  @override
  String get receiverUid => (origin as MessageReadProvider).receiverUid;
}

String _$getLastMessageHash() => r'e703ee612ccc36fa44d59ec4d98ad0fead064401';

/// See also [getLastMessage].
@ProviderFor(getLastMessage)
const getLastMessageProvider = GetLastMessageFamily();

/// See also [getLastMessage].
class GetLastMessageFamily
    extends Family<AsyncValue<List<Map<String, dynamic>>>> {
  /// See also [getLastMessage].
  const GetLastMessageFamily();

  /// See also [getLastMessage].
  GetLastMessageProvider call(
    String receiverUid,
    String senderUid,
  ) {
    return GetLastMessageProvider(
      receiverUid,
      senderUid,
    );
  }

  @override
  GetLastMessageProvider getProviderOverride(
    covariant GetLastMessageProvider provider,
  ) {
    return call(
      provider.receiverUid,
      provider.senderUid,
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
  String? get name => r'getLastMessageProvider';
}

/// See also [getLastMessage].
class GetLastMessageProvider
    extends AutoDisposeStreamProvider<List<Map<String, dynamic>>> {
  /// See also [getLastMessage].
  GetLastMessageProvider(
    String receiverUid,
    String senderUid,
  ) : this._internal(
          (ref) => getLastMessage(
            ref as GetLastMessageRef,
            receiverUid,
            senderUid,
          ),
          from: getLastMessageProvider,
          name: r'getLastMessageProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$getLastMessageHash,
          dependencies: GetLastMessageFamily._dependencies,
          allTransitiveDependencies:
              GetLastMessageFamily._allTransitiveDependencies,
          receiverUid: receiverUid,
          senderUid: senderUid,
        );

  GetLastMessageProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.receiverUid,
    required this.senderUid,
  }) : super.internal();

  final String receiverUid;
  final String senderUid;

  @override
  Override overrideWith(
    Stream<List<Map<String, dynamic>>> Function(GetLastMessageRef provider)
        create,
  ) {
    return ProviderOverride(
      origin: this,
      override: GetLastMessageProvider._internal(
        (ref) => create(ref as GetLastMessageRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        receiverUid: receiverUid,
        senderUid: senderUid,
      ),
    );
  }

  @override
  AutoDisposeStreamProviderElement<List<Map<String, dynamic>>> createElement() {
    return _GetLastMessageProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is GetLastMessageProvider &&
        other.receiverUid == receiverUid &&
        other.senderUid == senderUid;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, receiverUid.hashCode);
    hash = _SystemHash.combine(hash, senderUid.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin GetLastMessageRef
    on AutoDisposeStreamProviderRef<List<Map<String, dynamic>>> {
  /// The parameter `receiverUid` of this provider.
  String get receiverUid;

  /// The parameter `senderUid` of this provider.
  String get senderUid;
}

class _GetLastMessageProviderElement
    extends AutoDisposeStreamProviderElement<List<Map<String, dynamic>>>
    with GetLastMessageRef {
  _GetLastMessageProviderElement(super.provider);

  @override
  String get receiverUid => (origin as GetLastMessageProvider).receiverUid;
  @override
  String get senderUid => (origin as GetLastMessageProvider).senderUid;
}

String _$chatControllerHash() => r'08328be3a73bb75aac27e66c78d54f68ac49ac05';

/// See also [ChatController].
@ProviderFor(ChatController)
final chatControllerProvider =
    AutoDisposeAsyncNotifierProvider<ChatController, void>.internal(
  ChatController.new,
  name: r'chatControllerProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$chatControllerHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$ChatController = AutoDisposeAsyncNotifier<void>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
