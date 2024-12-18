import 'package:i18n_extension_core/i18n_extension_core.dart';
import 'package:i18n_extension_core/src/translations_by_identifier.dart';

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
/// * [locale]: A valid BCP47 language tag, usually language-script-country, like 'en-US', 'pt-BR', or 'zh-Hans-CN'.
/// * [translated string]: The translated strings for a given [translation-key].
/// * [identifier]: An immutable variable that you may use as a translation-key, instead of the string itself.
///
/// ---
///
/// The options are:
/// * [Translations.byText]
/// * [Translations.byLocale]
/// * [Translations.byId]
/// * [Translations.byFile]
/// * [Translations.byHttp]
/// * [ConstTranslations.new] which can be made const
/// ---
///
/// [Translations.byText] example:
///
/// ```
/// var t = Translations.byText('en-US') +
///       {
///         'en-US': 'i18n Demo',
///         'pt-BR': 'Demonstração i18n',
///       };
/// ```
/// ---
///
/// [Translations.byLocale] example:
///
/// ```
/// var t = Translations.byLocale('en-US') +
///   {
///      'en-US': {
///        'Hi.': 'Hi.',
///        'Goodbye.': 'Goodbye.',
///      },
///      'es-ES': {
///        'Hi.': 'Hola.',
///        'Goodbye.': 'Adiós.',
///      }
///   };
/// ```
/// ---
///
/// [Translations.byId] example:
///
/// ```
/// var t = Translations.byId<MyColors>('en-US', {
///   MyColors.red: {
///       'en-US': 'red',
///       'pt-BR': 'vermelho',
///   },
///   MyColors.green: {
///       'en-US': 'green',
///       'pt-BR': 'Verde',
///   });
/// ```
/// ---
///
/// [Translations.byFile] example:
///
/// ```
/// var t = Translations.byFile('en-US', dir: 'assets/translations');
/// ```
/// ---
///
/// [Translations.byHttp] example:
///
/// ```
/// var t = Translations.byHttp('en-US', url: 'https://example.com/translations.json');
/// ```
/// ---
///
/// [ConstTranslations.new] example:
///
/// ```
/// const t = ConstTranslations(
///    'en-US',
///    {
///      'i18n Demo': {
///        'en-US': 'i18n Demo',
///        'pt-BR': 'Demonstração i18n',
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
  /// static final t = Translations.byText('en-US') +
  ///       const {
  ///         'en-US': 'i18n Demo',
  ///         'pt-BR': 'Demonstração i18n',
  ///       };
  /// ```
  ///
  /// See also:
  /// - [Translations.byId], which lets you provide translations for identifiers.
  /// - [Translations.byLocale], where you provide all translations together for each locale.
  /// - [Translations.byFile], where you load translations from files.
  /// - [Translations.byHttp], where you load translations from the web.
  /// - [ConstTranslations.new], which responds better to hot reload.
  ///
  static Translations byText(StringLocale defaultLocaleStr) => TranslationsByText<
      String,
      Map<StringLocale, StringTranslated>,
      Map<String, StringTranslated>,
      Map<StringLocale, StringTranslated>>(defaultLocaleStr);

  /// The [Translations.byLocale] constructor allows you to provide, for each locale,
  /// all translations together:
  ///
  /// ```
  /// static var t = Translations.byLocale('en-US') +
  ///   {
  ///      'en-US': {
  ///        'Hi.': 'Hi.',
  ///        'Goodbye.': 'Goodbye.',
  ///      },
  ///      'es-ES': {
  ///        'Hi.': 'Hola.',
  ///        'Goodbye.': 'Adiós.',
  ///      }
  ///   };
  /// ```
  ///
  /// See also:
  /// - [Translations.byText], which lets you provide translations for strings.
  /// - [Translations.byId], which lets you provide translations for identifiers.
  /// - [Translations.byFile], where you load translations from files.
  /// - [Translations.byHttp], where you load translations from the web.
  /// - [ConstTranslations.new], which responds better to hot reload.
  ///
  static Translations byLocale(StringLocale defaultLocaleStr) => TranslationsByLocale<
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
  /// var t = Translations.byId<MyColors>('en-US', {
  ///              MyColors.red: {
  ///                  'en-US': 'red',
  ///                  'pt-BR': 'vermelho',
  ///              },
  ///              MyColors.green: {
  ///                  'en-US': 'green',
  ///                  'pt-BR': 'Verde',
  ///              });
  /// ```
  ///
  /// Note you may also add translations with the [+] operator. For example:
  ///
  /// ```
  /// var t = Translations.byId<MyColors>('en-US', {
  ///              MyColors.red: {
  ///                  'en-US': 'red',
  ///                  'pt-BR': 'vermelho',
  ///              }) +
  ///              {
  ///                  MyColors.green: {
  ///                     'en-US': 'green',
  ///                     'pt-BR': 'Verde',
  ///                  }
  ///              };
  /// ```
  ///
  /// If you want your identifiers to be of ANY type, you can use type `Object`
  /// or even `Object?` (or `dynamic`). For example:
  ///
  /// ```
  /// var t = Translations.byId<Object?>('en-US', {
  ///              MyColors.red: {
  ///                  'en-US': 'red',
  ///                  'pt-BR': 'vermelho',
  ///              },
  ///              123: {
  ///                  'en-US': 'One two three',
  ///                  'pt-BR': 'Um dois três',
  ///              },
  ///              null: {
  ///                  'en-US': 'This is empty',
  ///                  'pt-BR': 'Isso está vazio',
  ///              });
  /// ```
  ///
  /// IMPORTANT: You can create your own class and use its objects as identifiers, but it
  /// must implement the `==` and `hashCode` methods. Otherwise, it won't be possible to
  /// find it as one of the translation-keys.
  ///
  /// See also:
  /// - [Translations.byText], which lets you provide translations for strings.
  /// - [Translations.byLocale], where you provide all translations together for each locale.
  /// - [Translations.byFile], where you load translations from files.
  /// - [Translations.byHttp], where you load translations from the web.
  /// - [ConstTranslations.new], which responds better to hot reload.
  ///
  static Translations byId<TKEY>(
          StringLocale defaultLocaleStr,
          Map<TKEY, Map<StringLocale, StringTranslated>>
              translationByLocale_ByTranslationKey) =>
      TranslationsByIdentifier<
          TKEY, // The type of the translation-key.
          Map<StringLocale, StringTranslated>, // Translation strings by locale.
          Map<TKEY, StringTranslated>, // Translation strings by translation-key.
          Map<
              TKEY,
              Map<StringLocale,
                  StringTranslated>> // Shape of the added map for operator +.
          >(
        defaultLocaleStr,
        translationByLocale_ByTranslationKey,
      );

  static final Set<TranslationsByLocale> _translationsToLoadByFile = {};

  static final Set<TranslationsByLocale> _translationsToLoadByHttp = {};

  /// Load process used by [Translations.byFile].
  static Future<void> Function(TranslationsByLocale translations)? _loadByFile;

  /// Download process used by [Translations.byHttp].
  static Future<void> Function(TranslationsByLocale translations)? _loadByHttp;

  /// The load-by-file process can be set by a third-party package.
  /// It should modify/mutate the translation map in some way,
  /// like loading it from a file, or from a database, and then rebuild the widgets.
  static set loadByFile(Future<void> Function(TranslationsByLocale translations) value) {
    _loadByFile = value;

    // If there are translations waiting to load, load them now.
    if (_translationsToLoadByFile.isNotEmpty) {
      for (var translations in _translationsToLoadByFile) {
        _executeLoadByFile(translations);
      }
      _translationsToLoadByFile.clear();
    }
  }

  /// The load-by-http process can be set by a third-party package.
  /// It should modify/mutate the translation map in some way,
  /// like loading it from a https address, and then rebuild the widgets.
  static set loadByHttp(Future<void> Function(TranslationsByLocale translations) value) {
    _loadByHttp = value;

    // If there are translations waiting to load, load them now.
    if (_translationsToLoadByHttp.isNotEmpty) {
      for (var translations in _translationsToLoadByHttp) {
        _executeLoadByHttp(translations);
      }
      _translationsToLoadByHttp.clear();
    }
  }

  static void _executeLoadByFile(TranslationsByLocale translation) {
    _loadByFile!(translation).then((_) {
      translation.completer?.complete();
    }).catchError((error) {
      translation.completer
          ?.completeError(TranslationsException('Loading translations failed: $error.'));
    });
  }

  static void _executeLoadByHttp(TranslationsByLocale translation) {
    _loadByHttp!(translation).then((_) {
      translation.completer?.complete();
    }).catchError((error) {
      translation.completer
          ?.completeError(TranslationsException('Loading translations failed: $error.'));
    });
  }

  /// The [byFile] constructor allows you to read all locale translations from files.
  /// Note this works from `i18n_extension`, but not from `i18n_extension_core`.
  ///
  /// For example, if you want to load translations from `.json` files in your assets
  /// directory, create a folder and add some translation files like this:
  ///
  /// ```
  /// assets
  /// └── translations
  ///     ├── en-US.json
  ///     ├── es-ES.json
  ///     ├── zh-Hans-CN.json
  ///     └── pt.json
  /// ```
  ///
  /// You can also use `.po` files:
  ///
  /// ```
  /// assets
  /// └── translations
  ///     ├── en-US.po
  ///     ├── es-ES.po
  ///     ├── zh-Hans-CN.po
  ///     └── pt.po
  /// ```
  ///
  /// Don't forget to declare your assets directory in your `pubspec.yaml`:
  ///
  /// ```yaml
  /// flutter:
  ///   assets:
  ///     - assets/translations/
  /// ```
  ///
  /// Then, you can load the translations using `Translations.byFile()`:
  ///
  /// ```dart
  /// extension MyTranslations on String {
  ///   static final _t = Translations.byFile('en-US', dir: 'assets/translations');
  ///   String get i18n => localize(this, _t);
  /// }
  /// ```
  ///
  /// The above code will asynchronously load all the translations from the `.json`
  /// and `.po` files present in the `assets/translations` directory, and then rebuild
  /// your widgets with those new translations.
  ///
  /// Note: Since rebuilding widgets when the translations finish loading can cause a
  /// visible flicker, you can optionally avoid that by preloading the translations
  /// before running your app. To that end, first create a `load()` method in
  /// your `MyTranslations` extension:
  ///
  /// ```dart
  /// extension MyTranslations on String {
  ///   static final _t = Translations.byFile('en-US', dir: 'assets/translations');
  ///   String get i18n => localize(this, _t);
  ///
  ///   static Future<void> load() => _t.load(); // Here!
  /// }
  /// ```
  ///
  /// And then, in your `main()` method, call `MyTranslations.load()` before running
  /// the app:
  ///
  /// ```dart
  /// void main() async {
  ///   WidgetsFlutterBinding.ensureInitialized();
  ///
  ///   await MyTranslations.load(); // Here!
  ///
  ///   runApp(
  ///     I18n(
  ///       initialLocale: await I18n.loadLocale(),
  ///       autoSaveLocale: true,
  ///       child: AppCore(),
  ///     ),
  ///   );
  /// }
  /// ```
  ///
  /// Try running
  /// the <a href="https://github.com/marcglasberg/i18n_extension/blob/master/example/lib/6_load_example/main.dart">
  /// load example</a>.
  ///
  /// Another alternative is using a `FutureBuilder`:
  ///
  /// ```dart
  /// return FutureBuilder(
  ///   future: MyTranslations.load(),
  ///   builder: (context, snapshot) {
  ///     if (snapshot.connectionState == ConnectionState.done) {
  ///     return MyWidget(...);
  ///   } else {
  ///     return const Center(child: CircularProgressIndicator());
  ///   } ...
  /// ```
  ///
  /// Note: The load-by-file process has a default timeout of 0.5 seconds. If the timeout
  /// is reached, the future returned by `load` will complete, but the load process still
  /// continues in the background, and the widgets will rebuild automatically when the
  /// translations finally finish loading. Optionally, you can provide a
  /// different `timeout` duration.
  ///
  /// **Note:** The code to load translations from files is adapted from original code
  /// created by <a href="https://github.com/bauerj">Johann Bauer</a>.
  ///
  ///
  /// See also:
  /// - [Translations.byText], which lets you provide translations for strings.
  /// - [Translations.byLocale], where you provide all translations together for each locale.
  /// - [Translations.byId], which lets you provide translations for identifiers.
  /// - [Translations.byHttp], where you load translations from the web.
  /// - [ConstTranslations.new], which responds better to hot reload.
  ///
  static Translations byFile(StringLocale defaultLocaleStr, {required String dir}) {
    var translations = TranslationsByLocale<
            String,
            Map<StringLocale, StringTranslated>,
            Map<String, StringTranslated>,
            Map<StringLocale, Map<StringLocale, StringTranslated>>>.byFile(
        defaultLocaleStr,
        dir: dir);

    // If the load-by-file process has been set, load it.
    // Otherwise, add it to the list of translations to load in the future.
    if (_loadByFile != null) {
      _executeLoadByFile(translations);
    } else {
      _translationsToLoadByFile.add(translations);
    }

    return translations;
  }

  /// The [byHttp] constructor allows you to read all locale translations from the web.
  /// Note this works from `i18n_extension`, but not from `i18n_extension_core`.
  ///
  /// For example, if you want to load translations from a `.json` or `.po` file:
  ///
  ///
  /// ```dart
  /// extension MyTranslations on String {
  ///
  ///   static final _t = Translations.byHttp('en-US',
  ///     url: 'https://example.com/translations',
  ///     resources: ['en-US.json', 'es.json', 'pt-BR.po', 'fr.po']);
  ///
  ///   String get i18n => localize(this, _t);
  /// }
  /// ```
  ///
  /// The above code will asynchronously load all the following translation resources:
  ///
  /// https://example.com/translations/en-US.json
  /// https://example.com/translations/es.json
  /// https://example.com/translations/pt-BR.po
  /// https://example.com/translations/fr.po
  ///
  /// Then, the widgets will rebuild with those new translations.
  ///
  /// Note: Since rebuilding widgets when the translations finish loading can cause a
  /// visible flicker, you can optionally avoid that by preloading the translations
  /// before running your app. To that end, first create a `load()` method in
  /// your `MyTranslations` extension:
  ///
  /// ```dart
  /// extension MyTranslations on String {
  ///   static final _t = Translations.byHttp('en-US', url: ..., resources: ...);
  ///   String get i18n => localize(this, _t);
  ///
  ///   static Future<void> load() => _t.load(); // Here!
  /// }
  /// ```
  ///
  /// And then, in your `main()` method, call `MyTranslations.load()` before running
  /// the app:
  ///
  /// ```dart
  /// void main() async {
  ///   WidgetsFlutterBinding.ensureInitialized();
  ///
  ///   await MyTranslations.load(); // Here!
  ///
  ///   runApp(
  ///     I18n(
  ///       initialLocale: await I18n.loadLocale(),
  ///       autoSaveLocale: true,
  ///       child: AppCore(),
  ///     ),
  ///   );
  /// }
  /// ```
  ///
  /// Another alternative is using a `FutureBuilder`:
  ///
  /// ```dart
  /// return FutureBuilder(
  ///   future: MyTranslations.load(),
  ///   builder: (context, snapshot) {
  ///     if (snapshot.connectionState == ConnectionState.done) {
  ///     return MyWidget(...);
  ///   } else {
  ///     return const Center(child: CircularProgressIndicator());
  ///   } ...
  /// ```
  ///
  /// Note: The load-by-url process has a default timeout of 1 second. If the timeout is
  /// reached, the future returned by `load` will complete, but the load process still
  /// continues in the background, and the widgets will rebuild automatically when the
  /// translations finally finish loading. Optionally, you can provide a
  /// different `timeout` duration.
  ///
  ///
  /// See also:
  /// - [Translations.byText], which lets you provide translations for strings.
  /// - [Translations.byLocale], where you provide all translations together for each locale.
  /// - [Translations.byId], which lets you provide translations for identifiers.
  /// - [Translations.byFile], where you load translations from a file.
  /// - [ConstTranslations.new], which responds better to hot reload.
  ///
  static Translations byHttp(
    StringLocale defaultLocaleStr, {
    required String url,
    required Iterable<String> resources,
  }) {
    var translations = TranslationsByLocale<
        String,
        Map<StringLocale, StringTranslated>,
        Map<String, StringTranslated>,
        Map<StringLocale, Map<StringLocale, StringTranslated>>>.byHttp(
      defaultLocaleStr,
      url: url,
      resources: resources,
    );

    // If the load-by-http process has been set, load it.
    // Otherwise, add it to the list of translations to load in the future.
    if (_loadByHttp != null) {
      _executeLoadByHttp(translations);
    } else {
      _translationsToLoadByHttp.add(translations);
    }

    return translations;
  }

  /// All missing keys and translations will be put here.
  /// This may be used in tests to make sure no translations are missing.
  static Set<TranslatedString> missingKeys = {};
  static Set<TranslatedString> missingTranslations = {};

  /// If true, records missing translations keys.
  static bool recordMissingKeys = true;

  /// If true, records missing translations.
  static bool recordMissingTranslations = true;

  /// Contains the locales that are supported, as BCP47 language tags.
  /// For example: `['en-US', 'pt-BR', 'es', 'zh-Hans-CN']`
  static Iterable<String> supportedLocales = [];

  /// Replace this to log missing keys.
  static void Function(Object? key, StringLocale locale) missingKeyCallback =
      (key, locale) => print('➜ Translation-key in "$locale" is missing: "$key".');

  /// The default implementation of [missingTranslationCallback] prints missing
  /// translations to the console. If [supportedLocales] is provided, it will only
  /// consider missing translations for locales that are supported. If the supported
  /// locales is empty (not provided) it will log everything.
  ///
  /// You can replace this callback with your own implementation.
  ///
  /// If it returns true, the missing translation will also be put
  /// into the [missingTranslations] set.
  ///
  static MissingTranslationCallback missingTranslationCallback =
      _defaultMissingTranslationCallback;

  static bool _defaultMissingTranslationCallback({
    required Object? key,
    required StringLocale locale,
    required Translations translations,
    required Iterable<String> supportedLocales,
  }) {
    if (locale != translations.defaultLocaleStr &&
        (supportedLocales.isEmpty || supportedLocales.contains(locale))) {
      print('➜ There are no translations in "$locale" for "$key".');
      return true;
    } else {
      return false;
    }
  }

  /// Generative constructor.
  const Translations.gen({
    required this.translationByLocale_ByTranslationKey,
    required this.defaultLocaleStr,
  });

  /// Map of translations by locale, by translation-key.
  /// It's something like this:
  ///
  ///       'Hi': { // TKEY
  ///         'en-US': 'Hi', // LOCALE : TRAN
  ///         'pt-BR': 'Olá', // LOCALE : TRAN
  ///       },
  ///       'Goodbye': { // TKEY
  ///         'en-US': 'Goodbye', // LOCALE : TRAN
  ///         'pt-BR': 'Adeus', // LOCALE : TRAN
  ///       }
  final Map<TKEY, TRANbyLOCALE> translationByLocale_ByTranslationKey;

  /// The default locale, as a [String].
  final StringLocale defaultLocaleStr;

  /// To extract the language code from a locale identifier, we typically parse the identifier
  /// and take the first part before any underscore. The language code is always at the
  /// beginning of the locale identifier and is separated from any subsequent parts
  /// (like country/region or script) by an underscore.
  String get defaultLanguageStr => utils.checkLocale(defaultLocaleStr).split('_')[0];

  /// Returns the number of translation-keys.
  /// For example, if you have translations for 'Hi' and 'Goodbye', this will return 2.
  int get length;

  /// Add a [addedMap] (of type [Map]) to a [Translations] object.
  Translations<TKEY, TRANbyLOCALE, TRANbyTKEY, ADDEDMAP> operator +(ADDEDMAP addedMap);

  /// Add a [translationsObj] object to another [Translations] object.
  ///
  /// Example:
  ///
  /// ```
  /// var t1 = Translations.byText('en-US') + {'en-US': 'Hi.', 'pt-BR': 'Olá.'};
  /// var t2 = Translations.byText('en-US') + {'en-US': 'Goodbye.', 'pt-BR': 'Adeus.'};
  ///
  /// var translations = t1 * t2;
  /// print(localize('Hi.', translations, locale: 'pt-BR');
  ///
  Translations<TKEY, TRANbyLOCALE, TRANbyTKEY, ADDEDMAP> operator *(
      Translations<TKEY, TRANbyLOCALE, TRANbyTKEY, dynamic> translationsObj);

  /// Given a translations [key], returns a [Map] of translations for that key.
  /// The map will have the locale as the key, and the translation as the value.
  TRANbyLOCALE? operator [](TKEY key) => translationByLocale_ByTranslationKey[key];
}

