import 'package:i18n_extension_core/i18n_extension_core.dart';
import 'package:test/test.dart';

enum MyTranslations { hi, goodbye, letsGo, person }

void main() {
  //
  test("Empty translations.", () {
    DefaultLocale.set("en-US");

    var t = Translations.byId("en-US", <String, Map<String, String>>{});
    expect(t.length, 0);
    expect(t.translationByLocale_ByTranslationKey, {});
    expect(
        t.toString(),
        '\n'
        'Translations: ---------------\n');
  });

  test("Add translations. Generic type: MyTranslations", () {
    DefaultLocale.set("en-US");
    var t = Translations.byId<MyTranslations>("en-US", {
          MyTranslations.hi: {
            "en-US": "Hi",
            "pt-BR": "Olá",
          },
          MyTranslations.goodbye: {
            "en-US": "Goodbye",
            "pt-BR": "Adeus",
          }
        }) +
        {
          MyTranslations.letsGo: <StringLocale, StringTranslated>{
            "en-US": "Let's go",
            "pt-BR": "Vamos",
          }
        };

    expect(t.length, 3);

    expect(t.translationByLocale_ByTranslationKey, {
      MyTranslations.hi: {
        "en-US": "Hi",
        "pt-BR": "Olá",
      },
      MyTranslations.goodbye: {
        "en-US": "Goodbye",
        "pt-BR": "Adeus",
      },
      MyTranslations.letsGo: {
        "en-US": "Let's go",
        "pt-BR": "Vamos",
      },
    });

    expect(
        t.toString(),
        '\n'
        'Translations: ---------------\n'
        'MyTranslations.hi\n'
        '  en-US | Hi\n'
        '  pt-BR | Olá\n'
        '-----------------------------\n'
        'MyTranslations.goodbye\n'
        '  en-US | Goodbye\n'
        '  pt-BR | Adeus\n'
        '-----------------------------\n'
        'MyTranslations.letsGo\n'
        '  en-US | Let\'s go\n'
        '  pt-BR | Vamos\n'
        '-----------------------------\n');
  });

  test("Add translations, mixing more than one tyoe. Generic type not given", () {
    DefaultLocale.set("en-US");
    var t = Translations.byId<Object>("en-US", {
          MyTranslations.hi: {
            "en-US": "Hi",
            "pt-BR": "Olá",
          },
          MyTranslations.goodbye: {
            "en-US": "Goodbye",
            "pt-BR": "Adeus",
          },
          'Privacy policy': <StringLocale, StringTranslated>{
            "en-US": "We don't sell your data",
            "pt-BR": "Não vendemos suas informações",
          },
        }) +
        {
          'Legal terms': <StringLocale, StringTranslated>{
            "en-US": "The Legal terms are this and that",
            "pt-BR": "Os termos de uso são isso e aquilo",
          },
          MyTranslations.letsGo: {
            "en-US": "Let's go",
            "pt-BR": "Vamos",
          },
        };

    expect(t.length, 5);

    expect(t.translationByLocale_ByTranslationKey, {
      MyTranslations.hi: {
        "en-US": "Hi",
        "pt-BR": "Olá",
      },
      MyTranslations.goodbye: {
        "en-US": "Goodbye",
        "pt-BR": "Adeus",
      },
      'Privacy policy': <StringLocale, StringTranslated>{
        "en-US": "We don't sell your data",
        "pt-BR": "Não vendemos suas informações",
      },
      'Legal terms': <StringLocale, StringTranslated>{
        "en-US": "The Legal terms are this and that",
        "pt-BR": "Os termos de uso são isso e aquilo",
      },
      MyTranslations.letsGo: {
        "en-US": "Let's go",
        "pt-BR": "Vamos",
      },
    });

    expect(
        t.toString(),
        '\n'
        'Translations: ---------------\n'
        'MyTranslations.hi\n'
        '  en-US | Hi\n'
        '  pt-BR | Olá\n'
        '-----------------------------\n'
        'MyTranslations.goodbye\n'
        '  en-US | Goodbye\n'
        '  pt-BR | Adeus\n'
        '-----------------------------\n'
        'Privacy policy\n'
        '  en-US | We don\'t sell your data\n'
        '  pt-BR | Não vendemos suas informações\n'
        '-----------------------------\n'
        'Legal terms\n'
        '  en-US | The Legal terms are this and that\n'
        '  pt-BR | Os termos de uso são isso e aquilo\n'
        '-----------------------------\n'
        'MyTranslations.letsGo\n'
        '  en-US | Let\'s go\n'
        '  pt-BR | Vamos\n'
        '-----------------------------\n');
  });

  test("Type `Object?`", () {
    DefaultLocale.set("en-US");
    var t = Translations.byId<Object?>("en-US", {
      MyTranslations.hi: {
        "en-US": "Hi",
        "pt-BR": "Olá",
      },
      null: {
        "en-US": "Null",
        "pt-BR": "nulo",
      },
      'Privacy policy': <StringLocale, StringTranslated>{
        "en-US": "We don't sell your data",
        "pt-BR": "Não vendemos suas informações",
      },
    });

    expect(t.length, 3);

    expect(t.translationByLocale_ByTranslationKey, {
      MyTranslations.hi: {
        "en-US": "Hi",
        "pt-BR": "Olá",
      },
      null: {
        "en-US": "Null",
        "pt-BR": "nulo",
      },
      'Privacy policy': <StringLocale, StringTranslated>{
        "en-US": "We don't sell your data",
        "pt-BR": "Não vendemos suas informações",
      },
    });

    expect(
        t.toString(),
        '\n'
        'Translations: ---------------\n'
        'MyTranslations.hi\n'
        '  en-US | Hi\n'
        '  pt-BR | Olá\n'
        '-----------------------------\n'
        'null\n'
        '  en-US | Null\n'
        '  pt-BR | nulo\n'
        '-----------------------------\n'
        'Privacy policy\n'
        '  en-US | We don\'t sell your data\n'
        '  pt-BR | Não vendemos suas informações\n'
        '-----------------------------\n');

    DefaultLocale.set("en-US");
    expect(null.i18n, "This is empty");

    DefaultLocale.set("pt-BR");
    expect(null.i18n, "Isso está vazio");
  });

  test("Translate manually.", () {
    //
    var t = Translations.byId("en-US", {
      123: {"en-US": "One two three", "pt-BR": "Um dois três"},
      "Goodbye": {"en-US": "Goodbye", "pt-BR": "Adeus"}
    });

    DefaultLocale.set("en-US");
    expect(localize(123, t), "One two three");
    expect(localize("Goodbye", t), "Goodbye");
    expect(localize("Doesn't exist", t), "Doesn't exist"); // Return the original string
    expect(localize(456, t), '456'); // Return the original value.toString()
    expect(localize(true, t), 'true'); // Return the original value.toString()

    DefaultLocale.set("pt-BR");
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

    DefaultLocale.set("en-US");
    expect(456.plural(0), "There are no items.");
    expect(456.plural(1), "There is 1 item.");
    expect(456.plural(2), "There are a pair of items.");
    expect(456.plural(3), "There are 3 items.");
    expect(456.plural(4), "There are 4 items.");
    expect(456.plural(5), "Yes, you reached 5 items.");

    DefaultLocale.set("pt-BR");
    expect(456.plural(0), "Não há itens.");
    expect(456.plural(1), "Há 1 item.");
    expect(456.plural(2), "Há um par de itens.");
    expect(456.plural(3), "Há 3 itens.");
    expect(456.plural(4), "Há 4 itens.");
    expect(456.plural(5), "Sim, você alcançou 5 items.");

    DefaultLocale.set("en-US");
    expect(MyTranslations.person.gender(Gender.male), "There is a man");
    expect(MyTranslations.person.gender(Gender.female), "There is a woman");
    expect(MyTranslations.person.gender(Gender.they), "There is a person");

    DefaultLocale.set("pt-BR");
    expect(MyTranslations.person.gender(Gender.male), "Há um homem");
    expect(MyTranslations.person.gender(Gender.female), "Há uma mulher");
    expect(MyTranslations.person.gender(Gender.they), "Há uma pessoa");
  });

  test("Translate using the extension.", () {
    //
    DefaultLocale.set("en-US");
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

    DefaultLocale.set("pt-BR");
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
// "pt-BR": "Há 1 item."
//    .zero("Não há itens.")
//     .one("Há 1 item.")
//     .two("Há um par de itens.")
//     .times(5, "Sim, você alcançou 5 items.")
//     .many("Há %d itens."),

extension Localization on Object? {
  //
  static final _t = Translations.byId<dynamic>(
    "en-US",
    {
      123: {
        "en-US": "One two three",
        "pt-BR": "Um dois três",
      },
      "There is 1 item.": {
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
      },
      456: {
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
      },
      MyTranslations.person: {
        "en-US": "There is a person"
            .modifier(Gender.male, "There is a man")
            .modifier(Gender.female, "There is a woman")
            .modifier(Gender.they, "There is a person"),
        "pt-BR": "Há uma pessoa"
            .modifier(Gender.male, "Há um homem")
            .modifier(Gender.female, "Há uma mulher")
            .modifier(Gender.they, "Há uma pessoa"),
      },
      null: {
        "en-US": "This is empty",
        "pt-BR": "Isso está vazio",
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
