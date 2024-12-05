import 'package:i18n_extension_core/i18n_extension_core.dart';
import 'package:test/test.dart';

void main() {
  //
  test("Empty translations.", () {
    DefaultLocale.set("en-US");

    const t = ConstTranslations("en-US", <String, Map<String, String>>{});
    expect(t.length, 0);
    expect(t.translationByLocale_ByTranslationKey, {});
    expect(
        t.toString(),
        '\n'
        'Translations: ---------------\n');
  });

  test("Can't add a Map to a const translation.", () {
    DefaultLocale.set("en-US");
    expect(
        () =>
            const ConstTranslations("en-US", <String, Map<String, String>>{}) +
            {"en-US": "Hi."},
        throwsA(isA<UnsupportedError>()));
  });

  test("Add translation in English only (2).", () {
    DefaultLocale.set("en-US");
    var t = const ConstTranslations("en-US", {
      "Hi.": {"en-US": "Hi."}
    });
    expect(t.length, 1);
    expect(t.translationByLocale_ByTranslationKey, {
      'Hi.': {'en-US': 'Hi.'}
    });
    expect(
        t.toString(),
        '\nTranslations: ---------------\n'
        '  en-US | Hi.\n'
        '-----------------------------\n');
  });

  test("Add translation in many languages.", () {
    DefaultLocale.set("en-US");

    var t = const ConstTranslations("en-US", {
      "Hi.": {
        "cs-CZ": "Ahoj.",
        "en-US": "Hi.",
        "en-UK": "Hi.",
        "pt-BR": "Olá.",
        "es": "Hola.",
      },
    });

    expect(t.length, 1);

    expect(t.translationByLocale_ByTranslationKey, {
      "Hi.": {
        "en-US": "Hi.",
        "en-UK": "Hi.",
        "cs-CZ": "Ahoj.",
        "pt-BR": "Olá.",
        "es": "Hola.",
      }
    });

    expect(
        t.toString(),
        '\nTranslations: ---------------\n'
        '  en-US | Hi.\n'
        '  en-UK | Hi.\n'
        '  cs-CZ | Ahoj.\n'
        '  es    | Hola.\n'
        '  pt-BR | Olá.\n'
        '-----------------------------\n');
  });

  test("Add 2 translations in a single language.", () {
    DefaultLocale.set("en-US");

    var t = const ConstTranslations("en-US", {
      "Hi.": {"en-US": "Hi."},
      "Goodbye.": {"en-US": "Goodbye."},
    });

    expect(t.length, 2);

    expect(t.translationByLocale_ByTranslationKey, {
      "Hi.": {"en-US": "Hi."},
      "Goodbye.": {"en-US": "Goodbye."}
    });

    expect(
        t.toString(),
        '\nTranslations: ---------------\n'
        '  en-US | Hi.\n'
        '-----------------------------\n'
        '  en-US | Goodbye.\n'
        '-----------------------------\n');
  });

  test("Add 2 translations in 2 languages.", () {
    DefaultLocale.set("en-US");

    var t = const ConstTranslations("en-US", {
      "Hi.": {"en-US": "Hi.", "pt-BR": "Olá."},
      "Goodbye.": {"en-US": "Goodbye.", "pt-BR": "Adeus."},
    });

    expect(t.length, 2);

    expect(t.translationByLocale_ByTranslationKey, {
      "Hi.": {
        "en-US": "Hi.",
        "pt-BR": "Olá.",
      },
      "Goodbye.": {
        "en-US": "Goodbye.",
        "pt-BR": "Adeus.",
      }
    });

    expect(
        t.toString(),
        '\nTranslations: ---------------\n'
        '  en-US | Hi.\n'
        '  pt-BR | Olá.\n'
        '-----------------------------\n'
        '  en-US | Goodbye.\n'
        '  pt-BR | Adeus.\n'
        '-----------------------------\n');
  });

  test("Can't add a translation to a const translation.", () {
    DefaultLocale.set("en-US");

    var t1 = const ConstTranslations("en-US", {
      "Hi.": {"en-US": "Hi.", "pt-BR": "Olá."}
    });

    var t2 = const ConstTranslations("en-US", {
      "Goodbye.": {"en-US": "Goodbye.", "pt-BR": "Adeus."}
    });

    expect(() => t1 * t2, throwsA(isA<UnsupportedError>()));
  });

  test("Can add a const translation to a regular translation.", () {
    DefaultLocale.set("en-US");

    var t1 = Translations.byText("en-US") +
        {
          "en-US": "Hi.",
          "pt-BR": "Olá.",
        };

    var t2 = const ConstTranslations("en-US", {
      "Goodbye.": {
        "en-US": "Goodbye.",
        "pt-BR": "Adeus.",
      }
    });

    var t = t1 * t2;

    expect(t.length, 2);

    expect(t.translationByLocale_ByTranslationKey, {
      "Hi.": {
        "en-US": "Hi.",
        "pt-BR": "Olá.",
      },
      "Goodbye.": {
        "en-US": "Goodbye.",
        "pt-BR": "Adeus.",
      }
    });

    expect(
        t.toString(),
        '\nTranslations: ---------------\n'
        '  en-US | Hi.\n'
        '  pt-BR | Olá.\n'
        '-----------------------------\n'
        '  en-US | Goodbye.\n'
        '  pt-BR | Adeus.\n'
        '-----------------------------\n');
  });

  test("Translate manually.", () {
    //
    var t = const ConstTranslations("en-US", {
      "Hi.": {"en-US": "Hi.", "pt-BR": "Olá."},
      "Goodbye.": {"en-US": "Goodbye.", "pt-BR": "Adeus."}
    });

    DefaultLocale.set("en-US");
    expect(localize("Hi.", t), "Hi.");
    expect(localize("Goodbye.", t), "Goodbye.");

    DefaultLocale.set("pt-BR");
    expect(localize("Hi.", t), "Olá.");
    expect(localize("Goodbye.", t), "Adeus.");

    // When it doesn't find, it returns the original string.
    // This is useful for development, when you are adding translations.
    // Note this missing translation is added to the missing translations list.
    expect(localize("DOESN'T FIND", t), "DOESN'T FIND");
  });

  test("Translate using the extension.", () {
    //
    DefaultLocale.set("en-US");
    expect("Hi.".i18n, "Hi.");
    expect("Goodbye.".i18n, "Goodbye.");
    expect("XYZ".i18n, "XYZ");

    DefaultLocale.set("pt-BR");
    expect("Hi.".i18n, "Olá.");
    expect("Goodbye.".i18n, "Adeus.");
    expect("XYZ".i18n, "XYZ");
  });
}

extension Localization on String {
  //
  static final _t = Translations.byText("en-US") +
      {
        "en-US": "Hi.",
        "cs-CZ": "Zdravím tě",
        "en-UK": "Hi.",
        "pt-BR": "Olá.",
        "es": "Hola.",
      } +
      {
        "en-US": "Goodbye.",
        "pt-BR": "Adeus.",
        "cs-CZ": "Sbohem.",
        "en-UK": "Goodbye.",
        "es": "Adiós.",
      } +
      {
        "en-US": "There is 1 item."
            .zero("There are no items.")
            .one("There is 1 item.")
            .two("There are a pair of items.")
            .times(5, "Yes, you reached 5 items.")
            .many("There are %d items."),
        "pt-BR": "Há 1 item."
            .zero("Não há itens.")
            .one("Há 1 item.")
            .two("Há um par de itens.")
            .times(5, "Sim, você alcançou 5 items.")
            .many("Há %d itens."),
      } +
      {
        "en-US": "There is a person"
            .modifier(Gender.male, "There is a man")
            .modifier(Gender.female, "There is a woman")
            .modifier(Gender.they, "There is a person"),
        "pt-BR": "Há uma pessoa"
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
