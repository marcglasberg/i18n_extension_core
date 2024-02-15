import 'package:i18n_extension_core/src/translations_by_identifier.dart';
import 'package:i18n_extension_core/src/typedefs.dart';

import 'translated_string.dart';
import 'translations_by_locale.dart';
import 'translations_by_text.dart';
import 'utils.dart' as utils;

/// A [Translations] object is where you provide the translated strings.
/// Given a "translation-key", it returns a map of translations: { locale : translated strings }.
/// The translation-key may be the string itself that you want to translate, or an identifier.
///
/// Glossary:
/// * [translatable string]: The string you want to translate.
/// * [translation-key]: The key that represents the translatable string (may be the string itself).
/// * [locale]: The language and country code, like "en_us" or "pt_br".
/// * [translated string]: The translated strings for a given [translation-key].
/// * [identifier]: An immutable variable that you may use as a translation key, instead of the string itself.
///
/// ---
///
/// You may use this class to
///
/// The options are:
/// * [Translations.byText]
/// * [Translations.byLocale]
/// * [Translations.byId]
/// * [ConstTranslations.new] which can be made const
/// ---
///
/// [Translations.byText] example:
///
/// ```
/// var t = Translations.byText("en_us") +
///       const {
///         "en_us": "i18n Demo",
///         "pt_br": "Demonstração i18n",
///       };
/// ```
/// ---
///
/// [Translations.byLocale] example:
///
/// ```
/// var t = Translations.byLocale("en_us") +
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
/// ---
///
/// [Translations.byId] example:
///
/// ```
/// var t = Translations.byId<MyColors>("en_us", {
///   MyColors.red: {
///       "en_us": "red",
///       "pt_br": "vermelho",
///   },
///   MyColors.green: {
///       "en_us": "green",
///       "pt_br": "Verde",
///   });
/// ```
/// ---
///
/// [ConstTranslations.new] example:
///
/// ```
/// const t = ConstTranslations(
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
/// IMPORTANT: You may create your own translation classes, as long as they implement this interface.
///
/// This class is visible from both [i18_exception] and [i18_exception_core] packages.
///
abstract class Translations< //
    TKEY, //
    TRANbyLOCALE extends Map<StringLocale, StringTranslated>, //
    TRANbyTKEY extends Map<TKEY, StringTranslated>, //
    ADDEDMAP> //
{
  //

  /// The [Translations.byText] constructor allows you to provide all locale translations
  /// of the first translatable string, then all locale translations of the second translatable
  /// string, and so on; and then you add translations with the [+] operator. For example:
  ///
  /// ```
  /// static final t = Translations.byText("en_us") +
  ///       const {
  ///         "en_us": "i18n Demo",
  ///         "pt_br": "Demonstração i18n",
  ///       };
  /// ```
  ///
  /// See also:
  /// - [Translations.byId], which lets you provide translations for identifiers.
  /// - [Translations.byLocale], where you provide all translations together for each locale.
  /// - [ConstTranslations.new], which responds better to hot reload.
  ///
  static TranslationsByText byText(StringLocale defaultLocaleStr) => TranslationsByText<
      String,
      Map<StringLocale, StringTranslated>,
      Map<String, StringTranslated>,
      Map<StringLocale, StringTranslated>>(defaultLocaleStr);

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
  ///
  /// See also:
  /// - [Translations.byText], which lets you provide translations for strings.
  /// - [Translations.byId], which lets you provide translations for identifiers.
  /// - [ConstTranslations.new], which responds better to hot reload.
  ///
  static TranslationsByLocale byLocale(StringLocale defaultLocaleStr) => TranslationsByLocale<
      String,
      Map<StringLocale, StringTranslated>,
      Map<String, StringTranslated>,
      Map<StringLocale, Map<StringLocale, StringTranslated>>>(defaultLocaleStr);

  /// The [byId] constructor allows you to provide all locale translations related
  /// to a first identifier, then for a second identifier, and so on. Identifiers may be
  /// any immutable object, such as a `String`, `int`, `enum`, or any object you create.
  ///
  /// You should pass the generic type of the identifier. For example, to
  /// create translations for an enum named `MyColors`: `Translations.byId<MyColors>`:
  ///
  /// ```dart
  /// enum MyColors { red, green }
  ///
  /// var t = Translations.byId<MyColors>("en_us", {
  ///              MyColors.red: {
  ///                  "en_us": "red",
  ///                  "pt_br": "vermelho",
  ///              },
  ///              MyColors.green: {
  ///                  "en_us": "green",
  ///                  "pt_br": "Verde",
  ///              });
  /// ```
  ///
  /// Note you may also add translations with the [+] operator. For example:
  ///
  /// ```
  /// var t = Translations.byId<MyColors>("en_us", {
  ///              MyColors.red: {
  ///                  "en_us": "red",
  ///                  "pt_br": "vermelho",
  ///              }) +
  ///              {
  ///                  MyColors.green: {
  ///                     "en_us": "green",
  ///                     "pt_br": "Verde",
  ///                  }
  ///              };
  /// ```
  ///
  /// If you want your identifiers to be of ANY type, you can use type `Object`
  /// or even `Object?` (or `dynamic`). For example:
  ///
  /// ```
  /// var t = Translations.byId<Object?>("en_us", {
  ///              MyColors.red: {
  ///                  "en_us": "red",
  ///                  "pt_br": "vermelho",
  ///              },
  ///              123: {
  ///                  "en_us": "One two three",
  ///                  "pt_br": "Um dois três",
  ///              },
  ///              null: {
  ///                  "en_us": "This is empty",
  ///                  "pt_br": "Isso está vazio",
  ///              });
  /// ```
  ///
  /// IMPORTANT: You can create your own class and use its objects as identifiers, but it
  /// must implement the `==` and `hashCode` methods. Otherwise, it won't be possible to
  /// find it as one of the translation keys.
  ///
  /// See also:
  /// - [Translations.byText], which lets you provide translations for strings.
  /// - [Translations.byLocale], where you provide all translations together for each locale.
  /// - [ConstTranslations.new], which responds better to hot reload.
  ///
  static TranslationsByIdentifier<
      TKEY, // The type of the translation-key.
      Map<StringLocale, StringTranslated>, // Translation strings by locale.
      Map<TKEY, StringTranslated>, // Translation strings by translation-key.
      Map<TKEY, Map<StringLocale, StringTranslated>> // Shape of the added map for operator +.
      > byId<TKEY>(StringLocale defaultLocaleStr,
          Map<TKEY, Map<StringLocale, StringTranslated>> translationByLocale_ByTranslationKey) =>
      TranslationsByIdentifier<
          TKEY, // The type of the translation-key.
          Map<StringLocale, StringTranslated>, // Translation strings by locale.
          Map<TKEY, StringTranslated>, // Translation strings by translation-key.
          Map<TKEY, Map<StringLocale, StringTranslated>> // Shape of the added map for operator +.
          >(
        defaultLocaleStr,
        translationByLocale_ByTranslationKey,
      );

  /// All missing keys and translations will be put here.
  /// This may be used in tests to make sure no translations are missing.
  static Set<TranslatedString> missingKeys = {};
  static Set<TranslatedString> missingTranslations = {};

  static bool recordMissingKeys = true;
  static bool recordMissingTranslations = true;

  /// Replace this to log missing keys.
  static void Function(Object? key, StringLocale locale) missingKeyCallback =
      (key, locale) => print("➜ Translation key in '$locale' is missing: \"$key\".");

  /// Replace this to log missing translations.
  static void Function(Object? key, StringLocale locale) missingTranslationCallback =
      (key, locale) => print("➜ There are no translations in '$locale' for \"$key\".");

  /// Generative constructor.
  const Translations.gen({
    required this.translationByLocale_ByTranslationKey,
    required this.defaultLocaleStr,
  });

  /// Something like:
  ///       'Hi': { // TKEY
  ///         'en_us': 'Hi', // LOCALE : TRAN
  ///         'pt_br': 'Olá', // LOCALE : TRAN
  ///       },
  ///       'Goodbye': { // TKEY
  ///         'en_us': 'Goodbye', // LOCALE : TRAN
  ///         'pt_br': 'Adeus', // LOCALE : TRAN
  ///       }
  final Map<TKEY, TRANbyLOCALE> translationByLocale_ByTranslationKey;

  final StringLocale defaultLocaleStr;

  /// To extract the language code from a locale identifier, we typically parse the identifier
  /// and take the first part before any underscore. The language code is always at the
  /// beginning of the locale identifier and is separated from any subsequent parts
  /// (like country/region or script) by an underscore.
  String get defaultLanguageStr => utils.normalizeLocale(defaultLocaleStr).split('_')[0];

  /// Returns the number of translation-keys.
  /// For example, if you have translations for "Hi" and "Goodbye", this will return 2.
  int get length;

  /// Add a [addedMap] (of type [Map]) to a [Translations] object.
  Translations<TKEY, TRANbyLOCALE, TRANbyTKEY, ADDEDMAP> operator +(ADDEDMAP addedMap);

  /// Add a [translationsObj] object to another [Translations] object.
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
  Translations<TKEY, TRANbyLOCALE, TRANbyTKEY, ADDEDMAP> operator *(
      Translations<TKEY, TRANbyLOCALE, TRANbyTKEY, dynamic> translationsObj);

  /// Given a translations [key], returns a [Map] of translations for that key.
  /// The map will have the locale as the key, and the translation as the value.
  TRANbyLOCALE? operator [](TKEY key) => translationByLocale_ByTranslationKey[key];
}

