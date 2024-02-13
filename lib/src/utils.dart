import 'translations_exception.dart';

/// Static function in Dart that takes `String locale` and normalizes it as a lowercase 2 letter [a-z] or else two lowercase 2 letter [a-z] separated by an underscore. Example: `en` or `en_us`.
String normalizeLocale(String locale) {
  locale = locale.trim().toLowerCase();
  while (locale.endsWith("_")) locale = locale.substring(0, locale.length - 1);
  if (locale.length == 2) return locale;
  if (locale.length == 5 && locale[2] == "_") return locale;
  throw TranslationsException("Invalid locale: '$locale'.");
}
