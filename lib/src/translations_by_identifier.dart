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
/// var t = Translations.byId<MyTranslations>("en-US", {
///              MyColors.red: {
///                  "en-US": "red",
///                  "pt-BR": "vermelho",
///              },
///              MyColors.green: {
///                  "en-US": "green",
///                  "pt-BR": "Verde",
///              });
/// ```
///
/// Note you may also add translations with the [+] operator. For example:
///
/// ```
/// var t = Translations.byId<MyTranslations>("en-US", {
///              MyColors.red: {
///                  "en-US": "red",
///                  "pt-BR": "vermelho",
///              }) +
///              {
///                  MyColors.green: {
///                     "en-US": "green",
///                     "pt-BR": "Verde",
///                  }
///              };
/// ```
///
/// If you want your identifiers to be of ANY type, you can use type `Object`
/// or even `Object?` (or `dynamic`). For example:
///
/// ```
/// var t = Translations.byId<Object?>("en-US", {
///              MyColors.red: {
///                  "en-US": "red",
///                  "pt-BR": "vermelho",
///              },
///              123: {
///                  "en-US": "One two three",
///                  "pt-BR": "Um dois três",
///              },
///              null: {
///                  "en-US": "This is empty",
///                  "pt-BR": "Isso está vazio",
///              });
/// ```
///
/// IMPORTANT: You can create your own class and use its objects as identifiers, but it
/// must implement the `==` and `hashCode` methods. Otherwise, it won't be possible to
/// find it as one of the translation-keys.
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

  /// The default constructor of [TranslationsByIdentifier] allows you to provide all locale
  /// translations related to a first identifier, then for a second identifier, and so on.
  /// Identifiers may be any immutable object, such as a `String`, `int`, `enum`, or any object
  /// you create.
  ///
  /// It may be instantiated with the default [Translations.byId] constructor.
  /// You should pass the generic type of the identifier. For example, to
  /// create translations for an enum named `MyColors`: `Translations.byId<MyTranslations>`:
  ///
  /// ```dart
  /// enum MyColors { red, green }
  ///
  /// var t = Translations.byId<MyTranslations>("en-US", {
  ///              MyColors.red: {
  ///                  "en-US": "red",
  ///                  "pt-BR": "vermelho",
  ///              },
  ///              MyColors.green: {
  ///                  "en-US": "green",
  ///                  "pt-BR": "Verde",
  ///              });
  /// ```
  ///
  /// Note you may also add translations with the [+] operator. For example:
  ///
  /// ```
  /// var t = Translations.byId<MyTranslations>("en-US", {
  ///              MyColors.red: {
  ///                  "en-US": "red",
  ///                  "pt-BR": "vermelho",
  ///              }) +
  ///              {
  ///                  MyColors.green: {
  ///                     "en-US": "green",
  ///                     "pt-BR": "Verde",
  ///                  }
  ///              };
  /// ```
  ///
  /// If you want your identifiers to be of ANY type, you can use type `Object`
  /// or even `Object?` (or `dynamic`). For example:
  ///
  /// ```
  /// var t = Translations.byId<Object?>("en-US", {
  ///              MyColors.red: {
  ///                  "en-US": "red",
  ///                  "pt-BR": "vermelho",
  ///              },
  ///              123: {
  ///                  "en-US": "One two three",
  ///                  "pt-BR": "Um dois três",
  ///              },
  ///              null: {
  ///                  "en-US": "This is empty",
  ///                  "pt-BR": "Isso está vazio",
  ///              });
  /// ```
  ///
  /// IMPORTANT: You can create your own class and use its objects as identifiers, but it
  /// must implement the `==` and `hashCode` methods. Otherwise, it won't be possible to
  /// find it as one of the translation-keys.
  ///
  TranslationsByIdentifier(
    String defaultLocaleStr,
    Map<TKEY, TRANbyLOCALE> translationByLocale_ByTranslationKey,
  ) : super.gen(
          defaultLocaleStr: checkLocale(defaultLocaleStr),
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
  /// var t = Translations.byId("en-US") +
  ///         {123 : {"en-US": "Hi", "pt-BR": "Olá" }} + // addedMap
  ///         {456 : {"en-US": "Goodbye", "pt-BR": "Adeus"}}; // Another addedMap
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
  /// var t1 = Translations.byId("en-US") + {"en-US": "Hi.", "pt-BR": "Olá."};
  /// var t2 = Translations.byId("en-US") + {"en-US": "Goodbye.", "pt-BR": "Adeus."};
  ///
  /// var translations = t1 * t2;
  /// print(localize("Hi.", translations, locale: "pt-BR");
  ///
  @override
  Translations<TKEY, TRANbyLOCALE, TRANbyTKEY, ADDEDMAP> operator *(
      Translations<TKEY, TRANbyLOCALE, TRANbyTKEY, dynamic> translationsObj) {
    //
    if (translationsObj.defaultLocaleStr != defaultLocaleStr)
      throw TranslationsException(
          "Can't combine translations with different default locales: "
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

  List<TranslatedString> _translatedStrings(
          Map<StringLocale, StringTranslated> translation) =>
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
      translationByLocale_ByTranslationKey[translationKey] =
          _translations as TRANbyLOCALE;
    }
    _translations[locale] = stringTranslated;
  }

  /// Prints the translations in a human-readable format.
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
