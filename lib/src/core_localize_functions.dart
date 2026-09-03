import 'package:i18n_extension_core/src/parse_string.dart';
import 'package:sprintf/sprintf.dart';

import 'gender.dart';
import 'translated_string.dart';
import 'translations.dart';
import 'translations_exception.dart';

/// The [localize] function localizes a "translatable string" to the given [locale].
/// You must provide the [key], which is usually the string you want to translate,
/// and also the [translations] object which holds the translations.
///
/// If [locale] is not provided (it's `null`), the method will use the default locale
/// in [DefaultLocale.locale] (which may be set with [DefaultLocale.set].
///
/// If both [locale] and [DefaultLocale.locale] are not provided, it defaults to 'en-US'.
///
/// ---
///
/// Fallback order:
///
/// - If the translation to the exact locale is found, this will be returned.
///   For example, for `zh-Hans-CN` it will try `zh-Hans-CN`.
///   For example, for `pt-BR` it will try `pt-BR`.
///
/// - Otherwise, it searches for translations to less specific locales,
///   until the locale is just the general language.
///   For example, for `zh-Hans-CN` it will try `zh-Hans`, then `zh`.
///   For example, for `pt-BR` it will try `pt`.
///
/// - Otherwise, it searches for translations to any locale with that
///   language. For example, for `zh-Hans-CN` it will try `zh-Hant-CN`.
///   For example, for `pt-BR` it will try `pt-PT` or `pt-MO`.
///
/// - Otherwise, it returns the key itself (which may be the translation for the default
///   locale).
///
/// Example 1:
/// If `pt-BR` is asked, and `pt-BR` is available, return for `pt-BR`.
///
/// Example 2:
/// If `pt-BR` is asked, `pt-BR` is not available, and `pt` is available,
/// return for `pt`.
///
/// Example 3:
/// If `pt-BR` is asked, but `pt-BR` and `pt` are not available, but `pt-PT` is,
/// return for `pt-PT`.
///
/// ---
/// Note this function is visible only from the [i18_exception_core] package.
/// The [i18_exception] package uses a different function with the same name.
///
String localize(
  Object? key,
  Translations translations, {
  String? locale,
}) {
  Map<String, String>? translatedStringPerLocale = translations[key];

  if (translatedStringPerLocale == null) {
    //
    if (Translations.recordMissingKeys) {
      Translations.missingKeys.add(
        TranslatedString(locale: translations.defaultLocaleStr, key: key),
      );
    }

    Translations.missingKeyCallback(key, translations.defaultLocaleStr);

    return key.toString();
  }
  //
  else {
    locale = _normalizedOrDefaultLocale(locale);

    if (locale == "null")
      throw TranslationsException(
          "Locale is the 4 letter string 'null', which is invalid.");

    // Find and return the translated string in the exact locale.
    String? translatedString = translatedStringPerLocale[locale];
    if (translatedString != null) return translatedString;

    // If the deprecated format (underscore lowercase) matches, throw an error.
    assert(() {
      var deprecatedLocale = locale!.replaceAll("-", "_").toLowerCase();
      translatedString = translatedStringPerLocale[deprecatedLocale];
      if (translatedString != null)
        throw TranslationsException('Locale "$deprecatedLocale" '
            'should be "$locale" (for translatable string "$key").');

      return true;
    }());

    // If the exact locale was not found, and it's a supported locale, record missing.
    _recordMissingTranslations(key, locale, translations);

    // ---

    List<String> parts = locale.split('-');

    // Try finding language tag that partially matches.
    // Example: Will match "pt-Latn-BR" with "pt-Latn" first, and if not, with "pt".
    for (int i = parts.length - 1; i > 0; i--) {
      String partialLocale = parts.sublist(0, i).join('-');
      String? translatedString = translatedStringPerLocale[partialLocale];
      if (translatedString != null) return translatedString;

      // If the partial locale was not found, and it's a supported locale, record missing.
      _recordMissingTranslations(key, partialLocale, translations);

      // If the deprecated format (underscore lowercase) matches, throw an error.
      assert(() {
        var deprecatedLocale = partialLocale.replaceAll("-", "_").toLowerCase();
        translatedString = translatedStringPerLocale[deprecatedLocale];
        if (translatedString != null)
          throw TranslationsException('Locale "$deprecatedLocale" '
              'should be "$partialLocale" (for translatable string "$key").');
        return true;
      }());
    }

    // Try finding partial language tag that partially matches.
    for (int i = parts.length; i > 0; i--) {
      String partialLocale = parts.sublist(0, i).join('-');

      // Example: Will match "pt-Latn-BR" with "pt-Latn-PT" first, and if not,
      // will match "pt-Latn" with "pt-Latn-PT", and if not,
      // will match "pt" with "pt-Latn-PT".
      for (MapEntry<String, String> entry in translatedStringPerLocale.entries) {
        var entryParts = entry.key.split('-');
        if (entryParts.length >= i) {
          var partialMatch = entryParts.sublist(0, i).join('-');
          if (partialLocale == partialMatch) return entry.value;

          // If the deprecated format (underscore lowercase) matches, throw an error.
          assert(() {
            var deprecatedLocale = partialLocale.replaceAll("-", "_").toLowerCase();
            if (deprecatedLocale == partialMatch) if (translatedString != null)
              throw TranslationsException('Locale "$deprecatedLocale" '
                  'should be "$partialMatch" (for translatable string "$key").');
            return true;
          }());
        }
      }
    }

    // If nothing is found, return the value or key,
    // that is the translation in the default locale.
    return translatedStringPerLocale[translations.defaultLocaleStr] ?? key.toString();
  }
}

