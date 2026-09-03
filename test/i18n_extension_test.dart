import 'package:i18n_extension_core/i18n_extension_core.dart';
import 'package:test/test.dart';

void main() {
  //
  test("Empty translations.", () {
    DefaultLocale.set("en-US");

    var t = Translations.byText("en-US");
    expect(t.length, 0);
    expect(t.translationByLocale_ByTranslationKey, {});
    expect(
        t.toString(),
        '\n'
        'Translations: ---------------\n');
  });

  test("Add translation in English only.", () {
    DefaultLocale.set("en-US");
    print(Translations.byText("en-US").runtimeType);
    var t = (Translations.byText("en-US")) + {"en-US": "Hi"};
    expect(t.length, 1);
    expect(t.translationByLocale_ByTranslationKey, {
      'Hi': {'en-US': 'Hi'}
    });
    expect(
        t.toString(),
        '\nTranslations: ---------------\n'
        '  en-US | Hi\n'
        '-----------------------------\n');
  });

  test("Add translation in many languages.", () {
    DefaultLocale.set("en-US");

    Translations t = Translations.byText("en-US") +
        {
          "cs-CZ": "Ahoj.",
          "en-US": "Hi.",
          "en-UK": "Hi.",
          "pt-BR": "Olá.",
          "es": "Hola.",
        };

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

    var t = Translations.byText("en-US") +
        {
          "en-US": "Hi.",
        } +
        {
          "en-US": "Goodbye.",
        };

    expect(t.length, 2);

    expect(t.translationByLocale_ByTranslationKey, {
      "Hi.": {
        "en-US": "Hi.",
      },
      "Goodbye.": {
        "en-US": "Goodbye.",
      }
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

    var t = Translations.byText("en-US") +
        {
          "en-US": "Hi.",
          "pt-BR": "Olá.",
        } +
        {
          "en-US": "Goodbye.",
          "pt-BR": "Adeus.",
        };

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

  test("Translations with versions.", () {
    DefaultLocale.set("en-US");

    var t = Translations.byText("en-US") +
        {
          "en-US": "MyString".zero("Zero").one("One").two("Two").many("many"),
          "pt-BR": "MinhaString".zero("Zero").one("Um").two("Dois").many("Muitos"),
        };

    expect(t.length, 1);

    expect(t.translationByLocale_ByTranslationKey, {
      "MyString": {
        "en-US":
            "\uFFFFMyString\uFFFF0\uFFFEZero\uFFFF1\uFFFEOne\uFFFF2\uFFFETwo\uFFFFM\uFFFEmany",
        "pt-BR":
            "\uFFFFMinhaString\uFFFF0\uFFFEZero\uFFFF1\uFFFEUm\uFFFF2\uFFFEDois\uFFFFM\uFFFEMuitos",
      },
    });

    expect(
        t.toString(),
        '\nTranslations: ---------------\n'
        '  en-US | MyString\n'
        '          0 → Zero\n'
        '          1 → One\n'
        '          2 → Two\n'
        '          M → many\n'
        '  pt-BR | MinhaString\n'
        '          0 → Zero\n'
        '          1 → Um\n'
        '          2 → Dois\n'
        '          M → Muitos\n'
        '-----------------------------\n');
  });

  test("Translations by locale with versions.", () {
    DefaultLocale.set("en-US");

    var t = Translations.byLocale("en-US") +
        {
          "en-US": {
            "MyString": "MyString".zero("Zero").one("One").two("Two").many("many"),
          },
          "pt-BR": {
            "MyString": "MinhaString".zero("Zero").one("Um").two("Dois").many("Muitos"),
          }
        };

    expect(t.length, 1);

    expect(t.translationByLocale_ByTranslationKey, {
      "MyString": {
        "en-US":
            "\uFFFFMyString\uFFFF0\uFFFEZero\uFFFF1\uFFFEOne\uFFFF2\uFFFETwo\uFFFFM\uFFFEmany",
        "pt-BR":
            "\uFFFFMinhaString\uFFFF0\uFFFEZero\uFFFF1\uFFFEUm\uFFFF2\uFFFEDois\uFFFFM\uFFFEMuitos",
      },
    });

    expect(
        t.toString(),
        '\nTranslations: ---------------\n'
        '  en-US | MyString\n'
        '          0 → Zero\n'
        '          1 → One\n'
        '          2 → Two\n'
        '          M → many\n'
        '  pt-BR | MinhaString\n'
        '          0 → Zero\n'
        '          1 → Um\n'
        '          2 → Dois\n'
        '          M → Muitos\n'
        '-----------------------------\n');
  });

  test("Translations by locale with plurals.", () {
    DefaultLocale.set("en-US");

    String key = "You clicked the button %d times";

    var t = Translations.byLocale("en-US") +
        {
          "en-US": {
            key: "You clicked the button %d times"
                .zero("You haven't clicked the button")
                .one("You clicked it once")
                .two("You clicked a couple times")
                .many("You clicked %d times")
                .times(12, "You clicked a dozen times"),
          },
          "pt-BR": {
            key: "Você clicou o botão %d vezes"
                .zero("Você não clicou no botão")
                .one("Você clicou uma única vez")
                .two("Você clicou um par de vezes")
                .many("Você clicou %d vezes")
                .times(12, "Você clicou uma dúzia de vezes"),
          }
        };

    String plural(value) => localizePlural(value, key, t);

    expect(plural(0), "You haven't clicked the button");
    expect(plural(1), "You clicked it once");
    expect(plural(2), "You clicked a couple times");
    expect(plural(3), "You clicked 3 times");
    expect(plural(12), "You clicked a dozen times");
    expect(plural('12'), "You clicked a dozen times");

    DefaultLocale.set("pt-BR");

    expect(plural(0), "Você não clicou no botão");
    expect(plural(1), "Você clicou uma única vez");
    expect(plural(2), "Você clicou um par de vezes");
    expect(plural(3), "Você clicou 3 vezes");
    expect(plural(12), "Você clicou uma dúzia de vezes");
  });

  test("Combine 2 translations.", () {
    DefaultLocale.set("en-US");

    var t1 = Translations.byText("en-US") +
        {
          "en-US": "Hi.",
          "pt-BR": "Olá.",
        };

    var t2 = Translations.byText("en-US") +
        {
          "en-US": "Goodbye.",
          "pt-BR": "Adeus.",
        };

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

  test("Add 2 translations in 3 languages, by locale.", () {
    DefaultLocale.set("en-US");

    var t = Translations.byLocale("en-US") +
        {
          "en-US": {
            "Hi.": "Hi.",
            "Goodbye.": "Goodbye.",
          },
          "es-ES": {
            "Hi.": "Hola.",
            "Goodbye.": "Adiós.",
          }
        } +
        {
          "pt-BR": {
            "Hi.": "Olá.",
            "Goodbye.": "Adeus.",
          }
        };

    expect(t.length, 2);

    expect(t.translationByLocale_ByTranslationKey, {
      "Hi.": {
        "en-US": "Hi.",
        "es-ES": "Hola.",
        "pt-BR": "Olá.",
      },
      "Goodbye.": {
        "en-US": "Goodbye.",
        "es-ES": "Adiós.",
        "pt-BR": "Adeus.",
      }
    });

    expect(
        t.toString(),
        '\nTranslations: ---------------\n'
        '  en-US | Hi.\n'
        '  es-ES | Hola.\n'
        '  pt-BR | Olá.\n'
        '-----------------------------\n'
        '  en-US | Goodbye.\n'
        '  es-ES | Adiós.\n'
        '  pt-BR | Adeus.\n'
        '-----------------------------\n');
  });

  test("Combine 2 translations, one of them by locale. Define both as `Translations`",
      () {
    DefaultLocale.set("en-US");

    Translations t1 = Translations.byText("en-US") +
        {
          "cs-CZ": "Ahoj.",
          "en-US": "Hi.",
          "pt-BR": "Olá.",
        };

    Translations t2 = Translations.byLocale("en-US") +
        {
          "pt-BR": {
            "Hi.": "Olá.",
            "Goodbye.": "Adeus.",
          }
        };

    // ---

    var t12 = t1 * t2;

    expect(t12.length, 2);

    expect(t12.translationByLocale_ByTranslationKey, {
      'Hi.': {
        'cs-CZ': 'Ahoj.',
        'en-US': 'Hi.',
        'pt-BR': 'Olá.',
      },
      'Goodbye.': {
        'pt-BR': 'Adeus.',
      }
    });

    // ---

    var t21 = t2 * t1;

    expect(t21.length, 2);

    expect(t21.translationByLocale_ByTranslationKey, {
      'Hi.': {
        'cs-CZ': 'Ahoj.',
        'en-US': 'Hi.',
        'pt-BR': 'Olá.',
      },
      'Goodbye.': {
        'pt-BR': 'Adeus.',
      }
    });
  });

  test("Combine 2 translations by locale.", () {
    DefaultLocale.set("en-US");

    var t1 = Translations.byLocale("en-US") +
        {
          "en-US": {
            "Hi.": "Hi.",
            "Goodbye.": "Goodbye.",
          },
          "es-ES": {
            "Hi.": "Hola.",
            "Goodbye.": "Adiós.",
          }
        };

    Translations t2 = Translations.byLocale("en-US") +
        {
          "pt-BR": {
            "Hi.": "Olá.",
            "Goodbye.": "Adeus.",
          }
        };

    var t = t1 * t2;

    expect(t.length, 2);

    expect(t.translationByLocale_ByTranslationKey, {
      "Hi.": {
        "en-US": "Hi.",
        "es-ES": "Hola.",
        "pt-BR": "Olá.",
      },
      "Goodbye.": {
        "en-US": "Goodbye.",
        "es-ES": "Adiós.",
        "pt-BR": "Adeus.",
      }
    });

    expect(
        t.toString(),
        '\nTranslations: ---------------\n'
        '  en-US | Hi.\n'
        '  es-ES | Hola.\n'
        '  pt-BR | Olá.\n'
        '-----------------------------\n'
        '  en-US | Goodbye.\n'
        '  es-ES | Adiós.\n'
        '  pt-BR | Adeus.\n'
        '-----------------------------\n');
  });

  test("Keys can vary from the translations. Should return the value or key.", () {
    var t = Translations.byLocale("en-US") +
        {
          "en-US": {
            "Hi.": "Hello.", // Different key/value for default language
            "Goodbye.": "Goodbye.",
          },
          "es-ES": {
            "Hi.": "Hola.",
            "Goodbye.": "Adiós.",
          },
          "pt-BR": {
            // Hi is missing,
            "Goodbye.": "Adeus.",
          }
        };
    expect(t.length, 2);

    expect(t.translationByLocale_ByTranslationKey, {
      "Hi.": {
        "en-US": "Hello.",
        "es-ES": "Hola.",
      },
      "Goodbye.": {
        "en-US": "Goodbye.",
        "es-ES": "Adiós.",
        "pt-BR": "Adeus.",
      }
    });

    expect(
        t.toString(),
        '\nTranslations: ---------------\n'
        '  en-US | Hello.\n'
        '  es-ES | Hola.\n'
        '-----------------------------\n'
        '  en-US | Goodbye.\n'
        '  es-ES | Adiós.\n'
        '  pt-BR | Adeus.\n'
        '-----------------------------\n');

    // The translations should return the default value, rather than the key
    DefaultLocale.set("en-US");
    expect(localize('Hi.', t), "Hello.");

    DefaultLocale.set("es-ES");
    expect(localize('Hi.', t), "Hola.");

    DefaultLocale.set("pt-BR");
    expect(localize('Hi.', t), "Hello.");
  });

  test("Combine 2 translations, one of them by locale. Define both as `var`", () {
    DefaultLocale.set("en-US");

    var t1 = Translations.byText("en-US") +
        {
          "cs-CZ": "Ahoj.",
          "en-US": "Hi.",
          "pt-BR": "Olá.",
        };

    var t2 = Translations.byLocale("en-US") +
        {
          "pt-BR": {
            "Hi.": "Olá.",
            "Goodbye.": "Adeus.",
          }
        };

    // ---

    var t12 = t1 * t2;

    expect(t12.length, 2);

    expect(t12.translationByLocale_ByTranslationKey, {
      'Hi.': {
        'cs-CZ': 'Ahoj.',
        'en-US': 'Hi.',
        'pt-BR': 'Olá.',
      },
      'Goodbye.': {
        'pt-BR': 'Adeus.',
      }
    });

    // ---

    var t21 = t2 * t1;

    expect(t21.length, 2);

    expect(t21.translationByLocale_ByTranslationKey, {
      'Hi.': {
        'cs-CZ': 'Ahoj.',
        'en-US': 'Hi.',
        'pt-BR': 'Olá.',
      },
      'Goodbye.': {
        'pt-BR': 'Adeus.',
      }
    });
  });

  test("Translate manually.", () {
    //
    var t = Translations.byText("en-US") +
        {
          "en-US": "Hi.",
          "pt-BR": "Olá.",
        } +
        {
          "en-US": "Goodbye.",
          "pt-BR": "Adeus.",
        };

    DefaultLocale.set("en-US");
    expect(localize("Hi.", t), "Hi.");
    expect(localize("Goodbye", t), "Goodbye");

    DefaultLocale.set("pt-BR");
    expect(localize("Hi.", t), "Olá.");
    expect(localize("Goodbye.", t), "Adeus.");
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

  test("Record missing keys and missing translations.", () {
    //
    // ---------------

    // 1) Search for a key which exists, and the translation also exists.

    Translations.supportedLocales = ["en-US", "cs-CZ", "en-UK", "pt-BR", "es"];
    Translations.missingKeys.clear();
    Translations.missingTranslations.clear();
    expect(Translations.missingKeys, isEmpty);
    expect(Translations.missingTranslations, isEmpty);

    DefaultLocale.set("en-US");
    expect("Hi.".i18n, "Hi.");

    DefaultLocale.set("pt-BR");
    expect("Hi.".i18n, "Olá.");

    expect(Translations.missingKeys, isEmpty);
    expect(Translations.missingTranslations, isEmpty);

    // ---------------

    // 2) Search for a key which does NOT exist.

    Translations.supportedLocales = ["en-US", "cs-CZ", "en-UK", "pt-BR", "es"];
    Translations.missingKeys.clear();
    Translations.missingTranslations.clear();

    DefaultLocale.set("en-US");
    expect("Unknown text".i18n, "Unknown text");

    expect(Translations.missingKeys.single,
        TranslatedString(locale: "en-US", key: "Unknown text"));

    expect(Translations.missingTranslations, isEmpty);

    // ---------------

    // 3) Search for a key which exists, but the translation in the locale does NOT,
    //    and "xx-YY" is a supported locale.

    //
    Translations.supportedLocales = ["xx-YY", "en-US", "cs-CZ", "en-UK", "pt-BR", "es"];
    Translations.missingKeys.clear();
    Translations.missingTranslations.clear();

    DefaultLocale.set("xx_YY");
    expect("Hi.".i18n, "Hi.");

    expect(Translations.missingKeys, isEmpty);

    expect(Translations.missingTranslations.single,
        TranslatedString(locale: "xx-YY", key: "Hi."));

    // ---------------

    // 4) Search for a key which exists, but the translation in the locale does NOT,
    //    and "xx-YY" is NOT a supported locale.

    Translations.supportedLocales = ["en-US", "cs-CZ", "en-UK", "pt-BR", "es"];
    Translations.missingKeys.clear();
    Translations.missingTranslations.clear();

    DefaultLocale.set("xx_YY");
    expect("Hi.".i18n, "Hi.");

    expect(Translations.missingKeys, isEmpty);
    expect(Translations.missingTranslations, isEmpty);
  });

  test(
      "Don't record unnecessary missing translations with the Translation.byLocale constructor.",
      () {
    //
    // ---------------

    // 1) You CAN provide the translations "by locale" in the default locale, if you want.

    Translations.missingKeys.clear();
    Translations.missingTranslations.clear();

    var t1 = Translations.byLocale("en-US") +
        {
          "en-US": {"Hi.": "Hi."},
          "es-ES": {"Hi.": "Hola."}
        };

    DefaultLocale.set("en-US");
    expect(localize("Hi.", t1), "Hi.");

    expect(Translations.missingKeys, isEmpty);
    expect(Translations.missingTranslations, isEmpty);

    // ---------------

    // 2) But you don't NEED to to provide the translations "by locale" in the default locale.

    Translations.missingKeys.clear();
    Translations.missingTranslations.clear();

    var t2 = Translations.byLocale("en-US") +
        {
          "es-ES": {"Hi.": "Hola."}
        };

    DefaultLocale.set("en-US");
    expect(localize("Hi.", t2), "Hi.");

    expect(Translations.missingKeys, isEmpty);
    expect(Translations.missingTranslations, isEmpty);

    // ---------------

    // 3) However, note this doesn't reduce boilerplate when using the regular constructor,
    // since it uses the default locale translation as key.

    Translations.missingKeys.clear();
    Translations.missingTranslations.clear();

    var t3 = Translations.byText("en-US") +
        {
          "en-US": "Hi.",
          "es-ES": "Hola.",
        };

    DefaultLocale.set("en-US");
    expect(localize("Hi.", t3), "Hi.");

    expect(Translations.missingKeys, isEmpty);
    expect(Translations.missingTranslations, isEmpty);

    expect(() => Translations.byText("en-US") + {"es-ES": "Hola."},
        throwsA(TranslationsException("No default translation for 'en-US'.")));

    // ---------------
  });

  test("You must provide the translation in the default language.", () {
    //
    expect(() => Translations.byText("en-US") + {"pt-BR": "Olá."},
        throwsA(TranslationsException("No default translation for 'en-US'.")));

    expect(() => Translations.byText("en-US") + {"pt-BR": "Olá."},
        throwsA(TranslationsException("No default translation for 'en-US'.")));
  });

  test("Translations with version.", () {
    //
    var text = "MyKey".modifier("x", "abc");
    expect(text, "\uFFFFMyKey\uFFFFx\uFFFEabc");

    text = "MyKey".modifier("x", "abc").modifier("y", "def");
    expect(text, "\uFFFFMyKey\uFFFFx\uFFFEabc\uFFFFy\uFFFEdef");

    text = "MyKey".zero("abc").one("def").two("ghi").many("jkl").times(5, "mno");
    expect(text,
        "\uFFFFMyKey\uFFFF0\uFFFEabc\uFFFF1\uFFFEdef\uFFFF2\uFFFEghi\uFFFFM\uFFFEjkl\uFFFF5\uFFFEmno");

    expect(text.plural(0), "abc");
    expect(text.version("0"), "abc");
    expect(text.allVersions()["0"], "abc");

    expect(text.plural(1), "def");
    expect(text.version("1"), "def");
    expect(text.allVersions()["1"], "def");

    expect(text.plural(2), "ghi");
    expect(text.version("2"), "ghi");
    expect(text.allVersions()["2"], "ghi");

    expect(text.plural(3), "jkl");
    expect(text.version("M"), "jkl");
    expect(text.allVersions()["M"], "jkl");

    expect(text.plural(5), "mno");
    expect(text.version("5"), "mno");
    expect(text.allVersions()["5"], "mno");

    // Gender modifiers are encoded as "m", "f" and "n".
    text = "MyKey".male("abc").female("def").neutral("ghi");
    expect(text, "\uFFFFMyKey\uFFFFm\uFFFEabc\uFFFFf\uFFFEdef\uFFFFn\uFFFEghi");

    expect(text.gender(Gender.male), "abc");
    expect(text.version("m"), "abc");
    expect(text.allVersions()["m"], "abc");

    expect(text.gender(Gender.female), "def");
    expect(text.version("f"), "def");
    expect(text.allVersions()["f"], "def");

    expect(text.gender(Gender.neutral), "ghi");
    expect(text.version("n"), "ghi");
    expect(text.allVersions()["n"], "ghi");

    // Gender and plural modifiers can be mixed, and don't collide:
    // "m" (male) is not "M" (many), and "f" (female) is not "F" (zeroOne).
    text = "MyKey".many("abc").zeroOne("def").male("ghi").female("jkl");
    expect(text.plural(3), "abc");
    expect(text.plural(1), "def");
    expect(text.gender(Gender.male), "ghi");
    expect(text.gender(Gender.female), "jkl");
    expect(text.gender(Gender.neutral), "MyKey");

    // Nested modifiers are flattened, with the outer identifier prepended to the
    // identifiers of the inner versions. This is how gender and plural are combined.
    text = "MyKey".male("abc".zero("def").many("ghi"));
    expect(text, "MyKey".male("abc").modifier("m0", "def").modifier("mM", "ghi"));
    expect(text.allVersions(), {null: "MyKey", "m": "abc", "m0": "def", "mM": "ghi"});
    expect(text.gender(Gender.male), "abc");
    expect(text.plural(1, Gender.male), "abc");
    expect(text.plural(0, Gender.male), "def");
    expect(text.plural(3, Gender.male), "ghi");
    expect(text.plural(3, Gender.female), "MyKey");
    expect(text.plural(3), "MyKey");

    // Custom modifiers are flattened the same way.
    text = "MyKey".modifier("x", "abc".modifier("y", "def").modifier("z", "ghi"));
    expect(text, "MyKey".modifier("x", "abc").modifier("xy", "def").modifier("xz", "ghi"));
    expect(text.version("x"), "abc");
    expect(text.version("xy"), "def");
    expect(text.version("xz"), "ghi");

    // `.times(10)` is the same as `.ten()`, so that `.plural(10)` finds it
    // (it looks for the `T` version, not for a `10` version).
    expect("MyKey".times(10, "abc"), "MyKey".ten("abc"));
    expect("MyKey".times(10, "abc").plural(10), "abc");
    expect("MyKey".times(10, "abc").version("T"), "abc");
    expect("MyKey".times(12, "abc").plural(12), "abc");
    expect("MyKey".times(12, "abc").version(12), "abc");

    // The identifier of a custom modifier is its toString().
    expect("MyKey".modifier(Animal.dog, "abc").version(Animal.dog), "abc");
    expect("MyKey".modifier(Animal.dog, "abc").version("Animal.dog"), "abc");
  });

  test("Numeric modifiers.", () {
    //
    DefaultLocale.set("en-US");
    var text = "There is 1 item.";
    expect(text.plural(0), "There are no items.");
    expect(text.plural(1), "There is 1 item.");
    expect(text.plural(2), "There are a pair of items.");
    expect(text.plural(3), "There are 3 items.");
    expect(text.plural(4), "There are 4 items.");
    expect(text.plural(5), "Yes, you reached 5 items.");

    DefaultLocale.set("pt-BR");
    text = "There is 1 item.";
    expect(text.plural(0), "Não há itens.");
    expect(text.plural(1), "Há 1 item.");
    expect(text.plural(2), "Há um par de itens.");
    expect(text.plural(3), "Há 3 itens.");
    expect(text.plural(4), "Há 4 itens.");
    expect(text.plural(5), "Sim, você alcançou 5 items.");
  });

  test("Custom modifiers.", () {
    //
    DefaultLocale.set("en-US");
    var text = "There is an animal";
    expect(text.animal(Animal.dog), "There is a dog");
    expect(text.animal(Animal.cat), "There is a cat");
    expect(text.animal(Animal.fish), "There is a fish");

    expect(
        () => text.animal(Animal.x),
        throwsA(TranslationsException(
            "This text has no version for modifier 'Animal.x' (modifier: Animal.x, key: 'There is an animal', locale: 'en-US').")));

    // ---

    DefaultLocale.set("pt-BR");
    text = "There is an animal";
    expect(text.animal(Animal.dog), "Há um cachorro");
    expect(text.animal(Animal.cat), "Há um gato");
    expect(text.animal(Animal.fish), "Há um peixe");

    expect(
        () => text.animal(Animal.x),
        throwsA(TranslationsException(
            "This text has no version for modifier 'Animal.x' (modifier: Animal.x, key: 'There is an animal', locale: 'pt-BR').")));
  });

  test("Gender modifiers.", () {
    //
    // A gender without a version (here, neutral) falls back to the unversioned text.
    DefaultLocale.set("en-US");
    var text = "There is a person";
    expect(text.gender(Gender.male), "There is a man");
    expect(text.gender(Gender.female), "There is a woman");
    expect(text.gender(Gender.neutral), "There is a person");

    DefaultLocale.set("pt-BR");
    expect(text.gender(Gender.male), "Há um homem");
    expect(text.gender(Gender.female), "Há uma mulher");
    expect(text.gender(Gender.neutral), "Há uma pessoa");

    // ---

    // The neutral version, when defined, is used instead of the unversioned text.
    DefaultLocale.set("en-US");
    text = "Welcome";
    expect(text.gender(Gender.male), "Welcome, sir");
    expect(text.gender(Gender.female), "Welcome, madam");
    expect(text.gender(Gender.neutral), "Welcome, friend");

    DefaultLocale.set("pt-BR");
    expect(text.gender(Gender.male), "Bem-vindo, senhor");
    expect(text.gender(Gender.female), "Bem-vinda, senhora");
    expect(text.gender(Gender.neutral), "Boas-vindas");

    // ---

    // Any gender without a version falls back to the unversioned text,
    // which may be different for each locale.
    DefaultLocale.set("en-US");
    text = "Thank you";
    expect(text.gender(Gender.male), "Thank you, sir");
    expect(text.gender(Gender.female), "Thank you");
    expect(text.gender(Gender.neutral), "Thank you");

    DefaultLocale.set("pt-BR");
    expect(text.gender(Gender.male), "Obrigado");
    expect(text.gender(Gender.female), "Obrigada");
    expect(text.gender(Gender.neutral), "Obrigado");

    // ---

    // A text without versions returns its translation, for any gender.
    DefaultLocale.set("pt-BR");
    expect("Hi.".gender(Gender.male), "Olá.");
    expect("Hi.".gender(Gender.female), "Olá.");
    expect("Hi.".gender(Gender.neutral), "Olá.");

    // A text without translation returns the key itself, for any gender.
    expect("Missing".gender(Gender.male), "Missing");
    expect("Missing".gender(Gender.female), "Missing");
    expect("Missing".gender(Gender.neutral), "Missing");

    // ---

    // The gender versions are also available with `version` and `allVersions`.
    DefaultLocale.set("en-US");
    expect("There is a person".version("m"), "There is a man");
    expect("There is a person".version("f"), "There is a woman");
    expect("There is a person".allVersions(), {
      null: "There is a person",
      "m": "There is a man",
      "f": "There is a woman",
    });

    // The `locale` parameter of `localizeGender` overrides the default locale.
    expect(localizeGender(Gender.female, "Thank you", Localization._t, locale: "pt-BR"),
        "Obrigada");
  });

  test("Gender and plural combined.", () {
    //
    DefaultLocale.set("en-US");
    var text = "There is a guest";

    // The plural versions of the gender come first.
    expect(text.plural(0, Gender.male), "There are no gentlemen");
    expect(text.plural(0, Gender.female), "There are no ladies");
    expect(text.plural(3, Gender.male), "There are 3 gentlemen");
    expect(text.plural(3, Gender.female), "There are 3 ladies");

    // For 1 element, the gender version is the singular of the gender.
    expect(text.plural(1, Gender.male), "There is a gentleman");
    expect(text.plural(1, Gender.female), "There is a lady");

    // A gender without versions (here, neutral) uses the plural versions
    // that don't depend on the gender, the same as no gender at all.
    expect(text.plural(0, Gender.neutral), "There are no guests");
    expect(text.plural(1, Gender.neutral), "There is a guest");
    expect(text.plural(3, Gender.neutral), "There are 3 guests");
    expect(text.plural(0), "There are no guests");
    expect(text.plural(1), "There is a guest");
    expect(text.plural(3), "There are 3 guests");

    // The gender function alone returns the singular of the gender.
    expect(text.gender(Gender.male), "There is a gentleman");
    expect(text.gender(Gender.female), "There is a lady");
    expect(text.gender(Gender.neutral), "There is a guest");

    expect(text.allVersions(), {
      null: "There is a guest",
      "0": "There are no guests",
      "M": "There are %d guests",
      "m": "There is a gentleman",
      "m0": "There are no gentlemen",
      "mM": "There are %d gentlemen",
      "f": "There is a lady",
      "f0": "There are no ladies",
      "fM": "There are %d ladies",
    });

    DefaultLocale.set("pt-BR");
    expect(text.plural(0, Gender.male), "Não há cavalheiros");
    expect(text.plural(1, Gender.male), "Há um cavalheiro");
    expect(text.plural(3, Gender.male), "Há 3 cavalheiros");
    expect(text.plural(0, Gender.female), "Não há damas");
    expect(text.plural(1, Gender.female), "Há uma dama");
    expect(text.plural(3, Gender.female), "Há 3 damas");
    expect(text.plural(0, Gender.neutral), "Não há convidados");
    expect(text.plural(1, Gender.neutral), "Há um convidado");
    expect(text.plural(3, Gender.neutral), "Há 3 convidados");

    // ---

    // Fallbacks, when not all the combinations are declared.
    DefaultLocale.set("en-US");

    var t = Translations.byText("en-US") +
        {
          "en-US": "There is a person"
              .male("There is a man")
              .zero("There is nobody")
              .many("There are %d people"),
        } +
        {
          "en-US": "One person" //
              .one("There is one person")
              .male("There is a man"),
        } +
        {
          "en-US": "Woman" //
              .female("There is a woman".zeroOne("There is at most one woman")),
        };

    String plural(Object? n, String key, [Gender? gender]) =>
        localizePlural(n, key, t, gender: gender);

    // The gender version is the singular of the gender...
    expect(plural(1, "There is a person", Gender.male), "There is a man");

    // ...so for other numbers, the plural versions without gender are used.
    expect(plural(0, "There is a person", Gender.male), "There is nobody");
    expect(plural(3, "There is a person", Gender.male), "There are 3 people");

    // A gender without versions falls back to the plural versions without gender,
    // and then to the unversioned text.
    expect(plural(1, "There is a person", Gender.female), "There is a person");
    expect(plural(3, "There is a person", Gender.female), "There are 3 people");

    // For 1 element, the gender version wins over the `.one()` version.
    expect(plural(1, "One person", Gender.male), "There is a man");
    expect(plural(1, "One person", Gender.female), "There is one person");
    expect(plural(1, "One person"), "There is one person");

    // The plural versions of the gender follow the plural rules, like `zeroOne`.
    expect(plural(0, "Woman", Gender.female), "There is at most one woman");
    expect(plural(1, "Woman", Gender.female), "There is at most one woman");
    expect(plural(2, "Woman", Gender.female), "Woman");

    // The `locale` parameter overrides the default locale.
    expect(localizePlural(2, "There is a guest", Localization._t, //
            locale: "pt-BR", gender: Gender.female),
        "Há 2 damas");
  });

  test("Czech variations.", () {
    DefaultLocale.set("en-US");

    var t = Translations.byText("en-US") +
        {
          "en-US": "1 beer"
              .zero("0 beers")
              .one("1 beer")
              .two("2 beers")
              .three("3 beers")
              .four("4 beers")
              .five("5 beers")
              .six("6 beers")
              .ten("10 beers")
              .times(12, "12 beers")
              .many("many beers"),
          "cz-CZ": "1 variation"
              .zero("0 variation")
              .one("1 variation")
              .two("2 variation")
              .three("3 variation")
              .four("4 variation")
              // .twoThreeFour will not be used because we've
              // defined .two .three .four and those take precedence.
              .twoThreeFour("234 variation")
              .five("5 variation")
              .six("6 variation")
              .ten("10 variation")
              .times(12, "times variation")
              .many("many variation"),
        };

    DefaultLocale.set("cz-CZ");
    var key = "1 beer";
    expect(localizePlural(0, key, t, locale: "cz-CZ"), "0 variation");
    expect(localizePlural(1, key, t, locale: "cz-CZ"), "1 variation");
    expect(localizePlural(2, key, t, locale: "cz-CZ"), "2 variation");
    expect(localizePlural(3, key, t, locale: "cz-CZ"), "3 variation");
    expect(localizePlural(4, key, t, locale: "cz-CZ"), "4 variation");
    expect(localizePlural(5, key, t, locale: "cz-CZ"), "5 variation");
    expect(localizePlural(6, key, t, locale: "cz-CZ"), "6 variation");
    expect(localizePlural(7, key, t, locale: "cz-CZ"), "many variation");
    expect(localizePlural(8, key, t, locale: "cz-CZ"), "many variation");
    expect(localizePlural(9, key, t, locale: "cz-CZ"), "many variation");
    expect(localizePlural(10, key, t, locale: "cz-CZ"), "10 variation");
    expect(localizePlural(11, key, t, locale: "cz-CZ"), "many variation");
    expect(localizePlural(12, key, t, locale: "cz-CZ"), "times variation");
    expect(localizePlural(13, key, t, locale: "cz-CZ"), "many variation");
    expect(localizePlural(14, key, t, locale: "cz-CZ"), "many variation");

    expect(
        t.toString(),
        '\n'
        'Translations: ---------------\n'
        '  en-US | 1 beer\n'
        '          0 → 0 beers\n'
        '          1 → 1 beer\n'
        '          2 → 2 beers\n'
        '          3 → 3 beers\n'
        '          4 → 4 beers\n'
        '          5 → 5 beers\n'
        '          6 → 6 beers\n'
        '          T → 10 beers\n'
        '          12 → 12 beers\n'
        '          M → many beers\n'
        '  cz-CZ | 1 variation\n'
        '          0 → 0 variation\n'
        '          1 → 1 variation\n'
        '          2 → 2 variation\n'
        '          3 → 3 variation\n'
        '          4 → 4 variation\n'
        '          C → 234 variation\n'
        '          5 → 5 variation\n'
        '          6 → 6 variation\n'
        '          T → 10 variation\n'
        '          12 → times variation\n'
        '          M → many variation\n'
        '-----------------------------\n');

    // Now try again without defining .two .three .four.
    t = Translations.byText("en-US") +
        {
          "en-US": "1 beer"
              .zero("0 beers")
              .one("1 beer")
              .five("5 beers")
              .six("6 beers")
              .ten("10 beers")
              .times(12, "12 beers")
              .many("many beers"),
          "cz-CZ": "1 variation"
              .zero("0 variation")
              .one("1 variation")
              // .twoThreeFour will  be used.
              .twoThreeFour("234 variation")
              .five("5 variation")
              .six("6 variation")
              .ten("10 variation")
              .times(12, "times variation")
              .many("many variation"),
        };

    expect(localizePlural(0, key, t, locale: "cz-CZ"), "0 variation");
    expect(localizePlural(1, key, t, locale: "cz-CZ"), "1 variation");
    expect(localizePlural(2, key, t, locale: "cz-CZ"), "234 variation");
    expect(localizePlural(3, key, t, locale: "cz-CZ"), "234 variation");
    expect(localizePlural(4, key, t, locale: "cz-CZ"), "234 variation");
    expect(localizePlural(5, key, t, locale: "cz-CZ"), "5 variation");
    expect(localizePlural(6, key, t, locale: "cz-CZ"), "6 variation");
    expect(localizePlural(7, key, t, locale: "cz-CZ"), "many variation");
    expect(localizePlural(8, key, t, locale: "cz-CZ"), "many variation");
    expect(localizePlural(9, key, t, locale: "cz-CZ"), "many variation");
    expect(localizePlural(10, key, t, locale: "cz-CZ"), "10 variation");
    expect(localizePlural(11, key, t, locale: "cz-CZ"), "many variation");
    expect(localizePlural(12, key, t, locale: "cz-CZ"), "times variation");
    expect(localizePlural(13, key, t, locale: "cz-CZ"), "many variation");
    expect(localizePlural(14, key, t, locale: "cz-CZ"), "many variation");
  });

  test("0 and 1 plural.", () {
    DefaultLocale.set("en-US");
    var key = "1 beer";

    // ---

    var t = Translations.byText("en-US") +
        {
          "en-US": "1 beer"
              .zeroOne("0 or 1 beers")
              .zero("0 beers")
              .one("1 beer")
              .two("2 beers")
              .three("3 beers")
              .many("many beers"),
        };

    // .zero and .one have priority over .zeroOne, because they are more specific.
    expect(localizePlural(0, key, t, locale: "en-US"), "0 beers");
    expect(localizePlural(1, key, t, locale: "en-US"), "1 beer");
    expect(localizePlural(2, key, t, locale: "en-US"), "2 beers");
    expect(localizePlural(3, key, t, locale: "en-US"), "3 beers");
    expect(localizePlural(4, key, t, locale: "en-US"), "many beers");

    // ---

    t = Translations.byText("en-US") +
        {
          "en-US": "1 beer"
              .zeroOne("0 or 1 beers")
              .two("2 beers")
              .three("3 beers")
              .many("many beers"),
        };

    expect(localizePlural(0, key, t, locale: "en-US"), "0 or 1 beers");
    expect(localizePlural(1, key, t, locale: "en-US"), "0 or 1 beers");
    expect(localizePlural(2, key, t, locale: "en-US"), "2 beers");
    expect(localizePlural(3, key, t, locale: "en-US"), "3 beers");
    expect(localizePlural(4, key, t, locale: "en-US"), "many beers");

    expect(
        t.toString(),
        '\n'
        'Translations: ---------------\n'
        '  en-US | 1 beer\n'
        '          F → 0 or 1 beers\n'
        '          2 → 2 beers\n'
        '          3 → 3 beers\n'
        '          M → many beers\n'
        '-----------------------------\n');
  });

  test("1 or more plural.", () {
    DefaultLocale.set("en-US");
    var key = "1 beer";

    // ---

    var t = Translations.byText("en-US") +
        {
          "en-US": "1 beer"
              .oneOrMore("1 or more beers")
              .zero("0 beers")
              .one("1 beer")
              .two("2 beers")
              .three("3 beers")
              .many("many beers"),
        };

    // .one, .two, .three, .many have priority over .oneMany, because they are more specific.
    expect(localizePlural(0, key, t, locale: "en-US"), "0 beers");
    expect(localizePlural(1, key, t, locale: "en-US"), "1 beer");
    expect(localizePlural(2, key, t, locale: "en-US"), "2 beers");
    expect(localizePlural(3, key, t, locale: "en-US"), "3 beers");
    expect(localizePlural(4, key, t, locale: "en-US"), "many beers");

    // ---

    t = Translations.byText("en-US") +
        {"en-US": "1 beer".oneOrMore("1 or more beers").zero("0 beers").three("3 beers")};

    expect(localizePlural(0, key, t, locale: "en-US"), "0 beers");
    expect(localizePlural(1, key, t, locale: "en-US"), "1 or more beers");
    expect(localizePlural(2, key, t, locale: "en-US"), "1 or more beers");
    expect(localizePlural(3, key, t, locale: "en-US"), "3 beers");
    expect(localizePlural(4, key, t, locale: "en-US"), "1 or more beers");

    expect(
        t.toString(),
        '\n'
        'Translations: ---------------\n'
        '  en-US | 1 beer\n'
        '          R → 1 or more beers\n'
        '          0 → 0 beers\n'
        '          3 → 3 beers\n'
        '-----------------------------\n');
  });

  test("Comparison between .oneOrMore and .many.", () {
    //
    DefaultLocale.set("en-US");
    var key = "1 beer";

    // Make sure "1 or more" DOES NOT include zero (but includes 1).
    var t =
        Translations.byText("en-US") + {"en-US": "1 beer".oneOrMore("1 or more beer")};

    expect(localizePlural(0, key, t, locale: "en-US"), "1 beer");
    expect(localizePlural(1, key, t, locale: "en-US"), "1 or more beer");
    expect(localizePlural(2, key, t, locale: "en-US"), "1 or more beer");
    expect(localizePlural(3, key, t, locale: "en-US"), "1 or more beer");
    expect(localizePlural(4, key, t, locale: "en-US"), "1 or more beer");

    // While "many" DOES INCLUDE zero (but not one).
    t = Translations.byText("en-US") + {"en-US": "1 beer".many("many beers")};

    expect(localizePlural(0, key, t, locale: "en-US"), "many beers");
    expect(localizePlural(1, key, t, locale: "en-US"), "1 beer");
    expect(localizePlural(2, key, t, locale: "en-US"), "many beers");
    expect(localizePlural(3, key, t, locale: "en-US"), "many beers");
    expect(localizePlural(4, key, t, locale: "en-US"), "many beers");
  });

  test("Empty strings are allowed.", () {
    //
    DefaultLocale.set("en-US");
    var key = "1 beer";

    var t = Translations.byText("en-US") +
        {"en-US": "1 beer".zero("").three("").many("many beers")};

    expect(localizePlural(0, key, t, locale: "en-US"), "");
    expect(localizePlural(1, key, t, locale: "en-US"), "1 beer");
    expect(localizePlural(2, key, t, locale: "en-US"), "many beers");
    expect(localizePlural(3, key, t, locale: "en-US"), "");
    expect(localizePlural(4, key, t, locale: "en-US"), "many beers");
  });

  test("Plurals not provided default to the unversioned string.", () {
    //
    DefaultLocale.set("pt-BR");
    var key = "unversioned";

    // ---

    var t = Translations.byText("en-US") +
        {
          "en-US": "unversioned".zero("version 0").many("version many"),
          "pt-BR": "não versionada".zero("versão 0").many("versão várias"),
        };

    expect(localizePlural(0, key, t, locale: "en-US"), "version 0");
    expect(localizePlural(1, key, t, locale: "en-US"), "unversioned");
    expect(localizePlural(2, key, t, locale: "en-US"), "version many");
    expect(localizePlural(3, key, t, locale: "en-US"), "version many");

    expect(localizePlural(0, key, t, locale: "pt-BR"), "versão 0");
    expect(localizePlural(1, key, t, locale: "pt-BR"), "não versionada");
    expect(localizePlural(2, key, t, locale: "pt-BR"), "versão várias");
    expect(localizePlural(3, key, t, locale: "pt-BR"), "versão várias");

    // ---

    t = Translations.byText("en-US") +
        {
          "en-US": "unversioned".zero("version 0").many("version many"),
          "pt-BR": "não versionada",
        };

    expect(localizePlural(0, key, t, locale: "en-US"), "version 0");
    expect(localizePlural(1, key, t, locale: "en-US"), "unversioned");
    expect(localizePlural(2, key, t, locale: "en-US"), "version many");
    expect(localizePlural(3, key, t, locale: "en-US"), "version many");

    expect(localizePlural(0, key, t, locale: "pt-BR"), "não versionada");
    expect(localizePlural(1, key, t, locale: "pt-BR"), "não versionada");
    expect(localizePlural(2, key, t, locale: "pt-BR"), "não versionada");
    expect(localizePlural(3, key, t, locale: "pt-BR"), "não versionada");

    expect(
        t.toString(),
        '\n'
        'Translations: ---------------\n'
        '  en-US | unversioned\n'
        '          0 → version 0\n'
        '          M → version many\n'
        '  pt-BR | não versionada\n'
        '-----------------------------\n');
  });

  test("Conversion of plural modifier.", () {
    //

    // Integer
    expect(convertToIntegerModifier(-10), 10);
    expect(convertToIntegerModifier(-2), 2);
    expect(convertToIntegerModifier(-1), 1);
    expect(convertToIntegerModifier(0), 0);
    expect(convertToIntegerModifier(1), 1);
    expect(convertToIntegerModifier(2), 2);
    expect(convertToIntegerModifier(10), 10);

    // Double
    expect(convertToIntegerModifier(-10.0), 10);
    expect(convertToIntegerModifier(-10.25), 11);
    expect(convertToIntegerModifier(-2.0), 2);
    expect(convertToIntegerModifier(-2.2), 3);
    expect(convertToIntegerModifier(-2.7), 3);
    expect(convertToIntegerModifier(-1.0), 1);
    expect(convertToIntegerModifier(0.0), 0);
    expect(convertToIntegerModifier(0.2), 0);
    expect(convertToIntegerModifier(0.5), 0);
    expect(convertToIntegerModifier(0.7), 0);
    expect(convertToIntegerModifier(1.0), 1);
    expect(convertToIntegerModifier(1.1), 2);
    expect(convertToIntegerModifier(1.8), 2);
    expect(convertToIntegerModifier(2.0), 2);
    expect(convertToIntegerModifier(2.4), 3);
    expect(convertToIntegerModifier(2.5), 3);
    expect(convertToIntegerModifier(2.81232), 3);
    expect(convertToIntegerModifier(10.0), 10);

    // String
    expect(convertToIntegerModifier("-10"), 10);
    expect(convertToIntegerModifier("-10.0"), 10);
    expect(convertToIntegerModifier("-10.25"), 11);
    expect(convertToIntegerModifier("0.3"), 0);
    expect(convertToIntegerModifier("5"), 5);
    expect(convertToIntegerModifier("5.6"), 6);
    expect(convertToIntegerModifier(" 5.6 "), 6);
    expect(convertToIntegerModifier(" 5.6a"), 6);
    expect(convertToIntegerModifier("5 .6"), 0);
    expect(convertToIntegerModifier("5. 6"), 0);
    expect(convertToIntegerModifier("5.6 2 3"), 0);
    expect(convertToIntegerModifier("5.6a2x3"), 0);
    expect(convertToIntegerModifier("5.a"), 5);
    expect(convertToIntegerModifier("^&-5.a"), 5);
    expect(convertToIntegerModifier("^-&-5.a"), 5);
    expect(convertToIntegerModifier("^-&-5.1.2a"), 0);

    // Some object which is not int, double, or String (will use the object's toString()).
    expect(convertToIntegerModifier(SomeObj("-10")), 10);
    expect(convertToIntegerModifier(SomeObj("-10.0")), 10);
    expect(convertToIntegerModifier(SomeObj("-10.25")), 11);
    expect(convertToIntegerModifier(SomeObj("0.3")), 0);
    expect(convertToIntegerModifier(SomeObj("5")), 5);
    expect(convertToIntegerModifier(SomeObj("5.6")), 6);
    expect(convertToIntegerModifier(SomeObj(" 5.6 ")), 6);
    expect(convertToIntegerModifier(SomeObj(" 5.6a")), 6);
    expect(convertToIntegerModifier(SomeObj("5 .6")), 0);
    expect(convertToIntegerModifier(SomeObj("5. 6")), 0);
    expect(convertToIntegerModifier(SomeObj("5.6 2 3")), 0);
    expect(convertToIntegerModifier(SomeObj("5.6a2x3")), 0);
    expect(convertToIntegerModifier(SomeObj("5.a")), 5);
    expect(convertToIntegerModifier(SomeObj("^&-5.a")), 5);
    expect(convertToIntegerModifier(SomeObj("^-&-5.a")), 5);
    expect(convertToIntegerModifier(SomeObj("^-&-5.1.2a")), 0);
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
        "en-US": "There is an animal"
            .modifier(Animal.dog, "There is a dog")
            .modifier(Animal.cat, "There is a cat")
            .modifier(Animal.fish, "There is a fish"),
        "pt-BR": "Há um animal"
            .modifier(Animal.dog, "Há um cachorro")
            .modifier(Animal.cat, "Há um gato")
            .modifier(Animal.fish, "Há um peixe"),
      } +
      {
        "en-US": "There is a person" //
            .male("There is a man")
            .female("There is a woman"),
        "pt-BR": "Há uma pessoa" //
            .male("Há um homem")
            .female("Há uma mulher"),
      } +
      {
        "en-US": "Welcome" //
            .male("Welcome, sir")
            .female("Welcome, madam")
            .neutral("Welcome, friend"),
        "pt-BR": "Bem-vindo" //
            .male("Bem-vindo, senhor")
            .female("Bem-vinda, senhora")
            .neutral("Boas-vindas"),
      } +
      {
        "en-US": "Thank you".male("Thank you, sir"),
        "pt-BR": "Obrigado".female("Obrigada"),
      } +
      {
        "en-US": "There is a guest"
            .zero("There are no guests")
            .many("There are %d guests")
            .male("There is a gentleman"
                .zero("There are no gentlemen")
                .many("There are %d gentlemen"))
            .female("There is a lady" //
                .zero("There are no ladies")
                .many("There are %d ladies")),
        "pt-BR": "Há um convidado"
            .zero("Não há convidados")
            .many("Há %d convidados")
            .male("Há um cavalheiro" //
                .zero("Não há cavalheiros")
                .many("Há %d cavalheiros"))
            .female("Há uma dama" //
                .zero("Não há damas")
                .many("Há %d damas")),
      };

  String get i18n => localize(this, _t);

  String fill(List<Object> params) => localizeFill(this, params);

  String? plural(value, [Gender? gender]) => localizePlural(value, this, _t, gender: gender);

  String version(Object modifier) => localizeVersion(modifier, this, _t);

  Map<String?, String> allVersions() => localizeAllVersions(this, _t);

  String gender(Gender gender) => localizeGender(gender, this, _t);

  String animal(Animal animal) => localizeVersion(animal, this, _t);
}

enum Animal { dog, cat, fish, x }

class SomeObj {
  final String value;

  SomeObj(this.value);

  @override
  String toString() => 'SomeObj{value: $value}';
}
