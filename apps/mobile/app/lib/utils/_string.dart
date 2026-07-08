import 'package:characters/characters.dart';
import 'package:time_machine/time_machine.dart';

extension StringX on String {
  /// Returns a substring of this string from [start] to [end] as a [String].
  /// Use this when the receiver [String] may contain emojis, as [String.substring]
  /// will cause an error in that case:
  /// Invalid argument(s): string is not well-formed UTF-16
  String safeSubstring(int start, [int? end]) {
    return characters.take(end ?? characters.length).skip(start).join();
  }

  String get alphaNumericOnly => characters.where((c) {
    return RegExp('[a-zA-Z0-9]').hasMatch(c);
  }).join();

  LocalDate yyyyMMddToLocalDate() {
    if (length != 10) {
      return LocalDate.dateTime(DateTime.parse(this));
    }
    return LocalDate(
      int.parse(substring(0, 4)),
      int.parse(substring(5, 7)),
      int.parse(substring(8, 10)),
    );
  }
}

extension NullableStringX on String? {
  LocalDate? iso8601ToLocalDate() {
    if (this == null) {
      return null;
    }
    try {
      return LocalDate.dateTime(DateTime.parse(this!));
    } on Exception {
      return null;
    }
  }
}
