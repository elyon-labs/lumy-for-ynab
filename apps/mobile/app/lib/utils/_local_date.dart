// ignore_for_file: non_constant_identifier_names

import 'package:clock/clock.dart';
import 'package:collection/collection.dart';
import 'package:intl/intl.dart';
import 'package:time_machine/time_machine.dart';

import '../features/date_range/domain/models/date_range.dart';

Map<String, DateTime> cachedDateTimes = {};
Map<String, LocalDate> cachedLocalDates = {};

LocalDate get today => LocalDate(clock.now().year, clock.now().month, clock.now().day);

LocalDate get thisMonth => today.firstDayOfMonth();
LocalDate get lastMonth => today.firstDayOfMonth().subtractMonths(1);
LocalDate get nextMonth => today.firstDayOfMonth().addMonths(1);

DateFormat yearMonthFormatter = DateFormat('yyyy-MM');

extension LocalDateX on LocalDate {
  bool isBefore(LocalDate other) {
    return compareTo(other) < 0;
  }

  bool isAfter(LocalDate other) {
    return compareTo(other) > 0;
  }

  bool isSameDayAs(LocalDate other) {
    return this == other;
  }

  bool isSameMonthAs(LocalDate other) {
    return year == other.year && monthOfYear == other.monthOfYear;
  }

  bool isSameMonthAsOrAfter(LocalDate other) {
    return isSameMonthAs(other) || isAfter(other);
  }

  bool isBetween(
    LocalDate first,
    LocalDate? second, {
    bool inclusiveStart = true,
    bool inclusiveEnd = true,
  }) {
    late final isAfterStart = inclusiveStart
        ? isSameDayAs(first) || isAfter(first)
        : isAfter(first);
    late final isBeforeEnd =
        second == null ||
        (inclusiveEnd ? isSameDayAs(second) || isBefore(second) : isBefore(second));

    return isAfterStart && isBeforeEnd;
  }

  bool isInRange(DateRange range) {
    return isBetween(range.from, range.to);
  }

  LocalDate firstDayOfMonth() {
    return subtractDays(dayOfMonth - 1);
  }

  LocalDate lastDayOfMonth() {
    return firstDayOfMonth().addMonths(1).subtractDays(1);
  }

  bool isToday() {
    return isSameDayAs(today);
  }

  bool isSameOrAfterToday() {
    return isAfter(today) || isSameDayAs(today);
  }

  bool isSameOrBeforeToday() {
    return isBefore(today) || isSameDayAs(today);
  }

  Iterable<LocalDate> daysInMonth() sync* {
    var current = firstDayOfMonth();
    bool stillInMonth() {
      return current.isBefore(lastDayOfMonth()) || //
          current.isSameDayAs(lastDayOfMonth());
    }

    while (stillInMonth()) {
      yield current;
      current = current.addDays(1);
    }
  }

  Duration subtractInternal(LocalDate other) {
    // Use DateTime because subtracting LocalDate from LocalDate returns a
    // Period where `days` is 0.
    return toDateTimeUnspecified().difference(other.toDateTimeUnspecified());
  }

  /// Returns the days in the receiver's month.
  int numDaysInMonth() {
    final from = firstDayOfMonth();
    final to = from.addMonths(1);
    final difference = to.subtractInternal(from);
    return (difference.inHours / 24).round();
  }

  String MMMMd() {
    return toString('MMMM d');
  }

  String MMMd() {
    return toString('MMM d');
  }

  String MMM() {
    return toString('MMM');
  }

  String yy() {
    return toString('yy');
  }

  String yyyy() {
    return toString('yyyy');
  }

  String MMMdyyyy() {
    return toString('MMM d yyyy');
  }

  String MMMMdyyyy() {
    return toString('MMMM d yyyy');
  }

  String MMMyyyy() {
    return toString('MMM yyyy');
  }

  String MMMMyyyy() {
    return toString('MMMM yyyy');
  }

  String Myy() {
    return toString('M/yy');
  }

  String yyyyMMdd() {
    return toString('yyyyMMdd');
  }

  String yyyyMMddWithHyphens() {
    return toString('yyyy-MM-dd');
  }

  String toIso8601String() {
    return toDateTimeUnspecified().toIso8601String();
  }
}

abstract class LocalDateUtils {
  static Iterable<LocalDate> monthsBetween(LocalDate first, LocalDate second) {
    final out = <LocalDate>[];
    var currentDate = first;
    while (currentDate.isBefore(second) || currentDate.isSameMonthAs(second)) {
      if (currentDate.dayOfMonth == 1 && out.none((d) => d.isSameMonthAs(currentDate))) {
        out.add(currentDate);
      }
      currentDate = currentDate.addDays(1);
    }
    return out;
  }
}
