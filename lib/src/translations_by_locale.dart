import 'package:i18n_extension_core/src/utils.dart';

import 'translations.dart';
import 'translations_by_text.dart';
import 'translations_exception.dart';
import 'typedefs.dart';

/// The [TranslationsByLocale] class allows you to provide all
/// translations together for each locale.
///
/// It may be instantiated with the [Translations.byLocale] constructor.
///
/// ```
/// static var t = Translations.byLocale("en_us") +
///   {
///      "en_us": {
///        "Hi.": "Hi.",
///        "Goodbye.": "Goodbye.",
///      },
///      "es_es": {
///        "Hi.": "Hola.",
///        "Goodbye.": "Adiós.",
///      }
///   };
/// ```
///
/// ---
/// This class is NOT visible anywhere:
/// Not in [i18_exception] and NOT in [i18_exception_core].
///
class TranslationsByLocale< //
        TKEY extends String, //
        TRANbyLOCALE extends Map<StringLocale, StringTranslated>, //
        TRANbyTKEY extends Map<TKEY, StringTranslated>, //
        ADDEDMAP extends Map<StringLocale, TRANbyTKEY>> //
    extends Translations<TKEY, TRANbyLOCALE, TRANbyTKEY, ADDEDMAP> {
  //
  final TranslationsByText<TKEY, TRANbyLOCALE, TRANbyTKEY, TRANbyLOCALE> byKey;

  /// Returns the Map of translations by locale, by translation-key.
  /// It's something like this:
  ///
  ///       'Hi': { // TKEY
  ///         'en_us': 'Hi', // LOCALE : TRAN
  ///         'pt_br': 'Olá', // LOCALE : TRAN
  ///       },
  ///       'Goodbye': { // TKEY
  ///         'en_us': 'Goodbye', // LOCALE : TRAN
  ///         'pt_br': 'Adeus', // LOCALE : TRAN
  ///       }
  @override
  Map<TKEY, TRANbyLOCALE> get translationByLocale_ByTranslationKey =>
      byKey.translationByLocale_ByTranslationKey;

  /// The default constructor of [TranslationsByLocale] allows you to provide all
  /// translations together for each locale.
  ///
  /// It may be instantiated with the [Translations.byLocale] constructor.
  ///
  /// ```
  /// static var t = Translations.byLocale("en_us") +
  ///   {
  ///      "en_us": {
  ///        "Hi.": "Hi.",
  ///        "Goodbye.": "Goodbye.",
  ///      },
  ///      "es_es": {
  ///        "Hi.": "Hola.",
  ///        "Goodbye.": "Adiós.",
  ///      }
  ///   };
  /// ```
  TranslationsByLocale(String defaultLocaleStr)
      : byKey = TranslationsByText(defaultLocaleStr),
        super.gen(
          defaultLocaleStr: normalizeLocale(defaultLocaleStr),
          translationByLocale_ByTranslationKey: <TKEY, TRANbyLOCALE>{}, // dummy.
        );

  /// Adds a Map [addedMap] of translations to a [Translations] object. Example:
  ///
  /// ```dart
  /// var t = Translations.byLocale("en_us") +
  ///         { "en_us":                  // LOCALE
  ///               {
  ///               "Hi": "Hi",           // TKEY : TRAN == TRANbyTKEY
  ///               "Goodbye": "Goodbye"  // TKEY : TRAN == TRANbyTKEY
  ///               },
  ///           "es_es":                  // LOCALE
  ///               {
  ///               "Hi": "Hola",         // TKEY : TRAN == TRANbyTKEY
  ///               "Goodbye": "Adiós"    // TKEY : TRAN == TRANbyTKEY
  ///               },
  ///         };
  /// ```
  @override
  Translations<TKEY, TRANbyLOCALE, TRANbyTKEY, ADDEDMAP> operator +(ADDEDMAP addedMap) {
    //

    // Note: ADDEDMAP = Map<StringLocale, TRANbyTKEY>>
    for (MapEntry<StringLocale, TRANbyTKEY> entry in addedMap.entries) {
      ///
      String locale = entry.key;

      for (MapEntry<String, String> entry2 in entry.value.entries) {
        String translationKey = _getTranslationKeyWithModifiers(entry2.key);
        String translatedString = entry2.value;
        byKey.addTranslation(
          locale: locale,
          translationKey: translationKey,
          stringTranslated: translatedString,
        );
      }
    }
    return this;
  }

  /// If the translation does NOT start with _splitter2, the translation is the
  /// key. Otherwise, if the translation is something like "·MyKey·0→abc·1→def"
  /// the key is "MyKey".
  String _getTranslationKeyWithModifiers(String translation) {
    if (translation.startsWith(_splitter1)) {
      List<String> parts = translation.split(_splitter1);
      return parts[1];
    } else
      return translation;
  }

  /// Add the translations of a [Translations] object to another [Translations] object.
  ///
  /// Example:
  ///
  /// ```
  /// var t1 = Translations.byLocale("en_us") + {"en_us": "Hi.", "pt_br": "Olá."};
  /// var t2 = Translations.byLocale("en_us") + {"en_us": "Goodbye.", "pt_br": "Adeus."};
  ///
  /// var translations = t1 * t2;
  /// print(localize("Hi.", translations, locale: "pt_br");
  ///
  @override
  Translations<TKEY, TRANbyLOCALE, TRANbyTKEY, ADDEDMAP> operator *(
      Translations<TKEY, TRANbyLOCALE, TRANbyTKEY, dynamic> translationsByLocale) {
    //
    if (translationsByLocale.defaultLocaleStr != defaultLocaleStr)
      throw TranslationsException("Can't combine translations with different default locales: "
          "'$defaultLocaleStr' and "
          "'${translationsByLocale.defaultLocaleStr}'.");
    // ---

    for (MapEntry<String, Map<String, String>> entry
        in translationsByLocale.translationByLocale_ByTranslationKey.entries) {
      var key = entry.key;
      for (MapEntry<String, String> entry2 in entry.value.entries) {
        String locale = entry2.key;
        String translatedString = entry2.value;
        byKey.addTranslation(
          locale: locale,
          translationKey: key,
          stringTranslated: translatedString,
        );
      }
    }
    return this;
  }

  @override
  String get defaultLocaleStr => byKey.defaultLocaleStr;

  /// To extract the language code from a locale identifier, we typically parse the identifier
  /// and take the first part before any underscore. The language code is always at the
  /// beginning of the locale identifier and is separated from any subsequent parts
  /// (like country/region or script) by an underscore.
  @override
  String get defaultLanguageStr => byKey.defaultLanguageStr;

  /// Returns the number of translation-keys.
  /// For example, if you have translations for "Hi" and "Goodbye", this will return 2.
  @override
  int get length => byKey.length;

  /// Prints the translations in a human-readable format.
  @override
  String toString() => byKey.toString();

  static const _splitter1 = "\uFFFF";
}
