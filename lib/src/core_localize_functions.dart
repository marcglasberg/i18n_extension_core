import 'package:sprintf/sprintf.dart';

import 'translated_string.dart';
import 'translations.dart';
import 'translations_exception.dart';

/// Use the [localize] method to localize a "translatable string" to the given [locale].
/// You must provide the [key] (which is usually the string you want to translate)
/// and the [translations] object which holds the translations.
///
/// If [locale] is not provided (it's `null`), the method will use the default locale
/// in [DefaultLocale.locale] (which may be set with [DefaultLocale.set].
///
/// If both [locale] and [DefaultLocale.locale] are not provided, it defaults to 'en_US'.
///
/// ---
///
/// Fallback order:
///
/// - If the translation to the exact locale is found, this will be returned.
/// - Otherwise, it tries to return a translation for the general language of
///   the locale.
/// - Otherwise, it tries to return a translation for any locale with that
///   language.
/// - Otherwise, it tries to return the key itself (which is the translation
///   for the default locale).
///
/// Example 1:
/// If "pt_br" is asked, and "pt_br" is available, return for "pt_br".
///
/// Example 2:
/// If "pt_br" is asked, "pt_br" is not available, and "pt" is available,
/// return for "pt".
///
/// Example 3:
/// If "pt_mo" is asked, "pt_mo" and "pt" are not available, but "pt_br" is,
/// return for "pt_br".
///
/// ---
/// This function is visible only from the [i18_exception_core] package.
/// The [i18_exception] package uses a different function with the same name.
///
String localize(
  Object? key,
  Translations translations, {
  String? locale,
}) {
  Map<String, String>? translatedStringPerLocale = translations[key];

  if (translatedStringPerLocale == null) {
    if (Translations.recordMissingKeys)
      Translations.missingKeys
          .add(TranslatedString(locale: translations.defaultLocaleStr, key: key));

    Translations.missingKeyCallback(key, translations.defaultLocaleStr);

    return key.toString();
  }
  //
  else {
    locale = _effectiveLocale(locale);

    if (locale == "null")
      throw TranslationsException("Locale is the 4 letter string 'null', which is invalid.");

    // Get the translated string in the language we want.
    String? translatedString = translatedStringPerLocale[locale];

    // Return the translated string in the language we want.
    if (translatedString != null) return translatedString;

    // If there's no translated string in the locale, record it.
    if (Translations.recordMissingTranslations && locale != translations.defaultLocaleStr) {
      Translations.missingTranslations.add(TranslatedString(locale: locale, key: key));
      Translations.missingTranslationCallback(key, locale);
    }

    // ---

    var lang = _language(locale);

    // Try finding the translation in the general language. Note: If the locale
    // is already general, it was already searched, so no need to do it again.
    if (!_isGeneral(locale)) {
      translatedString = translatedStringPerLocale[lang];
      if (translatedString != null) return translatedString;
    }

    // Try finding the translation in any local with that language.
    for (MapEntry<String, String> entry in translatedStringPerLocale.entries) {
      if (lang == _language(entry.key)) return entry.value;
    }

    // If nothing is found, return the value or key,
    // that is the translation in the default locale.
    return translatedStringPerLocale[translations.defaultLocaleStr] ?? key.toString();
  }
}

/// "pt" is a general locale, because it's just a language, while "pt_br" is not.
bool _isGeneral(String locale) => !locale.contains("_");

/// The language must be everything before the underscore, otherwise this won't work.
String _language(String locale) => locale.split('_')[0];

