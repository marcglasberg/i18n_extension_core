import 'translations.dart';
import 'translations_by_string.dart';
import 'translations_exception.dart';

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
class TranslationsByLocale<T extends Map<String, Map<String, String>>> extends Translations<T> {
  //
  final TranslationsByString byKey;

  @override
  Map<String, Map<String, String>> get translations => byKey.translations;

  TranslationsByLocale(String defaultLocaleStr)
      : byKey = TranslationsByString(defaultLocaleStr),
        super.gen(
          translations: {}, // dummy.
          defaultLocaleStr: defaultLocaleStr,
        );

  /// Add a [Map] of translations to a [Translations] object.
  @override
  Translations<Map<String, Map<String, String>>> operator +(
      Map<String, Map<String, String>> translations) {
    for (MapEntry<String, Map<String, String>> entry in translations.entries) {
      String locale = entry.key;
      for (MapEntry<String, String> entry2 in entry.value.entries) {
        String key = _getKey(entry2.key);
        String translatedString = entry2.value;
        byKey.addTranslation(
          locale: locale,
          key: key,
          translatedString: translatedString,
        );
      }
    }
    return this;
  }

  /// If the translation does NOT start with _splitter2, the translation is the
  /// key. Otherwise, if the translation is something like "·MyKey·0→abc·1→def"
  /// the key is "MyKey".
  static String _getKey(String translation) {
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
  /// var t1 = Translations("en_us") + {"en_us": "Hi.", "pt_br": "Olá."};
  /// var t2 = Translations("en_us") + {"en_us": "Goodbye.", "pt_br": "Adeus."};
  ///
  /// var translations = t1 * t2;
  /// print(localize("Hi.", translations, locale: "pt_br");
  ///
  @override
  Translations<T> operator *(Translations<Map<String, Map<String, String>>> translationsByLocale) {
    if (translationsByLocale.defaultLocaleStr != defaultLocaleStr)
      throw TranslationsException("Can't combine translations with different default locales: "
          "'$defaultLocaleStr' and "
          "'${translationsByLocale.defaultLocaleStr}'.");
    // ---

    for (MapEntry<String, Map<String, String>> entry in translationsByLocale.translations.entries) {
      var key = entry.key;
      for (MapEntry<String, String> entry2 in entry.value.entries) {
        String locale = entry2.key;
        String translatedString = entry2.value;
        byKey.addTranslation(
          locale: locale,
          key: key,
          translatedString: translatedString,
        );
      }
    }
    return this;
  }

  @override
  String get defaultLanguageStr => byKey.defaultLanguageStr;

  @override
  String get defaultLocaleStr => byKey.defaultLocaleStr;

  @override
  int get length => byKey.length;

  @override
  String toString() => byKey.toString();

  static const _splitter1 = "\uFFFF";
}
