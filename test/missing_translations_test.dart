import 'package:i18n_extension_core/i18n_extension_core.dart';
import 'package:test/test.dart';

void main() {
  //
  test("Empty translations.", () {
    Translations.missingKeys = {};
    Translations.missingTranslations = {};

    DefaultLocale.set("es");
    expect('continue'.i18n, 'Continuar');
    expect(Translations.missingKeys, isEmpty);
    expect(Translations.missingTranslations, isEmpty);

    // Since en_US was never defines, it keeps the Spanish translation.
    DefaultLocale.set("en_US");
    expect('continue'.i18n, 'Continuar');
    expect(Translations.missingKeys, isEmpty);
    expect(Translations.missingTranslations, [TranslatedString(locale: 'en_us', key: 'continue')]);

    // Now we try a key that doesn't exist. They missing key should be in Spanish.
    expect('xxx'.i18n, 'xxx');
    expect(Translations.missingKeys, [TranslatedString(locale: 'es', key: 'xxx')]);
    expect(Translations.missingTranslations, [TranslatedString(locale: 'en_us', key: 'continue')]);
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