/// Does an `sprintf` on the [text] with the [params].
/// This is implemented with the `sprintf` package: https://pub.dev/packages/sprintf
///
/// Possible format values:
///
/// * `%s` - String
/// * `%b` - Binary number
/// * `%c` - Character according to the ASCII value of `c`
/// * `%d` - Signed decimal number (negative, zero or positive)
/// * `%u` - Unsigned decimal number (equal to or greater than zero)
/// * `%f` - Floating-point number
/// * `%e` - Scientific notation using a lowercase, like `1.2e+2`
/// * `%E` - Scientific notation using a uppercase, like `1.2E+2`
/// * `%g` - shorter of %e and %f
/// * `%G` - shorter of %E and %f
/// * `%o` - Octal number
/// * `%X` - Hexadecimal number, uppercase letters
/// * `%x` - Hexadecimal number, lowercase letters
///
/// Additional format values may be placed between the % and the letter.
/// If multiple of these are used, they must be in the same order as below.
///
/// * `+` - Forces both + and - in front of numbers. By default, only negative numbers are marked
/// * `'` - Specifies the padding char. Space is the default. Used together with the width specifier: %'x20s uses "x" as padding
/// * `-` - Left-justifies the value
/// * `[0-9]` -  Specifies the minimum width held of to the variable value
/// * `.[0-9]` - Specifies the number of decimal digits or maximum string length. Example: `%.2f`:
///
/// ---
/// This function is visible only from the [i18_exception_core] package.
/// The [i18_exception] package uses a different function with the same name.
///
String localizeFill(Object? text, List<Object> params) => sprintf(text.toString(), params);

/// Returns the translated version for the plural [modifier].
/// After getting the version, substring `%d` will be replaced with the modifier.
///
/// Note: This will try to get the most specific plural modifier. For example,
/// `.two` is more specific than `.many`.
///
/// If no applicable modifier can be found, it will default to the unversioned
/// string. For example, this: `"a".zero("b").four("c:")` will default to `"a"`
/// for 1, 2, 3, or more than 5 elements.
///
/// The modifier should usually be an integer. But in case it's not, it will
/// be converted into an integer. The rules are:
///
/// 1) If the modifier is an `int`, its absolute value will be used.
/// Note: absolute value means a negative value will become positive.
///
/// 2) If the modifier is a `double`, its absolute value will be used, like so:
/// - 1.0 will be 1.
/// - Values below 1.0 will become 0.
/// - Values larger than 1.0 will be rounded up.
///
/// 3) A `String` will be converted to `int` or, if that fails, to a `double`.
/// Conversion is done like so:
/// - First, it will discard other chars than numbers, dot and the minus sign,
///   by converting them to spaces.
/// - Then it will convert to int using `int.tryParse`.
/// - Then it will convert to double using `double.tryParse`.
/// - If all fails, it will be zero.
///
/// 4) Other objects will be converted to a string (using the toString method), and then the above
/// rules will apply.
///
/// ---
/// This function is visible only from the [i18_exception_core] package.
/// The [i18_exception] package uses a different function with the same name.
///
String localizePlural(
  Object? modifier,
  Object? key,
  Translations translations, {
  String? locale,
}) {
  int modifierInt = convertToIntegerModifier(modifier);

  locale = locale?.toLowerCase();

  Map<String?, String> versions = localizeAllVersions(key, translations, locale: locale);

  String? text;

  /// For plural(0), returns the version 0, otherwise the version the version
  /// 0-1, otherwise the version many, otherwise the unversioned.
  if (modifierInt == 0)
    text = versions["0"] ?? versions["F"] ?? versions["M"] ?? versions[null];

  /// For plural(1), returns the version 1, otherwise the version the version
  /// 0-1, otherwise the version the version 1-many, otherwise the unversioned.
  else if (modifierInt == 1)
    text = versions["1"] ?? versions["F"] ?? versions["R"] ?? versions[null];

  /// For plural(2), returns the version 2, otherwise the version 2-3-4,
  /// otherwise the version many/1-many, otherwise the unversioned.
  else if (modifierInt == 2)
    text = versions["2"] ?? versions["C"] ?? versions["M"] ?? versions["R"] ?? versions[null];

  /// For plural(3), returns the version 3, otherwise the version 2-3-4,
  /// otherwise the version many/1-many, otherwise the unversioned.
  else if (modifierInt == 3)
    text = versions["3"] ?? versions["C"] ?? versions["M"] ?? versions["R"] ?? versions[null];

  /// For plural(4), returns the version 4, otherwise the version 2-3-4,
  /// otherwise the version many/1-many, otherwise the unversioned.
  else if (modifierInt == 4)
    text = versions["4"] ?? versions["C"] ?? versions["M"] ?? versions["R"] ?? versions[null];

  /// For plural(5), returns the version 5, otherwise the version many/1-many,
  /// otherwise the unversioned.
  else if (modifierInt == 5)
    text = versions["5"] ?? versions["M"] ?? versions["R"] ?? versions[null];

  /// For plural(6), returns the version 6, otherwise the version many/1-many,
  /// otherwise the unversioned.
  else if (modifierInt == 6)
    text = versions["6"] ?? versions["M"] ?? versions["R"] ?? versions[null];

  /// For plural(10), returns the version 10, otherwise the version many/1-many,
  /// For plural(10), returns the version 10, otherwise the version many/1-many,
  /// otherwise the unversioned.
  else if (modifierInt == 10)
    text = versions["T"] ?? versions["M"] ?? versions["R"] ?? versions[null];

  /// For plural(<0 or >2), returns the version many/1-many,
  /// otherwise the unversioned.
  else
    text = versions[modifierInt.toString()] ?? versions["M"] ?? versions["R"] ?? versions[null];

  // ---

  if (text == null)
    throw TranslationsException("No version found "
        "(modifier: $modifierInt, "
        "key: '$key', "
        "locale: '${_effectiveLocale(locale)}').");

  text = text.replaceAll("%d", modifierInt.toString());

  return text;
}

