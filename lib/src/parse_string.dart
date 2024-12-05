class ParseString {
  final String text;
  final Object? p1, p2, p3, p4, p5, p6, p7, p8, p9, p10, p11, p12, p13, p14, p15;

  ParseString(
    this.text, {
    required this.p1,
    this.p2,
    this.p3,
    this.p4,
    this.p5,
    this.p6,
    this.p7,
    this.p8,
    this.p9,
    this.p10,
    this.p11,
    this.p12,
    this.p13,
    this.p14,
    this.p15,
  });

  /// This method will create the source map and the target map, and then will use both
  /// of them to apply the parameters to the text.
  String apply() {
    List<({Object placeholder, int start, int end})> sourceList = createSourceList();
    Map<Object, String> targetMap = createTargetMap();

    StringBuffer result = StringBuffer();
    int lastCharIndex = 0;
    int nakedPlaceholderIndex = 0;

    for (var entry in sourceList) {
      var key = entry.placeholder;
      var startChar = entry.start;
      var endChar = entry.end;

      // Append the text before the placeholder
      var textBefore = text.substring(lastCharIndex, startChar);
      result.write(textBefore);

      // Get the replacement value
      String? replacement;
      if (key is int)
        replacement = null;
      else
        replacement = targetMap[key];

      if (replacement == null) {
        replacement = targetMap[nakedPlaceholderIndex];
        if (replacement != null) {
          nakedPlaceholderIndex++;
        }
      }
      if (replacement != null) {
        result.write(replacement);
      } else {
        // If no replacement found, keep the placeholder as is
        var placeholder = text.substring(startChar, endChar + 1);
        result.write(placeholder);
      }

      lastCharIndex = endChar + 1;
    }

    // Append the remaining text after the last placeholder
    result.write(text.substring(lastCharIndex));

    return result.toString();
  }

  /// Given params [p1], [p2], ... [p15] return a map, following this procedure for each:
  /// - If the param is a single object, add {i: params.toString()}, where i starts with 0 and is incremented.
  /// - If the param is a list of n objects, add each one as you'd add a single object.
  /// - If the param is a map of n objects, return {key.toString(): value.toString()}
  ///
  /// In other words:
  ///
  /// - Single objects are added with an integer key starting from 0.
  /// - Lists are expanded, and each element is added with consecutive integer keys.
  /// - Maps are added directly with their own key-value pairs (keys are converted to strings).
  ///
  /// Returns a Map<Object, String> where keys are either integers or strings,
  /// and values are the string representations of the parameters.
  ///
  /// Examples:
  /// p1="student" -> {0: "student"}
  /// p1="student", p2="teacher" -> {0: "student", 1: "teacher"}
  /// p1=["student", "teacher"] -> {0: "student", 1: "teacher"}
  /// p1=["student", "teacher"], p2="admin", -> {0: "student", 1: "teacher", 3: "admin"}
  /// p1=["student", "teacher"], p2=["admin"], -> {0: "student", 1: "teacher", 3: "admin"}
  /// p1={"student": "A", "teacher": "B"}, p2=["admin"], -> {"student": "A", "teacher": "B", 0: "admin"}
  /// p1={"student": "A", "teacher": "B"}, p2={3: "admin"}, -> {"student": "A", "teacher": "B", "3": "admin"}
  /// p1={"student": "A", "teacher": "B"}, p2={"3": "admin"}, -> {"student": "A", "teacher": "B", "3": "admin"}
  ///
  Map<Object, String> createTargetMap() {
    final Map<Object, String> result = {};
    int i = 0;

    // List of all parameters for easy iteration
    final List<Object?> params = [
      p1,
      p2,
      p3,
      p4,
      p5,
      p6,
      p7,
      p8,
      p9,
      p10,
      p11,
      p12,
      p13,
      p14,
      p15
    ];

    for (var param in params) {
      if (param == null) continue;

      if (param is Map) {
        // Add each key-value pair from the map
        param.forEach((key, value) {
          result[key.toString()] = value.toString();
        });
      } else if (param is List) {
        // Add each item from the list with consecutive integer keys
        for (var item in param) {
          result[i++] = item.toString();
        }
      } else {
        // Add single object with the next integer key
        result[i++] = param.toString();
      }
    }

    return result;
  }

  /// Given the [text], return a map:
  /// - In case of named params, like {student}, the key is "student" (String).
  /// - In case of indexed params, like {1}, the key is the index, like "1" (String).
  /// - In case of naked params, like {}, the key is the order (int), i.e., the first naked param is 0, the second is 1, and so on.
  ///
  /// The value is the range of the param in the text `(int, int)`, both inclusive.
  ///
  /// For example, "Hello {student}" would result in: {"student": (6, 14)},
  /// because the "s" in "student" is at position 6, and the "t" is at position 14.
  ///
  /// Ignores outer placeholders (in case of nested placeholders), and malformed placeholders.
  /// For example "Hello {stu{den}t}" finds "{den}"
  /// For example "Hello {stu{dent}" finds "{dent}"
  /// For example "Hello {1 {2" finds nothing
  List<({Object placeholder, int start, int end})> createSourceList() {
    //
    final List<({Object placeholder, int start, int end})> paramsList = [];
    int nakedParamOrder = 0;
    int? currentStart;

    for (int i = 0; i < text.length; i++) {
      final char = text[i];

      if (char == '{') {
        if (currentStart != null) {
          // Nested '{' found before closing '}', abandon the previous placeholder
          currentStart = i;
        }
        //
        else {
          currentStart = i;
        }
      }
      //
      else if (char == '}') {
        if (currentStart != null) {
          // Extract the content within the braces.
          final content = text.substring(currentStart + 1, i);

          // Determine the placeholder based on the content
          Object placeholder;
          if (content.isEmpty) {
            placeholder = nakedParamOrder++; // Naked parameter.
          }
          //
          else if (int.tryParse(content) != null) {
            placeholder = content; // Indexed parameter.
          }
          //
          else {
            placeholder = content; // Named parameter.
          }

          // Add to the list with the range
          paramsList.add((placeholder: placeholder, start: currentStart, end: i));

          // Reset currentStart as we've closed the placeholder.
          currentStart = null;
        }
        // If there's a closing '}' without a matching '{', ignore it.
      }
      // Characters outside placeholders are ignored.
    }

    return paramsList;
  }
}