/// The [ConstTranslations] class allows you to define the translations
/// as a const object, all at once. This not only is a little bit more
/// efficient, but it's also better for "hot reload", since a const variable
/// will respond to hot reloads, while `final` variables will not.
///
/// Here you provide all locale translations of the first "translatable string",
/// then all locale translations of the second one, and so on.
///
/// ```
/// static const t = ConstTranslations("en_us",
///    {
///      "i18n Demo": {
///        "en_us": "i18n Demo",
///        "pt_br": "Demonstração i18n",
///      }
///    },
/// );
/// ```
///
/// IMPORTANT: Make sure the [defaultLocaleStr] you provide is correct (no spaces, lowercase etc).
/// Since this constructor is const, we can't normalize the locale string for you. If you are
/// not sure, call [ConstTranslations.normalizeLocale] before using it.
///
/// ---
/// This class is visible from both [i18_exception] and [i18_exception_core] packages.
///
class ConstTranslations< //
        TKEY extends String, //
        TRANbyLOCALE extends Map<StringLocale, StringTranslated>, //
        TRANbyTKEY extends Map<TKEY, StringTranslated>, //
        ADDEDMAP extends TRANbyLOCALE> //
    extends TranslationsByText<TKEY, TRANbyLOCALE, TRANbyTKEY, ADDEDMAP> {
  //

  /// The [ConstTranslations] constructor allows you to define the translations
  /// as a const object, all at once. This not only is a little bit more
  /// efficient, but it's also better for "hot reload", since a const variable
  /// will respond to hot reloads, while `final` variables will not.
  ///
  /// Here you provide all locale translations of the first "translatable string",
  /// then all locale translations of the second one, and so on.
  ///
  /// ```
  /// static const t = ConstTranslations("en_us",
  ///    {
  ///      "i18n Demo": {
  ///        "en_us": "i18n Demo",
  ///        "pt_br": "Demonstração i18n",
  ///      }
  ///    },
  /// );
  /// ```
  ///
  /// IMPORTANT: Make sure the [defaultLocaleStr] you provide is correct (no spaces, lowercase etc).
  /// Since this constructor is const, we can't normalize the locale string for you. If you are
  /// not sure, call [ConstTranslations.normalizeLocale] before using it.
  ///
  /// See also:
  /// - [Translations.byText], which lets you provide translations for strings.
  /// - [Translations.byId], which lets you provide translations for identifiers.
  /// - [Translations.byLocale], where you provide all translations together for each locale.
  /// - [ConstTranslations.new], which organizes translations differently.
  ///
  const ConstTranslations(
    StringLocale defaultLocaleStr,
    Map<TKEY, TRANbyLOCALE> translationByLocale_ByTranslationKey,
  ) : super.gen(
          defaultLocaleStr,
          translationByLocale_ByTranslationKey,
        );

  /// * Removes all spaces (and similar chars that are generally removed with the trim method).
  /// * Turns all hyphens into underscores.
  /// * Turns double (or more underscores) into a single underscore.
  /// * Trims leading and trailing underscores.
  /// * Turns the locale into lowercase.
  /// * Throws a [TranslationsException] if the locale has more than 20 characters or fewer than 2.
  /// Examples:
  /// * ` en_us_ ` becomes `en_us`.
  /// * ` en__us_ ` becomes `en_us`.
  /// * ` en-us ` becomes `en_us`.
  /// * `en-` becomes `en`.
  ///
  static String normalizeLocale(String locale) => utils.normalizeLocale(locale);

  /// You can't add a <Map> to a `ConstTranslations`.
  /// Which means operator `+` is not supported for `ConstTranslations`.
  @override
  Translations<TKEY, TRANbyLOCALE, TRANbyTKEY, ADDEDMAP> operator +(ADDEDMAP addedMap) {
    throw UnsupportedError("Operator `+` is not supported for class `ConstTranslations`.");
  }

  /// You can't add a `Translation` to a `ConstTranslations`.
  /// Which means operator `*` is not supported for `ConstTranslations`:
  ///
  /// ```dart
  /// // Doesn't work:
  /// var t = const ConstTranslations("en_us", {...}}) + Translations.byText("en_us");
  /// ```
  ///
  /// However, you can add a `ConstTranslations` to a regular `Translations`:
  ///
  /// ```dart
  /// // Works:
  /// var t = Translations.byText("en_us") + const ConstTranslations("en_us", {...}});
  /// ```
  @override
  Translations<TKEY, TRANbyLOCALE, TRANbyTKEY, ADDEDMAP> operator *(
      Translations<TKEY, TRANbyLOCALE, TRANbyTKEY, dynamic> translations) {
    throw UnsupportedError("Operator `*` is not supported for class `ConstTranslations`.");
  }
}
