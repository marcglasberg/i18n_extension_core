import 'translations_exception.dart';

/// This function:
/// * Removes all spaces (and similar chars that are generally removed with the trim method).
/// * Turns all hyphens into underscores.
/// * Turns double (or more underscores) into a single underscore.
/// * Trims leading and trailing underscores.
/// * Turns the locale into lowercase.
/// * Throws a [TranslationsException] if the locale has more than 20 characters or fewer than 2.
/// ---
///
/// Locale identifiers are generally not limited to just two ('en') or five ('en_US)' letters.
/// They follow a standard format, which can vary in length depending on the specificity of the
/// locale being represented. The most commonly seen structures are:
///
/// * Language Code: A two- or three-letter code defined by ISO 639 that represents a language.
/// Examples include en for English, es for Spanish, and zh for Chinese.
///
/// * Country/Region Code: Optionally, a language code can be followed by a country or region code
/// to specify a regional dialect or variation. This code is typically two letters, defined by
/// ISO 3166-1 alpha-2, but can also be three letters as per ISO 3166-1 alpha-3. Examples include
/// en-US (English as used in the United States) and pt-BR (Portuguese as used in Brazil).
///
/// However, locale identifiers can be more complex and include additional information to specify
/// script, variant, and extensions. The general structure can be represented as:
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
String normalizeLocale(String locale) {
  //
  // Note: This implementation is complex because it's very fast:
  // - No Regex
  // - No changing the string after it's created (only to make it lowercase).

  if (locale.length > 20)
    throw TranslationsException('Locale exceeds the maximum allowed length of 20 characters.');

  StringBuffer normalized = StringBuffer();
  bool lastWasUnderscore = false;
  bool isFirstValidCharFound = false;

  for (int i = 0; i < locale.length; i++) {
    String char = locale[i];

    // Skip any spaces etc.
    if (char.codeUnitAt(0) <= '\u0020'.codeUnitAt(0)) continue;

    // Skip leading hyphens and underscores.
    if (!isFirstValidCharFound) {
      if (char != '-' && char != '_') {
        isFirstValidCharFound = true;
      } else {
        continue;
      }
    }

    if (char == '-' || char == '_') {
      lastWasUnderscore = true;
    } else {
      // If lastWasUnderscore is true, append an underscore before the current character.
      if (lastWasUnderscore) {
        normalized.write('_');
        lastWasUnderscore = false; // Reset the flag as we've handled the underscore.
      }
      normalized.write(char);
    }
  }

  // Convert to string and convert to lower case in one step.
  String result = normalized.toString();

  if (locale.length < 2) throw TranslationsException('Locale needs at least two characters.');

  return result.toLowerCase();
}
