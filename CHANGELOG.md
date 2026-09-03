Sponsored by [MyText.ai](https://mytext.ai)

[![](./example/SponsoredByMyTextAi.png)](https://mytext.ai)

## 5.2.1

* `Translations.byFile()` and `Translations.byHttp()` now accept an optional
  `failOnInvalidResource` parameter, next to `failOnMissingResource`. Both default to
  `true`.

  The two flags cover different kinds of failure:

  - `failOnMissingResource` applies when the file or resource could not be read: a
    404 or network error, or an asset that fails to load (which on the web is also a
    download).
  - `failOnInvalidResource` applies when the file or resource was read, but could not
    be decoded (invalid JSON, YAML, ARB, or ICU message) or has invalid content (for
    example, a value that is not a String).

  When a flag is `false`, that kind of failure is reported and skipped, and the other
  files or resources still load. For example, to tolerate a temporarily unavailable
  language file, but still fail on a malformed one:

  ```dart
  static final _t = Translations.byHttp('en-US',
    url: 'https://example.com/translations',
    resources: ['en-US.json', 'es.json', 'pt-BR.po', 'fr.po'],
    failOnMissingResource: false, // Skip resources that cannot be read.
    failOnInvalidResource: true, // Still fail on resources that cannot be decoded.
  );
  ```

  Note these flags are only a configuration carried by the translations object. 
  The behavior they describe is implemented by the loader in the `i18n_extension` package.

## 5.1.0

* `Translations.byFile()` and `Translations.byHttp()` now accept an optional
  `failOnMissingResource` parameter. It defaults to `true`, which keeps the previous
  behavior: if a single file or resource fails to load, the whole load fails, and no
  translations are loaded at all.

  When you set it to `false`, the file or resource that failed is logged and skipped,
  and the ones that loaded correctly are kept. This is useful when a language file is
  temporarily unavailable, and you'd rather show the other languages than none:

  ```dart
  static final _t = Translations.byHttp('en-US',
    url: 'https://example.com/translations',
    resources: ['en-US.json', 'es.json', 'pt-BR.po', 'fr.po'],
    failOnMissingResource: false, // Keep the resources that loaded correctly.
  );
  ```

  Note this flag is only a configuration carried by the translations object. The
  behavior it describes is implemented by the loader in the `i18n_extension` package.

## 5.0.2

* You can now define `Translations.supportedLocales` to specify the locales that your
  app supports. If you do this, only those supported locales will be considered when
  recording missing translations. In other words, unsupported locales will not be
  recorded as missing translations. Note the supported locales should be valid BCP47
  codes. For example:

  ```dart
  Translations.supportedLocales = ['en-US', 'cs-CZ', 'es', 'zh-Hant-CN'];
  ```

* **Breaking Change**: The `Translations.missingTranslationCallback` signature changed,
  and it's now of type `MissingTranslationCallback`:

  ```dart
  typedef MissingTranslationCallback = bool Function({
    required Object? key,
    required String locale,
    required Translations translations,
    required Iterable<String> supportedLocales,
    });
  ```

  Note it now also returns a boolean. Only if it returns `true`, the missing translation
  will be put into the `Translations.missingTranslations` map.

## 4.0.0

* `Translations.byHttp()` is now available (only when using the `i18n_extension` package).
  It allows you to load translations from `.json` or `.po` files in the web.
  Use it like this:

  ```     
  final translations = Translations.byHttp('en-US', 
    url: 'https://example.com/translations', 
    resources: ['en-US.json', 'es.json', 'pt-BR.po', 'fr.po']);
  );
  ```

## 3.0.0

* **Breaking Change**: Language codes should now respect the BCP47 standard, when you
  define your translations.  
  For example, you should now use `en-US` instead of the old `en_us` format.
  Other valid code examples are: `en`, `es-419`, `hi-Deva-IN` and `zh-Hans-CN`.
  To help you upgrade, a `TranslationsException` error will be thrown when you use the
  old code format, with a detailed error message such as:
  `Locale "en_us" should be "en-US" (for translatable string "Hello!").`


* As a helper, in case you need it, we now provide function
  `DefaultLocale.normalizeLocale` to normalize language codes to the BCP47 standard
  (which is compatible with the Unicode Locale Identifier (ULI) syntax).
  It fixes casing (uppercase and lowercase), removes spaces, and turns underscores into
  hyphens. As such, it can be used to convert the old format language codes to the new
  ones. For example: `DefaultLocale.normalizeLocale('en_us')` returns `'en-US'`.


* You can now do string interpolation by using `{}`, `{1}`, and `{named}`, by
  using function `localizeArgs`:

  ```     
  localizeArgs('Hello {student} and {teacher}', {'student': 'John', 'teacher': 'Mary'});
  localizeArgs('Hello {student} and {teacher}', 'John', 'Mary');
  localizeArgs('Hello {1} and {2}', 'John', 'Mary');
  localizeArgs('Hello {1} and {2}', ['John', 'Mary']);
  localizeArgs('Hello {1} and {2}', {1: 'John', 2: 'Mary'});
  localizeArgs('Hello {} and {}', 'John', 'Mary');
  localizeArgs('Hello {} and {}', ['John', 'Mary']);
  ```

  From the `i18n_extension` package, this functionality is accessible via the `args`
  extension. For example:

  ```     
  'Hello {student} and {teacher}'.i18n.args({'student': 'John', 'teacher': 'Mary'});
  'Hello {student} and {teacher}'.i18n.args('John', 'Mary');
  'Hello {1} and {2}'.i18n.args('John', 'Mary');
  'Hello {1} and {2}'.i18n.args(['John', 'Mary']);
  'Hello {1} and {2}'.i18n.args({1: 'John', 2: 'Mary'});
  'Hello {} and {}'.i18n.args('John', 'Mary');
  'Hello {} and {}'.i18n.args(['John', 'Mary']);
  ```


* Previously, you could do string interpolation by using **sprintf** specifiers,
  like `%s`, `%1$s`, `%d` etc., and providing a list of values to fill them.
  This is still supported:

  ```     
  localizeFill('Hello %s and %s', ['student', 'teacher']);
  localizeFill('Hello %1$s and %2$s', ['student', 'teacher']);  
  ```

  However now you can also provide the values directly, without having to wrap them
  in a list:

  ```
  localizeFill('Hello %s and %s', 'student', 'teacher');
  localizeFill('Hello %1$s and %2$s', 'student', 'teacher');
  ```

  From the `i18n_extension` package, this functionality is accessible via the `fill`
  extension. For example:

  ```     
  'Hello %s and %s'.i18n.fill(['student', 'teacher']);
  'Hello %1$s and %2$s'.i18n.fill(['student', 'teacher']);  
  'Hello %s and %s'.i18n.fill('student', 'teacher');
  'Hello %1$s and %2$s'.i18n.fill('student', 'teacher');
  ```  

* `Translations.byFile()` is now available (only when using the `i18n_extension` package).
  It allows you to load translations from a `.json` or `.po` file. Use it like this:

  ```     
  final translations = Translations.byFile('en-US', dir: 'assets/translations');
  ```

## 2.0.6

* Translations:
    - `Translations.byText()`: Supports `String` themselves as translation-keys, organized
      per key.
    - `Translations.byLocale()`: Supports `String` themselves as translation-keys,
      organized per locale.
    - `Translations.byId<T>()`: Supports any object (of type `T`) as translation-keys.
    - `const ConstTranslations()`: Supports defining translations with a `const` Map.

## 1.0.0

* On Feb 11, 2024 I've created this Dart-only package to contain the core code of
  the [i18n_extension](https://pub.dev/packages/i18n_extension) package.