void _recordMissingTranslations(
  Object? key,
  String locale,
  Translations translations,
) {
  if (Translations.recordMissingTranslations) {
    //
    bool shouldRecord = Translations.missingTranslationCallback(
      key: key,
      locale: locale,
      translations: translations,
      supportedLocales: Translations.supportedLocales,
    );

    if (shouldRecord)
      Translations.missingTranslations.add(TranslatedString(locale: locale, key: key));
  }
}

/// The [localizeArgs] function applies interpolations on [text]
/// with the given params, [p1], [p2], [p3], ..., [p15].
///
///
/// # 1. Interpolation with named placeholders
///
/// Your translations file may contain interpolations:
///
/// ```dart
/// static var _t = Translations.byText('en-US') +
///     {
///       'en-US': 'Hello {student} and {teacher}',
///       'pt-BR': 'Olá {student} e {teacher}',
///     };
///
/// String get i18n => localize(this, _t);
/// ```
///
/// Then use the [args] function:
///
/// ```dart
/// print('Hello {student} and {teacher}'.i18n
///   .args({'student': 'John', 'teacher': 'Mary'}));
/// ```
///
/// The above code will print `Hello John and Mary` if the locale is English,
/// or `Olá John e Mary` if it's Portuguese. This interpolation method allows for the
/// translated string to change the order of the parameters.
///
/// # 2. Interpolation with numbered placeholders
///
/// ```dart
/// static var _t = Translations.byText('en-US') +
///     {
///       'en-US': 'Hello {1} and {2}',
///       'pt-BR': 'Olá {1} e {2}',
///     };
///
/// String get i18n => localize(this, _t);
/// ```
///
/// Then use the [args] function:
///
/// ```dart
/// print('Hello {1} and {2}'.i18n
///   .args({1: 'John', 2: 'Mary'}));
/// ```
///
/// The above code will print `Hello John and Mary` if the locale is English,
/// or `Olá John e Mary` if it's Portuguese. This interpolation method allows for the
/// translated string to change the order of the parameters.
///
///
/// # 3. Interpolation with unnamed placeholders
///
/// ```dart
/// static var _t = Translations.byText('en-US') +
///     {
///       'en-US': 'Hello {} and {}',
///       'pt-BR': 'Olá {} e {}',
///     };
///
/// String get i18n => localize(this, _t);
/// ```
///
/// Then use the [args] function:
///
/// ```dart
/// print('Hello {} and {}'.i18n.args('John', 'Mary'));
/// print('Hello {} and {}'.i18n.args(['John', 'Mary'])); // Also works
/// ```
///
/// The above code will replace the `{}` in order,
/// and print `Hello John and Mary` if the locale is English,
/// or `Olá John e Mary` if it's Portuguese.
///
/// The problem with this interpolation method is that it doesn’t allow for the
/// translated string to change the order of the parameters.
///
String localizeArgs(Object? text, Object p1,
    [Object? p2,
    Object? p3,
    Object? p4,
    Object? p5,
    Object? p6,
    Object? p7,
    Object? p8,
    Object? p9,
    Object? p10,
    Object? p11,
    Object? p12,
    Object? p13,
    Object? p14,
    Object? p15]) {
  //
  return ParseString(
    text.toString(),
    p1: p1,
    p2: p2,
    p3: p3,
    p4: p4,
    p5: p5,
    p6: p6,
    p7: p7,
    p8: p8,
    p9: p9,
    p10: p10,
    p11: p11,
    p12: p12,
    p13: p13,
    p14: p14,
    p15: p15,
  ).apply();
}

