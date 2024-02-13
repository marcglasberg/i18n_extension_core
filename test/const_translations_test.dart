import 'package:i18n_extension_core/i18n_extension_core.dart';
import 'package:test/test.dart';

void main() {
  //
  test("Empty translations.", () {
    DefaultLocale.set("en_US");

    const t = ConstTranslations("en_us", <String, Map<String, String>>{});
    expect(t.length, 0);
    expect(t.translationByLocale_ByTranslationKey, {});
    expect(
        t.toString(),
        '\n'
        'Translations: ---------------\n');
  });

  test("Can't add a Map to a const translation.", () {
    DefaultLocale.set("en_US");
    expect(
        () => const ConstTranslations("en_us", <String, Map<String, String>>{}) + {"en_us": "Hi."},
        throwsA(isA<UnsupportedError>()));
  });

  test("Add translation in English only (2).", () {
    DefaultLocale.set("en_US");
    var t = const ConstTranslations("en_us", {
      "Hi.": {"en_us": "Hi."}
    });
    expect(t.length, 1);
    expect(t.translationByLocale_ByTranslationKey, {
      'Hi.': {'en_us': 'Hi.'}
    });
    expect(
        t.toString(),
        '\nTranslations: ---------------\n'
        '  en_us | Hi.\n'
        '-----------------------------\n');
  });

  test("Add translation in many languages.", () {
    DefaultLocale.set("en_US");

    var t = const ConstTranslations("en_us", {
      "Hi.": {
        "cs_cz": "Ahoj.",
        "en_us": "Hi.",
        "en_uk": "Hi.",
        "pt_br": "Olá.",
        "es": "Hola.",
      },
    });

    expect(t.length, 1);

    expect(t.translationByLocale_ByTranslationKey, {
      "Hi.": {
        "en_us": "Hi.",
        "en_uk": "Hi.",
        "cs_cz": "Ahoj.",
        "pt_br": "Olá.",
        "es": "Hola.",
      }
    });

    expect(
        t.toString(),
        '\nTranslations: ---------------\n'
        '  en_us | Hi.\n'
        '  en_uk | Hi.\n'
        '  cs_cz | Ahoj.\n'
        '  es    | Hola.\n'
        '  pt_br | Olá.\n'
        '-----------------------------\n');
  });

  test("Add 2 translations in a single language.", () {
    DefaultLocale.set("en_US");

    var t = const ConstTranslations("en_us", {
      "Hi.": {"en_us": "Hi."},
      "Goodbye.": {"en_us": "Goodbye."},
    });

    expect(t.length, 2);

    expect(t.translationByLocale_ByTranslationKey, {
      "Hi.": {"en_us": "Hi."},
      "Goodbye.": {"en_us": "Goodbye."}
    });

    expect(
        t.toString(),
        '\nTranslations: ---------------\n'
        '  en_us | Hi.\n'
        '-----------------------------\n'
        '  en_us | Goodbye.\n'
        '-----------------------------\n');
  });

  test("Add 2 translations in 2 languages.", () {
    DefaultLocale.set("en_US");

    var t = const ConstTranslations("en_us", {
      "Hi.": {"en_us": "Hi.", "pt_br": "Olá."},
      "Goodbye.": {"en_us": "Goodbye.", "pt_br": "Adeus."},
    });

    expect(t.length, 2);

    expect(t.translationByLocale_ByTranslationKey, {
      "Hi.": {
        "en_us": "Hi.",
        "pt_br": "Olá.",
      },
      "Goodbye.": {
        "en_us": "Goodbye.",
        "pt_br": "Adeus.",
      }
    });

    expect(
        t.toString(),
        '\nTranslations: ---------------\n'
        '  en_us | Hi.\n'
        '  pt_br | Olá.\n'
        '-----------------------------\n'
        '  en_us | Goodbye.\n'
        '  pt_br | Adeus.\n'
        '-----------------------------\n');
  });

  test("Can't add a translation to a const translation.", () {
    DefaultLocale.set("en_US");

    var t1 = const ConstTranslations("en_us", {
      "Hi.": {"en_us": "Hi.", "pt_br": "Olá."}
    });

    var t2 = const ConstTranslations("en_us", {
      "Goodbye.": {"en_us": "Goodbye.", "pt_br": "Adeus."}
    });

    expect(() => t1 * t2, throwsA(isA<UnsupportedError>()));
  });

  test("Can add a const translation to a regular translation.", () {
    DefaultLocale.set("en_US");

    var t1 = Translations.byText("en_us") +
        {
          "en_us": "Hi.",
          "pt_br": "Olá.",
        };

    var t2 = const ConstTranslations("en_us", {
      "Goodbye.": {
        "en_us": "Goodbye.",
        "pt_br": "Adeus.",
      }
    });

    var t = t1 * t2;

    expect(t.length, 2);

    expect(t.translationByLocale_ByTranslationKey, {
      "Hi.": {
        "en_us": "Hi.",
        "pt_br": "Olá.",
      },
      "Goodbye.": {
        "en_us": "Goodbye.",
        "pt_br": "Adeus.",
      }
    });

    expect(
        t.toString(),
        '\nTranslations: ---------------\n'
        '  en_us | Hi.\n'
        '  pt_br | Olá.\n'
        '-----------------------------\n'
        '  en_us | Goodbye.\n'
        '  pt_br | Adeus.\n'
        '-----------------------------\n');
  });

  test("Translate manually.", () {
    //
    var t = const ConstTranslations("en_us", {
      "Hi.": {"en_us": "Hi.", "pt_br": "Olá."},
      "Goodbye.": {"en_us": "Goodbye.", "pt_br": "Adeus."}
    });

    DefaultLocale.set("en_US");
    expect(localize("Hi.", t), "Hi.");
    expect(localize("Goodbye.", t), "Goodbye.");

    DefaultLocale.set("pt_BR");
    expect(localize("Hi.", t), "Olá.");
    expect(localize("Goodbye.", t), "Adeus.");

    // When it doesn't find, it returns the original string.
    // This is useful for development, when you are adding translations.
    // Note this missing translation is added to the missing translations list.
    expect(localize("DOESN'T FIND", t), "DOESN'T FIND");
  });

  test("Translate using the extension.", () {
    //
    DefaultLocale.set("en_US");
    expect("Hi.".i18n, "Hi.");
    expect("Goodbye.".i18n, "Goodbye.");
    expect("XYZ".i18n, "XYZ");

    DefaultLocale.set("pt_BR");
    expect("Hi.".i18n, "Olá.");
    expect("Goodbye.".i18n, "Adeus.");
    expect("XYZ".i18n, "XYZ");
  });
}

