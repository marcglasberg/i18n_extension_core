import 'package:i18n_extension_core/src/core_localize_functions.dart';
import 'package:test/test.dart';

void main() {
  test("Get the normalize Locale.", () {
    expect(DefaultLocale.normalizeLocale("en-US"), "en-US");
    expect(DefaultLocale.normalizeLocale("en-US"), "en-US");
    expect(DefaultLocale.normalizeLocale("en-US"), "en-US");
    expect(DefaultLocale.normalizeLocale("en-US"), "en-US");
    expect(DefaultLocale.normalizeLocale("_en-US_"), "en-US");
    expect(DefaultLocale.normalizeLocale("en-US_"), "en-US");
    expect(DefaultLocale.normalizeLocale("_en-US"), "en-US");
    expect(DefaultLocale.normalizeLocale(" en-US "), "en-US");
    expect(DefaultLocale.normalizeLocale(" en-US"), "en-US");
    expect(DefaultLocale.normalizeLocale("en-US "), "en-US");
    expect(DefaultLocale.normalizeLocale("en-US _ "), "en-US");
    expect(DefaultLocale.normalizeLocale("_ en-US _ "), "en-US");
    expect(DefaultLocale.normalizeLocale("_ en-US _ "), "en-US");
  });
}
