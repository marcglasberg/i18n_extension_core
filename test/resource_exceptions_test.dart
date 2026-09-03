import 'package:i18n_extension_core/i18n_extension_core.dart';
import 'package:test/test.dart';

/// Note: [MissingResourceException] and [InvalidResourceException] are thrown by
/// the loader in the `i18n_extension` package, not by this package. These tests
/// only check that the exception types behave as expected.
void main() {
  group('MissingResourceException', () {
    //
    test('Is a TranslationsException.', () {
      var exception = MissingResourceException('Could not read en-US.json.');
      expect(exception, isA<TranslationsException>());
      expect(exception, isA<MissingResourceException>());
      expect(exception, isNot(isA<InvalidResourceException>()));
    });

    test('Carries its message.', () {
      var exception = MissingResourceException('Could not read en-US.json.');
      expect(exception.msg, 'Could not read en-US.json.');
    });

    test('toString uses its own class name.', () {
      var exception = MissingResourceException('Could not read en-US.json.');
      expect(exception.toString(),
          'MissingResourceException{msg: Could not read en-US.json.}');
    });

    test('Is equal to another MissingResourceException with the same message.', () {
      expect(
        MissingResourceException('Could not read en-US.json.'),
        MissingResourceException('Could not read en-US.json.'),
      );
      expect(
        MissingResourceException('Could not read en-US.json.').hashCode,
        MissingResourceException('Could not read en-US.json.').hashCode,
      );
    });

    test('Is not equal to one with a different message.', () {
      expect(
        MissingResourceException('Could not read en-US.json.'),
        isNot(MissingResourceException('Could not read pt-BR.json.')),
      );
    });

    test('Is not equal to a plain TranslationsException with the same message.', () {
      var missing = MissingResourceException('Could not read en-US.json.');
      var plain = TranslationsException('Could not read en-US.json.');
      expect(missing, isNot(plain));
      expect(plain, isNot(missing));
    });

    test('Is not equal to an InvalidResourceException with the same message.', () {
      var missing = MissingResourceException('Some message.');
      var invalid = InvalidResourceException('Some message.');
      expect(missing, isNot(invalid));
      expect(invalid, isNot(missing));
    });

    test('Can be caught as a TranslationsException.', () {
      expect(
        () => throw MissingResourceException('Could not read en-US.json.'),
        throwsA(isA<TranslationsException>()
            .having((e) => e.msg, 'msg', 'Could not read en-US.json.')),
      );
    });
  });

  group('InvalidResourceException', () {
    //
    test('Is a TranslationsException.', () {
      var exception = InvalidResourceException('Invalid JSON in en-US.json.');
      expect(exception, isA<TranslationsException>());
      expect(exception, isA<InvalidResourceException>());
      expect(exception, isNot(isA<MissingResourceException>()));
    });

    test('Carries its message.', () {
      var exception = InvalidResourceException('Invalid JSON in en-US.json.');
      expect(exception.msg, 'Invalid JSON in en-US.json.');
    });

    test('toString uses its own class name.', () {
      var exception = InvalidResourceException('Invalid JSON in en-US.json.');
      expect(exception.toString(),
          'InvalidResourceException{msg: Invalid JSON in en-US.json.}');
    });

    test('Is equal to another InvalidResourceException with the same message.', () {
      expect(
        InvalidResourceException('Invalid JSON in en-US.json.'),
        InvalidResourceException('Invalid JSON in en-US.json.'),
      );
      expect(
        InvalidResourceException('Invalid JSON in en-US.json.').hashCode,
        InvalidResourceException('Invalid JSON in en-US.json.').hashCode,
      );
    });

    test('Is not equal to one with a different message.', () {
      expect(
        InvalidResourceException('Invalid JSON in en-US.json.'),
        isNot(InvalidResourceException('Invalid JSON in pt-BR.json.')),
      );
    });

    test('Is not equal to a plain TranslationsException with the same message.', () {
      var invalid = InvalidResourceException('Invalid JSON in en-US.json.');
      var plain = TranslationsException('Invalid JSON in en-US.json.');
      expect(invalid, isNot(plain));
      expect(plain, isNot(invalid));
    });

    test('Can be caught as a TranslationsException.', () {
      expect(
        () => throw InvalidResourceException('Invalid JSON in en-US.json.'),
        throwsA(isA<TranslationsException>()
            .having((e) => e.msg, 'msg', 'Invalid JSON in en-US.json.')),
      );
    });
  });

  group('TranslationsException', () {
    //
    test('A plain TranslationsException is not a resource exception.', () {
      var plain = TranslationsException('Some message.');
      expect(plain, isNot(isA<MissingResourceException>()));
      expect(plain, isNot(isA<InvalidResourceException>()));
      expect(plain.toString(), 'TranslationsException{msg: Some message.}');
    });
  });
}
