import 'package:i18n_extension_core/src/core_localize_functions.dart';
import 'package:i18n_extension_core/src/translations.dart';
import 'package:test/test.dart';

void main() {
  test("Sprintf interpolations.", () {
    //
    DefaultLocale.set("en-US");

    expect(
        () => localizeFill("Hello %s, this is %s.".i18n, []), throwsA(isA<RangeError>()));

    expect(() => localizeFill("Hello %s, this is %s.".i18n, "John"),
        throwsA(isA<RangeError>()));

    expect(() => localizeFill("Hello %s, this is %s.".i18n, ["John"]),
        throwsA(isA<RangeError>()));

    expect(localizeFill("Hello %s, this is %s.".i18n, ["John", "Mary"]),
        "Hello John, this is Mary.");

    expect(localizeFill("Hello %s, this is %s.".i18n, {"John", "Mary"}),
        "Hello John, this is Mary.");

    expect(localizeFill("Hello %s, this is %s.".i18n, "John", "Mary"),
        "Hello John, this is Mary.");

    expect(localizeFill("Hello %s, this is %s.".i18n, ["John", "Mary", "Eve"]),
        "Hello John, this is Mary.");

    expect(localizeFill("Hello %s, this is %s.".i18n, "John", "Mary", "Eve"),
        "Hello John, this is Mary.");

    // ---

    DefaultLocale.set("pt-BR");

    expect(localizeFill("Hello %s, this is %s.".i18n, ["John", "Mary"]),
        "Olá John, aqui é Mary.");

    expect(localizeFill("Hello %s, this is %s.".i18n, {"John", "Mary"}),
        "Olá John, aqui é Mary.");

    expect(localizeFill("Hello %s, this is %s.".i18n, "John", "Mary"),
        "Olá John, aqui é Mary.");
  });
}

extension Localization on String {
  //
  static final _t = Translations.byText("en-US") +
      {
        "en-US": "Hello %s, this is %s.",
        "pt-BR": "Olá %s, aqui é %s.",
      };

  String get i18n => localize(this, _t);
}
