import 'translated_string.dart';
import 'translations.dart';
import 'translations_exception.dart';

/// The [TranslationsByString] class allows you to provide all locale translations of the
/// first translatable string, then all locale translations of the second translatable string,
/// and so on.
///
/// It may be instantiated with the default [Translations.new] constructor,
/// and then you add translations with the [+] operator. For example:
///
/// ```
/// static final t = Translations("en_us") +
///       const {
///         "en_us": "i18n Demo",
///         "pt_br": "Demonstração i18n",
///       };
/// ```
///
/// ---
/// This class is NOT visible anywhere:
/// Not in [i18_exception] and NOT in [i18_exception_core].
///
class TranslationsByString<T extends Map<String, String>> extends Translations<T> {
  //
  TranslationsByString(String defaultLocaleStr)
      : assert(trim(defaultLocaleStr).isNotEmpty),
        super.gen(
          defaultLocaleStr: trim(defaultLocaleStr),
          translations: <String, Map<String, String>>{},
        );

  static String trim(String locale) {
    locale = locale.trim();
    while (locale.endsWith("_")) locale = locale.substring(0, locale.length - 1);
    return locale;
  }

  // Generative constructor.
  const TranslationsByString.gen(
    String defaultLocaleStr,
    Map<String, Map<String, String>> translations,
  ) : super.gen(
          defaultLocaleStr: defaultLocaleStr,
          translations: translations,
        );

  @override
  int get length => translations.length;

  /// Add a [Map] of translations to a [Translations] object.
  @override
  Translations<Map<String, String>> operator +(Map<String, String> translations) {
    //
    var defaultTranslation = translations[defaultLocaleStr];

    if (defaultTranslation == null)
      throw TranslationsException("No default translation for '$defaultLocaleStr'.");

    String key = _getKey(defaultTranslation);

    this.translations[key] = translations;
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
  Translations<T> operator *(Translations<Map<String, String>> translations) {
    //
    if (translations.defaultLocaleStr != defaultLocaleStr)
      throw TranslationsException("Can't combine translations with different default locales: "
          "'$defaultLocaleStr' and "
          "'${translations.defaultLocaleStr}'.");

    for (MapEntry<String, Map<String, String>> entry in translations.translations.entries) {
      var key = entry.key;
      for (MapEntry<String, String> entry2 in entry.value.entries) {
        String locale = entry2.key;
        String translatedString = entry2.value;
        addTranslation(locale: locale, key: key, translatedString: translatedString);
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

  List<TranslatedString> _translatedStrings(Map<String, String> translation) => translation.entries
      .map((entry) => TranslatedString(locale: entry.key, text: entry.value))
      .toList()
    ..sort(TranslatedString.comparable(defaultLocaleStr));

  /// Add a [key]/[translatedString] pair to the translations.
  /// You must provide non-empty [locale] and [key], but the [translatedString]
  /// may be empty (for the case when some text shouldn't be displayed in some
  /// language).
  ///
  /// If [locale] or [key] are empty, an error is thrown.
  /// However, if both the [key] and [translatedString] are empty,
  /// the method will ignore it and won't throw any errors.
  ///
  void addTranslation({
    required String locale,
    required String key,
    required String translatedString,
  }) {
    if (locale.isEmpty) throw TranslationsException("Missing locale.");
    if (key.isEmpty) {
      if (translatedString.isEmpty) return;
      throw TranslationsException("Missing key.");
    }

    // ---

    Map<String, String>? _translations = translations[key];
    if (_translations == null) {
      _translations = {};
      translations[key] = _translations;
    }
    _translations[locale] = translatedString;
  }

  @override
  String toString() {
    String text = "\nTranslations: ---------------\n";
    for (MapEntry<String, Map<String, String>> entry in translations.entries) {
      Map<String, String> translation = entry.value;
      for (var translatedString in _translatedStrings(translation)) {
        text += "  ${translatedString.locale.padRight(5)}"
            " | "
            "${_prettify(translatedString.text)}\n";
      }
      text += "-----------------------------\n";
    }
    return text;
  }

  static const _splitter1 = "\uFFFF";
  static const _splitter2 = "\uFFFE";
}
