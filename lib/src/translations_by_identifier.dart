import 'package:i18n_extension_core/src/translations.dart';

import 'translated_string.dart';
import 'translations_exception.dart';
import 'typedefs.dart';
import 'utils.dart';

/// The [TranslationsByIdentifier] class allows you to provide all locale translations related
/// to a first identifier, then for a second identifier, and so on. Identifiers may be
/// any immutable object, such as a `String`, `int`, `enum`, or any object you create.
///
/// It may be instantiated with the default [Translations.byId] constructor.
/// You should pass the generic type of the identifier. For example, to
/// create translations for an enum named `MyColors`: `Translations.byId<MyTranslations>`:
///
/// ```dart
/// enum MyColors { red, green }
///
/// var t = Translations.byId<MyTranslations>("en_us", {
///              MyColors.red: {
///                  "en_us": "red",
///                  "pt_br": "vermelho",
///              },
///              MyColors.green: {
///                  "en_us": "green",
///                  "pt_br": "Verde",
///              });
/// ```
///
/// Note you may also add translations with the [+] operator. For example:
///
/// ```
/// var t = Translations.byId<MyTranslations>("en_us", {
///              MyColors.red: {
///                  "en_us": "red",
///                  "pt_br": "vermelho",
///              }) +
///              {
///                  MyColors.green: {
///                     "en_us": "green",
///                     "pt_br": "Verde",
///                  }
///              };
/// ```
///
/// If you want your identifiers to be of ANY type, you can use type `Object`
/// or even `Object?` (or `dynamic`). For example:
///
/// ```
/// var t = Translations.byId<Object?>("en_us", {
///              MyColors.red: {
///                  "en_us": "red",
///                  "pt_br": "vermelho",
///              },
///              123: {
///                  "en_us": "One two three",
///                  "pt_br": "Um dois três",
///              },
///              null: {
///                  "en_us": "This is empty",
///                  "pt_br": "Isso está vazio",
///              });
/// ```
///
/// IMPORTANT: You can create your own class and use its objects as identifiers, but it
/// must implement the `==` and `hashCode` methods. Otherwise, it won't be possible to
/// find it as one of the translation keys.
///
/// ---
/// This class is NOT visible anywhere:
/// Not in [i18_exception] and NOT in [i18_exception_core].
///
class TranslationsByIdentifier< //
        TKEY extends Object?, //
        TRANbyLOCALE extends Map<StringLocale, StringTranslated>, //
        TRANbyTKEY extends Map<TKEY, StringTranslated>, //
        ADDEDMAP extends Map<TKEY, TRANbyLOCALE> //
        > //
    extends Translations<TKEY, TRANbyLOCALE, TRANbyTKEY, ADDEDMAP> {
  //
  TranslationsByIdentifier(
    String defaultLocaleStr,
    Map<TKEY, TRANbyLOCALE> translationByLocale_ByTranslationKey,
  )   : assert(normalizeLocale(defaultLocaleStr).isNotEmpty),
        super.gen(
          defaultLocaleStr: normalizeLocale(defaultLocaleStr),
          translationByLocale_ByTranslationKey: translationByLocale_ByTranslationKey,
        );

  // Generative constructor.
  const TranslationsByIdentifier.gen(
    StringLocale defaultLocaleStr,
    Map<TKEY, TRANbyLOCALE> translationByLocale_ByTranslationKey,
  ) : super.gen(
          defaultLocaleStr: defaultLocaleStr,
          translationByLocale_ByTranslationKey: translationByLocale_ByTranslationKey,
        );

  /// Returns the number of translation-keys.
  /// For example, if you have translations for "Hi" and "Goodbye", this will return 2.
  @override
  int get length => translationByLocale_ByTranslationKey.length;

  /// Adds a Map [addedMap] of translations to a [Translations] object. Example:
  ///
  /// ```dart
  /// var t = Translations.byId("en_us") +
  ///         {123 : {"en_us": "Hi", "pt_br": "Olá" }} + // addedMap
  ///         {456 : {"en_us": "Goodbye", "pt_br": "Adeus"}}; // Another addedMap
  /// ```
  @override
  Translations<TKEY, TRANbyLOCALE, TRANbyTKEY, ADDEDMAP> operator +(ADDEDMAP addedMap) {
    //
    for (MapEntry<TKEY, TRANbyLOCALE> idTranslations in addedMap.entries) {
      TKEY id = idTranslations.key;
      TRANbyLOCALE translationsByLocale = idTranslations.value;
      translationByLocale_ByTranslationKey[id] = translationsByLocale;
    }

    return this;
  }

  /// Add the translations of a [translationsObj] to another [Translations] object.
  ///
  /// Example:
  ///
  /// ```
  /// var t1 = Translations.byId("en_us") + {"en_us": "Hi.", "pt_br": "Olá."};
  /// var t2 = Translations.byId("en_us") + {"en_us": "Goodbye.", "pt_br": "Adeus."};
  ///
  /// var translations = t1 * t2;
  /// print(localize("Hi.", translations, locale: "pt_br");
  ///
  @override
  Translations<TKEY, TRANbyLOCALE, TRANbyTKEY, ADDEDMAP> operator *(
      Translations<TKEY, TRANbyLOCALE, TRANbyTKEY, dynamic> translationsObj) {
    //
    if (translationsObj.defaultLocaleStr != defaultLocaleStr)
      throw TranslationsException("Can't combine translations with different default locales: "
          "'$defaultLocaleStr' and "
          "'${translationsObj.defaultLocaleStr}'.");

    for (MapEntry<TKEY, TRANbyLOCALE> idTranslations
        in translationsObj.translationByLocale_ByTranslationKey.entries) {
      //
      TKEY translationKey = idTranslations.key;
      TRANbyLOCALE translationsByLocale = idTranslations.value;

      for (MapEntry<StringLocale, StringTranslated> translationByLocale
          in translationsByLocale.entries) {
        //
        String locale = translationByLocale.key;
        String stringTranslated = translationByLocale.value;

        addTranslation(
          locale: locale,
          translationKey: translationKey,
          stringTranslated: stringTranslated,
        );
      }
    }
    return this;
  }

  /// This prettifies versioned strings (that have modifiers).
  String _prettify(String translation) {
    if (!translation.startsWith(_splitter1)) return translation;

    List<String> parts = translation.split(_splitter1);

    String result = parts[1];

    for (int i = 2; i < parts.length; i++) {
      var part = parts[i];
      List<String> par = part.split(_splitter2);
      if (par.length != 2 || par[0].isEmpty || par[1].isEmpty) return translation;
      String modifier = par[0];
      String text = par[1];
      result += "\n          $modifier → $text";
    }
    return result;
  }

  List<TranslatedString> _translatedStrings(Map<StringLocale, StringTranslated> translation) =>
      translation.entries
          .map((entry) => TranslatedString(locale: entry.key, key: entry.value))
          .toList()
        ..sort(TranslatedString.comparable(defaultLocaleStr));

  /// Add a [translationKey]/[stringTranslated] pair to the translations.
  /// You must provide non-empty [locale] and [translationKey], but the [stringTranslated]
  /// may be empty (for the case when some text shouldn't be displayed in some
  /// language).
  ///
  void addTranslation({
    required String locale,
    required TKEY translationKey,
    required String stringTranslated,
  }) {
    if (locale.isEmpty) throw TranslationsException("Missing locale.");
    // ---

    Map<StringLocale, StringTranslated>? _translations =
        translationByLocale_ByTranslationKey[translationKey];

    if (_translations == null) {
      _translations = {};
      translationByLocale_ByTranslationKey[translationKey] = _translations as TRANbyLOCALE;
    }
    _translations[locale] = stringTranslated;
  }

  @override
  String toString() {
    String text = "\nTranslations: ---------------\n";
    for (MapEntry<TKEY, Map<StringLocale, StringTranslated>> entry
        in translationByLocale_ByTranslationKey.entries) {
      text += "${entry.key}\n";
      Map<StringLocale, StringTranslated> translation = entry.value;
      for (var translatedString in _translatedStrings(translation)) {
        text += "  ${translatedString.locale.padRight(5)}"
            " | "
            "${_prettify(translatedString.key.toString())}\n";
      }
      text += "-----------------------------\n";
    }
    return text;
  }

  static const _splitter1 = "\uFFFF";
  static const _splitter2 = "\uFFFE";
}

