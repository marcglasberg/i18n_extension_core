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
