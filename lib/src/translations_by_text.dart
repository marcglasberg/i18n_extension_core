import 'translated_string.dart';
import 'translations.dart';
import 'translations_exception.dart';
import 'typedefs.dart';
import 'utils.dart';

/// The [TranslationsByText] class allows you to provide all locale translations of the
/// first translatable string, then all locale translations of the second translatable string,
/// and so on.
///
/// It may be instantiated with the default [Translations.byText] constructor,
/// and then you add translations with the [+] operator. For example:
///
/// ```
/// static final t = Translations.byText("en_us") +
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
class TranslationsByText< //
        TKEY extends String, //
        TRANbyLOCALE extends Map<StringLocale, StringTranslated>, //
        TRANbyTKEY extends Map<TKEY, StringTranslated>, //
        ADDEDMAP extends TRANbyLOCALE //
        > //
    extends Translations<TKEY, TRANbyLOCALE, TRANbyTKEY, ADDEDMAP> {
  //
  TranslationsByText(String defaultLocaleStr)
      : assert(normalizeLocale(defaultLocaleStr).isNotEmpty),
        super.gen(
          defaultLocaleStr: normalizeLocale(defaultLocaleStr),
          translationByLocale_ByTranslationKey: <TKEY, TRANbyLOCALE>{},
        );

  // Generative constructor.
  const TranslationsByText.gen(
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
  /// var t = Translations.byText("en_us") +
  ///         {"en_us": "Hi", "pt_br": "Olá" } + // addedMap
  ///         {"en_us": "Goodbye", "pt_br": "Adeus"}; // Another addedMap
  /// ```
  @override
  Translations<TKEY, TRANbyLOCALE, TRANbyTKEY, ADDEDMAP> operator +(ADDEDMAP addedMap) {
    //
    // When using [TranslationsByText], the default locale (a String) is the key of the map.
    String? defaultStringTranslated = addedMap[defaultLocaleStr];

    if (defaultStringTranslated == null)
      throw TranslationsException("No default translation for '$defaultLocaleStr'.");

    TKEY translationKey = _getTranslationKeyWithModifiers(defaultStringTranslated);
    translationByLocale_ByTranslationKey[translationKey] = addedMap;

    return this;
  }

  /// If the translation does NOT start with _splitter2, the translation is the
  /// key. Otherwise, if the translation is something like "·MyKey·0→abc·1→def"
  /// the key is "MyKey".
  TKEY _getTranslationKeyWithModifiers(String translation) {
    if (translation.startsWith(_splitter1)) {
      List<String> parts = translation.split(_splitter1);
      return parts[1] as TKEY;
    } else
      return translation as TKEY;
  }

  /// Add the translations of a [translationsObj] to another [Translations] object.
  ///
  /// Example:
  ///
  /// ```
  /// var t1 = Translations.byText("en_us") + {"en_us": "Hi.", "pt_br": "Olá."};
  /// var t2 = Translations.byText("en_us") + {"en_us": "Goodbye.", "pt_br": "Adeus."};
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

    for (MapEntry<TKEY, TRANbyLOCALE> entry
        in translationsObj.translationByLocale_ByTranslationKey.entries) {
      //
      String translationKey = entry.key;
      TRANbyLOCALE translationsByLocale = entry.value;

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
  /// If [locale] or [translationKey] are empty, an error is thrown.
  /// However, if both the [translationKey] and [stringTranslated] are empty,
  /// the method will ignore it and won't throw any errors.
  ///
  void addTranslation({
    required String locale,
    required String translationKey,
    required String stringTranslated,
  }) {
    if (locale.isEmpty) throw TranslationsException("Missing locale.");
    if (translationKey.isEmpty) {
      if (stringTranslated.isEmpty)
        return;
      else
        throw TranslationsException("Missing key.");
    }

    // ---

    Map<StringLocale, StringTranslated>? _translations =
        translationByLocale_ByTranslationKey[translationKey];

    if (_translations == null) {
      _translations = {};
      translationByLocale_ByTranslationKey[translationKey as TKEY] = _translations as ADDEDMAP;
    }
    _translations[locale] = stringTranslated;
  }

  @override
  String toString() {
    String text = "\nTranslations: ---------------\n";
    for (MapEntry<TKEY, Map<StringLocale, StringTranslated>> entry
        in translationByLocale_ByTranslationKey.entries) {
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