/// The [localizeFill] function applies a `sprintf` on the [text]
/// with the given params, [p1], [p2], [p3], ..., [p15].
///
/// This is implemented with the `sprintf` package: https://pub.dev/packages/sprintf
///
/// Example:
///
/// ```dart
/// print('Hello %s and %s'.i18n.fill('John', 'Mary');
///
/// // Also works
/// print('Hello %s and %s'.i18n.fill(['John', 'Mary']);
/// ```
///
/// Possible format values:
///
/// * `%s` - String
/// * `%1$s` and `%2$s` - 1st String and 2nd String
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
String localizeFill(Object? text, Object p1,
    [Object? p2,
    Object? p3,
    Object? p4,
    Object? p5,
    Object? p6,
    Object? p7,
    Object? p8,
    Object? p9,
    Object? p10,
    Object? p11,
    Object? p12,
    Object? p13,
    Object? p14,
    Object? p15]) {
  List<Object?> params = [
    p1,
    p2,
    p3,
    p4,
    p5,
    p6,
    p7,
    p8,
    p9,
    p10,
    p11,
    p12,
    p13,
    p14,
    p15
  ].where((param) => param != null).expand((param) {
    if (param is Iterable) {
      return param;
    } else {
      return [param];
    }
  }).toList();
  return sprintf(text.toString(), params);
}

/// The [localizePlural] function returns the translated version for the plural [modifier].
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
///
/// If a [gender] is provided, the plural versions of that gender are tried first. Those
/// are declared by nesting the plural modifiers inside the gender modifier, like this:
///
/// ```
/// "There is a person"
///     .zero("There is nobody")
///     .many("There are %d people")
///     .male("There is a man".zero("There are no men").many("There are %d men"))
///     .female("There is a woman".zero("There are no women").many("There are %d women"))
/// ```
///
/// For 1 element, the gender version itself (like `.male("There is a man")`) is the
/// singular of that gender. When the gender has no applicable version, the plural
/// versions that don't depend on the gender are tried, and finally the unversioned
/// text. In the example above:
///
/// - `localizePlural(3, key, t, gender: Gender.female)` returns `There are 3 women`.
/// - `localizePlural(1, key, t, gender: Gender.male)` returns `There is a man`.
/// - `localizePlural(0, key, t, gender: Gender.neutral)` returns `There is nobody`.
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
  Gender? gender,
}) {
  int modifierInt = convertToIntegerModifier(modifier);

  locale = _normalizedOrDefaultLocale(locale);

  Map<String?, String> versions = localizeAllVersions(key, translations, locale: locale);

  /// The plural modifiers that apply to the number of elements, from the most
  /// specific to the least specific.
  List<String> modifiers = _pluralModifiers(modifierInt);

  String? text;

  if (gender != null) {
    String genderId = _genderModifier(gender);

    /// First, the plural versions of the gender, like `.male("...".zero("..."))`,
    /// which are encoded with the gender modifier prepended, like `m0`.
    for (String modifier in modifiers) {
      text ??= versions["$genderId$modifier"];
    }

    /// Then, for 1 element, the gender version, like `.male("There is a man")`,
    /// which is the singular of the gender.
    if (modifierInt == 1) text ??= versions[genderId];
  }

  /// Then, the plural versions that don't depend on the gender.
  for (String modifier in modifiers) {
    text ??= versions[modifier];
  }

  /// Otherwise, the unversioned.
  text ??= versions[null];

  // ---

  if (text == null)
    throw TranslationsException("No version found "
        "(modifier: $modifierInt, "
        "key: '$key', "
        "locale: '$locale'"
        ").");

  text = text.replaceAll("%d", modifierInt.toString());

  return text;
}

