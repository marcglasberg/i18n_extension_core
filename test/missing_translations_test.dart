import 'package:i18n_extension_core/i18n_extension_core.dart';
import 'package:test/test.dart';

void main() {
  //
  test("Empty translations.", () {
    //
    Translations.supportedLocales = ["es"];

    Translations.missingKeys = {};
    Translations.missingTranslations = {};
    DefaultLocale.set("es");
    expect('continue'.i18n, 'Continuar');
    expect(Translations.missingKeys, isEmpty);
    expect(Translations.missingTranslations, isEmpty);

    // Since en-US was never defined, it keeps the Spanish translation.
    // It's not missing the en-US translation, because only "es" is supported.
    Translations.missingKeys = {};
    Translations.missingTranslations = {};
    DefaultLocale.set("en-US");
    expect('continue'.i18n, 'Continuar');
    expect(Translations.missingKeys, isEmpty);
    expect(Translations.missingTranslations, isEmpty);

    // Now we try a key that doesn't exist. They missing key should be in Spanish.
    // It's not missing the en-US translation, because only "es" is supported.
    Translations.missingKeys = {};
    Translations.missingTranslations = {};
    expect('xxx'.i18n, 'xxx');
    expect(Translations.missingKeys, [TranslatedString(locale: 'es', key: 'xxx')]);
    expect(Translations.missingTranslations, isEmpty);

    // ------------

    Translations.supportedLocales = ["en-US"];

    Translations.missingKeys = {};
    Translations.missingTranslations = {};
    DefaultLocale.set("es");
    expect('continue'.i18n, 'Continuar');
    expect(Translations.missingKeys, isEmpty);
    expect(Translations.missingTranslations, isEmpty);

    // Since en-US was never defines, it keeps the Spanish translation.
    Translations.missingKeys = {};
    Translations.missingTranslations = {};
    DefaultLocale.set("en-US");
    expect('continue'.i18n, 'Continuar');
    expect(Translations.missingKeys, isEmpty);
    expect(Translations.missingTranslations,
        [TranslatedString(locale: 'en-US', key: 'continue')]);

    // Now we try a key that doesn't exist.
    Translations.missingKeys = {};
    Translations.missingTranslations = {};
    expect('xxx'.i18n, 'xxx');
    expect(Translations.missingKeys, [TranslatedString(locale: 'es', key: 'xxx')]);
    expect(Translations.missingTranslations, isEmpty);
  });
}

extension Localization on String {
  //
  static const _t = ConstTranslations(
    'es',
    {
      'continue': {
        'es': 'Continuar',
      },
      'onBoarding1Title': {
        'es': 'Onboarding 1',
      },
      'onBoarding1Description': {
        'es': 'Lorem ipsum dolor sit amet, consectetur adipiscing elit.',
      }
    },
  );

  String get i18n => localize(this, _t);

  String fill(List<Object> params) => localizeFill(this, params);
}
