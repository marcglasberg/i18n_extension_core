import 'package:i18n_extension_core/i18n_extension_core.dart';
import 'package:i18n_extension_core/src/utils.dart';
import 'package:test/test.dart';

void main() {
  //
  test("Empty translations.", () {
    expect(() => checkLocale('pt'), returnsNormally);
    expect(() => checkLocale('pt-'), throwsA(isA<TranslationsException>()));
    expect(() => checkLocale('  pt  '), throwsA(isA<TranslationsException>()));
    expect(() => checkLocale('pt-BR'), returnsNormally);
    expect(() => checkLocale('  pt-BR  '), throwsA(isA<TranslationsException>()));
    expect(() => checkLocale('_pt__BR_'), throwsA(isA<TranslationsException>()));
    expect(() => checkLocale('pt-br'), throwsA(isA<TranslationsException>()));
    expect(() => checkLocale('pt-_BR'), throwsA(isA<TranslationsException>()));
    expect(() => checkLocale('-- p t-__'), throwsA(isA<TranslationsException>()));
    expect(() => checkLocale('abcdefghijkl'), throwsA(isA<TranslationsException>()));
    expect(() => checkLocale('mnopqrstuvwxyz'), throwsA(isA<TranslationsException>()));
    expect(() => checkLocale('ABCDEFGHIJKL'), throwsA(isA<TranslationsException>()));
    expect(() => checkLocale('MNOPQRSTUVWXYZ'), throwsA(isA<TranslationsException>()));
    expect(() => checkLocale('pt______'), throwsA(isA<TranslationsException>()));
    expect(() => checkLocale('p--t_b_R__X__'), throwsA(isA<TranslationsException>()));
    expect(() => checkLocale('p--t-b-R--X--'), throwsA(isA<TranslationsException>()));
  });
}
