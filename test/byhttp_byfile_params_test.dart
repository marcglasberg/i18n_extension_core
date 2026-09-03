import 'package:i18n_extension_core/i18n_extension_core.dart';
import 'package:i18n_extension_core/src/translations_by_locale.dart';
import 'package:test/test.dart';

/// Note: [failOnMissingResource] and [failOnInvalidResource] are only a
/// configuration carried by the translations object. The behavior they control is
/// implemented by the loader in the `i18n_extension` package. These tests only
/// check that the flags are correctly stored and made available to that loader.
void main() {
  group('Translations.byHttp failOnMissingResource parameter', () {
    //
    test('Defaults to true.', () {
      var translations = Translations.byHttp(
        'en-US',
        url: 'https://example.com/translations',
        resources: ['en-US.json', 'pt-BR.json'],
      ) as TranslationsByLocale;

      expect(translations.failOnMissingResource, isTrue);
      expect(translations.url, 'https://example.com/translations');
      expect(translations.resources, ['en-US.json', 'pt-BR.json']);
    });

    test('Can be set to false.', () {
      var translations = Translations.byHttp(
        'en-US',
        url: 'https://example.com/translations',
        resources: ['en-US.json', 'pt-BR.json'],
        failOnMissingResource: false,
      ) as TranslationsByLocale;

      expect(translations.failOnMissingResource, isFalse);
    });

    test('Can be set to true explicitly.', () {
      var translations = Translations.byHttp(
        'en-US',
        url: 'https://example.com/translations',
        resources: ['en-US.json'],
        failOnMissingResource: true,
      ) as TranslationsByLocale;

      expect(translations.failOnMissingResource, isTrue);
    });
  });

  group('Translations.byFile failOnMissingResource parameter', () {
    //
    test('Defaults to true.', () {
      var translations = Translations.byFile(
        'en-US',
        dir: 'assets/translations',
      ) as TranslationsByLocale;

      expect(translations.failOnMissingResource, isTrue);
      expect(translations.dir, 'assets/translations');
    });

    test('Can be set to false.', () {
      var translations = Translations.byFile(
        'en-US',
        dir: 'assets/translations',
        failOnMissingResource: false,
      ) as TranslationsByLocale;

      expect(translations.failOnMissingResource, isFalse);
    });

    test('Can be set to true explicitly.', () {
      var translations = Translations.byFile(
        'en-US',
        dir: 'assets/translations',
        failOnMissingResource: true,
      ) as TranslationsByLocale;

      expect(translations.failOnMissingResource, isTrue);
    });
  });


  group('Translations.byHttp failOnInvalidResource parameter', () {
    //
    test('Defaults to true.', () {
      var translations = Translations.byHttp(
        'en-US',
        url: 'https://example.com/translations',
        resources: ['en-US.json', 'pt-BR.json'],
      ) as TranslationsByLocale;

      expect(translations.failOnInvalidResource, isTrue);
    });

    test('Can be set to false.', () {
      var translations = Translations.byHttp(
        'en-US',
        url: 'https://example.com/translations',
        resources: ['en-US.json', 'pt-BR.json'],
        failOnInvalidResource: false,
      ) as TranslationsByLocale;

      expect(translations.failOnInvalidResource, isFalse);
    });

    test('Can be set to true explicitly.', () {
      var translations = Translations.byHttp(
        'en-US',
        url: 'https://example.com/translations',
        resources: ['en-US.json'],
        failOnInvalidResource: true,
      ) as TranslationsByLocale;

      expect(translations.failOnInvalidResource, isTrue);
    });

    test('Setting failOnInvalidResource does not affect failOnMissingResource.', () {
      var translations = Translations.byHttp(
        'en-US',
        url: 'https://example.com/translations',
        resources: ['en-US.json'],
        failOnInvalidResource: false,
      ) as TranslationsByLocale;

      expect(translations.failOnMissingResource, isTrue);
      expect(translations.failOnInvalidResource, isFalse);
    });

    test('Setting failOnMissingResource does not affect failOnInvalidResource.', () {
      var translations = Translations.byHttp(
        'en-US',
        url: 'https://example.com/translations',
        resources: ['en-US.json'],
        failOnMissingResource: false,
      ) as TranslationsByLocale;

      expect(translations.failOnMissingResource, isFalse);
      expect(translations.failOnInvalidResource, isTrue);
    });

    test('Both flags can be set to false.', () {
      var translations = Translations.byHttp(
        'en-US',
        url: 'https://example.com/translations',
        resources: ['en-US.json'],
        failOnMissingResource: false,
        failOnInvalidResource: false,
      ) as TranslationsByLocale;

      expect(translations.failOnMissingResource, isFalse);
      expect(translations.failOnInvalidResource, isFalse);
    });
  });

  group('Translations.byFile failOnInvalidResource parameter', () {
    //
    test('Defaults to true.', () {
      var translations = Translations.byFile(
        'en-US',
        dir: 'assets/translations',
      ) as TranslationsByLocale;

      expect(translations.failOnInvalidResource, isTrue);
    });

    test('Can be set to false.', () {
      var translations = Translations.byFile(
        'en-US',
        dir: 'assets/translations',
        failOnInvalidResource: false,
      ) as TranslationsByLocale;

      expect(translations.failOnInvalidResource, isFalse);
    });

    test('Can be set to true explicitly.', () {
      var translations = Translations.byFile(
        'en-US',
        dir: 'assets/translations',
        failOnInvalidResource: true,
      ) as TranslationsByLocale;

      expect(translations.failOnInvalidResource, isTrue);
    });

    test('Setting failOnInvalidResource does not affect failOnMissingResource.', () {
      var translations = Translations.byFile(
        'en-US',
        dir: 'assets/translations',
        failOnInvalidResource: false,
      ) as TranslationsByLocale;

      expect(translations.failOnMissingResource, isTrue);
      expect(translations.failOnInvalidResource, isFalse);
    });

    test('Setting failOnMissingResource does not affect failOnInvalidResource.', () {
      var translations = Translations.byFile(
        'en-US',
        dir: 'assets/translations',
        failOnMissingResource: false,
      ) as TranslationsByLocale;

      expect(translations.failOnMissingResource, isFalse);
      expect(translations.failOnInvalidResource, isTrue);
    });

    test('Both flags can be set to false.', () {
      var translations = Translations.byFile(
        'en-US',
        dir: 'assets/translations',
        failOnMissingResource: false,
        failOnInvalidResource: false,
      ) as TranslationsByLocale;

      expect(translations.failOnMissingResource, isFalse);
      expect(translations.failOnInvalidResource, isFalse);
    });
  });

  group('TranslationsByLocale constructors', () {
    //
    test('The plain constructor defaults both flags to true.', () {
      var translations = TranslationsByLocale('en-US');
      expect(translations.failOnMissingResource, isTrue);
      expect(translations.failOnInvalidResource, isTrue);
    });

    test('Translations.byLocale defaults both flags to true.', () {
      var translations = Translations.byLocale('en-US') as TranslationsByLocale;
      expect(translations.failOnMissingResource, isTrue);
      expect(translations.failOnInvalidResource, isTrue);
    });

    test('TranslationsByLocale.byFile defaults both flags to true.', () {
      var translations = TranslationsByLocale.byFile('en-US', dir: 'assets/translations');
      expect(translations.failOnMissingResource, isTrue);
      expect(translations.failOnInvalidResource, isTrue);
    });

    test('TranslationsByLocale.byFile accepts each flag independently.', () {
      var translations = TranslationsByLocale.byFile(
        'en-US',
        dir: 'assets/translations',
        failOnMissingResource: false,
      );
      expect(translations.failOnMissingResource, isFalse);
      expect(translations.failOnInvalidResource, isTrue);

      translations = TranslationsByLocale.byFile(
        'en-US',
        dir: 'assets/translations',
        failOnInvalidResource: false,
      );
      expect(translations.failOnMissingResource, isTrue);
      expect(translations.failOnInvalidResource, isFalse);
    });

    test('TranslationsByLocale.byHttp defaults both flags to true.', () {
      var translations = TranslationsByLocale.byHttp(
        'en-US',
        url: 'https://example.com/translations',
        resources: ['en-US.json'],
      );
      expect(translations.failOnMissingResource, isTrue);
      expect(translations.failOnInvalidResource, isTrue);
    });

    test('TranslationsByLocale.byHttp accepts each flag independently.', () {
      var translations = TranslationsByLocale.byHttp(
        'en-US',
        url: 'https://example.com/translations',
        resources: ['en-US.json'],
        failOnMissingResource: false,
      );
      expect(translations.failOnMissingResource, isFalse);
      expect(translations.failOnInvalidResource, isTrue);

      translations = TranslationsByLocale.byHttp(
        'en-US',
        url: 'https://example.com/translations',
        resources: ['en-US.json'],
        failOnInvalidResource: false,
      );
      expect(translations.failOnMissingResource, isTrue);
      expect(translations.failOnInvalidResource, isFalse);
    });
  });
}
