/// All translation exceptions are of type [TranslationsException].
///
/// This class is visible from both [i18_exception] and [i18_exception_core] packages.
///
class TranslationsException {
  String msg;

  TranslationsException(this.msg);

  @override
  String toString() => msg;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TranslationsException && runtimeType == other.runtimeType && msg == other.msg;

  @override
  int get hashCode => msg.hashCode;
}
