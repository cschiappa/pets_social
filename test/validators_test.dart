import 'package:pets_social/core/utils/validators.dart';
import 'package:test/test.dart';

void main() {
  group('emptyField', () {
    test('returns an error message for empty input', () {
      expect(emptyField(''), 'Please enter this field.');
    });

    test('returns null for non-empty input', () {
      expect(emptyField('Non-empty value'), isNull);
    });
  });

  group('emailValidator', () {
    test('returns an error message for empty input', () {
      expect(emailValidator(''), 'Please enter this field.');
    });

    test('returns null for non-empty input', () {
      expect(emailValidator('test@example.com'), isNull);
    });
  });

  group('usernameValidator', () {
    test('returns an error message for empty input', () {
      expect(usernameValidator(''), 'Please enter this field.');
    });

    test('returns an error message for a long username', () {
      expect(usernameValidator('TooLongUsername123456'), 'Username must be 15 characters or less.');
    });

    test('returns null for a valid username', () {
      expect(usernameValidator('ValidUsername'), isNull);
    });
  });

  group('bioValidator', () {
    test('returns an error message for a long bio', () {
      expect(bioValidator('A very long bio that exceeds the limit' * 10), 'Bio must be 150 characters or less.');
    });

    test('returns null for a valid bio', () {
      expect(bioValidator('Short bio'), isNull);
    });

    test('returns null for null input', () {
      expect(bioValidator(null), isNull);
    });
  });

  group('passwordValidator', () {
    test('returns an error message for empty input', () {
      expect(passwordValidator(''), 'Please enter this field.');
    });

    test('returns an error message for an invalid password', () {
      expect(
        passwordValidator('weakpassword'),
        'Your password must contain a minimum of 5 letters, at least 1 upper case letter, 1 lower case letter, 1 numeric character and one special character.',
      );
    });

    test('returns null for a valid password', () {
      expect(passwordValidator('StrongPass123!'), isNull);
    });
  });
}
