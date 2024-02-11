import 'package:i18n_extension_core/i18n_extension_core.dart';
import 'package:test/test.dart';

void main() {
  //
  test("Get the normalize Locale.", () {
    expect(DefaultLocale.normalizeLocale("EN_US"), "en_us");
    expect(DefaultLocale.normalizeLocale("en_US"), "en_us");
    expect(DefaultLocale.normalizeLocale("EN_us"), "en_us");
    expect(DefaultLocale.normalizeLocale("En_Us"), "en_us");
    expect(DefaultLocale.normalizeLocale("_EN_US_"), "en_us");
    expect(DefaultLocale.normalizeLocale("EN_US_"), "en_us");
    expect(DefaultLocale.normalizeLocale("_EN_US"), "en_us");
    expect(DefaultLocale.normalizeLocale(" EN_US "), "en_us");
    expect(DefaultLocale.normalizeLocale(" EN_US"), "en_us");
    expect(DefaultLocale.normalizeLocale("EN_US "), "en_us");
    expect(DefaultLocale.normalizeLocale("EN_US _ "), "en_us");
    expect(DefaultLocale.normalizeLocale("_ EN_US _ "), "en_us");
    expect(DefaultLocale.normalizeLocale("_ eN_uS _ "), "en_us");
  });
}