// ----------------------------------------------------------------------------------------

/// The [TranslationsById] constructor allows you to use any type of "identifiers"
/// as translation keys. You can define the keys as `final` or `const` values in
/// your translations file, and then use the [IdTranslations.new] constructor.
/// For example:
///
/// ```dart
///  import 'package:i18n_extension/i18n_extension.dart';
///
///  const appbarTitle = "appbarTitle";
///  const greetings = "greetings";
///  const increment = "increment";
///  const changeLanguage = "changeLanguage";
///  const youClickedThisNumberOfTimes = "youClickedThisNumberOfTimes";
///
///  extension Localization on String {
///
///   static final _t = Translations.byId("en_us", {
///     appbarTitle: {
///       "en_us": "i18n Demo",
///       "pt_br": "Demonstração i18n",
///     },
///     greetings: {
///       "en_us": "This example demonstrates how to use identifiers as keys.\n\n"
///           "For example, you can write:\n"
///           "helloThere.i18n\n"
///           "instead of\n"
///           "\"Hello There\".i18n",
///       "pt_br": "Este exemplo demonstra como usar identificadores como chaves.\n\n"
///           "Por exemplo, você pode escrever:\n"
///           "saudacao.i18n\n"
///           "em vez de\n"
///           "\"Olá como vai\".i18n",
///     },
///     increment: {
///       "en_us": "Increment",
///       "pt_br": "Incrementar",
///     },
///     changeLanguage: {
///       "en_us": "Change Language",
///       "pt_br": "Mude Idioma",
///     },
///     youClickedThisNumberOfTimes: {
///       "en_us": "You clicked the button %d times:"
///           .zero("You haven't clicked the button:")
///           .one("You clicked it once:")
///           .two("You clicked a couple times:")
///           .many("You clicked %d times:")
///           .times(12, "You clicked a dozen times:"),
///       "pt_br": "Você clicou o botão %d vezes:"
///           .zero("Você não clicou no botão:")
///           .one("Você clicou uma única vez:")
///           .two("Você clicou um par de vezes:")
///           .many("Você clicou %d vezes:")
///           .times(12, "Você clicou uma dúzia de vezes:"),
///     }
///   });
///
///   String get i18n => localize(this, _t);
///
///   String fill(List<Object> params) => localizeFill(this, params);
///
///   String plural(value) => localizePlural(value, this, _t);
/// }