/// See rules stated in [localizePlural]'s documentation.
/// IMPORTANT: This function is visible for testing purposes only.
///
/// ---
/// This function is visible only from the [i18_exception_core] package.
///
int convertToIntegerModifier(Object? modifierObj) {
  //
  if (modifierObj is! int && modifierObj is! double) {
    String modifierStr = modifierObj.toString();
    modifierStr = modifierStr.replaceAll(RegExp(r'[^0-9\.]'), ' ');

    modifierObj = int.tryParse(modifierStr);
    modifierObj ??= double.tryParse(modifierStr) ?? 0.0;
  }

  if (modifierObj is double) {
    modifierObj = modifierObj.abs();

    if (modifierObj == 1.0)
      return 1;
    else if (modifierObj < 1.0)
      return 0;
    else
      return modifierObj.ceil();
  }
  //
  else if (modifierObj is int)
    return modifierObj.abs();
  //
  else
    throw AssertionError(modifierObj);
}

/// Use the [localizeVersion] method to localize a "translatable string" to the given [locale].
/// You must provide the [key] (which is usually the string you want to translate),
/// a [modifier], and the [translations] object which holds the translations.
///
/// You may use an object of any type as the [modifier], but it will do a `toString()`
/// in it and use resulting String. So, make sure your object has a suitable
/// string representation.
///
/// If [locale] is not provided (it's `null`), the method will use the default locale
/// in [DefaultLocale.locale] (which may be set with [DefaultLocale.set].
///
/// If both [locale] and [DefaultLocale.locale] are not provided, it defaults to 'en_US'.
///
/// ---
/// This function is visible only from the [i18_exception_core] package.
/// The [i18_exception] package uses a different function with the same name.
///
String localizeVersion(
  Object modifier,
  Object? key,
  Translations translations, {
  String? locale,
}) {
  locale = locale?.toLowerCase();

  String total = localize(key, translations, locale: locale);

  if (!total.startsWith(_splitter1))
    throw TranslationsException("This text has no version for modifier '$modifier' "
        "(modifier: $modifier, "
        "key: '$key', "
        "locale: '${_effectiveLocale(locale)}').");

  List<String> parts = total.split(_splitter1);

  for (int i = 2; i < parts.length; i++) {
    var part = parts[i];
    List<String> par = part.split(_splitter2);
    if (par.length != 2 || par[0].isEmpty || par[1].isEmpty)
      throw TranslationsException("Invalid text version for '$part'.");
    String _modifier = par[0];
    String text = par[1];
    if (_modifier == modifier.toString()) return text;
  }

  throw TranslationsException("This text has no version for modifier '$modifier' "
      "(modifier: $modifier, "
      "key: '$key', "
      "locale: '${_effectiveLocale(locale)}').");
}

