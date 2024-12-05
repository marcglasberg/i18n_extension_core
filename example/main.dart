import 'package:i18n_extension_core/i18n_extension_core.dart';

/// Go to the i18n_extension package (https://pub.dev/packages/i18n_extension) to read the docs
/// and see examples.
void main() {
  DefaultLocale.set("pt");

  String text = "Hello World".i18n;
  String filledText = "%s is %s years old".i18n.fill(["John", 30]);

  print(text);
  print(filledText);
}

extension Localization on String {
  //
  static final _t = Translations.byText("en-US") +
      {
        "en-US": "Hello World",
        "pt": "Olá Mundo",
      } +
      {
        "en-US": "%s is %s years old",
        "pt": "%s tem %s anos de idade",
      };

  String get i18n => localize(this, _t);

  String fill(List<Object> params) => localizeFill(this, params);
}
