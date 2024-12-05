import 'package:i18n_extension_core/src/core_localize_functions.dart';
import 'package:i18n_extension_core/src/translations.dart';
import 'package:i18n_extension_core/src/translations_exception.dart';
import 'package:test/test.dart';

void main() {
  //
  test("Fallbacks", () {
    //
    DefaultLocale.set("zh-Hant-CN");

    expect(
        localize(
            "A",
            Translations.byText("en-US") +
                {
                  "en-US": "A",
                  "zh-Hant-CN": "B",
                  "zh-Hanz-CN": "C",
                }),
        "B");

    // ---------

    DefaultLocale.set("zh-Hant-CN");

    expect(
        localize(
            "A",
            Translations.byText("en-US") +
                {
                  "en-US": "A",
                  "zh-Hant": "B",
                }),
        "B");

    // ---------

    DefaultLocale.set("zh-Hant-CN");

    expect(
        localize(
            "A",
            Translations.byText("en-US") +
                {
                  "en-US": "A",
                  "zh": "B",
                }),
        "B");

    // ---------

    DefaultLocale.set("zh-Hant-CN");

    expect(
        localize(
            "A",
            Translations.byText("en-US") +
                {
                  "en-US": "A",
                  "pt": "B",
                }),
        "A"); // No match.

    // ---------

    DefaultLocale.set("zh-Hant-CN");

    expect(
        localize(
            "A",
            Translations.byText("en-US") +
                {
                  "en-US": "A",
                  "zh-Hanz-CN": "B",
                }),
        "B"); // No match.

    // ---------

    DefaultLocale.set("zh-Hant");

    expect(
        localize(
            "A",
            Translations.byText("en-US") +
                {
                  "en-US": "A",
                  "zh-Hant-CN": "B",
                  "zh-Hanz-CN": "C",
                }),
        "B");

    // ---------

    DefaultLocale.set("zh-Hant");

    expect(
        localize(
            "A",
            Translations.byText("en-US") +
                {
                  "en-US": "A",
                  "zh-Hant-CN": "B",
                  "zh-Hant": "C",
                  "zh-Hant-HK": "D",
                }),
        "C");

    // ---------

    DefaultLocale.set("zh-Hant");

    expect(
        localize(
            "A",
            Translations.byText("en-US") +
                {
                  "en-US": "A",
                  "zh-Hanz-CN": "B", // Matched by "zh" only.
                  "zh-Hanz": "C",
                  "zh-Hanz-HK": "D",
                }),
        "B");

    // ---------

    DefaultLocale.set("zh");

    expect(
        localize(
            "A",
            Translations.byText("en-US") +
                {
                  "en-US": "A",
                  "zh-Hanz-CN": "B", // Matched by "zh" only.
                  "zh-Hanz": "C",
                  "zh-Hanz-HK": "D",
                }),
        "B");

    // ---------

    DefaultLocale.set("zh");

    expect(
        localize(
            "A",
            Translations.byText("en-US") +
                {
                  "en-US": "A",
                  "zh-Hanz-CN": "B", // Matched by "zh" only.
                  "zh-Hanz": "C",
                  "zh-Hanz-HK": "D",
                  "zh-Hant": "E",
                }),
        "B");

    // ---------

    DefaultLocale.set("zh");

    expect(
        localize(
            "A",
            Translations.byText("en-US") +
                {
                  "en-US": "A",
                  "zh-Hanz-CN": "B", // Matched by "zh" only.
                  "zh-Hanz": "C",
                  "zh-Hanz-HK": "D",
                  "zh-Hant": "E",
                  "zh": "F",
                }),
        "F");

    // ---------
  });

  test(
      "If the translation to the exact locale is found, this will be returned. "
      "Otherwise, it tries to return a translation for the general language of the locale. "
      "Otherwise, it tries to return a translation for any locale with that language. "
      "Otherwise, it tries to return the key itself (which is the translation for the default locale).",
      () {
    // Translations exist for "en-US": ----------------

    // There's an EXACT translation for this exact locale.
    DefaultLocale.set("en-US");
    expect("Mobile phone".i18n_1, "Mobile phone");

    // There's NO exact translation, and NO general translation.
    // So uses any other translation in "en".
    DefaultLocale.set("en-UK");
    expect("Mobile phone".i18n_1, "Mobile phone");

    // There's NO general "en" translation, so uses any other translation in "en".
    DefaultLocale.set("en");
    expect("Mobile phone".i18n_1, "Mobile phone");

    // Ignores ending with "_".
    DefaultLocale.set("en-US_");
    expect("Mobile phone".i18n_1, "Mobile phone");

    // Translations exist for "pt-BR" and "pt_pt": ----------------

    // There's an EXACT translation for this exact locale.
    DefaultLocale.set("pt-BR");
    expect("Mobile phone".i18n_1, "Celular");

    // There's an EXACT translation for this exact locale.
    DefaultLocale.set("pt-PT");
    expect("Mobile phone".i18n_1, "Telemóvel");

    // There's NO exact translation, and NO general translation.
    // So uses any other translation in "pt".
    DefaultLocale.set("pt-MO");
    expect("Mobile phone".i18n_1, "Celular");

    // There's NO general "pt" translation, so uses any other translation in "pt".
    DefaultLocale.set("pt");
    expect("Mobile phone".i18n_1, "Celular");

    // There's NO translation at all in this language.
    DefaultLocale.set("xx");
    expect("Mobile phone".i18n_1, "Mobile phone");

    // There's NO translation at all in this locale.
    DefaultLocale.set("xx_yy");
    expect("Mobile phone".i18n_1, "Mobile phone");

    // Translations exist for "pt-BR" and "pt": ----------------

    // There's an EXACT translation for this exact locale.
    DefaultLocale.set("pt-BR");
    expect("Address".i18n_1, "Endereço");

    // There's NO exact translation,
    // So uses the GENERAL translation in "pt".
    DefaultLocale.set("pt-PT");
    expect("Address".i18n_1, "Morada");

    // There's the exact GENERAL translation in "pt".
    DefaultLocale.set("pt");
    expect("Address".i18n_1, "Morada");

    // There's NO translation at all in this language.
    DefaultLocale.set("xx");
    expect("Address".i18n_1, "Address");

    // There's NO translation at all in this locale.
    DefaultLocale.set("xx-yy");
    expect("Address".i18n_1, "Address");

    // Ignores ending with "-".
    DefaultLocale.set("pt-");
    expect("Address".i18n_1, "Morada");
  });

  test(
      "If the translation to the exact locale is found, this will be returned. "
      "Otherwise, it tries to return a translation for the general language of the locale. "
      "Otherwise, it tries to return a translation for any locale with that language. "
      "Otherwise, it tries to return the key itself (which is the translation for the default locale).",
      () {
    // Translations exist for "en": ----------------

    // There's an EXACT translation for this exact locale.
    DefaultLocale.set("en");
    expect("Mobile phone".i18n_2, "Mobile phone");

    // There's NO exact translation, so uses general "en".
    DefaultLocale.set("en-US");
    expect("Mobile phone".i18n_2, "Mobile phone");

    // Ignores country with "_".
    DefaultLocale.set("en--US");
    expect("Mobile phone".i18n_2, "Mobile phone");

    // Translations exist for "pt-BR" and "pt_pt": ----------------

    // There's an EXACT translation for this exact locale.
    DefaultLocale.set("pt-BR");
    expect("Mobile phone".i18n_2, "Celular");

    // There's an EXACT translation for this exact locale.
    DefaultLocale.set("pt-PT");
    expect("Mobile phone".i18n_2, "Telemóvel");

    // There's NO exact translation, and NO general translation.
    // So uses any other translation in "pt".
    DefaultLocale.set("pt_MO");
    expect("Mobile phone".i18n_2, "Celular");

    // There's NO general "pt" translation, so uses any other translation in "pt".
    DefaultLocale.set("pt");
    expect("Mobile phone".i18n_2, "Celular");

    // There's NO translation at all in this language.
    DefaultLocale.set("xx");
    expect("Mobile phone".i18n_2, "Mobile phone");

    // There's NO translation at all in this locale.
    DefaultLocale.set("xx_YY");
    expect("Mobile phone".i18n_2, "Mobile phone");

    // Ignores country with "_".
    DefaultLocale.set("pt__BR");
    expect("Mobile phone".i18n_2, "Celular");

    // Translations exist for "pt-BR" and "pt": ----------------

    // There's an EXACT translation for this exact locale.
    DefaultLocale.set("pt-BR");
    expect("Address".i18n_2, "Endereço");

    // There's NO exact translation,
    // So uses the GENERAL translation in "pt".
    DefaultLocale.set("pt-PT");
    expect("Address".i18n_2, "Morada");

    // There's the exact GENERAL translation in "pt".
    DefaultLocale.set("pt");
    expect("Address".i18n_2, "Morada");

    // There's NO translation at all in this language.
    DefaultLocale.set("xx");
    expect("Address".i18n_2, "Address");

    // There's NO translation at all in this locale.
    DefaultLocale.set("xx_YY");
    expect("Address".i18n_2, "Address");
  });

  test("Ignores spaces or underscore.", () {
    //
    expect(Translations.byText("en").defaultLocaleStr, "en");

    expect(() => Translations.byText("en-"), throwsA(isA<TranslationsException>()));
    expect(() => Translations.byText("en "), throwsA(isA<TranslationsException>()));
    expect(() => Translations.byText(" en "), throwsA(isA<TranslationsException>()));
    expect(() => Translations.byText(" en- "), throwsA(isA<TranslationsException>()));
    expect(() => Translations.byText(" en--- "), throwsA(isA<TranslationsException>()));
    expect(() => Translations.byText(" en-us- "), throwsA(isA<TranslationsException>()));

    expect(() => Translations.byText("en-"), throwsA(isA<TranslationsException>()));
    expect(() => Translations.byText("en "), throwsA(isA<TranslationsException>()));
    expect(() => Translations.byText(" en "), throwsA(isA<TranslationsException>()));
    expect(() => Translations.byText(" en- "), throwsA(isA<TranslationsException>()));
    expect(() => Translations.byText(" en--- "), throwsA(isA<TranslationsException>()));
    expect(() => Translations.byText(" en-us- "), throwsA(isA<TranslationsException>()));

    DefaultLocale.set("en");
    expect(DefaultLocale.locale, "en");

    DefaultLocale.set("en--");
    expect(DefaultLocale.locale, "en");

    DefaultLocale.set("en--US");
    expect(DefaultLocale.locale, "en-US");

    DefaultLocale.set("en-us");
    expect(DefaultLocale.locale, "en-US");

    DefaultLocale.set("EN-US");
    expect(DefaultLocale.locale, "en-US");

    DefaultLocale.set("en-US - ");
    expect(DefaultLocale.locale, "en-US");
  });
}

extension Localization on String {
  //
  static var t1 = Translations.byText("en-US") +
      {
        "en-US": "Mobile phone",
        "pt-BR": "Celular",
        "pt-PT": "Telemóvel",
      } +
      {
        "en-US": "Address",
        "pt-BR": "Endereço",
        "pt": "Morada",
      };

  static var t2 = Translations.byText("en") +
      {
        "en": "Mobile phone",
        "pt-BR": "Celular",
        "pt-PT": "Telemóvel",
      } +
      {
        "en": "Address",
        "pt-BR": "Endereço",
        "pt": "Morada",
      };

  String get i18n_1 => localize(this, t1);

  String get i18n_2 => localize(this, t2);
}