/// Use the [localizeAllVersions] method to return a [Map] of all translated strings,
/// where modifiers are the keys. In special, the unversioned text is indexed with a `null` key.
///
/// If [locale] is not provided (it's `null`), the method will use the default locale
/// in [DefaultLocale.locale] (which may be set with [DefaultLocale.set].
///
/// If both [locale] and [DefaultLocale.locale] are not provided, it defaults to 'en_US'.
///
/// ---
/// This function is visible only from the [i18_exception_core] package.
/// The [i18_exception] package uses a different function with the same name.
///
Map<String?, String> localizeAllVersions(
  Object? key,
  Translations translations, {
  String? locale,
}) {
  locale = locale?.toLowerCase();
  String total = localize(key, translations, locale: locale);

  if (!total.startsWith(_splitter1)) {
    return {null: total};
  }

  List<String> parts = total.split(_splitter1);
  if (parts.isEmpty) return {null: key.toString()};

  Map<String?, String> all = {null: parts[1]};

  for (int i = 2; i < parts.length; i++) {
    var part = parts[i];
    List<String> par = part.split(_splitter2);
    String version = par[0];
    String text = (par.length == 2) ? par[1] : "";

    if (version.isEmpty)
      throw TranslationsException("Invalid text version for '$part' "
          "(key: '$key', "
          "locale: '${_effectiveLocale(locale)}').");

    all[version] = text;
  }

  return all;
}

/// To set the default locale, use this class:
///
/// ```dart
/// DefaultLocale.set("en_US");
/// DefaultLocale.set("sp_ES");
/// DefaultLocale.set("pt_BR");
///
/// If you remove the default locale, it's considered English of the Unites States.
/// DefaultLocale.set(null); // Means "en_US".
/// DefaultLocale.set(""); // Means "en_US".
/// ```
///
/// To get the locale as a lowercase string: `DefaultLocale.locale;`
///
/// When you translate strings using [localize], [localizePlural], [localizeVersion]
/// or [localizeAllVersions], you can pass them the locale as a parameter.
/// When you don't, the default locale defined here will be used. If you don't
/// define a default locale, it will be "en_us".
///
/// ---
/// The [DefaultLocale] class is visible only from the [i18_exception_core] package.
/// The [i18_exception] package lets you set the default locale in a different way:
/// By using the `I18n` widget class, which is turn is not visible from
/// the [i18_exception_core] package.
///
class DefaultLocale {
  DefaultLocale._();

  static String? _locale;

  /// Returns the default locale, as a lowercase String with no spaces, like `en_us`.
  static String get locale => _locale ?? 'en_US';

  /// Use this to set the value of [DefaultLocale.locale].
  /// Note the locale will be normalized (trims spaces and underscore).
  /// If you remove the default locale with `DefaultLocale.set(null)`,
  /// the default will be English of the Unites States.
  static void set(String? localeStr) => _locale = normalizeLocale(localeStr);

  /// Return the string representation of the given [locale], normalized
  /// as lowercase, without spaces, and at most a single underscore.
  static String? normalizeLocale(String? locale) {
    if (locale == null || locale.isEmpty)
      return null;
    else {
      String str = locale.toLowerCase();
      RegExp pattern = RegExp('^[_ ]+|[_ ]+\$');
      return str.replaceAll(pattern, '');
    }
  }
}

String _effectiveLocale(String? locale) => locale?.toLowerCase() ?? DefaultLocale.locale;

/// Function [recordMissingKey] simply records the given key as a missing
/// translation with unknown locale. It returns the same [key] provided,
/// unaffected.
///
/// ---
/// This function is visible only from the [i18_exception_core] package.
/// The [i18_exception] package uses a different function with the same name.
///
String recordMissingKey(Object? key) {
  if (Translations.recordMissingKeys)
    Translations.missingKeys.add(TranslatedString(locale: "", key: key));

  Translations.missingKeyCallback(key, "");

  return key.toString();
}

const _splitter1 = "\uFFFF";
const _splitter2 = "\uFFFE";
