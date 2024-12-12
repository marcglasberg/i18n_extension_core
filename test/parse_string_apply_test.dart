import 'package:i18n_extension_core/src/parse_string.dart';
import 'package:test/test.dart';

void main() {
  group('ParseString.apply', () {
    test('Single named parameter', () {
      final parse = ParseString(
        'Hello {student}',
        p1: 'Alice',
      );

      expect(parse.apply(), 'Hello Alice');
    });

    test('Multiple named parameters', () {
      final parse = ParseString(
        'Hello {student}, meet {teacher}',
        p1: 'Alice',
        p2: 'Mr. Smith',
      );

      expect(parse.apply(), 'Hello Alice, meet Mr. Smith');
    });

    test('Single indexed parameter', () {
      final parse = ParseString(
        'Hello {0}',
        p1: 'Alice',
      );

      expect(parse.apply(), 'Hello Alice');
    });

    test('Multiple indexed parameters', () {
      final parse = ParseString(
        'Hello {0}, meet {1}',
        p1: 'Alice',
        p2: 'Mr. Smith',
      );

      expect(parse.apply(), 'Hello Alice, meet Mr. Smith');
    });

    test('Naked parameters', () {
      final parse = ParseString(
        'Hello {}, meet {}',
        p1: 'Alice',
        p2: 'Mr. Smith',
      );

      expect(parse.apply(), 'Hello Alice, meet Mr. Smith');
    });

    test('Combination of named, indexed, and naked parameters', () {
      final parse = ParseString(
        'Hello {student}, meet {1} and {}',
        p1: 'Alice',
        p2: 'Mr. Smith',
        p3: 'Bob',
      );

      expect(parse.apply(), 'Hello Alice, meet Mr. Smith and Bob');
    });

    test('List parameters', () {
      var parse = ParseString(
        'Students: {0}, {1}, and {2}',
        p1: ['Alice', 'Bob', 'Charlie'],
      );

      expect(parse.apply(), 'Students: Alice, Bob, and Charlie');

      // We invert the order of the indexed placeholders, in the text.
      // However, params are still applied in the same order.
      // Only a map like {0: 'Alice', 1: 'Bob', 2: 'Charlie'} would change the order.
      parse = ParseString(
        'Students: {2}, {1}, and {0}',
        p1: ['Alice', 'Bob', 'Charlie'],
      );

      expect(parse.apply(), 'Students: Alice, Bob, and Charlie');
    });

    test('Map parameters with named keys', () {
      final parse = ParseString(
        'Role: {student}, Assistant: {teacher}',
        p1: {'student': 'Alice', 'teacher': 'Mr. Smith'},
      );

      expect(parse.apply(), 'Role: Alice, Assistant: Mr. Smith');
    });

    test('Map parameters with named keys out of order', () {
      final parse = ParseString(
        'Role: {student}, Assistant: {teacher}',
        p1: {'teacher': 'Alice', 'student': 'Mr. Smith'},
      );

      expect(parse.apply(), 'Role: Mr. Smith, Assistant: Alice');
    });

    test('Map parameters with indexed keys', () {
      var parse = ParseString(
        'First: {0}, Second: {1}',
        p1: {'0': 'Alice', '1': 'Bob'},
      );

      expect(parse.apply(), 'First: Alice, Second: Bob');

      parse = ParseString(
        'First: {1}, Second: {0}',
        p1: {'0': 'Alice', '1': 'Bob'},
      );

      expect(parse.apply(), 'First: Bob, Second: Alice');
    });

    test('List and single parameters combination', () {
      final parse = ParseString(
        'Students: {0}, {1}, Admin: {2}',
        p1: ['Alice', 'Bob'],
        p2: 'Charlie',
      );

      expect(parse.apply(), 'Students: Alice, Bob, Admin: Charlie');
    });

    test('Map and list parameters combination', () {
      final parse = ParseString(
        'Role: {student}, Assistant: {teacher}, Guest: {0}',
        p1: {'student': 'Alice', 'teacher': 'Mr. Smith'},
        p2: ['Charlie'],
      );

      expect(parse.apply(), 'Role: Alice, Assistant: Mr. Smith, Guest: Charlie');
    });

    test('Empty placeholders remain unchanged', () {
      final parse = ParseString(
        'Hello {}, meet {} and {unknown}',
        p1: 'Alice',
        p2: 'Bob',
      );

      expect(parse.apply(), 'Hello Alice, meet Bob and {unknown}');
    });

    test('Malformed placeholders are ignored', () {
      final parse = ParseString(
        'Hello {stu{den}t}, {1 {2}, {}',
        p1: 'Alice',
        p2: 'Bob',
        p3: 'Charlie',
      );

      // "{stu"  is malformed and ignored
      // "{den}" should be replaced with 'Alice'
      // "t}"  is malformed and ignored
      // "{1" is malformed and ignored
      // "{2}" should be replaced with 'Bob'
      // "{}" should be replaced with 'Charlie'
      // So replacements: "den" -> "Bob", naked -> "Charlie"
      expect(parse.apply(), 'Hello {stuAlicet}, {1 Bob, Charlie');
    });

    test('Nested placeholders are handled correctly', () {
      final parse = ParseString(
        'Value: {outer{inner}} and {simple}',
        p1: {'inner': 'InnerValue', 'simple': 'SimpleValue'},
      );

      // According to createSourceList, it should detect "{inner}" first
      // and then "{outer{inner}}", but since nested placeholders are ignored,
      // only "{inner}" and "{simple}" are replaced
      expect(parse.apply(), 'Value: {outerInnerValue} and SimpleValue');
    });

    test('Overlapping placeholders are handled correctly', () {
      final parse = ParseString(
        'Start {0} middle {1} end',
        p1: 'Alice',
        p2: 'Bob',
      );

      expect(parse.apply(), 'Start Alice middle Bob end');
    });

    test('Multiple occurrences of the same named parameter', () {
      final parse = ParseString(
        '{greet}, {greet}!',
        p1: {'greet': 'Hello'},
      );

      expect(parse.apply(), 'Hello, Hello!');
    });

    test('Multiple occurrences of the same indexed parameter (int param)', () {
      final parse = ParseString(
        '{0}, {0}, and {1}',
        p1: {0: 'Alice'},
        p2: {1: 'Bob'},
      );

      expect(parse.apply(), 'Alice, Alice, and Bob');
    });

    test('Multiple occurrences of the same indexed parameter (string param)', () {
      final parse = ParseString(
        '{0}, {0}, and {1}',
        p1: {'0': 'Alice'},
        p2: {'1': 'Bob'},
      );

      expect(parse.apply(), 'Alice, Alice, and Bob');
    });

    test('Wrong usage of multiple occurrences of the same indexed parameter', () {
      final parse = ParseString(
        '{0}, {0}, and {1}',
        p1: 'Alice',
        p2: 'Bob',
      );

      expect(parse.apply(), 'Alice, Bob, and {1}');
    });

    test('Parameter keys as integers in map', () {
      final parse = ParseString(
        'First: {1}, Second: {2}',
        p1: {1: 'Alice', 2: 'Bob'},
      );

      expect(parse.apply(), 'First: Alice, Second: Bob');
    });

    test('Parameter keys as strings in map', () {
      final parse = ParseString(
        'First: {1}, Second: {2}',
        p1: {'1': 'Alice', '2': 'Bob'},
      );

      expect(parse.apply(), 'First: Alice, Second: Bob');
    });

    test('No placeholders in text', () {
      final parse = ParseString(
        'Hello World!',
        p1: 'Alice',
      );

      expect(parse.apply(), 'Hello World!');
    });

    test('Placeholders with no corresponding parameters', () {
      final parse = ParseString(
        'Hello {0}, meet {1}',
        p1: 'Alice',
      );

      expect(parse.apply(), 'Hello Alice, meet {1}');
    });

    test('Exceeding parameter count', () {
      final parse = ParseString(
        'Hello {0}, meet {1}',
        p1: 'Alice',
        p2: 'Bob',
        p3: 'Charlie', // Extra parameter
      );

      expect(parse.apply(), 'Hello Alice, meet Bob');
    });

    test('Empty text with parameters', () {
      final parse = ParseString(
        '',
        p1: 'Alice',
      );

      expect(parse.apply(), '');
    });

    test('Only placeholders without parameters', () {
      final parse = ParseString(
        '{}, {}, {}',
        p1: 'Alice',
      );

      expect(parse.apply(), 'Alice, {}, {}');
    });

    test('Placeholders with numerical and string keys', () {
      final parse = ParseString(
        'Name: {name}, Age: {age}, ID: {0}',
        p1: {'name': 'Alice', 'age': '30'},
        p2: 'ID123',
      );

      expect(parse.apply(), 'Name: Alice, Age: 30, ID: ID123');
    });

    test('Parameters as different data types', () {
      final parse = ParseString(
        'String: {0}, Number: {1}, Bool: {2}',
        p1: 'Alice',
        p2: 25,
        p3: true,
      );

      expect(parse.apply(), 'String: Alice, Number: 25, Bool: true');
    });

    test('List of maps as parameters', () {
      final parse = ParseString(
        'User1: {0}, User2: {1}',
        p1: [
          {'name': 'Alice'},
          {'name': 'Bob'}
        ],
      );

      expect(parse.apply(), 'User1: {name: Alice}, User2: {name: Bob}');
    });

    test('Wrong usage of Map with list values as parameters', () {
      final parse = ParseString(
        'Students: {students}, Teachers: {teachers}',
        p1: {
          'students': ['Alice', 'Bob'],
          'teachers': ['Mr. Smith', 'Ms. Johnson']
        },
      );

      expect(parse.apply(), 'Students: [Alice, Bob], Teachers: [Mr. Smith, Ms. Johnson]');
    });
  });

  test('Examples from the README', () {
    //
    expect(
        ParseString(
          'Hello {student} and {teacher}',
          p1: {'student': 'John', 'teacher': 'Mary'},
        ).apply(),
        'Hello John and Mary');

    expect(
        ParseString(
          'Hello {student} and {teacher}',
          p1: {1: 'John', 2: 'Mary'},
        ).apply(),
        'Hello {student} and {teacher}'); // Doesn't work.

    expect(
        ParseString(
          'Hello {student} and {teacher}',
          p1: {'1': 'John', '2': 'Mary'},
        ).apply(),
        'Hello {student} and {teacher}'); // Doesn't work.

    expect(
        ParseString(
          'Hello {student} and {teacher}',
          p1: 'John',
          p2: 'Mary',
        ).apply(),
        'Hello John and Mary');

    expect(
        ParseString(
          'Hello {student} and {teacher}',
          p1: ['John', 'Mary'],
        ).apply(),
        'Hello John and Mary');

    // ---------

    expect(
        ParseString(
          'Hello {} and {}',
          p1: {'student': 'John', 'teacher': 'Mary'},
        ).apply(),
        'Hello {} and {}'); // Doesn't work.

    expect(
        ParseString(
          'Hello {} and {}',
          p1: {1: 'John', 2: 'Mary'},
        ).apply(),
        'Hello {} and {}'); // Doesn't work.

    expect(
        ParseString(
          'Hello {} and {}',
          p1: {'1': 'John', '2': 'Mary'},
        ).apply(),
        'Hello {} and {}'); // Doesn't work.

    expect(
        ParseString(
          'Hello {} and {}',
          p1: 'John',
          p2: 'Mary',
        ).apply(),
        'Hello John and Mary');

    expect(
        ParseString(
          'Hello {} and {}',
          p1: ['John', 'Mary'],
        ).apply(),
        'Hello John and Mary');

    // ---------

    expect(
        ParseString(
          'Hello {1} and {2}',
          p1: {'student': 'John', 'teacher': 'Mary'},
        ).apply(),
        'Hello {1} and {2}'); // Doesn't work.

    expect(
        ParseString(
          'Hello {1} and {2}',
          p1: {1: 'John', 2: 'Mary'},
        ).apply(),
        'Hello John and Mary');

    expect(
        ParseString(
          'Hello {1} and {2}',
          p1: {'1': 'John', '2': 'Mary'},
        ).apply(),
        'Hello John and Mary');

    expect(
        ParseString(
          'Hello {1} and {2}',
          p1: 'John',
          p2: 'Mary',
        ).apply(),
        'Hello John and Mary');

    expect(
        ParseString(
          'Hello {1} and {1}',
          p1: ['John', 'Mary'],
        ).apply(),
        'Hello John and Mary');

    // ---------

    expect(
        ParseString(
          'Hello {1} and {2}',
          p1: {2: 'John', 1: 'Mary'},
        ).apply(),
        'Hello Mary and John');

    expect(
        ParseString(
          'Hello {2} and {1}',
          p1: {1: 'John', 2: 'Mary'},
        ).apply(),
        'Hello Mary and John');

    // ---------
  });

  test('Final complex test', () {
    final parse = ParseString(
      'A {a}, B {}, C {c}, D {}, E {1}, F {2}, G {5}, H {}, I {i}',
      p1: {'c': 'ccc'},
      p2: ['bbb', 'ddd'],
      p3: 'hhh',
      p4: {'i': 'iii', 'a': 'aaa'},
      p5: {1: 'eee', 5: 'ggg', '2': 'fff'},
    );

    expect(
        parse.apply(),
        'A aaa, B bbb, C ccc, D ddd, '
        'E eee, F fff, G ggg, H hhh, I iii');
  });
}
