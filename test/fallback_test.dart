import 'package:i18n_extension_core/src/core_localize_functions.dart';
import 'package:i18n_extension_core/src/translations.dart';
import 'package:i18n_extension_core/src/translations_exception.dart';
import 'package:test/test.dart';

void main() {
  //
  test("Fallbacks", () {
    //
    DefaultLocale.set("zh_Hant_CN");

    expect(
        () => localize(
            "A",
            Translations.byText("en_us") +
                {
                  "en_us": "A",
                  "zh_hant_cn": "B",
                  "zh_hanz_cn": "C",
                }),
        throwsA(predicate((e) =>
            e is TranslationsException &&
            e.msg ==
                'Locale "en_us" is not a valid BCP47 locale identifier. Try "en-US".')));

    expect(
        () => localize(
            "A",
            Translations.byText("en-US") +
                {
                  "en_us": "A",
                  "zh_hant_cn": "B",
                  "zh_hanz_cn": "C",
                }),
        throwsA(predicate((e) =>
            e is TranslationsException &&
            e.msg == 'Locale "en_us" should be "en-US" (for translatable string "A").')));

    expect(
        () => localize(
            "A",
            Translations.byText("en-US") +
                {
                  "en_us": "A",
                  "zh_hant_cn": "B",
                  "zh_hanz_cn": "C",
                }),
        throwsA(predicate((e) =>
            e is TranslationsException &&
            e.msg == 'Locale "en_us" should be "en-US" (for translatable string "A").')));

    // ---------

    DefaultLocale.set("zh_hant_cn");

    expect(
        () => localize(
            "A",
            Translations.byText("en-US") +
                {
                  "en_us": "A",
                  "zh_hant": "B",
                }),
        throwsA(predicate((e) =>
            e is TranslationsException &&
            e.msg == 'Locale "en_us" should be "en-US" (for translatable string "A").')));

    // ---------

    DefaultLocale.set("zh_hant_cn");

    expect(
        () => localize(
            "A",
            Translations.byText("en-US") +
                {
                  "en_us": "A",
                  "zh": "B",
                }),
        throwsA(predicate((e) =>
            e is TranslationsException &&
            e.msg == 'Locale "en_us" should be "en-US" (for translatable string "A").')));

    // ---------

    DefaultLocale.set("zh_hant_cn");

    expect(
        () => localize(
            "A",
            Translations.byText("en-US") +
                {
                  "en_us": "A",
                  "pt": "B",
                }),
        throwsA(predicate((e) =>
            e is TranslationsException &&
            e.msg == 'Locale "en_us" should be "en-US" (for translatable string "A").')));

    // ---------

    DefaultLocale.set("zh_Hant_CN");

    expect(
        () => localize(
            "A",
            Translations.byText("en-US") +
                {
                  "en_us": "A",
                  "zh_hanz_cn": "B",
                }),
        throwsA(predicate((e) =>
            e is TranslationsException &&
            e.msg == 'Locale "en_us" should be "en-US" (for translatable string "A").')));

    // ---------

    DefaultLocale.set("zh_Hant");

    expect(
        () => localize(
            "A",
            Translations.byText("en-US") +
                {
                  "en_us": "A",
                  "zh_hant_cn": "B",
                  "zh_hanz_cn": "C",
                }),
        throwsA(predicate((e) =>
            e is TranslationsException &&
            e.msg == 'Locale "en_us" should be "en-US" (for translatable string "A").')));

    // ---------

    DefaultLocale.set("zh_Hant");

    expect(
        () => localize(
            "A",
            Translations.byText("en-US") +
                {
                  "en_us": "A",
                  "zh_hant_cn": "B",
                  "zh_hant": "C",
                  "zh_hant_hk": "D",
                }),
        throwsA(predicate((e) =>
            e is TranslationsException &&
            e.msg == 'Locale "en_us" should be "en-US" (for translatable string "A").')));

    // ---------

    DefaultLocale.set("zh_Hant");

    expect(
        () => localize(
            "A",
            Translations.byText("en-US") +
                {
                  "en_us": "A",
                  "zh_hanz_cn": "B", // Matched by "zh" only.
                  "zh_hanz": "C",
                  "zh_hanz_hk": "D",
                }),
        throwsA(predicate((e) =>
            e is TranslationsException &&
            e.msg == 'Locale "en_us" should be "en-US" (for translatable string "A").')));

    // ---------

    DefaultLocale.set("zh");

    expect(
        () => localize(
            "A",
            Translations.byText("en-US") +
                {
                  "en_us": "A",
                  "zh_hanz_cn": "B", // Matched by "zh" only.
                  "zh_hanz": "C",
                  "zh_hanz_hk": "D",
                }),
        throwsA(predicate((e) =>
            e is TranslationsException &&
            e.msg == 'Locale "en_us" should be "en-US" (for translatable string "A").')));

    // ---------

    DefaultLocale.set("zh");

    expect(
        () => localize(
            "A",
            Translations.byText("en-US") +
                {
                  "en_us": "A",
                  "zh_hanz_cn": "B", // Matched by "zh" only.
                  "zh_hanz": "C",
                  "zh_hanz_hk": "D",
                  "zh_hant": "E",
                }),
        throwsA(predicate((e) =>
            e is TranslationsException &&
            e.msg == 'Locale "en_us" should be "en-US" (for translatable string "A").')));

    // ---------

    DefaultLocale.set("zh");

    expect(
        () => localize(
            "A",
            Translations.byText("en-US") +
                {
                  "en_us": "A",
                  "zh_hanz_cn": "B", // Matched by "zh" only.
                  "zh_hanz": "C",
                  "zh_hanz_hk": "D",
                  "zh_hant": "E",
                  "zh": "F",
                }),
        throwsA(predicate((e) =>
            e is TranslationsException &&
            e.msg == 'Locale "en_us" should be "en-US" (for translatable string "A").')));

    // ---------
  });
}
