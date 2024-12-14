/// String extension which allows you to add plural modifiers to a string.
///
/// For example:
///
/// ```
/// static var _t = Translations.byText("en-US") +
/// {
/// "en-US": "You clicked the button %d times"
///     .zero("You haven't clicked the button")
///     .one("You clicked it once")
///     .two("You clicked a couple times")
///     .many("You clicked %d times")
///     .times(12, "You clicked a dozen times"),
/// "pt-BR": "Você clicou o botão %d vezes"
///     .zero("Você não clicou no botão")
///     .one("Você clicou uma única vez")
///     .two("Você clicou um par de vezes")
///     .many("Você clicou %d vezes")
///     .times(12, "Você clicou uma dúzia de vezes"),
/// };
///
/// String plural(value) => localizePlural(value, this, _t);
/// ```
///
/// This extension is visible from both [i18_exception] and [i18_exception_core] packages.
///
extension I18nModifierLocalization on String {
  //
  static const _splitter1 = "\uFFFF";
  static const _splitter2 = "\uFFFE";

  /// Creates a modifier for the given [identifier] and [text].
  String modifier(Object identifier, String text) =>
      ((!startsWith(_splitter1)) ? _splitter1 : "") //
      +
      "$this$_splitter1$identifier$_splitter2$text";

  /// Plural modifier for zero elements.
  String zero(String text) => modifier("0", text);

  /// Plural modifier for 1 element.
  String one(String text) => modifier("1", text);

  /// Plural modifier for 2 elements.
  String two(String text) => modifier("2", text);

  /// Plural modifier for 3 elements.
  String three(String text) => modifier("3", text);

  /// Plural modifier for 4 elements.
  String four(String text) => modifier("4", text);

  /// Plural modifier for 5 elements.
  String five(String text) => modifier("5", text);

  /// Plural modifier for 6 elements.
  String six(String text) => modifier("6", text);

  /// Plural modifier for 10 elements.
  String ten(String text) => modifier("T", text);

  /// Plural modifier for any number of elements, except 0, 1 and 2.
  String times(int numberOfTimes, String text) {
    assert(numberOfTimes < 0 || numberOfTimes > 2);
    return modifier(numberOfTimes, text);
  }

  /// Plural modifier for 2, 3 or 4 elements (especially for Czech language).
  String twoThreeFour(String text) => modifier("C", text);

  /// Plural modifier for 1 or more elements.
  /// In other words, it includes any number of elements except zero.
  String oneOrMore(String text) => modifier("R", text);

  /// Plural modifier for 0 or 1 elements.
  String zeroOne(String text) => modifier("F", text);

  /// Plural modifier for any number of elements, except 1.
  /// Note: [many] includes 0 elements, but it's less specific
  /// than [zero] and [zeroOne].
  String many(String text) => modifier("M", text);
}