/// The [ConstTranslations] class allows you to define the translations
/// as a const object, all at once. This is a little bit more efficient,
/// and also better for "hot reload", since a const variable
/// will respond to hot reloads, while `final` variables will not.
///
/// Here you provide all locale translations of the first "translatable string",
/// then all locale translations of the second one, and so on.
///
/// ```
/// static const t = ConstTranslations('en-US',
///    {
///      'i18n Demo': {
///        'en-US': 'i18n Demo',
///        'pt-BR': 'Demonstração i18n',
///      }
///    },
/// );
/// ```
///
/// IMPORTANT: Make sure the [defaultLocaleStr] you provide is a syntactically valid
/// IETF BCP47 language tag (which is compatible with the Unicode Locale Identifier (ULI)
/// syntax). Since this constructor is const, we can't normalize the locale string for
/// you. If you are not sure, call [ConstTranslations.normalizeLocale] before using it.
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
  /// as a const object, all at once. This is a little bit more efficient,
  /// and also better for "hot reload", since a const variable
  /// will respond to hot reloads, while `final` variables will not.
  ///
  /// Here you provide all locale translations of the first "translatable string",
  /// then all locale translations of the second one, and so on.
  ///
  /// ```
  /// static const t = ConstTranslations('en-US',
  ///    {
  ///      'i18n Demo': {
  ///        'en-US': 'i18n Demo',
  ///        'pt-BR': 'Demonstração i18n',
  ///      }
  ///    },
  /// );
  /// ```
  ///
  /// IMPORTANT: Make sure the [defaultLocaleStr] you provide is correct (a valid BCP47
  /// language tag, compatible with the Unicode Locale Identifier (ULI) syntax).
  /// Since this constructor is const, we can't normalize the locale string for you.
  /// If you are not sure, call [ConstTranslations.normalizeLocale] before using it.
  ///
  /// See also:
  /// - [Translations.byText], which lets you provide translations for strings.
  /// - [Translations.byId], which lets you provide translations for identifiers.
  /// - [Translations.byLocale], where you provide all translations together for each locale.
  /// - [Translations.byFile], where you load translations from a file.
  /// - [Translations.byHttp], where you load translations from the web.
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
  /// * ` en-US_ ` becomes `en-US`.
  /// * ` en__us_ ` becomes `en-US`.
  /// * ` en-us ` becomes `en-US`.
  /// * `en-` becomes `en`.
  ///
  static String normalizeLocale(String locale) => utils.checkLocale(locale);

  /// You can't add a <Map> to a `ConstTranslations`.
  /// Which means operator `+` is not supported for `ConstTranslations`.
  @override
  Translations<TKEY, TRANbyLOCALE, TRANbyTKEY, ADDEDMAP> operator +(ADDEDMAP addedMap) {
    throw UnsupportedError(
        'Operator `+` is not supported for class `ConstTranslations`.');
  }

  /// You can't add a `Translation` to a `ConstTranslations`.
  /// Which means operator `*` is not supported for `ConstTranslations`:
  ///
  /// ```dart
  /// // Doesn't work:
  /// var t = const ConstTranslations('en-US', {...}}) + Translations.byText('en-US');
  /// ```
  ///
  /// However, you can add a `ConstTranslations` to a regular `Translations`:
  ///
  /// ```dart
  /// // Works:
  /// var t = Translations.byText('en-US') + const ConstTranslations('en-US', {...}});
  /// ```
  @override
  Translations<TKEY, TRANbyLOCALE, TRANbyTKEY, ADDEDMAP> operator *(
      Translations<TKEY, TRANbyLOCALE, TRANbyTKEY, dynamic> translations) {
    throw UnsupportedError(
        'Operator `*` is not supported for class `ConstTranslations`.');
  }
}

typedef MissingTranslationCallback = bool Function({
  required Object? key,
  required StringLocale locale,
  required Translations translations,
  required Iterable<String> supportedLocales,
});
