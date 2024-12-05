import 'package:i18n_extension_core/src/parse_string.dart';
import 'package:test/test.dart';

void main() {
  group('ParseString.createSourceList', () {
    test('Basic test with named parameter', () {
      final parse = ParseString("Hello {student}", p1: null);
      final result = parse.createSourceList();

      expect(result, [(placeholder: 'student', start: 6, end: 14)]);
    });

    test('Basic test with indexed parameter', () {
      final parse = ParseString("Hello {1}", p1: null);
      final result = parse.createSourceList();

      expect(result, [(placeholder: '1', start: 6, end: 8)]);
    });
  });

  test('Basic test with naked parameter', () {
    final parse = ParseString("Hello {}", p1: null);
    final result = parse.createSourceList();

    expect(result, [(placeholder: 0, start: 6, end: 7)]);
  });

  test('Multiple named parameters', () {
    final parse = ParseString("Hello {student}, this is {teacher}", p1: null);
    final result = parse.createSourceList();

    expect(result, [
      (placeholder: 'student', start: 6, end: 14),
      (placeholder: 'teacher', start: 25, end: 33)
    ]);
  });

  test('Multiple indexed parameters', () {
    final parse = ParseString("Hello {1}, this is {2}", p1: null);
    final result = parse.createSourceList();

    expect(result,
        [(placeholder: '1', start: 6, end: 8), (placeholder: '2', start: 19, end: 21)]);
  });

  test('Multiple naked parameters', () {
    final parse = ParseString("Hello {}, this is {}", p1: null);
    final result = parse.createSourceList();

    expect(result,
        [(placeholder: 0, start: 6, end: 7), (placeholder: 1, start: 18, end: 19)]);
  });

  test('Mixed parameter types', () {
    final parse = ParseString("Hello {student}, this is {1} and {} and {}", p1: null);
    final result = parse.createSourceList();

    expect(result, [
      (placeholder: 'student', start: 6, end: 14),
      (placeholder: '1', start: 25, end: 27),
      (placeholder: 0, start: 33, end: 34),
      (placeholder: 1, start: 40, end: 41),
    ]);
  });

  test('Empty string', () {
    final parse = ParseString("", p1: null);
    final result = parse.createSourceList();

    expect(result, isEmpty); // No placeholders
  });

  test('No placeholders in text', () {
    final parse = ParseString("Hello world", p1: null);
    final result = parse.createSourceList();

    expect(result, isEmpty); // No placeholders
  });

  test('Unclosed placeholder', () {
    final parse = ParseString("Hello {student", p1: null);
    final result = parse.createSourceList();

    expect(result, isEmpty); // Unclosed placeholder is ignored
  });

  test('Malformed placeholders', () {
    final parse = ParseString("Hello {stu{dent} and {1", p1: null);
    final result = parse.createSourceList();

    expect(result, [(placeholder: 'dent', start: 10, end: 15)]);
  });

  test('Multiple consecutive placeholders', () {
    final parse = ParseString("{1}{2}{3}", p1: null);
    final result = parse.createSourceList();

    expect(result, [
      (placeholder: '1', start: 0, end: 2),
      (placeholder: '2', start: 3, end: 5),
      (placeholder: '3', start: 6, end: 8),
    ]);
  });

  test('Overlapping placeholders (invalid case)', () {
    final parse = ParseString("{student {teacher}", p1: null);
    final result = parse.createSourceList();

    expect(result, [(placeholder: 'teacher', start: 9, end: 17)]);
  });

  test('Whitespace inside placeholders', () {
    final parse = ParseString("Hello { student } and {1 }", p1: null);
    final result = parse.createSourceList();

    expect(result, [
      (placeholder: ' student ', start: 6, end: 16),
      (placeholder: '1 ', start: 22, end: 25)
    ]);
  });

  test('Trailing and leading text with placeholders', () {
    final parse = ParseString("Start {1}, middle {}, end {last}", p1: null);
    final result = parse.createSourceList();

    expect(result, [
      (placeholder: '1', start: 6, end: 8),
      (placeholder: 0, start: 18, end: 19),
      (placeholder: 'last', start: 26, end: 31)
    ]);
  });

  test('Long string with multiple placeholders', () {
    final parse = ParseString(
        "Hello {1}, this is {teacher}, you are {}. Welcome to {location}!",
        p1: null);
    final result = parse.createSourceList();

    expect(result, [
      (placeholder: '1', start: 6, end: 8),
      (placeholder: 'teacher', start: 19, end: 27),
      (placeholder: 0, start: 38, end: 39),
      (placeholder: 'location', start: 53, end: 62),
    ]);
  });
}