/// The plural modifiers that apply to the given number of elements, from the most
/// specific to the least specific. Note `F` is `zeroOne`, `R` is `oneOrMore`,
/// `C` is `twoThreeFour`, `M` is `many` and `T` is `ten`.
List<String> _pluralModifiers(int modifierInt) => switch (modifierInt) {
      /// For plural(0), the version 0, otherwise the version 0-1, otherwise many.
      0 => ["0", "F", "M"],

      /// For plural(1), the version 1, otherwise the version 0-1, otherwise 1-many.
      1 => ["1", "F", "R"],

      /// For plural(2), (3) and (4), the exact version, otherwise the version 2-3-4,
      /// otherwise many, otherwise 1-many.
      2 => ["2", "C", "M", "R"],
      3 => ["3", "C", "M", "R"],
      4 => ["4", "C", "M", "R"],

      /// For plural(10), the version ten, otherwise many, otherwise 1-many.
      10 => ["T", "M", "R"],

      /// For any other number, the exact version, otherwise many, otherwise 1-many.
      _ => [modifierInt.toString(), "M", "R"],
    };

/// The modifiers of `.male()`, `.female()` and `.neutral()`.
String _genderModifier(Gender gender) => switch (gender) {
      Gender.male => "m",
      Gender.female => "f",
      Gender.neutral => "n",
    };

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

/// The [localizeGender] function returns the translated version for the given [gender],
/// which is the version created with the `.male()`, `.female()` or `.neutral()` string
/// modifiers.
///
/// If the text has no version for the given [gender], it returns the unversioned text.
/// For example, `"Uma pessoa".male("Um homem").female("Uma mulher")` returns
/// `"Uma pessoa"` for [Gender.neutral]. This also means a text without versions is
/// returned as is, for any gender.
///
/// If [locale] is not provided (it's `null`), the method will use the default locale
/// in [DefaultLocale.locale] (which may be set with [DefaultLocale.set].
///
/// If both [locale] and [DefaultLocale.locale] are not provided, it defaults to 'en-US'.
///
/// ---
/// This function is visible only from the [i18_exception_core] package.
/// The [i18_exception] package uses a different function with the same name.
///
String localizeGender(
  Gender gender,
  Object? key,
  Translations translations, {
  String? locale,
}) {
  locale = _normalizedOrDefaultLocale(locale);

  Map<String?, String> versions = localizeAllVersions(key, translations, locale: locale);

  /// Returns the version for the gender, otherwise the unversioned.
  String? text = versions[_genderModifier(gender)] ?? versions[null];

  if (text == null)
    throw TranslationsException("No version found "
        "(gender: $gender, "
        "key: '$key', "
        "locale: '$locale'"
        ").");

  return text;
}

/// Use the [localizeVersion] method to localize a "translatable string" to the given [locale].
/// You must provide the [key] (which is usually the string you want to translate),
/// a [modifier], and the [translations] object which holds the translations.
///
/// You may use an object of any type as the [modifier], but it will do a `toString()`
/// in it and use resulting String. So, make sure your object has a suitable
/// string representation.
///
/// Note the plural and gender modifiers are encoded as `0`, `1`, `2`, ..., `M` and
/// `m`, `f`, `n` (the same keys returned by [localizeAllVersions]), so
/// `localizeVersion("m", ...)` returns the male version. But to select those, use
/// [localizePlural] and [localizeGender], which also apply the fallback rules.
///
/// If [locale] is not provided (it's `null`), the method will use the default locale
/// in [DefaultLocale.locale] (which may be set with [DefaultLocale.set].
///
/// If both [locale] and [DefaultLocale.locale] are not provided, it defaults to 'en-US'.
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
  locale = _normalizedOrDefaultLocale(locale);

  String total = localize(key, translations, locale: locale);

  if (!total.startsWith(_splitter1))
    throw TranslationsException("This text has no version for modifier '$modifier' "
        "(modifier: $modifier, "
        "key: '$key', "
        "locale: '${_normalizedOrDefaultLocale(locale)}').");

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
      "locale: '$locale'"
      ").");
}

