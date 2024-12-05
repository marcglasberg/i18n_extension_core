import 'package:i18n_extension_core/i18n_extension_core.dart';

/// Checks if the given locale identifier is a valid BCP47 locale string.
///
/// A valid BCP47 locale identifier consists of a language subtag (mandatory),
/// and optional script, region, variant, extension, and private use subtags.
///
/// - [locale]: The locale identifier string to be validated.
///
/// Returns `true` if the [locale] is a valid BCP47 locale identifier, otherwise `false`.
bool isValidLocale(String locale) {
  // Split the locale by hyphen
  List<String> parts = locale.split('-');
  if (parts.isEmpty) {
    return false;
  }

  // Validate language subtag (2-3 letters)
  String language = parts[0];
  if (language.length < 2 || language.length > 3 || !_isAlpha(language)) {
    return false;
  }

  // Initialize indices for optional subtags
  int index = 1;

  // Validate optional script subtag (4 letters, title case)
  if (index < parts.length &&
      parts[index].length == 4 &&
      _isTitleCaseScript(parts[index])) {
    index++;
  }

  // Validate optional region subtag (2 letters or 3 digits)
  if (index < parts.length &&
      (parts[index].length == 2 && _isUpper(parts[index]) ||
          parts[index].length == 3 && _isDigit(parts[index]))) {
    index++;
  }

  // Validate optional variant subtags (5-8 alphanumeric characters)
  while (index < parts.length &&
      parts[index].length >= 5 &&
      parts[index].length <= 8 &&
      _isAlphaNum(parts[index])) {
    index++;
  }

  // Validate optional extensions starting with a singleton (excluding 'x')
  while (index < parts.length &&
      parts[index].length == 1 &&
      parts[index] != 'x' &&
      _isAlphaNum(parts[index])) {
    index++;
    if (index >= parts.length) {
      return false;
    }
    while (index < parts.length &&
        parts[index].length >= 2 &&
        parts[index].length <= 8 &&
        _isAlphaNum(parts[index])) {
      index++;
    }
  }

  // Validate optional private use subtag starting with 'x'
  if (index < parts.length && parts[index] == 'x') {
    index++;
    if (index >= parts.length) {
      return false;
    }
    while (index < parts.length &&
        (parts[index].isNotEmpty) &&
        parts[index].length <= 8 &&
        _isAlphaNum(parts[index])) {
      index++;
    }
  }

  // Ensure no remaining unexpected parts
  return index == parts.length;
}

// Helper functions
bool _isAlpha(String str) =>
    str.codeUnits.every((c) => (c >= 65 && c <= 90) || (c >= 97 && c <= 122));

bool _isUpper(String str) => str.codeUnits.every((c) => c >= 65 && c <= 90);

bool _isDigit(String str) => str.codeUnits.every((c) => c >= 48 && c <= 57);

bool _isAlphaNum(String str) => str.codeUnits
    .every((c) => (c >= 65 && c <= 90) || (c >= 97 && c <= 122) || (c >= 48 && c <= 57));

bool _isTitleCaseScript(String str) =>
    str.length == 4 && _isUpper(str[0]) && _isAlpha(str.substring(1));

/// This function throws a [TranslationsException] if the locale is not a valid BCP47
/// locale identifier. If it's valid, it returns the locale, unchanged.
///
/// The most common language identifiers are generally two ('en') or five ('en-US)'
/// letters. They follow a standard format, which can vary in length depending on the
/// specificity of the locale being represented. The most commonly seen structures are:
///
/// * Language Code: A two- or three-letter code defined by ISO 639 that represents a
/// language. Examples include en for English, es for Spanish, and zh for Chinese.
///
/// * Country/Region Code: Optionally, a language code can be followed by a country or
/// region code to specify a regional dialect or variation. This code is typically two
/// letters, defined by ISO 3166-1 alpha-2, but can also be three letters as per
/// ISO 3166-1 alpha-3. Examples include en-US (English as used in the United States)
/// and pt-BR (Portuguese as used in Brazil).
///
/// However, locale identifiers can be more complex and include additional information to
/// specify script, variant, and extensions. The general structure can be represented as:
///
/// `language[-script][-region][-variant][-extension]`
///
/// * Script Code: A four-letter code defined by ISO 15924 that represents a writing system.
/// For example, sr-Cyrl specifies Serbian language written in Cyrillic script, while sr-Latn
/// specifies Serbian in Latin script.
///
/// * Variant: Additional variations of a locale where there is a need to distinguish between
/// orthographies or conventions beyond language, script, and region.
///
/// * Extensions: For specifying additional behaviors (such as currency, calendar type, number
/// system) that might be preferred in the user interface.
///
/// An example of a more complex locale identifier could be `zh-Hant-HK` (Chinese, Traditional
/// script, as used in Hong Kong SAR) or de-DE-1996 (German as used in Germany, orthography
/// of 1996).
///
/// So, locales can vary in length and complexity beyond just two or five letters,
/// reflecting the diversity of language, script, region, and cultural preferences.
///
String checkLocale(String locale) {
  //
  if (locale.length > 64) throw TranslationsException('Locale is too large.');

  if (!isValidLocale(locale)) {
    String normalized = DefaultLocale.normalizeLocale(locale) ?? '';
    if (isValidLocale(normalized))
      throw TranslationsException(
          'Locale "$locale" is not a valid BCP47 locale identifier. '
          'Try "$normalized".');
    else
      throw TranslationsException(
          'Locale "$locale" is not a valid BCP47 locale identifier.');
  }

  return locale;
}

/// Same as [isValidLocale], but implemented with a regular expression.
bool isValidLocale_Regex(String locale) {
  final localeRegex = RegExp(
    r'^[a-zA-Z]{2,3}' // Language subtag: 2 or 3 letters
    r'(?:-[A-Z][a-z]{3})?' // Optional script subtag: 4 letters (title case)
    r'(?:-[A-Z]{2}|-[0-9]{3})?' // Optional region subtag: 2 letters or 3 digits
    r'(?:-[a-zA-Z0-9]{5,8})*' // Optional variant subtag: 5 to 8 alphanumeric characters
    r'(?:-[a-wy-zA-WY-Z0-9](?:-[a-zA-Z0-9]{2,8})+)*' // Optional extensions starting with a singleton (excluding 'x')
    r'(?:-x(?:-[a-zA-Z0-9]{1,8})+)?\$', // Optional private use subtag starting with 'x'
  );
  return localeRegex.hasMatch(locale);
}
