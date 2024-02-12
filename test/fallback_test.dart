import 'package:i18n_extension_core/src/core_localize_functions.dart';
import 'package:i18n_extension_core/src/translations.dart';
import 'package:test/test.dart';

void main() {
  test(
      "If the translation to the exact locale is found, this will be returned. "
      "Otherwise, it tries to return a translation for the general language of the locale. "
      "Otherwise, it tries to return a translation for any locale with that language. "
      "Otherwise, it tries to return the key itself (which is the translation for the default locale).",
      () {
    // Translations exist for "en_us": ----------------

    // There's an EXACT translation for this exact locale.
    DefaultLocale.set("en_US");
    expect("Mobile phone".i18n_1, "Mobile phone");

    // There's NO exact translation, and NO general translation.
    // So uses any other translation in "en".
    DefaultLocale.set("en_UK");
    expect("Mobile phone".i18n_1, "Mobile phone");

    // There's NO general "en" translation, so uses any other translation in "en".
    DefaultLocale.set("en");
    expect("Mobile phone".i18n_1, "Mobile phone");

    // Ignores ending with "_".
    DefaultLocale.set("en_us_");
    expect("Mobile phone".i18n_1, "Mobile phone");

    // Translations exist for "pt_br" and "pt_pt": ----------------

    // There's an EXACT translation for this exact locale.
    DefaultLocale.set("pt_BR");
    expect("Mobile phone".i18n_1, "Celular");

    // There's an EXACT translation for this exact locale.
    DefaultLocale.set("pt_PT");
    expect("Mobile phone".i18n_1, "Telemóvel");

    // There's NO exact translation, and NO general translation.
    // So uses any other translation in "pt".
    DefaultLocale.set("pt_MO");
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

    // Translations exist for "pt_br" and "pt": ----------------

    // There's an EXACT translation for this exact locale.
    DefaultLocale.set("pt_BR");
    expect("Address".i18n_1, "Endereço");

    // There's NO exact translation,
    // So uses the GENERAL translation in "pt".
    DefaultLocale.set("pt_PT");
    expect("Address".i18n_1, "Morada");

    // There's the exact GENERAL translation in "pt".
    DefaultLocale.set("pt");
    expect("Address".i18n_1, "Morada");

    // There's NO translation at all in this language.
    DefaultLocale.set("xx");
    expect("Address".i18n_1, "Address");

    // There's NO translation at all in this locale.
    DefaultLocale.set("xx_yy");
    expect("Address".i18n_1, "Address");

    // Ignores ending with "_".
    DefaultLocale.set("pt_");
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
    DefaultLocale.set("en_US");
    expect("Mobile phone".i18n_2, "Mobile phone");

    // Ignores country with "_".
    DefaultLocale.set("en__us");
    expect("Mobile phone".i18n_2, "Mobile phone");

    // Translations exist for "pt_br" and "pt_pt": ----------------

    // There's an EXACT translation for this exact locale.
    DefaultLocale.set("pt_BR");
    expect("Mobile phone".i18n_2, "Celular");

    // There's an EXACT translation for this exact locale.
    DefaultLocale.set("pt_PT");
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

    // Translations exist for "pt_br" and "pt": ----------------

    // There's an EXACT translation for this exact locale.
    DefaultLocale.set("pt_BR");
    expect("Address".i18n_2, "Endereço");

    // There's NO exact translation,
    // So uses the GENERAL translation in "pt".
    DefaultLocale.set("pt_PT");
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
    expect(Translations("en_").defaultLocaleStr, "en");
    expect(Translations("en ").defaultLocaleStr, "en");
    expect(Translations(" en ").defaultLocaleStr, "en");
    expect(Translations(" en_ ").defaultLocaleStr, "en");
    expect(Translations(" en___ ").defaultLocaleStr, "en");
    expect(Translations(" en_us_ ").defaultLocaleStr, "en_us");

    expect(Translations("en_").defaultLanguageStr, "en");
    expect(Translations("en ").defaultLanguageStr, "en");
    expect(Translations(" en ").defaultLanguageStr, "en");
    expect(Translations(" en_ ").defaultLanguageStr, "en");
    expect(Translations(" en___ ").defaultLanguageStr, "en");
    expect(Translations(" en_us_ ").defaultLanguageStr, "en");

    DefaultLocale.set("en");
    expect(DefaultLocale.locale, "en");

    DefaultLocale.set("en__");
    expect(DefaultLocale.locale, "en");

    DefaultLocale.set("en_US");
    expect(DefaultLocale.locale, "en_us");

    DefaultLocale.set("en_US");
    expect(DefaultLocale.locale, "en_us");

    DefaultLocale.set("en_us");
    expect(DefaultLocale.locale, "en_us");

    DefaultLocale.set("en_us _ ");
    expect(DefaultLocale.locale, "en_us");
  });
}

extension Localization on String {
  //
  static var t1 = Translations("en_us") +
      {
        "en_us": "Mobile phone",
        "pt_br": "Celular",
        "pt_pt": "Telemóvel",
      } +
      {
        "en_us": "Address",
        "pt_br": "Endereço",
        "pt": "Morada",
      };

  static var t2 = Translations("en") +
      {
        "en": "Mobile phone",
        "pt_br": "Celular",
        "pt_pt": "Telemóvel",
      } +
      {
        "en": "Address",
        "pt_br": "Endereço",
        "pt": "Morada",
      };

  String get i18n_1 => localize(this, t1);

  String get i18n_2 => localize(this, t2);
}
