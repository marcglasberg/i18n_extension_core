import 'translated_string.dart';
import 'translations_by_locale.dart';
import 'translations_by_string.dart';

/// You may use this class to provide the translated strings.
///
/// The options are:
/// * [Translations.new] default constructor.
/// * [ConstTranslations.new] const default constructor.
/// * [Translations.byLocale].
///
/// ---
///
/// [Translations.new] example:
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
///
/// [ConstTranslations.new] example:
///
/// ```
/// static const t = Translations.from(
///    "en_us",
///    {
///      "i18n Demo": {
///        "en_us": "i18n Demo",
///        "pt_br": "Demonstração i18n",
///      }
///    },
/// );
/// ```
/// ---
///
/// [Translations.byLocale] example:
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
///
/// IMPORTANT: You may create your own translation classes, as long as they implement this interface.
///
/// This class is visible from both [i18_exception] and [i18_exception_core] packages.
///
abstract class Translations<T> {
  //

  /// The default [Translations.new] constructor allows you to provide all locale translations
  /// of the first translatable string, then all locale translations of the second translatable
  /// string, and so on; and then you add translations with the [+] operator. For example:
  ///
  /// ```
  /// static final t = Translations("en_us") +
  ///       const {
  ///         "en_us": "i18n Demo",
  ///         "pt_br": "Demonstração i18n",
  ///       };
  /// ```
  ///
  /// See also:
  /// - [ConstTranslations.new], which responds better to hot reload.
  /// - [Translations.byLocale], where you provide all translations together for each locale.
  ///
  factory Translations(String defaultLocaleStr) => TranslationsByString(defaultLocaleStr);

  /// The [Translations.byLocale] constructor allows you to provide, for each locale,
  /// all translations together:
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
  /// See also:
  /// - [Translations.new], which uses the [+] operator to add translations.
  /// - [ConstTranslations.new], which responds better to hot reload.
  ///
  factory Translations.byLocale(String defaultLocaleStr) => TranslationsByLocale(defaultLocaleStr);

  /// All missing keys and translations will be put here.
  /// This may be used in tests to make sure no translations are missing.
  static Set<TranslatedString> missingKeys = {};
  static Set<TranslatedString> missingTranslations = {};

  static bool recordMissingKeys = true;
  static bool recordMissingTranslations = true;

  /// Replace this to log missing keys.
  static void Function(String, String) missingKeyCallback =
      (key, locale) => print("➜ Translation key in '$locale' is missing: \"$key\".");

  /// Replace this to log missing translations.
  static void Function(String, String) missingTranslationCallback =
      (key, locale) => print("➜ There are no translations in '$locale' for \"$key\".");

  /// Generative constructor.
  const Translations.gen({
    required this.translations,
    required this.defaultLocaleStr,
  });

  final Map<String, Map<String, String>> translations;

  final String defaultLocaleStr;

  String get defaultLanguageStr => TranslationsByString.trim(defaultLocaleStr).substring(0, 2);

  int get length;

  /// Add a [Map] of translations to a [Translations] object.
  Translations operator +(T translations);

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
  Translations<T> operator *(Translations<T> translations);

  Map<String, String>? operator [](String key) => translations[key];
}

/// The [ConstTranslations] constructor allows you to define the translations
/// as a const object, all at once. This not only is a little bit more
/// efficient, but it's also better for "hot reload", since a const variable
/// will respond to hot reloads, while `final` variables will not.
///
/// Here, just like with [Translations.new], you provide all locale translations
/// of the first single "translatable string", then all locale translations of
/// the second one, and so on.
///
/// ```
/// static const t = Translations.from(
///    "en_us",
///    {
///      "i18n Demo": {
///        "en_us": "i18n Demo",
///        "pt_br": "Demonstração i18n",
///      }
///    },
/// );
/// ```
///
/// See also:
/// - [Translations.new], which uses the [+] operator to add translations.
/// - [ConstTranslations.byLocale], which organizes translations differently.
///
/// ---
/// This class is visible from both [i18_exception] and [i18_exception_core] packages.
///
class ConstTranslations extends TranslationsByString {
  //

  /// The [ConstTranslations] constructor allows you to define the translations
  /// as a const object, all at once. This not only is a little bit more
  /// efficient, but it's also better for "hot reload", since a const variable
  /// will respond to hot reloads, while `final` variables will not.
  ///
  /// Here, just like with [Translations.new], you provide all locale translations
  /// of the first single "translatable string", then all locale translations of
  /// the second one, and so on.
  ///
  /// ```
  /// static const t = Translations.from(
  ///    "en_us",
  ///    {
  ///      "i18n Demo": {
  ///        "en_us": "i18n Demo",
  ///        "pt_br": "Demonstração i18n",
  ///      }
  ///    },
  /// );
  /// ```
  ///
  /// See also:
  /// - [Translations.new], which uses the [+] operator to add translations.
  /// - [Translations.byLocale], where you provide all translations together for each locale.
  ///
  const ConstTranslations(
    String defaultLocaleStr,
    Map<String, Map<String, String>> translations,
  ) : super.gen(
          defaultLocaleStr,
          translations,
        );

  /// You can't add a <Map> to a `ConstTranslations`.
  /// Which means operator `+` is not supported for `ConstTranslations`.
  @override
  Translations<Map<String, String>> operator +(Map<String, String> translations) {
    throw UnsupportedError("Operator `+` is not supported for class `ConstTranslations`.");
  }

  /// You can't add a `Translation` to a `ConstTranslations`.
  /// Which means operator `*` is not supported for `ConstTranslations`:
  ///
  /// ```dart
  /// // Doesn't work:
  /// var t = const ConstTranslations("en_us", {...}}) + Translations("en_us");
  /// ```
  ///
  /// However, you can add a `ConstTranslations` to a regular `Translations`:
  ///
  /// ```dart
  /// // Works:
  /// var t = Translations("en_us") + const ConstTranslations("en_us", {...}});
  /// ```
  @override
  Translations<Map<String, String>> operator *(Translations<Map<String, String>> translations) {
    throw UnsupportedError("Operator `*` is not supported for class `ConstTranslations`.");
  }
}
