import 'package:i18n_extension_core/src/parse_string.dart';
import 'package:test/test.dart';

void main() {
  group('ParseString.createSourceList', () {
    test('Basic test with named parameter', () {
      final parse = ParseString("Hello {student}", p1: null);
      final result = parse.createSourceList();

      expect(result, {
        "student": (6, 14),
      });
    });

    test('Basic test with indexed parameter', () {
      final parse = ParseString("Hello {1}", p1: null);
      final result = parse.createSourceList();

      expect(result, {
        '1': (6, 8),
      });
    });

    test('Basic test with naked parameter', () {
      final parse = ParseString("Hello {}", p1: null);
      final result = parse.createSourceList();

      expect(result, {
        0: (6, 7),
      });
    });

    test('Multiple named parameters', () {
      final parse = ParseString("Hello {student}, this is {teacher}", p1: null);
      final result = parse.createSourceList();

      expect(result, {
        "student": (6, 14),
        "teacher": (25, 33),
      });
    });

    test('Multiple indexed parameters', () {
      final parse = ParseString("Hello {1}, this is {2}", p1: null);
      final result = parse.createSourceList();

      expect(result, {
        '1': (6, 8),
        '2': (19, 21),
      });
    });

    test('Multiple naked parameters', () {
      final parse = ParseString("Hello {}, this is {}", p1: null);
      final result = parse.createSourceList();

      expect(result, {
        0: (6, 7),
        1: (18, 19),
      });
    });

    test('Mixed parameter types', () {
      final parse = ParseString("Hello {student}, this is {1} and {} and {}", p1: null);
      final result = parse.createSourceList();

      expect(result, {
        "student": (6, 14),
        '1': (25, 27),
        0: (33, 34),
        1: (40, 41),
      });
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

      expect(result, {
        "dent": (10, 15), // Only valid nested placeholder
      });
    });

    test('Multiple consecutive placeholders', () {
      final parse = ParseString("{1}{2}{3}", p1: null);
      final result = parse.createSourceList();

      expect(result, {
        '1': (0, 2),
        '2': (3, 5),
        '3': (6, 8),
      });
    });

    test('Overlapping placeholders (invalid case)', () {
      final parse = ParseString("{student {teacher}", p1: null);
      final result = parse.createSourceList();

      expect(result, {
        "teacher": (9, 17),
      });
    });

    test('Whitespace inside placeholders', () {
      final parse = ParseString("Hello { student } and {1 }", p1: null);
      final result = parse.createSourceList();

      expect(result, {
        " student ": (6, 16),
        "1 ": (22, 25),
      });
    });

    test('Trailing and leading text with placeholders', () {
      final parse = ParseString("Start {1}, middle {}, end {last}", p1: null);
      final result = parse.createSourceList();

      expect(result, {
        '1': (6, 8),
        0: (18, 19),
        "last": (26, 31),
      });
    });

    test('Long string with multiple placeholders', () {
      final parse =
          ParseString("Hello {1}, this is {teacher}, you are {}. Welcome to {location}!", p1: null);
      final result = parse.createSourceList();

      expect(result, {
        '1': (6, 8),
        "teacher": (19, 27),
        0: (38, 39),
        "location": (53, 62),
      });
    });
  });
}