/// Use the [localizeAllVersions] method to return a [Map] of all translated strings,
/// where modifiers are the keys. In special, the unversioned text is indexed with a `null` key.
///
/// If [locale] is not provided (it's `null`), the method will use the default locale
/// in [DefaultLocale.locale] (which may be set with [DefaultLocale.set].
///
/// If both [locale] and [DefaultLocale.locale] are not provided, it defaults to 'en-US'.
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
  locale = _normalizedOrDefaultLocale(locale);

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
          "locale: '$locale"
          "').");

    all[version] = text;
  }

  return all;
}

/// To set the default locale, use this class:
///
/// ```dart
/// DefaultLocale.set("en-US");
/// DefaultLocale.set("es-ES");
/// DefaultLocale.set("pt-BR");
///
/// If you remove the default locale, it's considered English of the Unites States.
/// DefaultLocale.set(null); // Means "en-US".
/// DefaultLocale.set(""); // Means "en-US".
/// ```
///
/// To get the locale as a lowercase string: `DefaultLocale.locale;`
///
/// When you translate strings using [localize], [localizeArgs], [localizeFill],
/// [localizePlural], [localizeVersion] or [localizeAllVersions], you can pass them the
/// locale as a parameter. When you don't, the default locale defined here will be used.
/// If you don't define a default locale, it will be "en-US".
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

  /// Returns the default locale, as a syntactically valid IETF BCP47 language tag
  /// (which is compatible with the Unicode Locale Identifier (ULI) syntax).
  /// Some examples of such identifiers: "en", "en-US", "es-419", "hi-Deva-IN" and
  /// "zh-Hans-CN". See https://www.ietf.org/rfc/bcp/bcp47.html and
  /// http://www.unicode.org/reports/tr35/ for details.
  static String get locale => _locale ?? 'en-US';

  /// Use the given [locale] to set the value of [DefaultLocale.locale].
  ///
  /// It will use [normalizeLocale] to normalize and interpret the given [locale]
  /// as a BCP47 language tag (which is compatible with the Unicode Locale Identifier
  /// (ULI) syntax). See https://www.ietf.org/rfc/bcp/bcp47.html and
  /// http://www.unicode.org/reports/tr35/ for details.
  ///
  /// Note: If you remove the default locale with `DefaultLocale.set(null)`,
  /// the default will be English of the Unites States.
  ///
  static void set(String? locale) => _locale = normalizeLocale(locale);

  /// Normalizes a BCP47 language tag (which is compatible with the Unicode Locale
  /// Identifier (ULI) syntax), by adjusting the case of each component.
  ///
  /// This function takes a locale string and normalizes its subtags:
  /// - Removes spaces and converts underscores to hyphens.
  /// - The language subtag is converted to lowercase.
  /// - The script subtag (if present) is converted to title case
  ///   (first letter uppercase, rest lowercase).
  /// - The region subtag (if present) is converted to uppercase.
  ///
  /// If the input string is null or empty, an empty string is returned.
  ///
  /// Example:
  /// ```dart
  /// String? localeStr = 'eN-lAtN-us';
  /// String normalizedLocale = normalizeLocale(localeStr);
  /// print(normalizedLocale); // Output: en-Latn-US
  /// ```
  ///
  static String? normalizeLocale(String? localeStr) {
    //
    if (localeStr == null) return null;
    localeStr = localeStr.replaceAll(' ', '').replaceAll('_', '-');
    if (localeStr.isEmpty) return null;

    // Split the locale string by hyphens
    List<String> parts = localeStr.split('-').where((part) => part.isNotEmpty).toList();
    if (parts.isEmpty) return '';

    // Normalize each part of the locale identifier
    for (int i = 0; i < parts.length; i++) {
      if (i == 0) {
        // Language subtag: always lowercase
        parts[i] = parts[i].toLowerCase();
      } else if (i == 1 && parts[i].length == 4) {
        // Script subtag: title case (first letter uppercase, rest lowercase)
        parts[i] = parts[i][0].toUpperCase() + parts[i].substring(1).toLowerCase();
      } else if (i == 1 || i == 2) {
        // Region subtag: always uppercase (usually second or third position)
        parts[i] = parts[i].toUpperCase();
      }
    }

    // Join the parts back together with hyphens.
    return parts.join('-');
  }
}

String _normalizedOrDefaultLocale(String? locale) =>
    DefaultLocale.normalizeLocale(locale) ?? DefaultLocale.locale;

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
