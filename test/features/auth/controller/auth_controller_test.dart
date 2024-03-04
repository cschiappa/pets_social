// create a mock for the class we need to test
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pets_social/features/auth/controller/auth_controller.dart';
import 'package:pets_social/features/auth/repository/auth_repository.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

// a generic Listener class, used to keep track of when a provider notifies its listeners
class Listener<T> extends Mock {
  void call(T? previous, T next);
}

void main() {
  ProviderContainer makeProviderContainer(MockAuthRepository authRepository) {
    final container = ProviderContainer(
      overrides: [
        authRepositoryProvider.overrideWithValue(authRepository),
      ],
    );
    addTearDown(container.dispose);
    return container;
  }

  setUpAll(() {
    registerFallbackValue(const AsyncLoading<void>());
  });

  group('initialization', () {
    test('initial state is AsyncData', () {
      final authRepository = MockAuthRepository();
      // create the ProviderContainer with the mock auth repository
      final container = makeProviderContainer(authRepository);
      // create a listener
      final listener = Listener<AsyncValue<void>>();
      // listen to the provider and call [listener] whenever its value changes
      container.listen(
        authControllerProvider,
        listener.call,
        fireImmediately: true,
      );
      // verify
      verify(
        // the build method returns a value immediately, so we expect AsyncData
        () => listener(null, const AsyncData<void>(null)),
      );
      // verify that the listener is no longer called
      verifyNoMoreInteractions(listener);
      // verify that [signInAnonymously] was not called during initialization
      verifyNever(authRepository.signOut);
    });
  });

  group('signOut', () {
    test('sign-out success', () async {
      final authRepository = MockAuthRepository();

      // stub method to return success
      when(authRepository.signOut).thenAnswer((_) => Future.value());
      // create the ProviderContainer with the mock auth repository
      final container = makeProviderContainer(authRepository);

      // get the controller via container.read
      final controller = container.read(authControllerProvider.notifier);
      // create a listener
      final listener = Listener<AsyncValue<void>>();
      // listen to the provider and call [listener] whenever its value changes
      container.listen(
        authControllerProvider,
        listener.call,
        fireImmediately: true,
      );
      // store this into a variable since we'll need it multiple times
      const data = AsyncData<void>(null);
      // verify initial value from the build method
      verify(() => listener(null, data));

      // run
      await controller.signOut();
      // verify
      verifyInOrder([
        // set loading state
        // * use a matcher since AsyncLoading != AsyncLoading with data
        () => listener(data, any(that: isA<AsyncLoading>())),
        // data when complete
        () => listener(any(that: isA<AsyncLoading>()), data),
      ]);
      verifyNoMoreInteractions(listener);
      verify(authRepository.signOut).called(1);
    });

    test('sign-out failure', () async {
      // setup
      final authRepository = MockAuthRepository();
      final exception = Exception('Connection failed');
      when(authRepository.signOut).thenThrow(exception);
      final container = makeProviderContainer(authRepository);
      final listener = Listener<AsyncValue<void>>();
      container.listen(
        authControllerProvider,
        listener.call,
        fireImmediately: true,
      );
      const data = AsyncData<void>(null);
      // verify initial value from build method
      verify(() => listener(null, data));
      // run
      final controller = container.read(authControllerProvider.notifier);
      await controller.signOut();
      // verify
      verifyInOrder([
        // set loading state
        // * use a matcher since AsyncLoading != AsyncLoading with data
        () => listener(data, any(that: isA<AsyncLoading>())),
        // error when complete
        () => listener(any(that: isA<AsyncLoading>()), any(that: isA<AsyncError>())),
      ]);
      verifyNoMoreInteractions(listener);
      verify(authRepository.signOut).called(1);
    });
  });
}
