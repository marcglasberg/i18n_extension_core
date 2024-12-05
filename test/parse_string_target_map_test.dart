import 'package:i18n_extension_core/src/parse_string.dart';
import 'package:test/test.dart';

void main() {
  group('ParseString.createTargetMap', () {
    //
    test('Single single object parameter', () {
      var parser = ParseString("", p1: "student");
      var expected = {0: "student"};
      expect(parser.createTargetMap(), equals(expected));
    });

    test('Two single object parameters', () {
      var parser = ParseString("", p1: "student", p2: "teacher");
      var expected = {0: "student", 1: "teacher"};
      expect(parser.createTargetMap(), equals(expected));
    });

    test('Single list parameter', () {
      var parser = ParseString("", p1: ["student", "teacher"]);
      var expected = {0: "student", 1: "teacher"};
      expect(parser.createTargetMap(), equals(expected));
    });

    test('List and single parameter', () {
      var parser = ParseString("", p1: ["student", "teacher"], p2: "admin");
      var expected = {0: "student", 1: "teacher", 2: "admin"};
      expect(parser.createTargetMap(), equals(expected));
    });

    test('Map and list parameter', () {
      var parser = ParseString(
        "",
        p1: {"student": "A", "teacher": "B"},
        p2: ["admin"],
      );
      var expected = {"student": "A", "teacher": "B", 0: "admin"};
      expect(parser.createTargetMap(), equals(expected));
    });

    test('Map with integer key and list parameter', () {
      var parser = ParseString(
        "",
        p1: {"student": "A", "teacher": "B"},
        p2: {3: "admin"},
      );
      var expected = {"student": "A", "teacher": "B", "3": "admin"};
      expect(parser.createTargetMap(), equals(expected));
    });

    test('Map with string key and list parameter', () {
      var parser = ParseString(
        "",
        p1: {"student": "A", "teacher": "B"},
        p2: {"3": "admin"},
      );
      var expected = {"student": "A", "teacher": "B", "3": "admin"};
      expect(parser.createTargetMap(), equals(expected));
    });

    test('Multiple maps and lists', () {
      var parser = ParseString(
        "",
        p1: {"student": "A"},
        p2: ["teacher", "admin"],
        p3: {"director": "C"},
        p4: ["assistant", "intern"],
      );
      var expected = {
        "student": "A",
        0: "teacher",
        1: "admin",
        "director": "C",
        2: "assistant",
        3: "intern",
      };
      expect(parser.createTargetMap(), equals(expected));
    });

    test('Handles null parameters by skipping them', () {
      var parser = ParseString(
        "",
        p1: "student",
        p2: null,
        p3: ["teacher"],
        p4: null,
      );
      var expected = {0: "student", 1: "teacher"};
      expect(parser.createTargetMap(), equals(expected));
    });

    test('Empty list parameter', () {
      var parser = ParseString(
        "",
        p1: [],
        p2: "teacher",
      );
      var expected = {0: "teacher"};
      expect(parser.createTargetMap(), equals(expected));
    });

    test('Empty map parameter', () {
      var parser = ParseString(
        "",
        p1: {},
        p2: "teacher",
      );
      var expected = {0: "teacher"};
      expect(parser.createTargetMap(), equals(expected));
    });

    test('Empty list and map parameters', () {
      var parser = ParseString(
        "",
        p1: [],
        p2: {},
        p3: "teacher",
      );
      var expected = {0: "teacher"};
      expect(parser.createTargetMap(), equals(expected));
    });

    test('Overlapping keys between maps and lists', () {
      var parser = ParseString(
        "",
        p1: {"0": "mapZero"},
        p2: ["listZero"],
        p3: {"1": "mapOne"},
        p4: ["listOne"],
      );
      var expected = {
        "0": "mapZero",
        0: "listZero",
        "1": "mapOne",
        1: "listOne",
      };
      expect(parser.createTargetMap(), equals(expected));
    });

    test('Multiple list parameters with correct indexing', () {
      var parser = ParseString(
        "",
        p1: ["a", "b"],
        p2: ["c"],
        p3: ["d", "e", "f"],
      );
      var expected = {0: "a", 1: "b", 2: "c", 3: "d", 4: "e", 5: "f"};
      expect(parser.createTargetMap(), equals(expected));
    });

    test('Mix of all parameter types', () {
      var parser = ParseString(
        "",
        p1: "student",
        p2: ["teacher", "admin"],
        p3: {"director": "C"},
        p4: null,
        p5: {"assistant": "D"},
        p6: ["intern"],
        p7: "guest",
      );
      var expected = {
        0: "student",
        1: "teacher",
        2: "admin",
        "director": "C",
        "assistant": "D",
        3: "intern",
        4: "guest",
      };
      expect(parser.createTargetMap(), equals(expected));
    });

    test('Map with non-string keys', () {
      var parser = ParseString(
        "",
        p1: {1: "one", 2: "two"},
      );
      var expected = {"1": "one", "2": "two"};
      expect(parser.createTargetMap(), equals(expected));
    });

    test('List with mixed types', () {
      var parser = ParseString(
        "",
        p1: ["student", 123, true],
      );
      var expected = {0: "student", 1: "123", 2: "true"};
      expect(parser.createTargetMap(), equals(expected));
    });

    test('Map with mixed value types', () {
      var parser = ParseString(
        "",
        p1: {"student": "A", "age": 20, "active": true},
      );
      var expected = {"student": "A", "age": "20", "active": "true"};
      expect(parser.createTargetMap(), equals(expected));
    });

    test('Parameters beyond p3 are handled correctly', () {
      var parser = ParseString(
        "",
        p1: "student",
        p2: "teacher",
        p3: "admin",
        p4: "director",
        p5: "assistant",
        p6: "intern",
        p7: "guest",
        p8: "visitor",
        p9: "staff",
        p10: "manager",
        p11: "supervisor",
        p12: "coordinator",
        p13: "lead",
        p14: "executive",
        p15: "ceo",
      );
      var expected = {
        0: "student",
        1: "teacher",
        2: "admin",
        3: "director",
        4: "assistant",
        5: "intern",
        6: "guest",
        7: "visitor",
        8: "staff",
        9: "manager",
        10: "supervisor",
        11: "coordinator",
        12: "lead",
        13: "executive",
        14: "ceo",
      };
      expect(parser.createTargetMap(), equals(expected));
    });

    test('Large number of parameters with mixed types', () {
      var parser = ParseString(
        "",
        p1: "student",
        p2: ["teacher", "admin"],
        p3: {"director": "C"},
        p4: ["assistant", "intern"],
        p5: {"guest": "G"},
        p6: "visitor",
        p7: ["staff", "manager"],
        p8: {"supervisor": "S"},
        p9: null,
        p10: ["coordinator"],
        p11: {"lead": "L"},
        p12: "executive",
        p13: ["ceo"],
        p14: {"cto": "T"},
        p15: "cfo",
      );
      var expected = {
        0: "student",
        1: "teacher",
        2: "admin",
        "director": "C",
        3: "assistant",
        4: "intern",
        "guest": "G",
        5: "visitor",
        6: "staff",
        7: "manager",
        "supervisor": "S",
        8: "coordinator",
        "lead": "L",
        9: "executive",
        10: "ceo",
        "cto": "T",
        11: "cfo",
      };
      expect(parser.createTargetMap(), equals(expected));
    });
  });
}
