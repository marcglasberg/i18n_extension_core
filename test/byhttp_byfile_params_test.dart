import 'package:i18n_extension_core/i18n_extension_core.dart';
import 'package:i18n_extension_core/src/translations_by_locale.dart';
import 'package:test/test.dart';

/// Note: [failOnMissingResource] is only a configuration carried by the
/// translations object. The behavior it controls is implemented by the loader in
/// the `i18n_extension` package. These tests only check that the flag is
/// correctly stored and made available to that loader.
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

  group('Other Translations constructors', () {
    //
    test('byLocale defaults failOnMissingResource to true.', () {
      var translations = Translations.byLocale('en-US') as TranslationsByLocale;
      expect(translations.failOnMissingResource, isTrue);
    });
  });
}
