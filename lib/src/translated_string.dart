import 'translations.dart';

/// This class represents missing translations.
/// They are recorded in [Translations.missingTranslations] and [Translations.recordMissingKeys].
///
/// This class is visible from both [i18_exception] and [i18_exception_core] packages.
///
class TranslatedString {
  //
  final String locale;
  final Object? key;

  TranslatedString({
    required this.locale,
    required this.key,
  });

  /// First: The TranslatedString in the default locale.
  /// Then: The other TranslatedStrings with the same language as the default locale.
  /// Then: The other TranslatedStrings, in alphabetic order.
  static int Function(TranslatedString, TranslatedString) comparable(
    String defaultLocaleStr,
  ) =>
      (ts1, ts2) {
        if (ts1.locale == defaultLocaleStr) return -1;
        if (ts2.locale == defaultLocaleStr) return 1;

        var defaultLanguageStr = defaultLocaleStr.substring(0, 2);

        if (ts1.locale.startsWith(defaultLanguageStr) && !ts2.locale.startsWith(defaultLocaleStr))
          return -1;

        if (ts2.locale.startsWith(defaultLanguageStr) && !ts1.locale.startsWith(defaultLocaleStr))
          return 1;

        return ts1.locale.compareTo(ts2.locale);
      };

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TranslatedString &&
          runtimeType == other.runtimeType &&
          locale == other.locale &&
          key == other.key;

  @override
  int get hashCode => locale.hashCode ^ key.hashCode;
}
