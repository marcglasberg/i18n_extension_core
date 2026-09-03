/// All translation exceptions are of type [TranslationsException].
///
/// This class is visible from both [i18_exception] and [i18_exception_core] packages.
///
class TranslationsException {
  //

  /// The message of the exception.
  String msg;

  /// Creates a new instance of [TranslationsException] with the given [msg].
  TranslationsException(this.msg);

  /// Returns a string representation of this object.
  @override
  String toString() => 'TranslationsException{msg: $msg}';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TranslationsException && runtimeType == other.runtimeType && msg == other.msg;

  @override
  int get hashCode => msg.hashCode;
}

/// Thrown when a file or resource could not be read, when loading translations with
/// `Translations.byFile` or `Translations.byHttp`. For example, a 404 or network
/// error, or an asset that fails to load (which on the web is also a download).
///
/// Whether this failure fails the whole load, or is only reported and skipped, is
/// controlled by the `failOnMissingResource` flag of the translations object.
///
/// Note this package does not load files or resources itself. This exception is
/// thrown by the loader in the `i18n_extension` package.
///
/// This class is visible from both [i18_exception] and [i18_exception_core] packages.
///
class MissingResourceException extends TranslationsException {
  //

  /// Creates a new instance of [MissingResourceException] with the given [msg].
  MissingResourceException(super.msg);

  /// Returns a string representation of this object.
  @override
  String toString() => 'MissingResourceException{msg: $msg}';
}

/// Thrown when a file or resource was read, but could not be decoded (invalid JSON,
/// YAML, ARB, or ICU message) or has invalid content (for example, a value that is
/// not a String), when loading translations with `Translations.byFile` or
/// `Translations.byHttp`.
///
/// Whether this failure fails the whole load, or is only reported and skipped, is
/// controlled by the `failOnInvalidResource` flag of the translations object.
///
/// Note this package does not load files or resources itself. This exception is
/// thrown by the loader in the `i18n_extension` package.
///
/// This class is visible from both [i18_exception] and [i18_exception_core] packages.
///
class InvalidResourceException extends TranslationsException {
  //

  /// Creates a new instance of [InvalidResourceException] with the given [msg].
  InvalidResourceException(super.msg);

  /// Returns a string representation of this object.
  @override
  String toString() => 'InvalidResourceException{msg: $msg}';
}
