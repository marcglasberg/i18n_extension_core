import 'package:i18n_extension_core/src/utils.dart';
import 'package:test/test.dart';

void main() {
  //
  test("Empty translations.", () {
    expect(normalizeLocale('pt'), equals('pt'));
    expect(normalizeLocale('pt-'), equals('pt'));
    expect(normalizeLocale('  pt  '), equals('pt'));
    expect(normalizeLocale('pt_BR'), equals('pt_br'));
    expect(normalizeLocale('  pt_BR  '), equals('pt_br'));
    expect(normalizeLocale('_pt__BR_'), equals('pt_br'));
    expect(normalizeLocale('pt-BR'), equals('pt_br'));
    expect(normalizeLocale('pt-_BR'), equals('pt_br'));
    expect(normalizeLocale('-- p t-__'), equals('pt'));
    expect(normalizeLocale('abcdefghijkl'), equals('abcdefghijkl'));
    expect(normalizeLocale('mnopqrstuvwxyz'), equals('mnopqrstuvwxyz'));
    expect(normalizeLocale('ABCDEFGHIJKL'), equals('abcdefghijkl'));
    expect(normalizeLocale('MNOPQRSTUVWXYZ'), equals('mnopqrstuvwxyz'));
    expect(normalizeLocale('pt______'), equals('pt'));
    expect(normalizeLocale('p--t_b_R__X__'), equals('p_t_b_r_x'));
    expect(normalizeLocale('p--t-b-R--X--'), equals('p_t_b_r_x'));
  });
}
