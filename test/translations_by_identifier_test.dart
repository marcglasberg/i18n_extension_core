import 'package:i18n_extension_core/i18n_extension_core.dart';
import 'package:test/test.dart';

enum MyTranslations { hi, goodbye, letsGo, person }

void main() {
  //
  test("Empty translations.", () {
    DefaultLocale.set("en_US");

    var t = Translations.byId("en_us", <String, Map<String, String>>{});
    expect(t.length, 0);
    expect(t.translationByLocale_ByTranslationKey, {});
    expect(
        t.toString(),
        '\n'
        'Translations: ---------------\n');
  });

  test("Add translations. Generic type: MyTranslations", () {
    DefaultLocale.set("en_US");
    var t = Translations.byId<MyTranslations>("en_us", {
          MyTranslations.hi: {
            "en_us": "Hi",
            "pt_br": "Olá",
          },
          MyTranslations.goodbye: {
            "en_us": "Goodbye",
            "pt_br": "Adeus",
          }
        }) +
        {
          MyTranslations.letsGo: <StringLocale, StringTranslated>{
            "en_us": "Let's go",
            "pt_br": "Vamos",
          }
        };

    expect(t.length, 3);

    expect(t.translationByLocale_ByTranslationKey, {
      MyTranslations.hi: {
        "en_us": "Hi",
        "pt_br": "Olá",
      },
      MyTranslations.goodbye: {
        "en_us": "Goodbye",
        "pt_br": "Adeus",
      },
      MyTranslations.letsGo: {
        "en_us": "Let's go",
        "pt_br": "Vamos",
      },
    });

    expect(
        t.toString(),
        '\n'
        'Translations: ---------------\n'
        'MyTranslations.hi\n'
        '  en_us | Hi\n'
        '  pt_br | Olá\n'
        '-----------------------------\n'
        'MyTranslations.goodbye\n'
        '  en_us | Goodbye\n'
        '  pt_br | Adeus\n'
        '-----------------------------\n'
        'MyTranslations.letsGo\n'
        '  en_us | Let\'s go\n'
        '  pt_br | Vamos\n'
        '-----------------------------\n');
  });

  test("Add translations, mixing more than one tyoe. Generic type not given", () {
    DefaultLocale.set("en_US");
    var t = Translations.byId<Object>("en_us", {
          MyTranslations.hi: {
            "en_us": "Hi",
            "pt_br": "Olá",
          },
          MyTranslations.goodbye: {
            "en_us": "Goodbye",
            "pt_br": "Adeus",
          },
          'Privacy policy': <StringLocale, StringTranslated>{
            "en_us": "We don't sell your data",
            "pt_br": "Não vendemos suas informações",
          },
        }) +
        {
          'Legal terms': <StringLocale, StringTranslated>{
            "en_us": "The Legal terms are this and that",
            "pt_br": "Os termos de uso são isso e aquilo",
          },
          MyTranslations.letsGo: {
            "en_us": "Let's go",
            "pt_br": "Vamos",
          },
        };

    expect(t.length, 5);

    expect(t.translationByLocale_ByTranslationKey, {
      MyTranslations.hi: {
        "en_us": "Hi",
        "pt_br": "Olá",
      },
      MyTranslations.goodbye: {
        "en_us": "Goodbye",
        "pt_br": "Adeus",
      },
      'Privacy policy': <StringLocale, StringTranslated>{
        "en_us": "We don't sell your data",
        "pt_br": "Não vendemos suas informações",
      },
      'Legal terms': <StringLocale, StringTranslated>{
        "en_us": "The Legal terms are this and that",
        "pt_br": "Os termos de uso são isso e aquilo",
      },
      MyTranslations.letsGo: {
        "en_us": "Let's go",
        "pt_br": "Vamos",
      },
    });

    expect(
        t.toString(),
        '\n'
        'Translations: ---------------\n'
        'MyTranslations.hi\n'
        '  en_us | Hi\n'
        '  pt_br | Olá\n'
        '-----------------------------\n'
        'MyTranslations.goodbye\n'
        '  en_us | Goodbye\n'
        '  pt_br | Adeus\n'
        '-----------------------------\n'
        'Privacy policy\n'
        '  en_us | We don\'t sell your data\n'
        '  pt_br | Não vendemos suas informações\n'
        '-----------------------------\n'
        'Legal terms\n'
        '  en_us | The Legal terms are this and that\n'
        '  pt_br | Os termos de uso são isso e aquilo\n'
        '-----------------------------\n'
        'MyTranslations.letsGo\n'
        '  en_us | Let\'s go\n'
        '  pt_br | Vamos\n'
        '-----------------------------\n');
  });

  test("Type `Object?`", () {
    DefaultLocale.set("en_US");
    var t = Translations.byId<Object?>("en_us", {
      MyTranslations.hi: {
        "en_us": "Hi",
        "pt_br": "Olá",
      },
      null: {
        "en_us": "Null",
        "pt_br": "nulo",
      },
      'Privacy policy': <StringLocale, StringTranslated>{
        "en_us": "We don't sell your data",
        "pt_br": "Não vendemos suas informações",
      },
    });

    expect(t.length, 3);

    expect(t.translationByLocale_ByTranslationKey, {
      MyTranslations.hi: {
        "en_us": "Hi",
        "pt_br": "Olá",
      },
      null: {
        "en_us": "Null",
        "pt_br": "nulo",
      },
      'Privacy policy': <StringLocale, StringTranslated>{
        "en_us": "We don't sell your data",
        "pt_br": "Não vendemos suas informações",
      },
    });

    expect(
        t.toString(),
        '\n'
        'Translations: ---------------\n'
        'MyTranslations.hi\n'
        '  en_us | Hi\n'
        '  pt_br | Olá\n'
        '-----------------------------\n'
        'null\n'
        '  en_us | Null\n'
        '  pt_br | nulo\n'
        '-----------------------------\n'
        'Privacy policy\n'
        '  en_us | We don\'t sell your data\n'
        '  pt_br | Não vendemos suas informações\n'
        '-----------------------------\n');

    DefaultLocale.set("en_US");
    expect(null.i18n, "This is empty");

    DefaultLocale.set("pt_BR");
    expect(null.i18n, "Isso está vazio");
  });

  test("Translate manually.", () {
    //
    var t = Translations.byId("en_us", {
      123: {"en_us": "One two three", "pt_br": "Um dois três"},
      "Goodbye": {"en_us": "Goodbye", "pt_br": "Adeus"}
    });

    DefaultLocale.set("en_US");
    expect(localize(123, t), "One two three");
    expect(localize("Goodbye", t), "Goodbye");
    expect(localize("Doesn't exist", t), "Doesn't exist"); // Return the original string
    expect(localize(456, t), '456'); // Return the original value.toString()
    expect(localize(true, t), 'true'); // Return the original value.toString()

    DefaultLocale.set("pt_BR");
    expect(localize(123, t), "Um dois três");
    expect(localize("Goodbye", t), "Adeus");
    expect(localize("Nao existe", t), "Nao existe"); // Return the original string
    expect(localize(456, t), '456'); // Return the original value.toString()
    expect(localize(true, t), 'true'); // Return the original value.toString()

    // When it doesn't find, it returns the original string.
    // This is useful for development, when you are adding translations.
    // Note this missing translation is added to the missing translations list.
    expect(localize("DOESN'T FIND", t), "DOESN'T FIND");
  });

  test("Numeric modifiers.", () {
    //
    DefaultLocale.set("en_US");
    var text = "There is 1 item.";
    expect(text.plural(0), "There are no items.");
    expect(text.plural(1), "There is 1 item.");
    expect(text.plural(2), "There are a pair of items.");
    expect(text.plural(3), "There are 3 items.");
    expect(text.plural(4), "There are 4 items.");
    expect(text.plural(5), "Yes, you reached 5 items.");

    DefaultLocale.set("pt_BR");
    text = "There is 1 item.";
    expect(text.plural(0), "Não há itens.");
    expect(text.plural(1), "Há 1 item.");
    expect(text.plural(2), "Há um par de itens.");
    expect(text.plural(3), "Há 3 itens.");
    expect(text.plural(4), "Há 4 itens.");
    expect(text.plural(5), "Sim, você alcançou 5 items.");

    DefaultLocale.set("en_US");
    expect(456.plural(0), "There are no items.");
    expect(456.plural(1), "There is 1 item.");
    expect(456.plural(2), "There are a pair of items.");
    expect(456.plural(3), "There are 3 items.");
    expect(456.plural(4), "There are 4 items.");
    expect(456.plural(5), "Yes, you reached 5 items.");

    DefaultLocale.set("pt_BR");
    expect(456.plural(0), "Não há itens.");
    expect(456.plural(1), "Há 1 item.");
    expect(456.plural(2), "Há um par de itens.");
    expect(456.plural(3), "Há 3 itens.");
    expect(456.plural(4), "Há 4 itens.");
    expect(456.plural(5), "Sim, você alcançou 5 items.");

    DefaultLocale.set("en_US");
    expect(MyTranslations.person.gender(Gender.male), "There is a man");
    expect(MyTranslations.person.gender(Gender.female), "There is a woman");
    expect(MyTranslations.person.gender(Gender.they), "There is a person");

    DefaultLocale.set("pt_BR");
    expect(MyTranslations.person.gender(Gender.male), "Há um homem");
    expect(MyTranslations.person.gender(Gender.female), "Há uma mulher");
    expect(MyTranslations.person.gender(Gender.they), "Há uma pessoa");
  });

  test("Translate using the extension.", () {
    //
    DefaultLocale.set("en_US");
    expect(123.i18n, "One two three");
    expect("There is 1 item.".plural(0), "There are no items.");
    expect("There is 1 item.".plural(1), "There is 1 item.");
    expect("There is 1 item.".plural(2), "There are a pair of items.");
    expect("There is 1 item.".plural(3), "There are 3 items.");
    expect("There is 1 item.".plural(4), "There are 4 items.");
    expect("There is 1 item.".plural(5), "Yes, you reached 5 items.");
    expect("There is 1 item.".plural(6), "There are 6 items.");
    expect(456.plural(0), "There are no items.");
    expect(456.plural(1), "There is 1 item.");
    expect(456.plural(2), "There are a pair of items.");
    expect(456.plural(3), "There are 3 items.");
    expect(456.plural(4), "There are 4 items.");
    expect(456.plural(5), "Yes, you reached 5 items.");
    expect(456.plural(6), "There are 6 items.");

    DefaultLocale.set("pt_BR");
    expect(123.i18n, "Um dois três");
    expect("There is 1 item.".plural(0), "Não há itens.");
    expect("There is 1 item.".plural(1), "Há 1 item.");
    expect("There is 1 item.".plural(2), "Há um par de itens.");
    expect("There is 1 item.".plural(3), "Há 3 itens.");
    expect("There is 1 item.".plural(4), "Há 4 itens.");
    expect("There is 1 item.".plural(5), "Sim, você alcançou 5 items.");
    expect("There is 1 item.".plural(6), "Há 6 itens.");
    expect(456.plural(0), "Não há itens.");
    expect(456.plural(1), "Há 1 item.");
    expect(456.plural(2), "Há um par de itens.");
    expect(456.plural(3), "Há 3 itens.");
    expect(456.plural(4), "Há 4 itens.");
    expect(456.plural(5), "Sim, você alcançou 5 items.");
    expect(456.plural(6), "Há 6 itens.");
  });
}

//    .zero("There are no items.")
//     .one("There is 1 item.")
//     .two("There are a pair of items.")
//     .times(5, "Yes, you reached 5 items.")
//     .many("There are %d items."),
// "pt_br": "Há 1 item."
//    .zero("Não há itens.")
//     .one("Há 1 item.")
//     .two("Há um par de itens.")
//     .times(5, "Sim, você alcançou 5 items.")
//     .many("Há %d itens."),

extension Localization on Object? {
  //
  static final _t = Translations.byId<dynamic>(
    "en_us",
    {
      123: {
        "en_us": "One two three",
        "pt_br": "Um dois três",
      },
      "There is 1 item.": {
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
      },
      456: {
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
      },
      MyTranslations.person: {
        "en_us": "There is a person"
            .modifier(Gender.male, "There is a man")
            .modifier(Gender.female, "There is a woman")
            .modifier(Gender.they, "There is a person"),
        "pt_br": "Há uma pessoa"
            .modifier(Gender.male, "Há um homem")
            .modifier(Gender.female, "Há uma mulher")
            .modifier(Gender.they, "Há uma pessoa"),
      },
      null: {
        "en_us": "This is empty",
        "pt_br": "Isso está vazio",
      },
    },
  );

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
