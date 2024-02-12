// Developed by Marcelo Glasberg (2019) https://glasberg.dev and https://github.com/marcglasberg
// For more info, see: https://pub.dartlang.org/packages/i18n_extension

import 'package:i18n_extension_core/src/core_localize_functions.dart';

/// When you create a widget that has translatable strings,
/// add this default import to the widget's file:
///
/// ```dart
/// import 'package:i18n_extension_core/default.i18n.dart';
/// ```
///
/// This will allow you to add `.i18n` and `.plural()` to your strings,
/// but won't translate anything.
///
extension Localization on String {
  //
  String get i18n => recordMissingKey(this);

  String plural(value) {
    recordMissingKey(this);
    return replaceAll("%d", value.toString());
  }

  String fill(List<Object> params) => localizeFill(this, params);
}
