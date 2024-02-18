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
  /// It returns the same [key] provided, unaffected. This marks the string for future translation,
  /// and records the given key as a missing translation with unknown locale.
  String get i18n => recordMissingKey(this);

  /// Translates a string where %d is replaced by the given number.
  /// It returns the same [value] provided, where %d is replaced by the given number.
  /// This marks the string for future translation, and records the given value as a key
  /// missing translation with unknown locale.
  String plural(value) {
    recordMissingKey(this);
    return replaceAll("%d", value.toString());
  }

  /// Does an `sprintf` on the [text] with the [params].
  /// This is implemented with the `sprintf` package: https://pub.dev/packages/sprintf
  ///
  /// Possible format values:
  ///
  /// * `%s` - String
  /// * `%b` - Binary number
  /// * `%c` - Character according to the ASCII value of `c`
  /// * `%d` - Signed decimal number (negative, zero or positive)
  /// * `%u` - Unsigned decimal number (equal to or greater than zero)
  /// * `%f` - Floating-point number
  /// * `%e` - Scientific notation using a lowercase, like `1.2e+2`
  /// * `%E` - Scientific notation using a uppercase, like `1.2E+2`
  /// * `%g` - shorter of %e and %f
  /// * `%G` - shorter of %E and %f
  /// * `%o` - Octal number
  /// * `%X` - Hexadecimal number, uppercase letters
  /// * `%x` - Hexadecimal number, lowercase letters
  ///
  /// Additional format values may be placed between the % and the letter.
  /// If multiple of these are used, they must be in the same order as below.
  ///
  /// * `+` - Forces both + and - in front of numbers. By default, only negative numbers are marked
  /// * `'` - Specifies the padding char. Space is the default. Used together with the width specifier: %'x20s uses "x" as padding
  /// * `-` - Left-justifies the value
  /// * `[0-9]` -  Specifies the minimum width held of to the variable value
  /// * `.[0-9]` - Specifies the number of decimal digits or maximum string length. Example: `%.2f`:
  ///
  /// ---
  /// This function is visible only from the [i18_exception_core] package.
  /// The [i18_exception] package uses a different function with the same name.
  String fill(List<Object> params) => localizeFill(this, params);
}