extension Localization on String {
  //
  static final _t = Translations.byText("en_us") +
      {
        "en_us": "Hi.",
        "cs_cz": "Zdravím tě",
        "en_uk": "Hi.",
        "pt_br": "Olá.",
        "es": "Hola.",
      } +
      {
        "en_us": "Goodbye.",
        "pt_br": "Adeus.",
        "cs_cz": "Sbohem.",
        "en_uk": "Goodbye.",
        "es": "Adiós.",
      } +
      {
        "en_us": "There is 1 item."
            .zero("There are no items.")
            .one("There is 1 item.")
            .two("There are a pair of items.")
            .times(5, "Yes, you reached 5 items.")
            .many("There are %d items."),
        "pt_br": "Há 1 item."
            .zero("Não há itens.")
            .one("Há 1 item.")
            .two("Há um par de itens.")
            .times(5, "Sim, você alcançou 5 items.")
            .many("Há %d itens."),
      } +
      {
        "en_us": "There is a person"
            .modifier(Gender.male, "There is a man")
            .modifier(Gender.female, "There is a woman")
            .modifier(Gender.they, "There is a person"),
        "pt_br": "Há uma pessoa"
            .modifier(Gender.male, "Há um homem")
            .modifier(Gender.female, "Há uma mulher")
            .modifier(Gender.they, "Há uma pessoa"),
      };

  String get i18n => localize(this, _t);

  String fill(List<Object> params) => localizeFill(this, params);

  String? plural(value) => localizePlural(value, this, _t);

  String version(Object modifier) => localizeVersion(modifier, this, _t);

  Map<String?, String> allVersions() => localizeAllVersions(this, _t);

  String gender(Gender gnd) => localizeVersion(gnd, this, _t);
}

enum Gender { they, female, male, x }

class SomeObj {
  final String value;

  SomeObj(this.value);

  @override
  String toString() => 'SomeObj{value: $value}';
}
